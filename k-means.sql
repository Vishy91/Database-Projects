--  The task is to implement k-means algorithm. 
-- The input data is given in a relation Points(PId,x,y) where PId is an integer denoting a point and x and y are FLOATS given the x and y coordinates of that point.
-- Your algorithm should work for various values of k. For more information about k-means clustering consult
-- https://en.wikipedia.org/wiki/K-means_clustering.
-- There, the k-means algorithm is given for a d-dimensional space. In this implementation, d = 2.


--k-means Clustering
--STEP 1: CREATE TABLES
CREATE TABLE POINTS(PId integer PRIMARY KEY,x float,y float);

CREATE TABLE  CENTROID(CId integer PRIMARY KEY,x float,y float);

CREATE TABLE CLUSTER_NUMBERS(
PId integer REFERENCES Points(PId),
CId integer REFERENCES CENTROID(CId));
SELECT * FROM POINTS
-----------------
--STEP 2: GENERATE POINTS TO BE CLUSTERED USING THE RANDOM FUNCTION
CREATE OR REPLACE FUNCTION GenRandomPoint(lowerL float, upperL float, count INTEGER)
RETURNS void AS $$

BEGIN
FOR i in 1..count LOOP
INSERT INTO Points
SELECT i, random()*(upperL-lowerL)+lowerL, random()*(upperL-lowerL)+lowerL;
END LOOP;
END

$$ LANGUAGE plpgsql;


-----------------
--STEP 3: GENETRATE INITIAL CENTROIDS. THESE ARE RANDOM CENTROIDS IN THE GIVEN RANGE
CREATE OR REPLACE FUNCTION  InitiateCentroid(lowerL float, upperL float, k INTEGER)
RETURNS void AS $$

BEGIN
FOR i in 1..k LOOP
INSERT INTO CENTROID
SELECT i, random()*(upperL-lowerL)+lowerL, random()*(upperL-lowerL)+lowerL;
END LOOP;
END
$$ LANGUAGE plpgsql;

-----------------
--STEP 4: ASSIGN N NUMBER OF INITIAL CLUSTERS.
CREATE OR REPLACE FUNCTION  AssignCluster(count INTEGER)
RETURNS void AS $$
BEGIN

FOR i in 1..count LOOP
INSERT INTO CLUSTER_NUMBERS
SELECT i, 1;
END LOOP;

END
$$ LANGUAGE plpgsql;

-----------------
---
-- drop function if exists k_meansalgorithm();
CREATE OR REPLACE FUNCTION  K_MEANSALGORITHM( n INTEGER, ITER INTEGER, k INTEGER)
RETURNS void AS $$

BEGIN
FOR s in 1..iter LOOP
	FOR t in 1..n LOOP
		UPDATE CLUSTER_NUMBERS
		SET CId = (select C1.CId FROM CENTROID C1 
			   ORDER BY (C1.x-(select x from Points P1 where P1.PId = t)^2)+(C1.y-(select y from Points P1 where P1.PId = t)^2) ASC LIMIT 1) ---http://stackoverflow.com/questions/1485391/how-to-get-first-and-last-record-from-a-sql-query
		WHERE PId = t;
	END LOOP;
	UPDATE CENTROID C1
	SET  y = Q.y1,x = Q.X1 FROM 
	(select CL1.CId, avg(P.x) as X1, avg(P.y) as Y1 
	FROM Points P, CLUSTER_NUMBERS CL1
	WHERE P.PId = CL1.PId
	GROUP BY (CL1.CId)) Q
	WHERE C1.CId = Q.CId;
END LOOP;	
END

$$ LANGUAGE plpgsql;
---------------------------------
DROP TABLE CLUSTER_NUMBERS;

DROP TABLE POINTS;

DROP TABLE CENTROID;
CREATE TABLE POINTS(PId integer PRIMARY KEY,x float,y float);

CREATE TABLE  CENTROID(CId integer PRIMARY KEY,x float,y float);

CREATE TABLE CLUSTER_NUMBERS(
PId INTEGER REFERENCES Points(PId),
CId INTEGER REFERENCES CENTROID(CId));
SELECT * FROM POINTS


SELECT GenRandomPoint(1.00,1000.00,1000);

SELECT InitiateCentroid(1.00,1000.00,70);

SELECT AssignCluster(7);


DELETE FROM CLUSTER_NUMBERS
SELECT K_MEANSALGORITHM(100,6,70);
SELECT * from CLUSTER_NUMBERS;
SELECT * FROM CENTROID

