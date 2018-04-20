-- Consider the following relational schema. A tuple (pid, cpid) is in Parent Child
-- if pid is a parent of child cid.
-- You can assume that the domain of PId and SId is INTEGER.
-- Write a Postgres program that computes the pairs (id1, id2) such that id1
-- and id2 belong to the same generation in the Parent-Child relation and id1 = id2. (id1 and id2 belong to the same generation if their distance to the root in the Parent-Child relation is the same.)
drop table parent_child
create table Parent_Child(PId INTEGER,C_PId INTEGER);

insert into Parent_Child values(1,2),(1,3),(3,4),(3,5),(4,6),(4,7),(4,8),(7,9);
select * from parent_child


create or replace function find_parent_child()
returns void AS $$
begin
	create table if not exists root(rpid integer);
	insert into root
	select pid from Parent_Child
	where pid not in (select c_pid from parent_child);
--step 2
	create table if not exists root1(rpid1 integer);
	create table if not exists pairs(rpid integer,rpid1 integer);
	truncate table pairs;
	while exists  (select rpid from root) loop
		truncate table root1;
		insert into root1
		select rpid from root;
		insert into pairs
		select distinct r.rpid1,r2.rpid1
		from root1 r,root1 r2
		where r.rpid1<>r2.rpid1;
		truncate table root;
--all child of ancestor1 should be in ancestor
		insert into root
		select c_pid from Parent_Child pc inner join root1 r1 on r1.rpid1=pc.pid;
	end loop;
end;
$$ LANGUAGE plpgsql;

select find_parent_child()
----ANSWER
select * from pairs
--delete from pairs

