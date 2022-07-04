import pandas as pd
import os 
import re
import logging
import sys
import pyodbc
import hashlib
import time

def connect_db(DSN, DBA, UID, PWD):
    
    connection = pyodbc.connect('DSN={};DBA={};UID={};PWD={}'.format(DSN, DBA, UID, PWD))
    cursor = connection.cursor()
    
    return connection,cursor

connection, cursor = connect_db('nlp4stat', 'ESTAT', 'dba', 'dba')

# Change the name of the file to fit your needs
file = open(os.getcwd()+'\\Estat13k\\estat13k_glossary_data.sql', 'r', encoding='utf8')
#file = open(os.getcwd()+'\\Dictionnary and datasets\\estat_dataset_data_batch1.sql', 'r', encoding='utf8')
#file = open(os.getcwd()+'\\Dictionnary and datasets\\estat_dataset_data_batch2.sql', 'r', encoding='utf8')
#file = open(os.getcwd()+'\\Dictionnary and datasets\\estat_dataset_data_batch3.sql', 'r', encoding='utf8')
#file = open(os.getcwd()+'\\Dictionnary and datasets\\estat_dataset_data_batch4.sql', 'r', encoding='utf8')
#file = open(os.getcwd()+'\\Dictionnary and datasets\\estat_dataset_data_batch5.sql', 'r', encoding='utf8')
sqlFile = file.read()
file.close()

sqlCommands = sqlFile.split('INSERT INTO')
sqlCommands.pop(0)

sqlCommands

for i,command in enumerate (sqlCommands):
    command = command.replace('\n','').replace(';','')
    try:
        cursor.execute('INSERT INTO' + command)
        connection.commit()
    except:
        print(i)

