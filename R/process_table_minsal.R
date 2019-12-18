process_table_minsal <- function(list_element) {

  # DEBUG
  # list_element = list_tables[[1]]

  list_element_2 <- t(list_element)
  colnames(list_element_2) <- as.character(unlist(list_element_2[1, ]))
  list_element_2 <- list_element_2[-1, ]

  list_element_2 %>% as_tibble()
}
