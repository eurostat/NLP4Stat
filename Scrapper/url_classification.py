import sys
import os
import re
import logging
import pyodbc
import hashlib
import pandas as pd
from sql_request import *


c = pyodbc.connect('DSN=Virtuoso All;' +
                   'DBA=ESTAT;' +
                   'UID=dba;' +
                   'PWD=30gFcpQzj7sPtRu5bkes')
cursor = c.cursor()


def checkResourceType() :

    # gathering all the links for which the type has not been identified
    cursor.execute(LinkNoTypeSelect())
    c.commit()
    table = cursor.fetchall()

    for row in table:
        id = row.id
        url = row.url

        # european union law
        if 'eur-lex.europa.eu' in url:
            cursor.execute(LinkTypeUpdate(), 2, id)
            c.commit()
        # no use
        elif (('eurostat' and 'tgm') or
              ('url.org')) in url:
            cursor.execute(LinkTypeUpdate(), 2, id)
            c.commit()
        # glossary concept
        elif (('eurostat/statistics-explained' and 'title=Glossary') or
              ('ramon' and 'glossary_nom') or
              ('ec.europa.eu' and 'glossary') or
              ('europa.eu' and 'glossary') or
              ('oecd.org/glossary/detail')) in url:
            cursor.execute(LinkTypeUpdate(), 3, id)
            c.commit()
        # glossary homepage
        elif (('ramon' and 'glossary') or
              ('oecd.org' and 'glossary')) in url:
            cursor.execute(LinkTypeUpdate(), 4, id)
            c.commit()
        # infography
        elif 'eurostat/cache/infographs' in url:
            cursor.execute(LinkTypeUpdate(), 5, id)
            c.commit()
        # legal context
        elif (('eurostat/web' and 'legislation') or 
              ('europa.eu' and 'legislation') or
              ('europa.eu' and 'legal')) in url:
            cursor.execute(LinkTypeUpdate(), 6, id)
            c.commit()
        # miscellaneous
        elif ('ramon' and 'miscellaneous') in url:
            cursor.execute(LinkTypeUpdate(), 7, id)
            c.commit()
        # news
        elif (('eurostat' and 'news') or
              ('ec.europa.eu' and 'news') or
              ('europa.eu' and 'news') or
              ('who.int' and 'news-room') or
              ('unfcc.int' and 'newsroom') or
              ('fao.org' and 'news')) in url:
            cursor.execute(LinkTypeUpdate(), 8, id)
            c.commit()
        # publication
        elif (('eurostat/documents') or
              ('eurostat' and 'statistical-books') or
              ('eurostat' and 'guidelines') or
              ('eurostat' and 'yearbook') or
              ('eurostat' and 'reports') or
              ('eurostat' and 'publications') or
              ('ramon' and 'statmanual') or
              ('ramon/document') or
              ('eurostat' and 'product?code') or
              ('eurostat' and 'product?lang') or
              ('bookshop.europa.eu') or
              ('europa.eu' and 'report') or
              ('europa.eu' and 'publication') or
              ('ec.europa.eu' and 'guidelines') or
              ('europa.eu' and 'document') or
              ('ecb.europa.eu' and 'pdf') or
              ('consilium.europa.eu' and 'doc') or
              ('oecd.org' and '.pdf') or 
              ('oecd.org' and 'publication') or
              ('oecd.org' and 'guidelines') or
              ('oecd.org' and 'manual') or
              ('oecd.org' and 'handbook') or
              ('oecd.org' and 'outlook') or
              ('oecd-ilibrary') or
              ('who.int' and '.pdf') or
              ('who.int' and 'publications') or
              ('imf.org/external') or
              ('unesco' and 'pdf') or
              ('unesco' and 'publication') or
              ('unstat' and 'publication') or
              ('unstat' and 'report') or
              ('unstat' and 'pdf') or
              ('unstats.un.org/unsd') or
              ('undp.org' and 'handbook') or
              ('fao.org' and 'pdf') or
              ('fao.org' and 'handbook') or
              ('paris21.org' and 'pdf') or
              ('paris21.org' and 'publication') or
              ('unece.org' and 'pdf')) in url:
            cursor.execute(LinkTypeUpdate(), 9, id)
            c.commit()
        # statistic database
        elif (('appso.eurostat' and 'dataset') or
              ('eurostat' and 'database') or
              ('eurostat' and 'main-tables') or
              ('eurostat' and 'microdata') or
              ('eurostat/web/products-dataset') or
              ('eurostat/product?code=') or
              ('eurostat/web' and 'data') or
              ('europa.eu' and 'data') or
              ('europa.eu' and 'browse') or
              ('europa.eu' and 'circabc') or
              ('eige.europa.eu' and 'statistics') or
              ('oecd.org' and 'data') or
              ('oecd.org' and 'stats') or
              ('apps.who.int') or
              ('who.int' and 'data') or
              ('imf' and 'data') or
              ('worldbank' and 'data') or
              ('unstat' and 'database') or
              ('fao.org' and 'statistics') or
              ('unece.org' and 'statistics')) in url:
            cursor.execute(LinkTypeUpdate(), 10, id)
            c.commit()
        # statistic reference metadata
        elif ((('ramon/nomenclature' and 'LST_CLS') or
              ('ramon' and 'DSP_PUB_WELC') or
              ('eurostat/cache/metadata') or
              ('eurostat' and 'metadata') or
              ('unstat' and 'metadata')) in url) or (('eurostat' in url) and url.endswith('esms.htm')):
            cursor.execute(LinkTypeUpdate(), 11, id)
            c.commit()
        # statistic explained source data
        elif (('eurostat/statistics-explained' and '.xls') or
              ('statistics-explained/images' and '.doc')) in url:
            cursor.execute(LinkTypeUpdate(), 12, id)
            c.commit()
        # statistic table
        elif (('eurostat' and 'newxtweb') or
              ('eurostat' and 'databrowser') or
              ('eurostat' and 'product?mode=view&code=') or
              ('oecd.org' and 'DataSetCode') or
              ('undp.org' and 'statistics') or
              ('undp.org' and 'data') or
              ('fao.org' and 'stat') or
              ('unece.org' and 'stat') or
              ('ramon/coded_files' and '.xls')) in url:
            cursor.execute(LinkTypeUpdate(), 13, id)
            c.commit()
        # taxonomy
        elif (('ramon/nomenclature' and 'ACT_OTH_BUILD_TREE') or
              ('ramon/nomenclature' and 'LST_NOM_DTL&Str') or
              ('ramon' and 'other_document') or
              ('ramon/nomenclature' and 'ACT_OTH_DFLT_LAYOUT') or
              ('ramon/nomenclature' and 'LST_NOM&Str') or
              ('europa.eu' and 'eionet')) in url:
            cursor.execute(LinkTypeUpdate(), 14, id)
            c.commit()
        # articles
        elif (('eurostat' and 'press-release') or
              ('eurostat' and 'overview') or
              ('eurostat/cros') or
              ('eurostat/statistics-explained/index.php') or
              ('ramon/nomenclature' and 'DSP_GEN_DESC_VIEW') or
              ('eurostat/web' and 'methodology') or
              ('eurostat/web' and 'background') or
              ('eurostat' and 'portal') or
              ('europa.eu' and 'overview') or
              ('europa.eu' and 'index') or
              ('europa.eu' and 'eea') or
              ('ecb.europa.eu') or
              ('europa.eu' and 'eurofound') or
              ('europa.eu' and 'europarl') or
              ('europa.eu' and 'easo') or
              ('europa.eu' and 'cedefop') or
              ('europa.eu' and 'osha') or
              ('europa.eu' and 'erail') or
              ('europa.eu' and 'era') or
              ('europa.eu' and 'eige') or
              ('europa.eu' and 'emcdda') or
              ('europa.eu' and 'consilium') or
              ('europa.eu' and 'fra') or
              ('europa.eu' and 'eca') or
              ('itf-oecd.org') or
              ('oecdbetterlifeindex') or
              ('who.int' and 'topics') or
              ('who.int' and 'classifications') or
              ('unfcc.int') or
              ('imf.org/pages') or
              ('unstat' and 'article') or
              ('unstats') or
              ('undp.org' and 'content') or
              ('fao.org') or
              ('paris21.org') or
              ('unece.org' and 'html') or
              ('wikipedia')) in url:

            cursor.execute(LinkTypeUpdate(), 1, id)
            c.commit()
        else:
            cursor.execute(LinkTypeUpdate(), 0, id)
            c.commit()


        
def checkResourceInfo():

    # gathering all the links for which the type has not been identified
    cursor.execute(LinkNoResourceInfoSelect())
    c.commit()
    table = cursor.fetchall()

    for row in table:
        id = row.id
        url = row.url

        # eurostat
        if 'eurostat' in url:
            cursor.execute(LinkResourceInfoUpdate(), 1, id)
            c.commit()
        # European Agency for Safety and Health at Work
        elif 'osha.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 2, id)
            c.commit()
        # European Asylum Support Office
        elif 'easo.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 3, id)
            c.commit()
        # European Central Bank
        elif 'ecb.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 4, id)
            c.commit()
        # European Centre for the Development of Vocational Training
        elif 'cedefop.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 5, id)
            c.commit()
        # European Council and Council of the European Union
        elif 'consilium.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 6, id)
            c.commit()
        # European Court of Auditors
        elif 'eca.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 7, id)
            c.commit()
        # European Environment Agency
        elif 'eea.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 8, id)
            c.commit()
        # European Environment Information and Observation Network
        elif 'eionet.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 9, id)
            c.commit()
        # European Foundation for the Improvement of Living and Working Conditions
        elif 'eurofound.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 10, id)
            c.commit()
        # European Institute for Gender Equality
        elif 'eige.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 11, id)
            c.commit()
        # European Monitoring Centre for Drugs and Drug Addiction
        elif 'emcdda.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 12, id)
            c.commit()
        # European Parliament
        elif 'europarl.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 13, id)
            c.commit()
        # European Union Agency For Fundamental Rights
        elif 'fra.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 14, id)
            c.commit()
        # European Union Agency for Railways
        elif 'era.europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 15, id)
            c.commit()
        # European union
        elif 'europa.eu' in url:
            cursor.execute(LinkResourceInfoUpdate(), 16, id)
            c.commit()
        # European Patent Convention
        elif 'epo.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 17, id)
            c.commit()
        # European Investment Bank
        elif 'eib.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 18, id)
            c.commit()
        # European Free Trade Association
        elif 'efta.int' in url:
            cursor.execute(LinkResourceInfoUpdate(), 19, id)
            c.commit()
        # International Household survey network
        elif 'ihsn.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 20, id)
            c.commit()
        # International input output organization
        elif 'iioa.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 21, id)
            c.commit()
        # International Monetary Fund
        elif 'imf.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 22, id)
            c.commit()
        # International Statistics Institute
        elif 'isi-web.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 23, id)
            c.commit()
        # Organisation for Economic Co-operation and Development
        elif 'oecd.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 24, id)
            c.commit()
        # Paris21
        elif 'paris21.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 25, id)
            c.commit()
        # The World Bank
        elif 'worldbank.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 26, id)
            c.commit()
        # World Health Organization
        elif 'who.int' in url:
            cursor.execute(LinkResourceInfoUpdate(), 26, id)
            c.commit()
        # United Nations - Economic Commission for Europe
        elif 'unece.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 27, id)
            c.commit()
        # United Nations - Educational, Scientific and Cultural Organization
        elif 'unesco.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 28, id)
            c.commit()
        # United Nations - Development Program
        elif 'undp.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 29, id)
            c.commit()
        # Food and Agriculture Organization of the United Nations
        elif 'fao.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 30, id)
            c.commit()
        # United Nations - Framework Convention on Climate Change
        elif 'unfccc.int' in url:
            cursor.execute(LinkResourceInfoUpdate(), 31, id)
            c.commit()
        # United Nations - Office on drugs and crime
        elif 'unodc.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 32, id)
            c.commit()
        # United Nations - Statistics Division
        elif 'unstats.un.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 33, id)
            c.commit()
        # Wikipedia
        elif 'wikipedia.org' in url:
            cursor.execute(LinkResourceInfoUpdate(), 34, id)
            c.commit()
        else:
            cursor.execute(LinkResourceInfoUpdate(), 0, id)
            c.commit()

checkResourceType()
checkResourceInfo()