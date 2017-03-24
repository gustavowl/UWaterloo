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
