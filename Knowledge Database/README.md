### Revision note (April 2002): The new ontologies and the new KD documentation are in folder [KD model v2](https://github.com/eurostat/NLP4Stat/tree/testing/Knowledge%20Database/KD%20model%20v2).

### 1. Knowledge database

#### 1.1 Loading and deleting ontologies

Before populating the KDB, the ontology file must be added to the database. Go to Virtuoso Conductor/Linked Data/Quad Store Upload and load the NLP4Stat ontology by uploading the .owl file in https://github.com/eurostat/NLP4Stat/tree/testing/Knowledge%20Database/KD%20model. In the "Named Graph IRI*" field, write https://nlp4statref/knowledge/ontology/. This IRI will be used in the process of populating the KDB.
A already added ontology can be deleted by going to Linked Data/Graphs/Graphs and click on Delete button associated to the ontology you wish to delete. 

#### 1.2 Knowledge database population 

The KD_Population folder contains notebooks used for populating the knowledge database with elements stored in the content database, using SPARQL queries. 
A demo notebook is available to select elements contained in the KDB.
The ESTAT_Populate_KDB notebooks contain the addition of all elements that are currently stored and mapped (i.e. relations are modeled).
As the process does not include a verification step of the presence of a triplet before adding it, the notebook should be launched once. Do not hesitate to delete and add anew the ontology before populating it again using the notebook. 

#### 1.3 Knowledge graph

A knowledge graph can be created using the elements of the Knowledge_graph folder. A dedicated readme file is there. 

### 2. Virtuoso Bundle
In order to launch the various part of the project from a Windows environment, please follow the procedure described in [Software Environment](https://github.com/eurostat/NLP4Stat/tree/testing/Software%20Environment).

The Virtuoso database is now set up. The first step is now to fill the content database with scrapped content. Please refer to the [Scrapper](Scrapper) folder.
