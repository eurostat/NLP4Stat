##### FORMAT DATA FROM THE KNOWLEDGE DATABASE TO CREATE THE KNOWLEDGE GRAPH ############
# Our goal here is to create a JSON file from the info extracted from the knowledge DB.
# This file consists in a first part describing each unique node ("data_for_network.nodes")
# and a second part describing each edges ("data_for_network.edges").
# This file contain the type of edges and nodes, which are used for coloring the elements.

require(data.table)
require(dplyr)
require(rlist)
require(stringr)

###################################################### Load data 
files_path <- "data/"
files <- list.files(files_path)
files
# RELATIONS 
results_relations <- readxl::read_xlsx(paste0(files_path, "results_relations.xlsx"))
# TITLES 
results_titles <- readxl::read_xlsx(paste0(files_path, "results_titles.xlsx"))
# TYPES 
results_types <- readxl::read_xlsx(paste0(files_path, "results_types.xlsx"))

###################################################### Define clean type labels 

clean_type_label_table <- data.frame(node_type = c("None",NA,
                                                   "background-article",
                                                   "glossary-concept",   
                                                   "glossary-home-page",
                                                   "infography",     
                                                   "news",
                                                   "statistic-reference-metadata", 
                                                   "statistical-article",
                                                   "statistic-database",
                                                   "legal-context",
                                                   "european-union-law",
                                                   "miscellaneous",
                                                   "publication",
                                                   "statistical-data-report",
                                                   "statistic-table")
                                                   ,
                                     clean_type_label = c("", 
                                                          "",
                                                         "Background Article", 
                                                         "Glossary Concept", 
                                                         "Glossary Homepage",
                                                         "Infography",
                                                         "News",
                                                         "Statistic Reference Metadata",
                                                         "Statistical Article",
                                                         "Statistical DB",
                                                         "Legal Context",
                                                         "European Union Law",
                                                         "Miscellaneous",
                                                         "Publication",
                                                         "Statistical Data Report",
                                                         "Statistic Table"))


###################################################### Define functions 
create_node_tables <- function(results_relations, results_types, results_titles, clean_type_label_table){
  
  # Create the table containing all nodes and their metadata : 
  node_table <- data.table('node' = unique(c(results_relations$s.value, results_relations$o.value)))
  node_table <- merge(node_table, results_types[,c("s.value","o.value")], by.x = "node", by.y = "s.value", all.x = T, all.y = F)
  setnames(node_table, "o.value", "node_type")
  # node_table <- node_table[which(node_table$node %in% results_types$s.value & node_table$node %in% results_titles$s.value),] # si on veut garder que les lignes completes
  node_table <- merge(node_table, results_titles[,c("s.value","o.value")], by.x = "node", by.y = "s.value", all.x = T, all.y = F)
  setnames(node_table, "o.value", "node_title")
  node_table$node_type <- sapply(node_table$node_type, gsub, pattern = "https://nlp4statref/knowledge/resource/authority/resource-type#", replacement = "")
  print(table(node_table$node_type, useNA = 'ifany'))
  node_table$node_id <- seq(nrow(node_table)) # ids utilisés dans le graph
  node_table$size = 1 # pour le json 
  
  # Create the table with the types of the nodes 
  node_type_table <- node_table %>% distinct(node_type)
  node_type_table$type_id <- seq(nrow(node_type_table))
  node_type_table <- merge(node_type_table, clean_type_label_table, by = "node_type")
  
  # Add the types to the node table 
  node_table <- merge(node_table, node_type_table, by = "node_type")
  node_table$node_title  <- sapply(node_table$node_title, DetectTools::remove_balise)
  node_table <- node_table[which(!is.na(node_table$node_title)),]
  
  # Create clean label for nodes 
  node_table$clean_node_title <- paste(node_table$clean_type_label, node_table$node_title, sep = " - ")
  node_table$clean_node_title[which(str_starts(node_table$clean_node_title, pattern = " -"))] <- node_table$node_title[which(str_starts(node_table$clean_node_title, pattern = " -"))]
  
  # Creat the reduced table to be used in the JSON 
  data_for_network.nodes <- node_table
  data_for_network.nodes <- data_for_network.nodes[,c("clean_node_title", "type_id", "size")]
  colnames(data_for_network.nodes) = c("label", "group", "size") 
  
  
  output = list("node_type_table" = node_type_table,
                "node_table" = node_table,
                "data_for_network.nodes" = data_for_network.nodes)
  return(output)
}


create_edge_tables <- function(results_relations, node_table){
  
  # Create the table containing the edges types : 
  edge_type_table <- data.table('edge' = unique(results_relations$p.value))
  edge_type_table$edge_id = seq(nrow(edge_type_table))

  # Merge info to relations :
  results_relations.w_edge_type <- merge(results_relations, edge_type_table, by.x = 'p.value', by.y = "edge")
  
  # Create the edges table used for the JSON :
  data_for_network.edges <- data.table("source" = "", "target" = "", "val" = "", "edge" = "")[-1,]
  data_for_network.edges = apply(results_relations.w_edge_type, MARGIN = 1, function(row){
    
    # Get info from the source 
    source = unlist(row["s.value"])
    source_id = node_table[which(node_table$node == source),"node_id"]
    source_title = node_table[which(node_table$node == source),"clean_node_title"]
    
    if (nrow(source_title)>0){
      if (!is.na(source_title)){
        if (str_starts(source_title, pattern = " -")){
          source_title = node_table[which(node_table$node == source),"node_title"]
        } 
      }
      else source_title = ""
    }
    else source_title = ""
    
    # Get the type of relations 
    edge = row["edge_id"]
    
    # Get info from the target
    target = unlist(row["o.value"])
    target_id = node_table[which(node_table$node == target),"node_id"]
    target_title = node_table[which(node_table$node == target),"clean_node_title"]

    if (nrow(target_title)>0){
      if (!is.na(target_title)){
        if (str_starts(target_title, pattern = " -")){
          target_title = node_table[which(node_table$node == target),"node_title"]
        } 
      }
      else target_title = ""
    }
    else target_title = ""
    #
    val = 1
    return(data.table("source" = unlist(source_title), "target" = unlist(target_title) , "val" = val, "group" = edge))
  }
  )
  data_for_network.edges = list.rbind(data_for_network.edges)
  data_for_network.edges$group <- as.integer(data_for_network.edges$group)
  
    output = list("edge_type_table" = edge_type_table,
                  "results_relations.w_edge_type" = results_relations.w_edge_type,
                "data_for_network.edges" = data_for_network.edges)
  return(output)
}

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



pattern_material_selection_for_KG <- function(data_for_network.nodes = data_for_network.nodes, 
                                              data_for_network.edges = data_for_network.edges,
                                              pattern = "(quality)|(life)|(qol)",
                                              min_nb_links =3, 
                                              file_name = ""){
  
  # Select nodes related to a specified pattern in their title
  preprocessed_nodes = tolower(data_for_network.nodes$label)
  pattern_nodes = data_for_network.nodes$label[which(grepl(preprocessed_nodes, pattern = pattern))]
  # All edges with these nodes 
  data_for_network.edges.pattern <- data_for_network.edges[which(data_for_network.edges$source %in%  pattern_nodes |
                                                               data_for_network.edges$target %in% pattern_nodes),]
  setDF(data_for_network.edges.pattern)
  # Count of links per edges, to keep nodes with at least the minimum specified in the arguments  
  data_for_network.edges.pattern <- data_for_network.edges.pattern[which(data_for_network.edges.pattern$source != "" & 
                                                                           data_for_network.edges.pattern$target != ""),]
  table_links_per_node.pattern <- table(c(data_for_network.edges.pattern$source, data_for_network.edges.pattern$target))
  table_links_per_node_min.pattern <- names(table_links_per_node.pattern[which(table_links_per_node.pattern>min_nb_links)])

  # Edges pattern 
  data_for_network.edges.pattern.min <- data_for_network.edges.pattern[union(which(data_for_network.edges.pattern$source %in% table_links_per_node_min.pattern),
                                                                   which(data_for_network.edges.pattern$target %in% table_links_per_node_min.pattern)),]
  # Keep nodes related to pattern and min nb of links nodes
  data_for_network.nodes.pattern.min <- data_for_network.nodes[which(data_for_network.nodes$label %in% unique(c(data_for_network.edges.pattern.min$source,
                                                                                                          data_for_network.edges.pattern.min$target))),]
  # Keep edges that involve nodes that are in our list : 
  data_for_network.edges.pattern.min <- data_for_network.edges.pattern.min[which(data_for_network.edges.pattern.min$source %in%  data_for_network.nodes.pattern.min$label &
                                                                       data_for_network.edges.pattern.min$target %in% data_for_network.nodes.pattern.min$label),]
  # Delete duplicates :
  data_for_network.nodes.pattern.min <- unique(data_for_network.nodes.pattern.min)
  data_for_network.edges.pattern.min <- unique(data_for_network.edges.pattern.min)
  
  # Convert for the JSON output
  print(paste0("Number of nodes : ", nrow(data_for_network.nodes.pattern.min)))
  print(paste0("Number of edges : ", nrow(data_for_network.edges.pattern.min)))

  list_network = list("nodes" = data_to_list_for_json_conversion(data_for_network.nodes.pattern.min),
                      "links" = data_to_list_for_json_conversion(data_for_network.edges.pattern.min))
  list_network.json <-  RJSONIO::toJSON(list_network)
  writeLines(list_network.json,
             paste0(file_name))
}


###################################################### Apply functions to create json files 

# Create node tables 
create_node_tables.output <- create_node_tables(results_relations, results_types, results_titles, clean_type_label_table)
node_type_table = create_node_tables.output$node_type_table
node_table = create_node_tables.output$node_table
data_for_network.nodes = create_node_tables.output$data_for_network.nodes

# Create edges tables 
create_edge_tables.output <- create_edge_tables(results_relations, node_table)
edge_type_table = create_edge_tables.output$edge_type_table
print(edge_type_table)
results_relations.w_edge_type = create_edge_tables.output$results_relations.w_edge_type
data_for_network.edges = create_edge_tables.output$data_for_network.edges

###################################################### Output json files according to some string pattern
## Covid-19
pattern_material_selection_for_KG(data_for_network.nodes = data_for_network.nodes, data_for_network.edges = data_for_network.edges, 
                                  pattern = "covid",
                                  min_nb_links =1, file_name = "covid/data_for_network.covid.json")
## QoL : 
pattern_material_selection_for_KG(data_for_network.nodes = data_for_network.nodes, data_for_network.edges = data_for_network.edges, 
                                  pattern = "(quality)|(life)|(qol)|(living)|(live)|(qualitative)",
                                  min_nb_links =2, file_name = "qol/data_for_network.QoL.json")

## Climate : 
pattern_material_selection_for_KG(data_for_network.nodes = data_for_network.nodes, data_for_network.edges = data_for_network.edges, 
                                  pattern = "(environment)|(greenhouse)|(climate)",
                                  min_nb_links =2, file_name = "climate/data_for_network.climate.json")


