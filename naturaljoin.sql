-- Simulation in Postgres of a MapReduce program that implements the natural join R ⊲⊳ S of two relations R(A, B) and S(B, C).
-- You can assume that the domain of A, B, and C is INTEGER.

DROP TABLE IF EXISTS R;
DROP TABLE IF EXISTS S;
CREATE TABLE R (A INTEGER,B INTEGER);
CREATE TABLE S (B INTEGER,C INTEGER);
INSERT INTO R VALUES (12,3),(13,4),(1,5),(2,6),(3,7),(4,8),(5,9);
INSERT INTO S VALUES (1,5),(12,6),(13,7),(7,8),(3,9);
SELECT * FROM R;
SELECT * FROM S;

-- Map :

CREATE OR REPLACE FUNCTION MAP(col1 INTEGER, col2 INTEGER[])
RETURNS TABLE(colB INTEGER, colmap INTEGER) AS 
$$
select col1, MAP1.c FROM (select UNNEST(col2) AS c) MAP1;
$$ 
LANGUAGE SQL;

CREATE OR REPLACE FUNCTION mapNATURALJOIN()
RETURNS VOID AS $$
BEGIN
DROP TABLE IF EXISTS MAP_NATURAL;
DROP TABLE IF EXISTS TEMP1;
CREATE TABLE MAP_NATURAL (COLB INTEGER,COLCOM INTEGER);
CREATE TABLE temp1(COLB INTEGER,COLCOM INTEGER[]);
insert into temp1
select TEM1.b, TEM1.ARR from (select distinct r.b, ARRAY(select r1.A from R r1 where r.b = r1.b) as ARR from R r) TEM1;
insert into MAP_NATURAL
select Q.COLB, Q.COLMAP from TEMP1 Tp, LATERAL(select COLB, COLMAP from MAP(Tp.COLB, Tp.COLCOM)) Q;
delete from temp1;
insert into temp1
select TEM2.b, TEM2.ARR from (select distinct s1.B, ARRAY(select S.C from S s where s.B = s1.B ) as ARR from S s1) TEM2;
insert into MAP_NATURAL
select (-(Q.COLB)), Q.COLMAP from TEMP1 Tp, LATERAL(select COLB, COLMAP from MAP(Tp.COLB, Tp.COLCOM)) Q;
END

$$ LANGUAGE plpgsql;

select mapNATURALJOIN();

--select * from key_value_Natural;
--The Group Phase:

CREATE OR REPLACE FUNCTION  group_Natural()
returns void as $$

BEGIN
DROP TABLE IF EXISTS GROUPNATURAL;
CREATE TABLE GROUPNATURAL(Pair1 TEXT,Element2 INTEGER);
INSERT INTO GROUPNATURAL
select distinct (mn1.COLB, mn1.COLCOM), (select distinct mn.COLCOM from MAP_NATURAL mn where mn.COLB = -mn1.COLB)
from MAP_NATURAL mn1
where mn1.COLB > 0;

END
$$ LANGUAGE plpgsql;

select group_Natural();

--Reduce :

select split_part((pair1),',',1) as b,split_part((pair1),',',2) as a, GN.Element2 as c,(gn.pair1,gn.element2) AS "JOIN (B,A,C)"
from GROUPNATURAL GN where (GN.Element2) IS NOT NULL;
