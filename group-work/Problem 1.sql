SELECT 
    *
FROM
    (SELECT 
        student.name, course.title, takes.grade
    FROM
        UNIVERSITY.advisor, UNIVERSITY.teaches, UNIVERSITY.takes, UNIVERSITY.student, UNIVERSITY.course
    WHERE
        student.ID = advisor.s_ID
            AND teaches.ID = advisor.i_ID
            AND takes.ID = student.ID
            AND takes.course_id = teaches.course_id
            AND course.course_id = teaches.course_id) AS T
WHERE
    T.grade = 'C' OR T.grade = 'C-'
ORDER BY T.name