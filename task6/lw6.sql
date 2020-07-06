-- 1 Добавить внешние ключи.

ALTER TABLE lesson
ADD FOREIGN KEY (id_subject) REFERENCES [subject] (id_subject);

ALTER TABLE lesson 
ADD FOREIGN KEY (id_teacher) REFERENCES teacher (id_teacher);

ALTER TABLE lesson 
ADD FOREIGN KEY (id_group) REFERENCES [group] (id_group);

ALTER TABLE student
ADD FOREIGN KEY (id_group) REFERENCES [group] (id_group);

ALTER TABLE mark
ADD FOREIGN KEY (id_lesson) REFERENCES lesson (id_lesson);

ALTER TABLE mark
ADD FOREIGN KEY (id_student) REFERENCES	student (id_student);

--2 Выдать оценки студентов по информатике если они обучаются данному предмету. Оформить выдачу данных с использованием view

CREATE VIEW marks_for_informatics AS  
		SELECT student.name, mark.mark
	FROM mark
	INNER JOIN student ON student.id_student = mark.id_student
	INNER JOIN lesson ON mark.id_lesson = lesson.id_lesson
	INNER JOIN [subject] ON lesson.id_subject = [subject].id_subject
	WHERE [subject].name = 'Информатика'
GO
	
SELECT * 
FROM marks_for_informatics
ORDER BY marks_for_informatics.name

--3 Дать информацию о должниках с указанием фамилии студента и названия предмета.
--Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе. Оформить в виде процедуры, 
--на входе идентификатор группы.

CREATE PROCEDURE debtor_information
	@id_group AS INT
AS
	SELECT student.name, [subject].name, mark.mark
	FROM student
	INNER JOIN [group] ON [group].id_group = student.id_group
	INNER JOIN lesson ON lesson.id_group = [group].id_group
	INNER JOIN [subject] ON lesson.id_subject = [subject].id_subject
	LEFT JOIN mark ON student.id_student = mark.id_student AND lesson.id_lesson = mark.id_lesson
	WHERE [group].id_group = @id_group
	GROUP BY student.name, [subject].name, mark.mark
	HAVING count(mark.mark) = 0
GO
 
EXECUTE debtor_information @id_group = 1;
EXECUTE debtor_information @id_group = 2;
EXECUTE debtor_information @id_group = 3;
EXECUTE debtor_information @id_group = 4;

-- 4 Дать среднюю оценку студентов по каждому предмету для тех предметов, по которым занимается не менее 35 студентов



--вывод каждого предмета для каждой группы 
SELECT subject.name, AVG(mark.mark)
FROM student
JOIN [group] ON student.id_group = [group].id_group
JOIN lesson ON [group].id_group = lesson.id_group
JOIN subject ON lesson.id_subject = subject.id_subject
JOIN mark ON lesson.id_lesson = mark.id_lesson
GROUP BY subject.name, student.id_group
HAVING COUNT(DISTINCT student.id_student) >= 35







----вывод среднего значения по предмету от всех групп 
--SELECT subject.name, AVG(mark.mark)
--FROM student
--JOIN [group] ON student.id_group = [group].id_group
--JOIN lesson ON [group].id_group = lesson.id_group
--JOIN subject ON lesson.id_subject = subject.id_subject
--JOIN mark ON lesson.id_lesson = mark.id_lesson
--GROUP BY subject.name
--HAVING COUNT(DISTINCT student.id_student) >= 30







--5 Дать оценки студентов специальности ВМ по всем проводимым предметам с 
--указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить
--значениями NULL поля оценки

SELECT mark.mark, student.name, [subject].name, group_BM.name, lesson.date
FROM student
INNER JOIN (SELECT [group].id_group, [group].name
	FROM [group]
	WHERE [group].name = 'ВМ') AS group_BM 
	ON student.id_group = group_BM.id_group
INNER JOIN lesson ON group_BM.id_group = lesson.id_group
INNER JOIN [subject] ON lesson.id_subject = [subject].id_subject
LEFT JOIN mark ON (lesson.id_lesson = mark.id_lesson AND student.id_student = mark.id_student)
ORDER BY student.name 

--6 Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД до 12.05, 
--повысить эти оценки на 1 балл.

BEGIN TRANSACTION 

UPDATE mark
SET mark = mark + 1
WHERE id_mark IN 
(
	SELECT mark.id_mark
	FROM student
	INNER JOIN mark ON mark.id_student = student.id_student
	INNER JOIN lesson ON mark.id_lesson = lesson.id_lesson
	INNER JOIN [group] ON student.id_group = [group].id_group
	INNER JOIN [subject] ON lesson.id_subject = [subject].id_subject
	WHERE [group].name = 'ПС' AND
		[subject].name = 'БД' AND
		lesson.date < '2019-05-12' AND
		mark.mark < 5
);

ROLLBACK;

--7. Добавить необходимые индексы.

CREATE NONCLUSTERED INDEX[IX_group_name] ON [group]
(
	name ASC
)

CREATE NONCLUSTERED INDEX[IX_mark_id_lesson] ON mark
(
	id_lesson ASC
)

CREATE NONCLUSTERED INDEX[IX_mark_id_student] ON mark
(
	id_student ASC
)

CREATE NONCLUSTERED INDEX[IX_mark_id_lesson_id_student] ON mark
(
	id_lesson ASC,
	id_student ASC
)

CREATE NONCLUSTERED INDEX[IX_student_id_group] ON student
(
	id_group ASC
)

CREATE NONCLUSTERED INDEX[IX_student_name] ON student
(
	name ASC
)

CREATE NONCLUSTERED INDEX[IX_subject_name] ON [subject]
(
	name ASC
)

CREATE NONCLUSTERED INDEX[IX_teacher_name] ON teacher
(
	name ASC
)

CREATE NONCLUSTERED INDEX[IX_lesson_id_teacher] ON lesson
(
	id_teacher ASC
)

CREATE NONCLUSTERED INDEX[IX_lesson_id_group] ON lesson
(
	id_group ASC
)

CREATE NONCLUSTERED INDEX[IX_lesson_id_subject] ON lesson
(
	id_subject ASC
)

CREATE NONCLUSTERED INDEX[IX_lesson_id_group_id_subject] ON lesson
(
	id_group ASC,
	id_subject ASC
)

CREATE NONCLUSTERED INDEX[IX_lesson_id_group_id_teacher] ON lesson
(
	id_group ASC,
	id_teacher ASC
)

CREATE NONCLUSTERED INDEX[IX_lesson_id_teacher_id_subject] ON lesson
(
	id_teacher ASC,
	id_subject ASC
)