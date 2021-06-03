# NLP4Stat
## Project organisation
- Enrichement
- Illustrations
- KD model
- Scrapper : Pyhton project where the various spiders are implemented
- Script SQL : Script to build the content database
- Use Case A Widgets Demo


## Project instantiation

### 1. Docker image
Create the docker image using the `docker-compose up [docker-compose.yml](Docker Images/docker-compose.yml)` 

### 2. Conmect to the Virtuoso docker image

In a browser go to http://localhost:8890
and on the Virtuoso frontend/GUI click on Conductor login using the username `dba` and the password defined in the [docker-compose.yml](Docker Images/docker-compose.yml) file.

### 3. Virtuoso user parameters

![Virtuoso conductor](/Illustrations/virtuoso_conductor_homepage.PNG)

Go to System Admin/User accounts , to be able to launch SPARQL queries, please edit you user account as such :
![Virtuoso User account page](/Illustrations/virtuoso_conductor_user_accounts.PNG)

### 4. Content database

You will find in the Script SQL folder various file that help buil the content database. You can go to the  Datatbase/Interactive SQL tab.
![Virtuoso interactive SQL](/Illustrations/virtuoso_conductor_interactive_SQL.PNG)

#### 4.1 Structure

If it is your first instantiation, please use the ![global script](/Script%20SQL/cdb_global_v1_2021-06-01.sql)

If you are updating an existing database the needed scripts can be find in the Script SQL folder


#### 4.2 Static data

Some tables have to be fille in order for the project to work, such as:
- Named entities
- Modality

Like before, if it is your first instantiation of the database,  please use the ![global script](/Script%20SQL/cdb_global_data_v1_2021-06-01.sql) .

If it is an update, the scripts needed can be find in the Script SQL folder

### 5. Knowledge database

#### 5.1 Loading ontologies

### 6. Virtuoso Bundle
In order to launch the various part of the project from a Windows environment, please follow the procedure : http://vos.openlinksw.com/owiki/wiki/VOS/VOSUsageWindows#Optional%20--%20Register%20the%20VOS%20ODBC%20Driver


The Virtuoso database is now set up. The first step is now to fill the content database with scrapped content. Please refer to the Scrapper folder.
