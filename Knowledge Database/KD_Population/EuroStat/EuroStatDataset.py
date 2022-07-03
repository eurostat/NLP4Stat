import pandas as pd
import re

def Remove(duplicate):
    final = []
    for num in duplicate:
        if num not in final:
            final.append(num)
    return final

def createClass(listAllClasses):

    f = open("classes.txt", "a", encoding="utf-8")
    for cl in listAllClasses:
        helper = ""
        description = str(cl[1]).replace("\"", "").replace("\'", "")
        helper = "estat:" + str(cl[0]) + " rdf:type owl:Class.\n"
        helper = helper + "estat:" + str(cl[0]) + " rdf:type estat:StatisticalData.\n"
        helper = helper + "estat:" + str(cl[0]) + " rdfs:label \"" + description[1:] + "\"^^xsd:string.\n"
        helper = helper + "estat:" + str(cl[0]) + " estat:hasCode estatdata:" + str(cl[0]) + ".\n"
        helper = helper + "estatdata:" + str(cl[0]) + " rdf:type estat:Code.\n"
        helper = helper + "estatdata:" + str(cl[0]) + " estat:term \"" + str(cl[0]) + "\"^^xsd:string.\n"
        helper = helper + "estat:" + str(cl[0]) + " estat:databasePath   \"" + str(cl[2][1:]) + "\"^^xsd:string.\n"
        helper = helper + "estat:" + str(cl[0]) + " estat:level \"" + str(cl[3]) + "\"^^xsd:string.\n"
        f.write(helper)
    f.close()


    return 1

def sublist(lst1, lst2):
   ls1 = [element for element in lst1 if element in lst2]
   ls2 = [element for element in lst2 if element in lst1]
   return ls1 == ls2

def hierarchy(listHierarchy):

    listHelper = []
    for h in listHierarchy:
        helper = ""
        helper = "estat:" + str(h[0]) + " rdfs:subClassOf estat:StatisticalData.\n"
        listHelper.append(helper)
        try:
            for i in range(len(h) - 1):
                helper = "estat:" + str(h[i + 1]) + " rdfs:subClassOf estat:" + str(h[i]) + ".\n"
                listHelper.append(helper)
        except Exception:
            helper = "AAAAAAAAAAAAAAAAAAAAAA"

    listHelper = Remove(listHelper)
    print(len(listHelper))
    f = open("hierarchy.txt", "a")
    for cl in listHelper:
        f.write(cl)
    f.close()
    return 1

if __name__=="__main__":

    df = pd.read_excel("All Datasets.xlsx")

    hierarchyTuple, classes = [], []
    for i in range(len(df)):
        helperDescription = ""
        if str(df.loc[i, "link"]) == "nan":
            hier = df.loc[i, "codes"].replace("[", "").replace("]", "").replace("\xa0", "").replace("\'", "").split(", ")
            hierarchyTuple.append(hier)
            helperDescription = re.sub("[^a-zA-Z\d%]",' ', str(df.loc[i, "file_descr"]))
            names = str(df.loc[i, "names"]).replace("[", "").replace("]", "").replace("\'", "").replace("\' ", "")
            names = names.split(",")
            listNames = ""
            for name in names:
                listNames = listNames + re.sub("[^a-zA-Z\d%]", ' ', name).replace("   ", " ").replace("  ", " ").replace("\xa0", "").replace("\' ", "") + "; "
            finalListNames = listNames.replace("   ", " ").replace("  ", " ")[:-2]
            level = str(df.loc[i, "level"]).replace("\xa0", "")
            classes.append((hier[-1], helperDescription.replace("   ", " ").replace("  ", " ").replace("\" ", " "), finalListNames, level))

    print(len(hierarchyTuple), len(classes))

    flag = createClass(classes)
    flag = hierarchy(hierarchyTuple)