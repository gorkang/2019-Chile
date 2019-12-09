plot_global_heatmap <- function(DF) {

  DF_plot %>%
      drop_na() %>%
      group_by(name) %>%
      mutate(Nor_value = value/max(value)) %>%
      group_by(name, Fecha) %>%
      summarise(Nor_value = mean(Nor_value)) %>% 
      
      ggplot(aes(Fecha, name)) + 
      
      geom_tile(aes(fill = Nor_value), colour = "white", height = 1, width = 1, size = 1) + 
      theme_minimal(base_size = 14) +
      theme(legend.position = "bottom", axis.text.x = element_text(angle = 90, hjust = 1)) +
      guides(fill = guide_legend(title = "Eventos \n(normalizado por tipo)")) +
      
      labs(x = "",
           y = "",
           caption = "Fuente: http://ddhh.minjusticia.gob.cl/informacion-sobre-la-situacion-del-pais-desde-el-19-de-octubre\nPlot por @gorkang") +
      # scale_x_discrete() +
    scale_x_date(date_labels = "%d-%b", date_breaks  = "2 day", position = "top", 
                 limits = as.Date(c(min(DF_plot$Fecha) - 1, max(DF_plot$Fecha) + 1)),
                 expand = c(0, 0)) +
    scale_fill_distiller(palette = "Blues", direction = 1) +
    coord_fixed()

}



