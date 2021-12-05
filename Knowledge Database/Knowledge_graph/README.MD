# Knowledge graph creation

This folder contain elements to create a knowledge graph from data contained in the KDB. Tools involved are Python, R and d3.js.

In this folder you will find :
- Knowledge_graph_2021_12_05.ipynb : this is an **updated version in a single Jupyter notebook**. It will replace the previous version after a final check. Relevant comments will then be added here.
- Knowledge_graph_2021_09_21.ipynb : the notebook used to connect with the KDB and extract relations and data to create the knowledge graph.
- create_JSON_for_KG_V4.R : an R script used for formatting the data properly for the dataviz. It creates a json file with two elements : one with the nodes, one with the edges. In this version, three files are outputted, with nodes selected according to string pattern related to three topics : Covid-19, Quality of life and Climate change.
- data/ : a folder with the data extracted from the KDB. 
- legend_KG.jpg : the colors associated to the edges of the graph
- Three folders for the three topics. Each contains : 
	- neural_network_test.js : a Javascript file used to create the d3.js dataviz. 
	- data_for_network.XX.json : a json file outputted by the R Script
	- lib_kc_test_data.js : the file containing the data and the arguments of the d3.js dataviz
	- lib_kc_tests.html : the html file used to visualize the Knowledge graph


Instructions of the whole pipeline : 
1) Change the SPARQL data extraction limit in the Virtuoso Conductor by going through System Admin/Parameters/SPARQL and set ResultSetMaxRows to 100000 (or more). 
2) Run the notebook to extract data
3) Run the R script to create the json
4) Open the json files, copy and replace the json in the lib_kc_test_data.js file. (Notepad++ is a good tool for that). The "NeuralNetwork" part of the file can remain untouched but can be used to set the arguments of the KG.
5) Save the file and open the html file to see the network. 

Available parameters of this pipeline : 
- The chosen relations, in the notebook
- the chosen types of relations, in the R script

Possible Improvements : 
- Edges names should appear when passing the mouse over them
- Nodes should be more distant to improve clarity
- Colors coherence
- Make it all in a single notebook or script to simplify the pipeline
- Deploy it on a app and connect it to the KDB. 
