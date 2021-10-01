
# Installation of [Virtuoso](https://github.com/openlink/virtuoso-opensource) on a Windows machine

* Download the Virtuoso Open Source (VOS) for Windows distribution. Preferably version 7.2 for 64-bit machines which is available [here](https://github.com/openlink/virtuoso-opensource/releases). 

<img src="https://github.com/eurostat/NLP4Stat/blob/main/Software%20Environment/Virtuoso_setup1.JPG" alt="Virtuoso setup1" width="600"/>

*  Run the installer as administrator and accept the defaults. The default installation is shown below:

<img src="https://github.com/eurostat/NLP4Stat/blob/main/Software%20Environment/Virtuoso_setup2.JPG" alt="Virtuoso setup2" width="600"/>

* With this default installation as example:
    *  Go to the **system** environment variables and add C:\Program Files\OpenLink Software\Virtuoso OpenSource 7.2\bin and C:\Program Files\OpenLink Software\Virtuoso OpenSource 7.2\lib to the system PATH variable.
    *  Crete a new **system** variable VIRTUOSO_HOME with value C:\Program Files\OpenLink Software\Virtuoso OpenSource 7.2\

* Open the ODBC Data Sources (64-bit) tool in control panel, go to Tab System DSN and create a new data source selecting the Virtuoso (Open Source) driver. Press Finish to start the configuration.

<img src="https://github.com/eurostat/NLP4Stat/blob/main/Software%20Environment/Virtuoso_setup3.JPG" alt="Virtuoso setup3" width="600"/>
 
* Fill the first configuration screen as follows. Do NOT put http:// or https:// in front of the server address.

<img src="https://github.com/eurostat/NLP4Stat/blob/main/VSoftware%20Environment/Virtuoso_setup4.JPG" alt="Virtuoso setup4" width="600"/>

* In the next screen, fill-in your user name and password and press Next:

<img src="https://github.com/eurostat/NLP4Stat/blob/main/Software%20Environment/Virtuoso_setup5.JPG" alt="Virtuoso setup5" width="600"/>

* A connection should be established. Change the default database to ESTAT and press Finish.

<img src="https://github.com/eurostat/NLP4Stat/blob/main/Software%20Environment/Virtuoso_setup6.JPG" alt="Virtuoso setup6" width="600"/>

* Restart your system. You should be able to connect to the database using pyodbc. In the call to connect() replace "user name" and "password" with your credentials, all within the connection string.

<img src="https://github.com/eurostat/NLP4Stat/blob/main/Software%20Environment/Virtuoso_setup8.JPG" alt="Virtuoso setup8" width="600"/> 



