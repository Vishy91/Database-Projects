--Simulation in Postgres of a MapReduce program that implements the set diﬀerence of two relations R(A) and S(A).
--	You can assume that the domain of A is INTEGER.

DROP TABLE IF EXISTS R;
DROP TABLE IF EXISTS S;
CREATE TABLE R (A INTEGER);
CREATE TABLE S (A INTEGER);
INSERT INTO R VALUES (12),(13),(1),(2),(3),(4),(5);
INSERT INTO S VALUES (1),(12),(13),(7),(3);
SELECT * FROM S;

--MAP
CREATE OR REPLACE FUNCTION MAP(RELATION_NAME TEXT,A INTEGER[])
RETURNS TABLE(A INTEGER, RELATION_NAME TEXT) AS 
$$
SELECT MAP1.A1,RELATION_NAME FROM (select UNNEST(A) AS A1) MAP1; 
$$ LANGUAGE SQL;

create or replace function mapDIFFERENCE()
RETURNS VOID AS 
$$
BEGIN
DROP TABLE IF EXISTS MAP_DIFF;
create table if not exists MAP_DIFF(A INTEGER,RELATION_NAME TEXT);
insert into MAP_DIFF
select A, RELATION_NAME from MAP('R',(select ARRAY(select r.A from R r)));
insert into MAP_DIFF
select A, RELATION_NAME from MAP('S',(select ARRAY(select s.A from S s)));
END
$$ LANGUAGE plpgsql;

select mapDIFFERENCE();

select * from MAP_DIFF;

-- Group :

CREATE OR REPLACE FUNCTION groupDIFFERENCE()
RETURNS void as $$
BEGIN
DROP TABLE IF EXISTS GROUPDIFFER;
create table  groupDIFFER(A INTEGER,RELATION_NAME TEXT[]);
insert INTO groupDIFFER
select distinct GD1.A, (SELECT array(select distinct GD2.RELATION_NAME from MAP_DIFF GD2 where GD2.A = GD1.A))
from MAP_DIFF GD1;
END
$$ LANGUAGE plpgsql;

select groupDIFFERENCE();
SELECT * FROM groupDIFFER
--REDUCE

select GD.A AS "R-S"
from groupDIFFER GD
where GD.RELATION_NAME = ARRAY['R']
order by 1;

