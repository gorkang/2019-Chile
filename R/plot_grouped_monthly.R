plot_grouped_monthly <- function(DF) {
  
  # DF = DF2
  DF %>%
    mutate(year = gsub("^([0-9]{4}).*", "\\1", Fecha),
           month = gsub("^[0-9]{4}-([0-9]{2}).*", "\\1", Fecha)) %>% 
    group_by(year, month, name, tipo) %>% 
    summarise(value = mean(value)) %>% 
    mutate(Fecha = (paste0(year, "-", month))) %>% 
  
    ggplot(aes(Fecha, value, color = name, group = name)) +
    geom_point() +
    geom_line(alpha = .6) +
    geom_smooth(
      se = FALSE,
      linetype = "dashed",
      alpha = .3
    ) +
    
    facet_wrap(~ tipo, scales = "free") +
    theme_minimal(base_size = 12) +
    theme(
      axis.text.x = element_text(angle = 90, hjust = 1),
      legend.position = c(1, 0),
      legend.justification = c(1, 0)
    ) +
    guides(col = guide_legend(nrow = 6, byrow = TRUE)) +
    # scale_x_date(date_labels = "%d-%b", date_breaks = "5 day", limits = as.Date(c(min(DF_plot$Fecha) - 1, max(DF_plot$Fecha) + 1)), expand = c(0, 0)) +
    labs(
      x = "",
      y = "número",
      caption = "Fuente: http://ddhh.minjusticia.gob.cl/informacion-sobre-la-situacion-del-pais-desde-el-19-de-octubre\nPlot por @gorkang"
    ) +
    scale_color_brewer(palette = "Paired", name = "")
}
