# Extrae y grafica las tablas de: https://www.minsal.cl/reporte-de-lesionados-y-heridos/

# Funciones -------------------------------------------------
  
  source("R/process_table_minsal.R")


# Leer datos ----------------------------------------------------------------------------------

  minsalUrl = "https://www.minsal.cl/reporte-de-lesionados-y-heridos/"
  minsalHtml = minsalUrl %>% read_html()
  body = html_node(minsalHtml,"body")
  list_tables = html_nodes(body, "table") %>% html_table()



# Preparar datos ------------------------------------------------------------------------------
  
  DF_minsal = 1:length(list_tables) %>% 
    map_df(~ process_table_minsal(list_tables[[.x]]), .id = "ID")
  
  DF_minsal_long = DF_minsal %>% 
    pivot_longer(cols = 4:5) %>% 
    unite(V1:V2, col = "evento") %>% 
    mutate(value = as.numeric(value),
           ID = as.integer(ID)) %>%
    mutate(ID_order = (max(ID) + 1) - ID) %>% 
    mutate(evento = gsub("\\*\\*", "\\*", evento),
           evento = gsub("\\*", "", evento),
           evento = gsub("12 hrs", "24 hrs", evento),
           evento = gsub("Pacientes Hospitalizados_Acumulado", "Pacientes Hospitalizados_Actuales", evento),
           evento = gsub("_", "", evento))
  
  # Guarda datos de tabla
  save_object(DF_minsal_long, "raw_data_minsal", "data")
  
	
  
# PLOT 1 --------------------------------------------------------------------

  plot_minsal = DF_minsal_long %>% 
    ggplot(aes(ID_order, value, color = evento, group = evento)) +
    geom_point() +
    geom_smooth(se = FALSE) +
    facet_wrap( ~ evento + name, scales = "free") +
    theme_minimal(base_size = 14) +
    theme(legend.position = "none") +
    labs(x = "tiempo",
         y = "número",
         caption = "Fuente: https://www.minsal.cl/reporte-de-lesionados-y-heridos/ \n @gorkang")


  save_object(plot_minsal, "plot_minsal", "plot")
