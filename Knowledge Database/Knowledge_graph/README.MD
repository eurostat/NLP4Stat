# Knowledge graph creation


- [Knowledge_graph_2021_12_05.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Knowledge%20Database/Knowledge_graph/Knowledge_graph_2021_12_05.ipynb) : this is an **updated version in a single Jupyter notebook** and replaces the previous version.

The steps are as follows: 

After connecting to the knowledge base:

1. We select the type of relations that will be used in the knowledge graphs, namely:
[estat:relatedLegallnformation, 
estat:relatedEditorialContent,
estat:relatedStatisticData,
estat:sourceInformation,
estat:sourceData,
estat:dataInformation,
skos:related]

    and create a dataframe *results\_relations*, which has all triplets (s,p,o) with p.value in the list of selected relations.

2. In the second step, we select all titles, from the triplets (s,p,o) with p in [skos:prefLabel, dct:title] and we put them in a dataframe *results\_titles*.  

3. In a similar way, we collect all resource types, from the triplets (s,dct:type,o) and put them in a dataframe *results\_types*.

4. Then we create a function **create\_node_tables()** which accepts the three dataframes above and creates all information required for the nodes:
 
    - A dataframe *node\_table* which has the unique s and o values from *results\_relations*, together with the “cleaned” resource types of the nodes (missing types are replaced by empty strings), the titles of the nodes (nodes with missing titles are dropped) and the more descriptive titles from the concatenation of the type labels with the titles. 

    - A second look-up dataframe *node\_type\_table* which has the unique types and the cleaned type labels. 

    - A reduced dataframe *data\_for\_network\_nodes* which contains a subset of the columns of *node\_table*, with the titles, type IDs and size, initially 1.

    - The function returns all three dataframes, *node\_table*, *node\_type\_table* and *data\_for\_network\_nodes*.

5. Similarly, we define a function **create\_edge\_tables()** which accepts the dataframes *results\_relations* and *node\_table* and creates all information required for the edges:
 
    - A look-up dataframe *edge\_type\_table* which has the unique relations types together with an ID.
    - A dataframe *data\_for\_network\_edges* which has the relations with additional information for the nodes. In particular, for each pair of nodes s,o in a triplet (s,p,o) it contains the titles of the nodes (each as empty string if missing) from *node\_table*.

    - The function returns these two dataframes, *data\_for\_network\_edges* and *edge\_type\_table*.

6. Next, we define a function **pattern\_material\_selection\_for\_KG()**. This accepts as arguments the dataframes *data\_for\_network\_nodes* and                                      *data\_for\_network\_edges*, a *pattern* to search and a minimum number of links (*min\_nb\_links*) in order to display a node.

    This function selects all nodes with a label containing the pattern and all edges which have as source or as target these nodes. Edges are de-duplicated and those with blank source or target labels are discarded. Then, the frequencies of target nodes per source node are found and those source nodes which are connected with more than *min\_nb\_links* target nodes are marked.

    Edges with a marked node either as source or as target are kept.

    The function returns the node and edges information in two dataframes, *data\_for\_network\_nodes\_pattern\_min* and *data\_for\_network\_edges\_pattern\_min*.

7. Function **draw\_network()** accepts the two dataframes returned by *pattern\_material\_selection\_for\_KG()* and draws the graph, using **[pyvis](https://pyvis.readthedocs.io/en/latest/introduction.html)** which is a wrapper around the popular Javascript visJS library.

8. Finally, function **create\_graph()** accepts the dataframes *data\_for\_network\_nodes* and                  *data\_for\_network\_edge*s, the *pattern* to  be used and the parameter *min\_nb\_links*. It calls function *pattern\_material\_selection\_for_KG()* and then the function *draw\_network()*.

9. In all examples, we carry out the initial processing by calling *create\_node\_tables()* and *create\_edge\_tables()*. Then we call function *create\_graph()* with the *pattern* to be used and the parameter *min\_nb\_links*.

Examples:
![Climate]("/Figs/download_climate.png")

