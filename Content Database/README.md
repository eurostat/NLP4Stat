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
If it is an update, the scripts needed can be find in the [Statistics Explained folder](./CDB%20content/Script%20SQL/Statistics%20Explained). Launch the scripts in the following order : 

-	[cdb_link_info_v1.sql](./CDB%20content/Script%20SQL/Statistics%20Explained/cdb_link_info_v1.sql)
-	[cdb_glossary_v2.sql](./CDB%20content/Script%20SQL/Statistics%20Explained/cdb_glossary_v2.sql)
-	[cdb_articles_v1.sql](./CDB%20content/Script%20SQL/Statistics%20Explained/cdb_articles_v1.sql)
-	[estat_news_exp_stat.sql](./CDB%20content/Script%20SQL/Statistics%20Explained/estat_news_exp_stat.sql)


Once the structure is set you can launch the following files to fill the modality’s tables
-	[cdb_resources_mod_data.sql](./CDB%20content/Script%20SQL/Statistics%20Explained/cdb_resources_mod_data.sql)
-	[cdb_global_se_data_v1.sql](./CDB%20content/Script%20SQL/Statistics%20Explained/cdb_global_se_data_v1.sql)

Once the database is set you can start launching the various spiders.

## 4. Eurostat glossary
Regarding the structure, if you used the cdb_global_v2.sql file you can go to the data insertion part, if not you can go to the [Estat13k folder](./CDB%20content/Script%20SQL/Estat13k), and launch the following scripts : 
-	[estat13k_modalities.sql](./CDB%20content/Script%20SQL/Estat13k/estat13k_modalities.sql)
-	[estat13k_glossary.sql](./CDB%20content/Script%20SQL/Estat13k/estat13k_glossary.sql)

In order to gather the glossary instead of scrapping the data we used the bulkdownload option and created SQL queries from it.

First the modality queries ([estat13k_modalities_data.sql](./CDB%20content/Script%20SQL/Estat13k/estat13k_modalities_data.sql)) have to be launched.

Then the [estat13k_glossary_data.sql](./CDB%20content/Script%20SQL/Estat13k/estat13k_glossary_data.sql) , in order to do it use the following Jupiter Notebook : cdb_insert.ipynb

Finally, you can add the last queries : estat13k_stat_and_measurement_unit_data.sql


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
