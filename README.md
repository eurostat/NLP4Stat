# NLP4Stat
## Project organisation
- Docker images
- [Enrichement](https://github.com/eurostat/NLP4Stat/tree/main/Enrichment)
- Illustrations
- KD model
- Scrapper : Python project where the various spiders are implemented
- Script SQL : Script to build the content database
- Use Case A:
    - [Use Case A Widgets Demo](https://github.com/eurostat/NLP4Stat/tree/main/Use%20Case%20A%20Widgets%20Demo) : for demonstration of ipywidgets only, as part of deliverable D3.1. This is **superseded** by the next codes which are part of deliverable D3.2. 
    - [Use Case A Query builder](https://github.com/eurostat/NLP4Stat/tree/main/Use%20Case%20A%20Query%20builder): Script towards a query builder, still based only on scraped content (the latest version from both Glossary articles and Statistics Explained articles). 
    - [Use Case A Faceted search](https://github.com/eurostat/NLP4Stat/tree/main/Use%20Case%20A%20Faceted%20search): Faceted search. Work in progress, with inputs from the database (SE articles) except from one file (scraped categories per article - these are in the process of being transferred to the knowledge database). Among others, the code assigns the majority of the SE articles to (possibly more than one) themes, sub-themes and categories.
    - [Use Case A Graphical exploration](https://github.com/eurostat/NLP4Stat/tree/main/Use%20Case%20A%20Graphical%20exploration). Two applications for graphical exploration, one in R Shiny and another in MS Power BI. See separate description in this link.



## Project instantiation

### 1. Docker image
Create the docker image using the `docker-compose up docker-compose.yml`. The [docker-compose.yml](Docker%20Images/docker-compose.yml) is in the `Docker Images` folder. 

### 2. Conmect to the Virtuoso docker image

In a browser go to http://localhost:8890
and on the Virtuoso frontend/GUI click on Conductor login using the username `dba` and the password defined in the [docker-compose.yml](Docker%20Images/docker-compose.yml) file.

### 3. Virtuoso user parameters

![Virtuoso conductor](/Illustrations/virtuoso_conductor_homepage.PNG)

Go to System Admin/User accounts , to be able to launch SPARQL queries, please edit the user account for the 'dba' user as such :

![Virtuoso User account edit](/Illustrations/virtuoso_conductor_user_account_edit.png)

![Virtuoso User account page](/Illustrations/virtuoso_conductor_user_accounts.PNG)

### 4. Content database

You will find in the Script SQL folder various file that help buil the content database. You can go to the  Datatbase/Interactive SQL tab.
![Virtuoso interactive SQL](/Illustrations/virtuoso_conductor_interactive_SQL.PNG)

#### 4.1 Structure

If it is your first instantiation, please use the ![global script](/Script%20SQL/cdb_global_v1_2021-06-01.sql)

If you are updating an existing database the needed scripts can be find in the Script SQL folder


#### 4.2 Static data

Some tables have to be filled in order for the project to work, such as:
- Named entities
- Modality

Like before, if it is your first instantiation of the database,  please use the ![global script](/Script%20SQL/cdb_global_data_v1_2021-06-01.sql) .

If it is an update, the scripts needed can be find in the Script SQL folder

### 5. Knowledge database

#### 5.1 Loading ontologies

Before populating the KDB, the ontology file must be added to the database. Go to Virtuoso Conductor/Linked Data/Quad Store Upload and load the NLP4Stat ontology by uploading the .owl file in https://github.com/eurostat/NLP4Stat/tree/main/KD%20model/. In the "Named Graph IRI*" field, write https://ec.europa.eu/eurostat/resource/ontology/. This IRI will be used in the process of populating the KDB.

#### 5.2 Knowledge database population 
WIP

### 6. Virtuoso Bundle
In order to launch the various part of the project from a Windows environment, please follow the procedure described in [Virtuoso Setup](https://github.com/eurostat/NLP4Stat/blob/main/Virtuoso%20Setup/README.md)

The Virtuoso database is now set up. The first step is now to fill the content database with scrapped content. Please refer to the [Scrapper](Scrapper) folder.
