DROP PROCEDURE IF EXISTS add_balance;

CREATE PROCEDURE add_balance (
	check_username VARCHAR(50), 
	add_balance DECIMAL(20, 2)
)
BEGIN
	UPDATE user_attributes
	SET balance = balance + add_balance
	WHERE username = check_username;
END;