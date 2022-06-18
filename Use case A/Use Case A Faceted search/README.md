**The code was revised (January 2022) to read all data from the database**.

Use Case A - Faceted search. Receives inputs from the database (SE articles). Among others, the code assigns the majority of the SE articles to themes and sub-themes.
* File [Use Case A Faceted search_v4_rev_Jan2022.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20A/Use%20Case%20A%20Faceted%20search/Use%20Case%20A%20Faceted%20search_v4_rev_Jan2022.ipynb): Please replace your user name and password in the command c = pyodbc.connect('DSN=Virtuoso All; DBA=ESTAT; UID=user_name; PWD=password'). 

* [GC_Use_Case_A_Faceted_search_v4_rev_Jan2022.ipynb](GC_Use_Case_A_Faceted_search_v4_rev_Jan2022.ipynb) is a Google Colab version.

<img src="https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20A/Use%20Case%20A%20Faceted%20search/Figs/FS_screenshot.jpg" width="600">

[GC_Use_Case_A_Faceted_search_v5_rev_May2022.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20A/Use%20Case%20A%20Faceted%20search/GC_Use_Case_A_Faceted_search_v5_rev_May2022.ipynb) is a more recent version which uses the Knowledge Database to return, for each SE article, **all related resources** (and not only the related SE articles). These are grouped in the categories 'SE articles';'SE GL articles';'Publications';'Legislation','Other'.

The code is in a Google Colab notebook. Note that the SPARQL query takes a rather long time to run.

<img src="https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20A/Use%20Case%20A%20Faceted%20search/Figs/FS_screenshot4.jpg" width="600">

