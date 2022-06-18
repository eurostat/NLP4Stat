Use Case A - Faceted search. Receives inputs from the database (SE articles). Among others, the code assigns the majority of the SE articles to themes and sub-themes.

[GC_Use_Case_A_Faceted_search_v5_rev_May2022.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20A/Use%20Case%20A%20Faceted%20search/GC_Use_Case_A_Faceted_search_v5_rev_May2022.ipynb) is the latest version in a Google Colab notebook and uses a SPARQL query in the Knowledge Database to return, for each SE article, **all related resources** (and not only the related SE articles). These are grouped in the categories 'SE articles';'SE GL articles';'Publications';'Legislation','Other'. This grouping can easily be changed.
Please put your own credentials in the chunk with title "Connect to the Virtuoso database".

<img src="https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20A/Use%20Case%20A%20Faceted%20search/Figs/FS_screenshot4.jpg" width="600">

