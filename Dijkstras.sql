--Suppose you have a weighted directed graph G = (V, E) stored in a ternary table named Graph in your database. A triple (n, m, w) in Graph indicates that G has an edge (n, m) where n is the source, m is the target, and w is the edge’s weight. (In this problem, we will assume that each edge-weight is a positive integer.)
-- Implement Dijkstra’s Algorithm as a Postgres function Dijkstra to com-pute the shortest path lengths (i.e., the distance) from some input node n in G to all other nodes in G. Dijkstra should accept an argument n, the source node, and output a table Paths which stores the pairs (n, dm) where dm is the shortest distance from n to m. To test your procedure, you can use the graph shown in Figure 2. The corresponding table structure for G is given as the following Graph table.

create table graph(src INTEGER,t INTEGER,wght INTEGER);
select * from graph


create table if not exists DistTosrc(
TARGET INTEGER,
dist INTEGER);

insert into graph values(0,1,2),(0,4,10),(1,2,3),(1,4,7),(2,3,4),(3,4,5),(4,2,6);


-- drop table graph

-----------------

create or replace function calcDistTosrc(n INTEGER, dist INTEGER)
RETURNS void AS $$ 
DECLARE i INTEGER;
BEGIN

insert into DistTosrc
select G.t, (G.wght+dist) FROM graph G where G.src = n;
for i in (select G.t FROM graph G where G.src = n) LOOP
	IF (EXISTS (select G.t FROM graph G where G.src = i AND G.t NOT IN (select TARGET from DistTosrc) )) THEN
		select min(D.dist) from DistTosrc D where D.target = i INTO dist;
		PERFORM calcDistTosrc(i,dist);
	END IF;
END LOOP;
END
$$ LANGUAGE plpgsql;

-----------------

create or replace function Dijkstras(n INTEGER)
RETURNS TABLE(TARGET INTEGER, dist INTEGER) AS $$

insert into DistTosrc values(n,0);
select calcDistTosrc(n,0);
select DT.target, min(DT.dist) from DistTosrc DT
GROUP BY DT.target
order by 1,2
$$ LANGUAGE SQL;


select Dijkstras(0);

