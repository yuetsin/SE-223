DELIMITER $$
DROP PROCEDURE IF EXISTS teacher_salary;
CREATE PROCEDURE teacher_salary(dept_name VARCHAR(20))
READS SQL DATA
BEGIN
	SELECT dept_name, AVG(salary) FROM instructor
    WHERE instructor.dept_name = dept_name;
END;

SELECT 
    dept_name, TEACHER_SALARY(dept_name)
FROM
    department
WHERE
    TEACHER_SALARY(dept_name) IS NOT NULL
ORDER BY TEACHER_SALARY(dept_name) DESC; 
