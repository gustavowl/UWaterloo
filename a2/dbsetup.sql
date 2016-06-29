insert into author values (3, 'Michele Mosca', NULL)
insert into author values (4, 'Eugene Zima Kenobi', NULL)
--
insert into PUBLICATION VALUES ('QNC001', 'Quantum Computing') --book 1 author
insert into PUBLICATION VALUES ('QNC002', 'Quantum Operating Systems') -- book 2 authors
--
INSERT INTO book VALUES ('QNC001', 'Punisher', 2016)
INSERT INTO book VALUES ('QNC002', 'Punisher', 2017)
--
INSERT INTO wrote VALUES (3, 'QNC001', 1)
INSERT INTO wrote VALUES (3, 'QNC002', 1)
INSERT INTO wrote VALUES (4, 'QNC002', 2)
--
INSERT INTO publication VALUES ('OS001', 'Russian Operating Systems')
--
INSERT INTO book VALUES ('OS001', 'Starbucks', 2017)
--
INSERT INTO wrote VALUES (4, 'OS001', 1)
--
INSERT INTO publication VALUES ('COMP001', 'Bumbulis` Russian Compilers')
--
INSERT INTO book VALUES ('COMP001', 'Starbucks', 2016)
--
INSERT INTO wrote VALUES (1, 'COMP001', 1)
INSERT INTO wrote VALUES (4, 'COMP001', 2)
--
INSERT INTO publication VALUES ('JRN001', 'JOURNAL 001')
INSERT INTO publication VALUES ('PR001', 'PROCEEDING 001')
INSERT INTO publication VALUES ('OS002', 'Operating System Article in Journal')
INSERT INTO publication VALUES ('OS161', 'OS161 at Uwaterloo')
--
INSERT INTO proceedings VALUES ('PR001', 2014)
--
INSERT INTO journal VALUES ('JRN001', 1, 1, 2015)
--
INSERT INTO article VALUES ('OS002', 'JRN001', 73, 85)
INSERT INTO article VALUES ('OS161', 'PR001', 161, 170)
--
INSERT INTO wrote VALUES (4, 'OS002', 1)
INSERT INTO wrote VALUES (4, 'OS161', 1)