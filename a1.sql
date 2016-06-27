--QUESTION 1
SELECT SNUM, SNAME FROM STUDENT \
        WHERE SNUM in ( \
        	SELECT SNUM FROM MARK \
        	WHERE CNUM < 'CS300' AND CNUM > 'CS199' AND GRADE >= 80 \
        	GROUP BY SNUM HAVING COUNT(SNUM) >= 2 \
        ) \
        AND (STUDENT.YEAR = 3 OR STUDENT.YEAR = 4)


--QUESTION 2
SELECT PROFESSOR.PNUM, PROFESSOR.PNAME \
	FROM PROFESSOR INNER JOIN CLASS ON CLASS.PNUM=PROFESSOR.PNUM \
	WHERE CLASS.CNUM != 'CS240' AND CLASS.CNUM != 'CS245' \
	GROUP BY PROFESSOR.PNUM, PROFESSOR.PNAME

--QUESTION 3
SELECT PNUM, PNAME from PROFESSOR where PNUM in ( \
                select CLASS.PNUM from mark INNER JOIN class \
                on (class.cnum = mark.cnum and mark.term = class.term and class.section = mark.section) \
                where mark.CNUM='CS245' order by mark.GRADE desc FETCH FIRST 10 ROW ONLY \
        )

--QUESTION 4 
SELECT snum, sname FROM student WHERE snum IN ( \
        SELECT snum FROM mark WHERE grade>=85 AND (cnum LIKE 'CS%' OR cnum LIKE 'CO%') GROUP BY snum \
) AND snum NOT IN ( \
        SELECT snum FROM mark WHERE grade<85 AND (cnum LIKE 'CS%' OR cnum LIKE 'CO%') GROUP BY snum \
) AND year = 4


--QUESTION 4 FOR LOCAL TEST
--SELECT snum, sname FROM student WHERE snum IN ( \
--        SELECT snum FROM mark WHERE grade>=80 AND (cnum LIKE 'CS%' OR cnum LIKE 'CO%') GROUP BY snum \
--) AND snum NOT IN ( \
--        SELECT snum FROM mark WHERE grade<80 AND (cnum LIKE 'CS%' OR cnum LIKE 'CO%') GROUP BY snum \
--) AND year = 3

--QUESTION 5
SELECT dept FROM professor WHERE \
        dept IN ( \
                SELECT dept FROM professor p INNER JOIN class c ON (p.pnum=c.pnum) \
                INNER JOIN ( \
                        SELECT e.cnum, e.term, e.section FROM enrollment e WHERE NOT EXISTS ( \
                                SELECT * FROM mark m WHERE e.snum=m.snum AND e.cnum=m.cnum AND e.term=m.term AND e.section=m.section \
                        ) \
                ) e ON (c.cnum=e.cnum AND c.term=e.term AND c.section=e.section) \
                WHERE c.cnum LIKE p.dept || '%' \
        ) \
        AND dept NOT IN ( \
                SELECT dept FROM professor p INNER JOIN class c ON (p.pnum=c.pnum) \
                INNER JOIN ( \
                        SELECT e.cnum, e.term, e.section FROM enrollment e WHERE NOT EXISTS ( \
                                SELECT * FROM mark m WHERE e.snum=m.snum AND e.cnum=m.cnum AND e.term=m.term AND e.section=m.section \
                        ) \
                ) e ON (c.cnum=e.cnum AND c.term=e.term AND c.section=e.section) \
                WHERE c.cnum NOT LIKE p.dept || '%' \
        ) GROUP BY dept ORDER BY dept ASC

--SELECT dept FROM professor WHERE \
--      dept IN ( --departaments currently offering classes of their own (may exist idle departments)
--              SELECT dept FROM professor p INNER JOIN class c ON (p.pnum=c.pnum) \
--              INNER JOIN ( --with current courses
--                      SELECT e.cnum, e.term, e.section FROM enrollment e WHERE NOT EXISTS ( \ --courses with no marks, therefore current courses
--                              SELECT * FROM mark m WHERE e.snum=m.snum AND e.cnum=m.cnum AND e.term=m.term AND e.section=m.section \ --courses with marks
--                      )
--              ) ON (c.cnum=e.cnum AND c.term=e.term AND c.section=e.section) \
--               WHERE c.cnum LIKE p.dept || '%' \     
--      )
--      AND dept NOT IN (--departaments currently offering classes of other departments
--              SELECT dept FROM professor p INNER JOIN class c ON (p.pnum=c.pnum) \
--              INNER JOIN ( --with current courses
--                      SELECT e.cnum, e.term, e.section FROM enrollment e WHERE NOT EXISTS ( \ --courses with no marks, therefore current courses
--                              SELECT * FROM mark m WHERE e.snum=m.snum AND e.cnum=m.cnum AND e.term=m.term AND e.section=m.section \ --courses with marks
--                      )
--              ) ON (c.cnum=e.cnum AND c.term=e.term AND c.section=e.section) \
--              WHERE c.cnum NOT LIKE p.dept || '%' \

--      )

--QUESTION 6
select ( \
	select count (*) from ( \
		select snum, sum(case when (grade > 60 AND cnum LIKE '__1__')  then 1 else 0 end) as G60, \
		sum(case when (cnum LIKE '__1__') then 1 else 0 end) as ALLG \
		from mark group by snum \
	) tbl INNER JOIN student s ON (tbl.snum = s.snum) where tbl.G60=tbl.ALLG AND tbl.ALLG > 0 AND \
	s.year=2) \
* 100 / count(*) from student where year=2

--QUESTION 7

SELECT m.cnum, c.cname, m.term, COUNT(*)TTL_ENROLL, SUM(m.grade)/COUNT(*) AS AVERAGE \
FROM mark m INNER JOIN course c ON (m.cnum = c.cnum) \
GROUP BY  m.cnum, c.cname, m.term


--QUESTION 8
SELECT e2.cnum, e2.term, e2.section, c2.pnum, p2.pname, count(*) ENROLLCNT FROM enrollment e2 INNER JOIN \
class c2 ON ( e2.cnum=c2.cnum AND e2.term=c2.term AND e2.section=c2.section) INNER JOIN professor p2 ON ( \
p2.pnum=c2.pnum) WHERE EXISTS ( \
\
\
SELECT e.cnum, e.term, SUM(CASE WHEN p.dept='CS' THEN 1 ELSE 0 END) \
FROM enrollment e INNER JOIN class c ON ( \
c.cnum=e.cnum AND c.term=e.term AND c.section=e.section) \
INNER JOIN professor p ON (c.pnum=p.pnum) WHERE NOT EXISTS ( \
select * from mark m where e.snum=m.snum and e.cnum=m.cnum and e.term=m.term and e.section=m.section) \
\
AND e2.cnum=e.cnum AND e2.term=e.term \
\
GROUP BY e.cnum, e.term HAVING COUNT(CASE WHEN p.dept='CS' THEN 1 ELSE NULL END) > 0 \
) GROUP BY e2.cnum, e2.term, e2.section, c2.pnum, p2.pname ORDER BY e2.cnum ASC, e2.section ASC


--QUESTION 9
SELECT m2.cnum, m2.term, m2.section, MIN(m2.grade) MINI, MAX(m2.grade) MAXI, p.pnum, p.pname \
FROM mark m2 INNER JOIN class c ON (c.cnum=m2.cnum AND c.term=m2.term AND c.section=m2.section) \
INNER JOIN professor p ON (c.pnum=p.pnum) \
WHERE EXISTS ( \
	SELECT m.cnum, m.term, count(DISTINCT c.pnum) FROM mark m \
	INNER JOIN class c ON (m.cnum=c.cnum AND m.section=c.section AND m.term=c.term) \
	WHERE m2.cnum=m.cnum AND m2.term=m.term \
	GROUP BY m.cnum, m.term HAVING count(DISTINCT c.pnum) > 1 \
) GROUP BY m2.cnum, m2.term, m2.section, p.pnum, p.pname

--QUESTION 10
SELECT COUNT (DISTINCT pnum) * 100 / (SELECT COUNT(*) FROM PROFESSOR) FROM ( \
	SELECT pnum, term, COUNT(DISTINCT cnum) AS DIFFCOUR FROM class GROUP BY pnum, term \
) WHERE DIFFCOUR >= 2
