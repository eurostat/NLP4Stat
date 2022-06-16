import pandas as pd
import re

##add file code
def Remove(duplicate):
    final = []
    for num in duplicate:
        if num not in final:
            final.append(num)
    return final

def createInformation(listAll):


    counter, finalList = 1, []
    for tup in listAll:
        finalList.append("estatdata:" + str(tup[2]) + " rdf:type estat:" + tup[0][-2] + ".\n")
        finalList.append("estatdata:" + str(tup[2]) + " rdfs:label \"" + str(tup[1]) + "\"^^xsd:string.\n")
        finalList.append("estatdata:" + str(tup[2]) + " estat:level \"" + str(tup[3]) + "\"^^xsd:string.\n")
        finalList.append("estatdata:" + str(tup[2]) + " estat:fileLink \"" + str(tup[4]) + "\"^^xsd:anyURI.\n")
        finalList.append("estatdata:" + str(tup[2]) + " estat:databasePath   \"" + str(tup[5][1:]) + "\"^^xsd:string.\n")

        finalList.append("estatdata:" + str(tup[0][-1]) + " rdf:type estat:Code.\n")
        finalList.append("estatdata:" + str(tup[2]) + " estat:term \"" + str(tup[0][-1]) + "\"^^xsd:string.\n")
        finalList.append("estatdata:" + str(tup[2]) + " estat:hasCode estatdata:" + str(tup[0][-1]) + ".\n")
        counter = counter + 1

    print(len(finalList))
    finalList = Remove(finalList)
    print(len(finalList))

    f = open('dataset.ttl', 'a')
    for line in finalList:
        f.write(line)
    f.close()

    return 1

if __name__=="__main__":

    df = pd.read_excel("All Datasets.xlsx")

    tupleImportant = []
    for i in range(len(df)):
        if str(df.loc[i, "link"]) != "nan":
            codes = str(df.loc[i, "codes"]).replace("\xa0", "")
            codes = codes.replace("[", "").replace("]", "").replace("\xa0", "").replace("\'", "").split(", ")

            file_descr = str(df.loc[i, "file_descr"]).replace("\xa0", "")
            file_descr = re.sub("[^a-zA-Z\d%]", ' ', file_descr).replace("   ", " ").replace("  ", " ")
            file_code = str(df.loc[i, "file_code"]).replace("\xa0", "")
            level = str(df.loc[i, "level"]).replace("\xa0", "")
            link = str(df.loc[i, "link"]).replace("\xa0", "")
            names = str(df.loc[i, "names"]).replace("[", "").replace("]", "").replace("\'", "").replace("\' ", "")
            names = names.split(",")
            listNames = ""
            for name in names:
                listNames = listNames + re.sub("[^a-zA-Z\d%]", ' ', name).replace("   ", " ").replace("  ", " ").replace("\xa0", "").replace("\' ", "") + "; "

            finalListNames = listNames.replace("   ", " ").replace("  ", " ")[:-2]
            tupleImportant.append((codes, file_descr, file_code, level, link, finalListNames))

    flagCreate = createInformation(tupleImportant)

