library(tidyverse)
library(rvest)

minsalUrl = "https://www.minsal.cl/reporte-de-lesionados-y-heridos/"
minsalHtml = minsalUrl %>% read_html()
body = html_node(minsalHtml,"body")
list_tables = html_nodes(body, "table") %>% html_table()


process_table = function(list_element) {

  # DEBUG
    # XX = list_tables[[1]]
  
  XX = list_element
  
  list_element_2 = t(list_element)
  colnames(list_element_2) = as.character(unlist(list_element_2[1,]))
  list_element_2 = list_element_2[-1, ]
  
  list_element_2 %>% as_tibble()
  
}


DF = 1:length(list_tables) %>% 
  map_df(~ process_table(list_tables[[.x]]), .id = "ID")

DF_long = DF %>% 
  pivot_longer(cols = 4:5) %>% 
  unite(V1:V2, col = "evento") %>% 
  mutate(value = as.numeric(value),
         ID = as.integer(ID)) %>%
  rowwise() %>% 
  mutate(ID_order = 48 - ID) %>% 
  mutate(evento = gsub("\\*\\*", "\\*", evento),
         evento = gsub("\\*", "", evento),
         evento = gsub("12 hrs", "24 hrs", evento),
         evento = gsub("Pacientes Hospitalizados_Acumulado", "Pacientes Hospitalizados_Actuales", evento),
         evento = gsub("_", "", evento))

	
  # pivot_wider(names_from = V2, values_from = RM) %>% 

# DF_long 

plot_minsal = DF_long %>% 
  ggplot(aes(ID_order, value, color = evento, group = evento)) +
  geom_point() +
  geom_smooth(se = FALSE) +
  facet_wrap( ~ evento + name, scales = "free") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none") +
  labs(caption = "Fuente: https://www.minsal.cl/reporte-de-lesionados-y-heridos/ \n @gorkang")

# plot_minsal

save_object(plot_minsal, "plot_minsal", "plot")
