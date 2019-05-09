DELIMITER &&
CREATE DEFINER=`root`@`localhost` FUNCTION `getPrice`(id varchar(50)) RETURNS float
BEGIN
  declare done int default 1;
  declare _amount int;
  declare _price float;
  declare total float default 0;
  declare checkPrice cursor for
  select amount, price
  from 
  (dishes natural join order_include)
  where order_id = id;
  DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET done = 0;
  set total = 0;
  open checkPrice;
  fetch checkPrice into _amount, _price;
  while done do
    set total = total + _amount * _price;
    fetch checkPrice into _amount, _price;
  end while; 
  close checkPrice;
RETURN total;
END

DELIMITER ;

DELIMITER &&
CREATE DEFINER=`root`@`localhost` FUNCTION `fiPrice`(s_id varchar(50), o_id varchar(50)) RETURNS float
BEGIN
  declare done int default 1;
  declare _Trigger1 float;
  declare _Discount float;
  declare total float;
  declare coupons cursor for
    select trigger1, discount 
    from 
    coupon
    where store_id = s_id
    order by trigger1 desc;
  DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET done = 0;
  open coupons;
  fetch coupons into _Trigger1, _Discount;
  select getPrice(o_id) into total;
  while done do
    if total > _Trigger1 then
      set total = total - _Discount;
      set done = 0;
    end if;
    fetch coupons into _Trigger1, _Discount;
  end while; 
  close coupons;
RETURN total;
END

DELIMITER ;