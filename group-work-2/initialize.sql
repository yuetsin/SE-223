create database one;
use one;
/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2019/5/8 16:04:16                            */
/*==============================================================*/


drop table if exists Dishes;

drop table if exists coupon;

drop table if exists location;

drop table if exists order_include;

drop table if exists orders;

drop table if exists score;

drop table if exists score_dish;

drop table if exists store;

drop table if exists user;

drop table if exists user_attributes;

drop table if exists user_orders;

/*==============================================================*/
/* Table: Dishes                                                */
/*==============================================================*/
create table Dishes
(
   dish_id              varchar(50) not null,
   store_id             varchar(50),
   name                 varchar(40) not null,
   price                float(20,2) not null,
   pic                  longblob not null,
   select_count         decimal,
   primary key (dish_id)
);

/*==============================================================*/
/* Table: coupon                                                */
/*==============================================================*/
create table coupon
(
   trigger1            float(20,2) not null,
   discount             float(20,2) not null,
   coupon_id            varchar(50) not null,
   store_id             varchar(50),
   primary key (coupon_id)
);

/*==============================================================*/
/* Table: location                                              */
/*==============================================================*/
create table location
(
   uuid                 varchar(50) not null,
   order_id             varchar(50) not null,
   x                    float not null,
   y                    float not null,
   time                 datetime not null,
   primary key (uuid)
);

/*==============================================================*/
/* Table: order_include                                         */
/*==============================================================*/
create table order_include
(
   dish_id              varchar(50) not null,
   order_id             varchar(50) not null,
   amount               int not null,
   attribute            varchar(100),
   primary key (dish_id, order_id)
);

/*==============================================================*/
/* Table: orders                                                */
/*==============================================================*/
create table orders
(
   order_id             varchar(50) not null,
   username             varchar(50),
   primary key (order_id)
);

/*==============================================================*/
/* Table: score                                                 */
/*==============================================================*/
create table score
(
   use_username         varchar(50) not null,
   username             varchar(50) not null,
   score                numeric(2,0) not null default 5,
   comment              text,
   img                  longblob,
   type                 int,
   primary key (use_username, username)
);

/*==============================================================*/
/* Table: score_dish                                            */
/*==============================================================*/
create table score_dish
(
   username             varchar(50) not null,
   dish_id              varchar(50) not null,
   grade                decimal(3) not null default 0,
   comment              text,
   img                  longblob,
   primary key (username, dish_id)
);

/*==============================================================*/
/* Table: store                                                 */
/*==============================================================*/
create table store
(
   store_id             varchar(50) not null,
   username             varchar(50) not null,
   address              varchar(50) not null,
   s_phone              varchar(20) not null,
   primary key (store_id)
);

/*==============================================================*/
/* Table: user                                                  */
/*==============================================================*/
create table user
(
   username             varchar(50) not null,
   role                 varchar(10) not null,
   phone                varchar(20) not null,
   primary key (username)
);

/*==============================================================*/
/* Table: user_attributes                                       */
/*==============================================================*/
create table user_attributes
(
   username             varchar(50) not null,
   balance              decimal,
   look_count           decimal,
   primary key (username)
);

/*==============================================================*/
/* Table: user_orders                                           */
/*==============================================================*/
create table user_orders
(
   username             varchar(50) not null,
   order_id             varchar(50) not null,
   state                varchar(10) not null,
   reciever             varchar(20) not null,
   recieve_address      varchar(50) not null,
   r_phone              varchar(20) not null,
   primary key (username, order_id)
);

alter table Dishes add constraint FK_store_dishes foreign key (store_id)
      references store (store_id) on delete restrict on update restrict;

alter table coupon add constraint FK_store_coupons foreign key (store_id)
      references store (store_id) on delete restrict on update restrict;

alter table location add constraint FK_location foreign key (order_id)
      references orders (order_id) on delete restrict on update restrict;

alter table order_include add constraint FK_order_include foreign key (dish_id)
      references Dishes (dish_id) on delete restrict on update restrict;

alter table order_include add constraint FK_order_include2 foreign key (order_id)
      references orders (order_id) on delete restrict on update restrict;

alter table orders add constraint FK_rider_cur_orders foreign key (username)
      references user (username) on delete restrict on update restrict;

alter table score add constraint FK_be_scorer foreign key (username)
      references user (username) on delete restrict on update restrict;

alter table score add constraint FK_scorer foreign key (use_username)
      references user (username) on delete restrict on update restrict;

alter table score_dish add constraint FK_score_dish foreign key (username)
      references user (username) on delete restrict on update restrict;

alter table score_dish add constraint FK_score_dish2 foreign key (dish_id)
      references Dishes (dish_id) on delete restrict on update restrict;

alter table store add constraint FK_businessman_store foreign key (username)
      references user (username) on delete restrict on update restrict;

alter table user_attributes add constraint FK_user_has_attributes foreign key (username)
      references user (username) on delete restrict on update restrict;

alter table user_orders add constraint FK_user_orders foreign key (username)
      references user (username) on delete restrict on update restrict;

alter table user_orders add constraint FK_user_orders2 foreign key (order_id)
      references orders (order_id) on delete restrict on update restrict;

insert into user
(username, role, phone)
values
('Mary', '0', '15201922867');

insert into user
(username, role, phone)
values
('Jack', '0', '15291922867');

insert into user
(username, role, phone)
values
('Amy', '1', '13201922867');

insert into user
(username, role, phone)
values
('Alice', '1', '13801922867');

insert into user
(username, role, phone)
values
('Spancer', '2', '15801922867');

insert into user
(username, role, phone)
values
('Alyssa', '2', '13901922867');

insert into user_attributes
(username, balance, look_count)
values
('Mary', 23.9, 55);

insert into user_attributes
(username, balance, look_count)
values
('Jack', 5.3, 109);

INSERT INTO `store` (`store_id`,`username`,`address`,`s_phone`) VALUES ("ad","Amy","min","13201922867");
INSERT INTO `store` (`store_id`,`username`,`address`,`s_phone`) VALUES ("ae","Alice","hhh","13801922867");

INSERT INTO `coupon` (`trigger1`,`discount`,`coupon_id`,`store_id`) VALUES (30,56,"a568","ae");
INSERT INTO `coupon` (`trigger1`,`discount`,`coupon_id`,`store_id`) VALUES (20,5,"a567","ad");

INSERT INTO `dishes` (`dish_id`,`store_id`,`name`,`price`, `pic`) VALUES ("bac","ad","yu",20,0);
INSERT INTO `dishes` (`dish_id`,`store_id`,`name`,`price`, `pic`) VALUES ("bad","ad","rou",20,0);

INSERT INTO `user` (`username`,`role`,`phone`) VALUES ("huangli","0","1376346444");
INSERT INTO `user` (`username`,`role`,`phone`) VALUES ("huangyu","0","1373446444");
INSERT INTO `user` (`username`,`role`,`phone`) VALUES ("huangbin","1","1354346444");
INSERT INTO `user` (`username`,`role`,`phone`) VALUES ("huangqi","1","1372346444");
INSERT INTO `user` (`username`,`role`,`phone`) VALUES ("huangjia","2","1323346444");
INSERT INTO `user` (`username`,`role`,`phone`) VALUES ("huangyin","2","1343346444");

insert into orders
(order_id, username)
values
("o1", "Spancer");
insert into orders
(order_id, username)
values
("o2", "Alyssa");

INSERT INTO `user_orders` (`username`,`order_id`,`state`,`reciever`,`recieve_address`,`r_phone`) 
VALUES ("Jack","o1","0","Jack","d15","15291922867");

INSERT INTO `user_orders` (`username`,`order_id`,`state`,`reciever`,`recieve_address`,`r_phone`) 
VALUES ("Mary","o2","1","Mary","d14","15201922867");

INSERT INTO `order_include` (`dish_id`,`order_id`,`amount`,`attribute`) VALUES ("bac","o1",12,"dsf");

INSERT INTO `order_include` (`dish_id`,`order_id`,`amount`,`attribute`) VALUES ("bad","o2",20,"nfidlo");

