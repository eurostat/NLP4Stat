Use Case A - Query builder. Work in progress, with scraped content only. To be connected with the KB in a later version.

* File [Query_Builder_Senario_A_v6b_both_GL_SE.ipynb](Query_Builder_Senario_A_v6b_both_GL_SE.ipynb): The code receives inputs directly from the database. It accepts content from **both SE articles and SE Glossary articles, with result to very rich 'suggestions'**. The speed is mostly affected by the quality of the connection to the Virtuoso database. Please replace your user name and password in the command  
c = pyodbc.connect('DSN=Virtuoso All; DBA=ESTAT; UID=user_name; PWD=password'). 

<img src="./Figs/QB_screenshot.JPG" width="600">
