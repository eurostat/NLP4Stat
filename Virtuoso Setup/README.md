
* Download the Virtuoso Open Source (VOS) for Windows distribution. Preferably version 7.2 for 64-bit machines which is available [here](https://sourceforge.net/projects/virtuoso/files/latest/download). 

<img src="https://github.com/eurostat/NLP4Stat/edit/main/Virtuoso%20Setup//Virtuoso_setup1.JPG" alt="Your image title" width="250"/>
![Virtuoso setup1](Virtuoso_setup1.JPG). 

*  Run the installer as administrator and accept the defaults. The default installation is shown below:

![Virtuoso setup2](Virtuoso_setup2.JPG). 

* With this default installation as example:
    *  Go to the **system** environment variables and add C:\Program Files\OpenLink Software\Virtuoso OpenSource 7.2\bin and C:\Program Files\OpenLink Software\Virtuoso OpenSource 7.2\lib to the system PATH variable.
    *  Crete a new **system** variable VIRTUOSO_HOME with value C:\Program Files\OpenLink Software\Virtuoso OpenSource 7.2\

* Open the ODBC Data Sources (64-bit) tool in control panel, go to Tab System DSN and create a new data source selecting the Virtuoso (Open Source) driver. Press Finish to start the configuration.

![Virtuoso setup3](Virtuoso_setup3.JPG). 
 
* Fill the first configuration screen as follows. Do NOT put http:// or https:// in front of the server address.

![Virtuoso setup4](Virtuoso_setup4.JPG). 

* In the next screen, fill-in your user name and password and press Next:

![Virtuoso setup5](Virtuoso_setup5.JPG). 

* A connection should be established. Change the default database to ESTAT and press Finish.

![Virtuoso setup6](Virtuoso_setup6.JPG). 

* Restart your system. You should be able to connect to the database using pyodbc. In the call to connect() replace "user name" and "password" with your credentials, all within the connection string.

![Virtuoso setup8](Virtuoso_setup8.JPG). 



