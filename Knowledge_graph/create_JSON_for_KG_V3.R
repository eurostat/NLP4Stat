require(data.table)
require(dplyr)
require(rlist)

files_path <- "O:/00_KAP_CODE/05_Projets_Clients/03_Autres/Eurostat/Knowledge Graph/V2_1009/data/"
files <- list.files(files_path)
files
#results_infos <- readxl::read_xlsx(paste0(files_path, files[1]))
results_relations <- readxl::read_xlsx(paste0(files_path, files[2]))
results_titles <- readxl::read_xlsx(paste0(files_path, files[3]))
results_types <- readxl::read_xlsx(paste0(files_path, files[4]))

# Class nodes : 
node_table <- data.table('node' = unique(c(results_relations$s.value, results_relations$o.value)))
node_table <- merge(node_table, results_types[,c("s.value","o.value")], by.x = "node", by.y = "s.value", all.x = T, all.y = F)
setnames(node_table, "o.value", "node_type")
node_table <- merge(node_table, results_titles[,c("s.value","o.value")], by.x = "node", by.y = "s.value", all.x = T, all.y = F)
setnames(node_table, "o.value", "node_title")
node_table$node_type <- sapply(node_table$node_type, gsub, pattern = "https://nlp4statref/knowledge/resource/authority/resource-type#", replacement = "")
table(node_table$node_type, useNA = 'ifany')
node_table$node_id <- seq(nrow(node_table)) # ids utilisés dans le graph
node_table$size = 1 # pour le json 

# Type id table:
node_type_table <- node_table %>% distinct(node_type)
node_type_table$type_id <- seq(nrow(node_type_table))
node_table <- merge(node_table, node_type_table, by = "node_type")

# Class edges : 
edge_type_table <- data.table('edge' = unique(results_relations$p.value))
edge_type_table$edge_id = seq(nrow(edge_type_table))

# Merge info to relations :
results_relations <- merge(results_relations, edge_type_table, by.x = 'p.value', by.y = "edge")

# Create links table : 
# On se base sur ça : O:\00_KAP_CODE\08_IT_App\Projets_internes\Librairie D3\Template_JSON/Donnees_Reseau.json
# O:\00_KAP_CODE\08_IT_App\Projets_internes\Librairie D3\Datavisualisations\Tests\Donnees_Reseau_Test.json
data_for_network.nodes <- node_table
data_for_network.nodes$node_title <- paste(data_for_network.nodes$type_id, data_for_network.nodes$node_title,sep = " - ")
data_for_network.nodes <- data_for_network.nodes[,c("node_title", "node_type", "size")]
colnames(data_for_network.nodes) = c("label", "group", "size") 
data_for_network.nodes

### Version 1 : add the node type to the title 
data_for_network.edges <- data.table("source" = "", "target" = "", "val" = "", "edge" = "")[-1,]
data_for_network.edges = list.rbind(apply(results_relations, MARGIN = 1, function(row){
  source = row["s.value"]
  source_id = node_table[which(node_table$node == source),"node_id"]
  source_title = node_table[which(node_table$node == source),"node_title"]
  source_type = node_table[which(node_table$node == source),"type_id"]
  unname(unlist(source_title))
  source_title <- paste(unname(unlist(source_type)), unname(unlist(source_title)),sep = " - ")

  #
  edge = row["edge_id"]
  #
  target = row["o.value"]
  target_id = node_table[which(node_table$node == target),"node_id"]
  target_title = node_table[which(node_table$node == target),"node_title"]
  target_type = node_table[which(node_table$node == target),"type_id"]
  target_title <- paste(unname(unlist(target_type)), unname(unlist(target_title)),sep = " - ")
  #
  val = 1
  return( data.table("source" = source_title, "target" = target_title , "val" = val, "group" = edge))
  # return( data.table("source" = unname(unlist(source_id)), "target" = unname(unlist(target_id)), "val" = val, "group" = edge))
  
}
))
data_for_network.nodes$label <- sapply(data_for_network.nodes$label, DetectTools::remove_balise)
data_for_network.edges$source <- sapply(data_for_network.edges$source, DetectTools::remove_balise)
data_for_network.edges$target <- sapply(data_for_network.edges$target, DetectTools::remove_balise)

### Version 2 : title only
# data_for_network.edges <- data.table("source" = "", "target" = "", "val" = "", "edge" = "")[-1,]
# data_for_network.edges = list.rbind(apply(results_relations, MARGIN = 1, function(row){
#   source = row["s.value"]
#   source_id = node_table[which(node_table$node == source),"node_id"]
#   source_title = node_table[which(node_table$node == source),"node_title"]
#   #
#   edge = row["edge_id"]
#   #
#   target = row["o.value"]
#   target_id = node_table[which(node_table$node == target),"node_id"]
#   target_title = node_table[which(node_table$node == target),"node_title"]
#   #
#   val = 1
#   return( data.table("source" = unname(unlist(source_title)), "target" = unname(unlist(target_title)), "val" = val, "group" = edge))
#   # return( data.table("source" = unname(unlist(source_id)), "target" = unname(unlist(target_id)), "val" = val, "group" = edge))
#   
# }
# ))
# data_for_network.edges.V2 <- data_for_network.edges

# Output : 
data_to_list_for_json_conversion <- function(data){
  setDF(data)
  output_list <- list()
  for (i in seq(nrow(data))){
    # Get the row to add : 
    temp_row <- unlist(data[i,])
    # Get  the right format : 
    temp_row_as_list <- list()
    for (j in seq(ncol(data))){
      if (class(data[,j])%in% c("numeric","integer",'ts')) temp_row_as_list <- c(temp_row_as_list, list(as.numeric(as.character(temp_row[j]))))
      else if (class(data[,j])%in% c("character","factor","Date")) temp_row_as_list <- c(temp_row_as_list, list(as.character(temp_row[j])))
    }
    # add names : 
    names(temp_row_as_list) <- colnames(data)
    # Format percentage :
    # if (length(which(names(temp_row_as_list) == "P"))) temp_row_as_list[["P"]] <- as.numeric(format(c(temp_row_as_list[["P"]], 0.01))[1])
    
    # Add it to the global list : 
    output_list <- c(output_list, list(temp_row_as_list))
    
  }
  return(output_list)
}

# Format :  
data_for_network.edges$val <- 10
data_for_network.edges$group <- as.integer(data_for_network.edges$group)

# Total 
list_network = list("nodes" = data_to_list_for_json_conversion(data_for_network.nodes),
                    "links" = data_to_list_for_json_conversion(data_for_network.edges))
list_network.json <-  RJSONIO::toJSON(list_network)
writeLines(list_network.json,
           "C:/Users/Pierre/Documents/EUROSTAT/Dataviz/Knowledge_graph/data_for_network.total.json")
# Sample 
require(splitstackshape)
data_for_network.nodes.sample <- data_for_network.nodes[which(!is.na(data_for_network.nodes$group)),]
# data_for_network.nodes.sample <- data_for_network.nodes.sample[sample(1:nrow(data_for_network.nodes.sample), 500),]
data_for_network.nodes.sample <- stratified(data_for_network.nodes.sample, group = "group", 50)

data_for_network.edges.sample <- data_for_network.edges[which(data_for_network.edges$source %in% data_for_network.nodes.sample$label & data_for_network.edges$target %in% data_for_network.nodes.sample$label),]
list_network.sample = list("nodes" = data_to_list_for_json_conversion(data_for_network.nodes.sample),
                    "links" = data_to_list_for_json_conversion(data_for_network.edges.sample))
list_network.sample.json <-  RJSONIO::toJSON(list_network.sample)
writeLines(list_network.sample.json,
           "C:/Users/Pierre/Documents/EUROSTAT/Dataviz/Knowledge_graph/data_for_network.json")
# Sortie table node : 
writexl::write_xlsx(node_type_table, 
                    path =  "C:/Users/Pierre/Documents/EUROSTAT/Dataviz/Knowledge_graph/node_type_table.xlsx")

