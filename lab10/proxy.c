/*
 * proxy.c - ICS Web proxy
 *
 *
 */

#define DEBUG 1

#define DEBUG_TO_LOG 1

#if DEBUG
#define __LOG__ dprintf
#else
#define __LOG__(...)
#endif

#include "csapp.h"
#include <stdarg.h>
#include <sys/select.h>
#include <unistd.h>

#define MAXPARAMS 255
#define PORTLEN 100
/*
 * Function prototypes
 */
size_t read_request(int connfd, char* uri);
size_t perform_request(int writebackfd, char* host, char* port, char** param_list);
int    my_open_clientfd(char* hostname, int port);
int    parse_uri(char* uri, char* target_addr, char* path, char* port);
void   format_log_entry(char* logstring, struct sockaddr_in* sockaddr, char* uri, size_t size);
void   gen_timestamp(char* logstring);
char   log_string[MAXLINE];
int    Open_clientfd_w(char* hostname, char* port);
/*
 * main - Main routine for the proxy program
 */
int file_fd = -1;
int main(int argc, char** argv) {

    /* Check arguments */
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <port number>\n", argv[0]);
        exit(0);
    }

    if (DEBUG_TO_LOG) {
        file_fd = open("./proxy.log", O_CREAT | O_RDWR | O_APPEND, 00777);
        if (file_fd < 0) {
            printf("file_fd open failed. errno = %d.\n", errno);
            return -1;
        }
        gen_timestamp("logging start");
    }
    else {
        file_fd = ( int )stdout;
    }
    dprintf(file_fd, "Hey im here ahh\n");

    int                listenfd, connfd;
    socklen_t          clientlen;
    struct sockaddr_in clientaddr;
    clientaddr.sin_family = AF_INET;
    char client_hostname[MAXLINE], client_port[MAXLINE], uri[MAXLINE];
    listenfd = Open_listenfd(argv[1]);
    while (1) {
        __LOG__(file_fd, "Loop enter\n");
        __LOG__(file_fd, "\n\n\n");
        clientlen = sizeof(clientaddr);
        connfd    = Accept(listenfd, ( SA* )&clientaddr, &clientlen);
        Getnameinfo(( SA* )&clientaddr, clientlen, client_hostname, MAXLINE, client_port, MAXLINE, 0);
        __LOG__(file_fd, "Connected to (%s, %s)\n", client_hostname, client_port);

        size_t bytes = read_request(connfd, uri);
        format_log_entry(log_string, ( SA* )&clientaddr, uri, bytes);
        printf("%s\n", log_string);

        Close(connfd);
    }
    exit(0);
}

size_t read_request(int connfd, char* uri) {
    // printf("Yeah. here.\n");
    size_t n;
    char   buf[MAXLINE], address[MAXLINE], method[MAXLINE], hostname[MAXLINE], pathname[MAXLINE], port[MAXLINE];
    rio_t  rio;

    char* param_list[MAXPARAMS];

    Rio_readinitb(&rio, connfd);

    size_t counter = 0;
    while ((n = Rio_readlineb(&rio, buf, MAXLINE)) != 0) {
        if (counter >= MAXPARAMS) {
            break;
        }

        if (n <= 2) {
            continue;
        }
        __LOG__(file_fd, "Server received %d bytes\n", ( int )n);
        __LOG__(file_fd, "%s\n", buf);

        if (sscanf(buf, "GET %s %s", address, method) == 2 || sscanf(buf, "POST %s %s", address, method) == 2) {
            if (parse_uri(address, hostname, pathname, port) == 0) {
                snprintf(uri, MAXLINE, "http://%s:%s/", hostname, port);
                __LOG__(file_fd, "parse_uri parsed hostname: %s, pathname: %s, port: %s\n", hostname, pathname, port);
            }
            // continue;
        }
        param_list[counter] = ( char* )Malloc(MAXLINE);

        snprintf(param_list[counter], n, "%s", buf);
        // printf("Added param #%ld: %s\n", counter, param_list[counter]);
        ++counter;
    }
    size_t resp_size = perform_request(connfd, hostname, port, param_list);
    return resp_size;
}

size_t perform_request(int writebackfd, char* host, char* port, char** param_list) {
    char port_buf[PORTLEN];
    snprintf(port_buf, PORTLEN - 1, port);
    __LOG__(file_fd, "entered perform_request. writebackfd: %d, host: %s, port: %s, port_buf: %s\n", writebackfd, host, port, port_buf);
    int    clientfd;
    size_t n;
    rio_t  request_rio;
    char   response[MAXLINE];

    for (size_t i = 0; i < MAXPARAMS; i++) {
        if (param_list[i]) {

            __LOG__(file_fd, "Param #%ld >%s\n", i, param_list[i]);
        }
        else {
            break;
        }
    }

    clientfd = Open_clientfd_w(host, port_buf);

    if (clientfd <= 0) {
        __LOG__(file_fd, "bad clientfd: %d\n", clientfd);
        return -1;
    }
    __LOG__(file_fd, "clientfd: %d\n", clientfd);

    size_t counter = 0;
    while (param_list[counter]) {
        Rio_writen(clientfd, param_list[counter], strlen(param_list[counter]));
        __LOG__(file_fd, "Write to server #%ld: %s\n", counter, param_list[counter]);
        free(param_list[counter]);
        __LOG__(file_fd, "Freed buffer block #%ld\n", counter);
        ++counter;
    }

    Rio_readinitb(&request_rio, clientfd);

    size_t length = 0;
    while ((n = Rio_readlineb(&request_rio, response, MAXLINE)) != 0) {
        length += n;
        Rio_writen(writebackfd, response, n);
        __LOG__(file_fd, "Write back to client: %s\n", response);
    }

    // for (size_t i = 0; i < MAXPARAMS; i++) {
    //     if (param_list[i] == NULL) {
    //         break;
    //     }
    //     free(( void* )param_list[i]);
    //     __LOG__("Freed buffer block %ld\n", i);
    // }

    return length;
}

/*
 * parse_uri - URI parser
 *
 * Given a URI from an HTTP proxy GET request (i.e., a URL), extract
 * the host name, path name, and port.  The memory for hostname and
 * pathname must already be allocated and should be at least MAXLINE
 * bytes. Return -1 if there are any problems.
 */
int parse_uri(char* uri, char* hostname, char* pathname, char* port) {
    char* hostbegin;
    char* hostend;
    char* pathbegin;
    int   len;

    if (strncasecmp(uri, "http://", 7) != 0) {
        hostname[0] = '\0';
        return -1;
    }

    /* Extract the host name */
    hostbegin = uri + 7;
    hostend   = strpbrk(hostbegin, " :/\r\n\0");
    if (hostend == NULL)
        return -1;
    len = hostend - hostbegin;
    strncpy(hostname, hostbegin, len);
    hostname[len] = '\0';

    /* Extract the port number */
    if (*hostend == ':') {
        char* p = hostend + 1;
        while (isdigit(*p))
            *port++ = *p++;
        *port = '\0';
    }
    else {
        strcpy(port, "80");
    }

    /* Extract the path */
    pathbegin = strchr(hostbegin, '/');
    if (pathbegin == NULL) {
        pathname[0] = '\0';
    }
    else {
        pathbegin++;
        strcpy(pathname, pathbegin);
    }

    return 0;
}

/*
 * format_log_entry - Create a formatted log entry in logstring.
 *
 * The inputs are the socket address of the requesting client
 * (sockaddr), the URI from the request (uri), the number of bytes
 * from the server (size).
 */
void format_log_entry(char* logstring, struct sockaddr_in* sockaddr, char* uri, size_t size) {
    time_t        now;
    char          time_str[MAXLINE];
    unsigned long host;
    unsigned char a, b, c, d;

    /* Get a formatted time string */
    now = time(NULL);
    strftime(time_str, MAXLINE, "%a %d %b %Y %H:%M:%S %Z", localtime(&now));

    /*
     * Convert the IP address in network byte order to dotted decimal
     * form. Note that we could have used inet_ntoa, but chose not to
     * because inet_ntoa is a Class 3 thread unsafe function that
     * returns a pointer to a static variable (Ch 12, CS:APP).
     */
    host = ntohl(sockaddr->sin_addr.s_addr);
    a    = host >> 24;
    b    = (host >> 16) & 0xff;
    c    = (host >> 8) & 0xff;
    d    = host & 0xff;

    /* Return the formatted log entry string */
    sprintf(logstring, "%s: %d.%d.%d.%d %s %zu", time_str, a, b, c, d, uri, size);
}

void gen_timestamp(char* logstring) {
    time_t now;
    char   time_str[MAXLINE];

    /* Get a formatted time string */
    now = time(NULL);
    strftime(time_str, MAXLINE, "%a %d %b %Y %H:%M:%S %Z", localtime(&now));

    /* Return the formatted log entry string */
    __LOG__(file_fd, "%s: %s\n", time_str, logstring);
}

/****************************************************
 * Wrappers for reentrant protocol-independent helpers
 ****************************************************/
int Open_clientfd_w(char* hostname, char* port) {
    int rc;

    if ((rc = open_clientfd(hostname, port)) < 0)
        printf("Open_clientfd error. ErrCode: %d\n", rc);
    return rc;
}