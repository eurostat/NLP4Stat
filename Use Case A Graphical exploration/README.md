### Use Case A - Graphical exploration. 

* The **first code** is an R Shiny application (in progress) allowing the navigation in themes, sub-themes and categories and the display of corresponding articles. There are also some filters for the display of articles, for the year of last update and for keywords in titles and abstracts. 
* The source code (app.R) is in folder [Shiny files](https://github.com/eurostat/NLP4Stat/tree/main/Use%20Case%20A%20Graphical%20exploration/R%20Shiny%20files) and is still being improved and therefore undocumented. The same folder contains the Python code for the connection with the database and the production of the input file (Use Case A prepare data.ipynb), together with a recently produced file (dat6_7_12_19_30.xlsx).
* To run the code producing the input file, please replace user_name and password  with your credentials in command:  
c = pyodbc.connect('DSN=Virtuoso All;DBA=ESTAT;UID=user_name;PWD=password').
* The current functionalities can be seen in the **online version** [here](https://quantos-stat.shinyapps.io/Graphical_exploration_v2/). Because of frequent changes, please press **Reload** in your browser if you have visited this link already.

<img src="https://github.com/eurostat/NLP4Stat/blob/main/Use%20Case%20A%20Graphical%20exploration/r_shiny.JPG" width="600">

* The **second** code is an MS Power BI report (in progress) allowing again the navigation in themes, sub-themes and categories and the display of corresponding articles. There is also an interactive wordcloud graphical element. 
* The source code is still being improved and is not yet documented. The current .pbix file is in folder [Power BI](https://github.com/eurostat/NLP4Stat/tree/main/Use%20Case%20A%20Graphical%20exploration/Power_BI). The same folder contains the Python code for the connection with the database and the production of the input file (Use Case A prepare data.ipynb), together with a recently produced file (dat6_7_12_19_30.xlsx), and four direct exports of tables from the database which are not yet used.
* The current functionalities can be seen in the **online** version [here](https://app.powerbi.com/view?r=eyJrIjoiYTA2MDc0ZDMtNjM3YS00ODcxLTg5NTEtM2I0MDRlOTYyNDM4IiwidCI6ImM1MmVlYWMzLWUwNzctNDMyYy04MWUzLTRiY2JhZjZiOTM1ZSIsImMiOjl9&pageName=ReportSection0134a3f3c4be88106abb). Because of frequent changes, please press **Reload** in your browser if you have visited this link already.

<img src="https://github.com/eurostat/NLP4Stat/blob/main/Use%20Case%20A%20Graphical%20exploration/screenshot.JPG" width="600">


