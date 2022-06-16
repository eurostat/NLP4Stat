
## Populating of the knowledge database

-   Eurostat_Populate_Glossary_Explained_Articles is the code for the population with articles (SE + SE Glossary).

-   Eurostat_Populate_Glossary_LinkInfo is the code for the population with Eurostat's Glossary articles, and the links between articles.

-   Eurostat_Populate_OECD is the code for the population with ΟECD's data.

-   Eurostat_Populate_Term_Topic_Type is the code for the population with terms, topics, types and named entities.

-   Folder EuroStat contains two Python scripts, two text files, one Excel file and one .ttl file:
    - EuroStatDataset.py script creates the classes of the datasets, leaf classes and intermediate classes. The data are stored i) in file classes.txt, which contains only the names of the classes, and ii) in file hierarchy.txt which contains the hierarhy between the classes and iii) in file 
    - EuroStatDatasetGround.py creates all the additional information that exists for the datasets, such as the file descriptions, the database paths, the codes, and their labels, among others. This information is stored in the dataset.ttl file.
    - To obtain a complete "dataset part" of the ontology, please execute EuroStatDataset.py and EuroStatDatasetGround.py. Then, copy-paste the contents of classes.txt and hierarchy.txt into dataset.ttl. 
