def estatLinkSelectId():# select eurostat doc id
    estatLinkSelectId = "SELECT id FROM dat_link_info WHERE url = ? AND eurostat = 1"
    return estatLinkSelectId


def foreignLinkSelectId(): # select foreign doc id
    foreignLinkSelectId = "SELECT id FROM dat_link_info WHERE url = ? AND eurostat = 0"
    return foreignLinkSelectId

def estatLinkInsert():# insert eurostat doc
    estatLinkInsert = "INSERT INTO dat_link_info(title, url, eurostat) VALUES (?, ?, 1)"
    return estatLinkInsert

def foreignLinkInsert():# insert doc from outside eurostat
    foreignLinkInsert = "INSERT INTO dat_link_info(title, url, eurostat) VALUES (?, ?, 0)"
    return foreignLinkInsert

def conceptSelect():# select glossary element
    conceptSelect = "SELECT * FROM dat_concept WHERE id = ?"
    return conceptSelect


def conceptFullInsert():# insert glossary element
    conceptFullInsert = "INSERT INTO dat_concept(id, definition, last_update, homepage, redirection) VALUES (?, ?, ?, 0, 0)"
    return conceptFullInsert

def conceptInsert():# insert glossary element
    conceptInsert = "INSERT INTO dat_concept(id, definition, homepage, redirection) VALUES (?, ?, 0, 0)"
    return conceptInsert

# check if couple exists in dat_further_info
def furtherInfoCheck():
   furtherInfoCheck = "SELECT id FROM dat_further_info WHERE concept_id = ? AND link_id =?"
   return furtherInfoCheck

def furtherInfoInsert():# insert a further_info link
    furtherInfoInsert = "INSERT INTO dat_further_info(concept_id, link_id) VALUES (?, ?)"
    return furtherInfoInsert

def relCptCheck():# check if couple exists in dat_related_concepts
    relCptCheck = "SELECT id FROM dat_related_concepts WHERE concept_id = ? AND link_id =?"
    return relCptCheck

def relCptInsert():# insert a concept link
    relCptInsert = "INSERT INTO dat_related_concepts(concept_id, link_id) VALUES (?, ?)"
    return relCptInsert

def statDataCheck():# check if couple exists in dat_statistical_data
    statDataCheck = "SELECT id FROM dat_statistical_data WHERE concept_id = ? AND link_id =?"
    return statDataCheck


def statDataInsert():# insert a statistical data link
    statDataInsert = "INSERT INTO dat_statistical_data(concept_id, link_id) VALUES (?, ?)"
    return statDataInsert


def sourceCheck(): # check if couple exists in dat_sources
    sourceCheck = "SELECT id FROM dat_sources WHERE concept_id = ? AND link_id =?"
    return sourceCheck


def sourceInsert():# insert a source link
    sourceInsert = "INSERT INTO dat_sources(concept_id, link_id) VALUES (?, ?)"
    return sourceInsert