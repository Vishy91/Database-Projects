# Database-Projects
1. K-means

* Implemented the k-means algorithm. 
* The input data is given in a relation Points(PId,x,y) where PId is an integer denoting a point
    and x and y are FLOATS given the x and y coordinates of that point.
* The algorithm works for various values of k.
* For more information about k-means clustering [click here](https://en.wikipedia.org/wiki/K-means_clustering.)
* There, the k-means algorithm is given for a d-dimensional space. In this implemntation, d = 2.


2 Dijkstra’s Algorithm

* Suppose you have a weighted directed graph G = (V,E) stored in a ternary table named Graph in your database. 
* A triple (n,m,w) in Graph indicates that G has an edge (n,m) where n is the source, m is the target, and w isthe edge’s weight. (In this problem, we will assume that each edge-weight is a positive integer.)
* Implement Dijkstra’s Algorithm as a Postgres function Dijkstra to com-pute the shortest path lengths (i.e., the distance) from some input node n in G to all other nodes in G. 
* Dijkstra should accept an argument n, the source node, and output a table Paths which stores the pairs (n, dm) where dm is the shortest distance from n to m. To test your procedure, you can use the graph shown in Figure 2. 
* The corresponding table structure for G is given as the following Graph table.

| Source        | Target           | Weight  |
| ------------- |:-------------:| -----:|
| 0      | 1 | 2 |
| 0     | 4      |   10 |
| 1 | 2      |   3 |
| 1 | 4      |   7 |
| 2 | 3  | 4 |
| 3 | 4  | 5 |
| 4 | 2  | 6 |
*When you issue CALL Dijkstra(0), you should obtain the following Paths table:*

|Target | Distance |
| ------------- |:-------------:| 
|0 | 0 |
|1 | 2 |
|2 | 5 |
|3 | 9 |
|4 | 9 |

3  Parent Child

* Consider the following relational schema. A tuple (pid, cpid) is in Parent Child if pid is a parent of child cid.

    Table: Parent_Child 

    |PId | SId |
    | ------------- |:-------------:| 

* It is assumed that the domain of PId and SId is INTEGER.
* Implemented a Postgres program that computes the pairs (id1, id2) such that id1 and id2 belong to the same generation in the Parent-Child relation and id1 6= id2. (id1 and id2 belong to the same generation if their distance to the root in the Parent-Child relation is the same.)

4  Set difference

* A simulation in Postgres of a MapReduce program that implements the set difference of two relations R(A) and S(A).
* I have assumed that the domain of A is INTEGER.

5 Natural join
 
* A simulation  in Postgres of a MapReduce program that implements the natural join R ⊲⊳ S of two relations R(A,B) and S(B,C).
* I have assumed that the domain of A, B, and C is INTEGER. 