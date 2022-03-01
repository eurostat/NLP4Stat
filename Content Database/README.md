# Setup the Content Database

You will find in the [Script SQL folder](/CDB%20content/Script%20SQL) various file that help build the content database. You can go to the Database/Interactive SQL tab.
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

Then the [estat13k_glossary_data.sql](./CDB%20content/Script%20SQL/Estat13k/estat13k_glossary_data.sql). In order to do it use the following Jupyter Notebook : [cdb_insert.ipynb](./CDB%20content/Script%20SQL/cdb_insert.ipynb)

Finally, you can add the last queries : [estat13k_stat_and_measurement_unit_data.sql](./CDB%20content/Script%20SQL/Estat13k/estat13k_stat_and_measurement_unit_data.sql)

## 5. CodeList and datasets
Regarding the structure, if you used the cdb_global_v2.sql file you can go to the data insertion part, if not you can go to the [CodeList and datasets folder](./CDB%20content/Script%20SQL/CodeList%20and%20datasets), and launch the following script : 

-	[estat_codelist_datasets.sql](./CDB%20content/Script%20SQL/CodeList%20and%20datasets/estat_codelist_datasets.sql)

As previously, we did not scrape the following data, we first downloaded the raw data and created SQL queries in order to fill the database.

The first step is to launch : [estat_codelist_label_data.sql](./CDB%20content/Script%20SQL/CodeList%20and%20datasets/estat_codelist_label_data.sql)  and then using [cdb_insert.ipynb](./CDB%20content/Script%20SQL/cdb_insert.ipynb) launch each file: *estat_dictionnary_code_batchX.sql*, X=1,...,5.

At these stage, the codelists and code are all in the content database, however we found that we have to add some code to the time dictionnary in order for our work on the datasets to work. You'll find the elements to add in the [estat_dictionnary_code_data_time_addition.sql file](./CDB%20content/Script%20SQL/CodeList%20and%20datasets/estat_dictionnary_code_data_time_addition.sql)

Then you can add some datatsets.  Launch first the [estat_dataset_label_data.sql file](./CDB%20content/Script%20SQL/CodeList%20and%20datasets/estat_dataset_label_data.sql) and then the [estat_dataset_code_data.sql](./CDB%20content/Script%20SQL/CodeList%20and%20datasets/estat_dataset_code_data.sql) in order to create the links between datasets and codelists. If the last file is to heavy , the [cdb_insert.ipynb file](./CDB%20content/Script%20SQL/cdb_insert.ipynb) can be used.

## 6. Taxonomy, Terminology, Topic Model

In each folder you can find the structure of the needed tables.
