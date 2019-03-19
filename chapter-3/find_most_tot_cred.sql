SELECT *
FROM student
WHERE tot_cred >= ALL(SELECT tot_cred from STUDENT)