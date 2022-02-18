# Setup the Content Database

You will find in the Script SQL folder various file that help build the content database. You can go to the Database/Interactive SQL tab.
![Virtuoso interactive SQL](./Figs/virtuoso_conductor_interactive_SQL.PNG)
## 1. Setup the structure

If it is your first instantiation, please use the [global script cdb_global_v2.sql](
./CDB%20content/Script%20SQL/cdb_global_v2.sql)

If you are updating an existing database the needed scripts can be find in each specific folder.

## 2. Static data
Some tables have to be filled in order for the project to work, such as:
- Named entities
-	Modality

## 3. Statistics Explained Data
Like before, if it is your first instantiation of the database, please use the global script :  [global script cdb_global_v2.sql](
./CDB%20content/Script%20SQL/cdb_global_v2.sql)
If it is an update, the scripts needed can be find in the [Statistics Explained folder](./CDB%20content/Script%20SQL/Statistics Explained/). Launch the scripts in the following order : 

-	[cdb_link_info_v1.sql](./CDB%20content/Script%20SQL/Statistics Explained/cdb_link_info_v1.sql)
-	[cdb_glossary_v2.sql](./CDB%20content/Script%20SQL/Statistics Explained/cdb_glossary_v2.sql)
-	[cdb_articles_v1.sql](./CDB%20content/Script%20SQL/Statistics Explained/cdb_articles_v1.sql)
-	[estat_new_exp_stat.sql](./CDB%20content/Script%20SQL/Statistics Explained/estat_new_exp_stat.sql)


## 3. Load Statistics Explained Data

For Statistics Explained data for the first instantiation of the database,  please use the [global SE script](Content%20Database/CDB%20content/Script%20SQL/Statistics%20Explained/cdb_global_se_data_v1.sql).

Error ![global SE script](./Figs/se_global_error.jpg)

## 4. Create ODBC connection to the Virtuoso server on Windows

* Open the ODBC Data Sources (64-bit) tool in control panel, go to Tab System DSN and create a new data source selecting the Virtuoso (Open Source) driver. Press Finish to start the configuration.

<img src="./Figs/Virtuoso_setup3.JPG" alt="Virtuoso setup3" width="600"/>
 
* Fill the first configuration screen as follows. Do NOT put http:// or https:// in front of the server address.

<img src="./Figs/Virtuoso_setup4.JPG" alt="Virtuoso setup4" width="600"/>

* In the next screen, fill-in your user name and password (the default is user:dba, password:dba) and press Next:

<img src="./Figs/Virtuoso_setup5.JPG" alt="Virtuoso setup5" width="600"/>

* A connection should be established. Change the default database to ESTAT and press Finish.

<img src="./Figs/Virtuoso_setup6.JPG" alt="Virtuoso setup6" width="600"/>

* Restart your system. You should be able to connect to the database using pyodbc. In the call to connect() replace "user name" and "password" with your credentials, all within the connection string.

<img src="./Figs/Virtuoso_setup8.JPG" alt="Virtuoso setup8" width="600"/> 

Once the database is set you can start launching the [article spiders](Content%20Database/CDB%20content/Scrapper/README.md)


## 5. Load Eurostat glossary data
In order to gather the glossary instead of scrapping the data we used the bulkdownload option and created SQL queries from it.

First the [modality queries](Content%20Database/CDB%20content/Script%20SQL/Estat13k/estat13k_modalities_data.sql) have to be launch. 
??????? do we need this and where in Virtuoso Interactive SQl query


Then the [glossary data](Content%20Database/CDB%20content/Script%20SQL/Estat13k/estat13k_glossary_data.sql), in order to do it use the following [Jupyter Notebook](Content%20Database/CDB%20content/Script%20SQL/cdb_insert.ipynb) or the [python code](Content%20Database/CDB%20content/Script%20SQL/cdb_insert.py)

Finally, you can add the last queries : [estat13k_stat_and_measurement_unit_data](Content%20Database/CDB%20content/Script%20SQL/Estat13k/estat13k_stat_and_measurement_unit_data.sql)

??????? do we need this and where in Virtuoso Interactive SQl query


# to be continue...


????????If you are updating an existing database the needed scripts can be find in the ![Script SQL folder](Content%20Database/CDB%20content/Script%20SQL) 



?????????If it is an update, the scripts needed can be find in the ![Script SQL folder](Content%20Database/CDB%20content/Script%20SQL/Statistics%20Explained)

Once the database is set you can start launching the various ![spiders](Content%20Database/CDB%20content/Scrapper/README.md)

##### 4.2.2 Eurostat glossary
In order to gather the glossary instead of scrapping the data we used the bulkdownload option and created SQL queries from it.

First the ![modality queries](Content%20Database/CDB%20content/Script%20SQL/Estat13k/estat13k_modalities_data.sql) have to be launch.

Then the ![glossary data](Content%20Database/CDB%20content/Script%20SQL/Estat13k/estat13k_glossary_data.sql), in order to do it use the following Jupiter Notebook : ![cdb_insert.ipynb](Content%20Database/CDB%20content/Script%20SQL/cdb_insert.ipynb)

Finally, you can add the last queries : ![estat13k_stat_and_measurement_unit_data](Content%20Database/CDB%20content/Script%20SQL/Estat13k/estat13k_stat_and_measurement_unit_data.sql)

##### 4.2.3 Dictionnary and Datasets
As previously, we did not scrap the following datas, we first downloaded the raw and created SQL queries in order to fill the database.

The first step is to fill the ![mod_dictionnary table](Content%20Database/CDB%20content/Script%20SQL/Dictionnary%20and%20datasets/estat_dictionnary_label_data.sql) and then using ![cdb_insert.ipynb](Content%20Database/CDB%20content/Script%20SQL/cdb_insert.ipynb) launch each ![dictionnary_code_data_batch](Content%20Database/CDB%20content/Script%20SQL/Dictionnary%20and%20datasets). 

At these stage, the dictionnary and code are all in the content database, however we found that we have to add somme code to the time dictionnary in order for our work on the datasets to work. You'll find the added elemnts ![here](Content%20Database/CDB%20content/Script%20SQL/Dictionnary%20and%20datasets/estat_dictionnary_code_data_time_addition.sql)

Then you can add some ![datasets](Content%20Database/CDB%20content/Script%20SQL/Dictionnary%20and%20datasets/estat_dataset_label_data.sql) and then using ![cdb_insert.ipynb](Content%20Database/CDB%20content/Script%20SQL/cdb_insert.ipynb) launch each ![dictionnary_code_data_batch](Content%20Database/CDB%20content/Script%20SQL/Dictionnary%20and%20datasets) to add the links between the datasets and the dictionnaries. 
