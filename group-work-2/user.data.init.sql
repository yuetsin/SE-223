INSERT INTO `user` (`username`, `role`, `phone`)
VALUES ('huangli', '0', '1376346444');

INSERT INTO `user` (`username`, `role`, `phone`)
VALUES ('huangyu', '0', '1373446444');

INSERT INTO `user` (`username`, `role`, `phone`)
VALUES ('huangbin', '1', '1354346444');

INSERT INTO `user` (`username`, `role`, `phone`)
VALUES ('huangqi', '1', '1372346444');

INSERT INTO `user` (`username`, `role`, `phone`)
VALUES ('huangjia', '2', '1323346444');

INSERT INTO `user` (`username`, `role`, `phone`)
VALUES ('huangyin', '2', '1343346444');

INSERT INTO `orders` (`order_id`, `username`)
VALUES ('o1', 'huangbin');

INSERT INTO `orders` (`order_id`, `username`)
VALUES ('o2', 'huangbjia');

INSERT INTO `user_orders` (`username`, `order_id`, `state`, `receiver`, `receiver_address`
	, `r_phone`)
VALUES ('huangbin', 'o1', '0', 'bawang', 'd15'
	, '1478683683');

INSERT INTO `user_orders` (`username`, `order_id`, `state`, `receiver`, `receiver_address`
	, `r_phone`)
VALUES ('huangyu', 'o2', '1', 'bawa', 'd14'
	, '147433683');

INSERT INTO `coupon` (`coupon_trigger`, `discount`, `coupon_id`, `store_id`)
VALUES (20, 5, 'a567', 'ad');

INSERT INTO `coupon` (`coupon_trigger`, `discount`, `coupon_id`, `store_id`)
VALUES (30, 5, 'a568', 'ae');

INSERT INTO `dishes` (`dish_id`, `store_id`, `name`, `price`)
VALUES ('bac', 'ad', 'yu', 20);

INSERT INTO `dishes` (`dish_id`, `store_id`, `name`, `price`)
VALUES ('bad', 'ad', 'rou', 20);

INSERT INTO `store` (`store_id`, `username`, `address`, `s_phone`)
VALUES ('ad', 'jia', 'min', '1376546444');

INSERT INTO `store` (`store_id`, `username`, `address`, `s_phone`)
VALUES ('ae', 'utt', 'hhh', '1376687444');

INSERT INTO user_attributes (username, balance, look_count)
VALUES ('Mary', 23.9, 55);

INSERT INTO user_attributes (username, balance, look_count)
VALUES ('Jack', 5.3, 109);

INSERT INTO user (username, role, phone)
VALUES ('Mary', '0', '15201922867');

INSERT INTO user (username, role, phone)
VALUES ('Jack', '0', '15291922867');

INSERT INTO user (username, role, phone)
VALUES ('Amy', '1', '13201922867');

INSERT INTO user (username, role, phone)
VALUES ('Alice', '1', '13801922867');

INSERT INTO user (username, role, phone)
VALUES ('Spancer', '2', '15801922867');

INSERT INTO user (username, role, phone)
VALUES ('Alyssa', '2', '13901922867');