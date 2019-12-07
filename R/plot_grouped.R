plot_grouped <- function(DF) {
  
  DF %>% 
    ggplot(aes(Fecha, value, color = name, group = name)) +
      geom_point() +
      geom_line(alpha = .6) +
      geom_smooth(se = FALSE,
                  linetype = "dashed",
                  alpha = .3) +
      
      # Dias con toque de queda
      annotate(
        "rect",
        xmin = as.Date("2019-10-20"),
        xmax = as.Date("2019-10-27"),
        ymin = 0,
        ymax = Inf,
        alpha = .2
      ) +
      facet_wrap( ~ tipo, scales = "free") +
      theme_minimal(base_size = 12) +
      theme(
        axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = c(1, 0),
        legend.justification = c(1, 0)
      ) +
      guides(col = guide_legend(nrow = 6, byrow = TRUE)) +
      scale_x_date(date_labels = "%d-%b", date_breaks  = "2 day") +
      labs(x = "",
           y = "número",
           caption = "Fuente: http://ddhh.minjusticia.gob.cl/informacion-sobre-la-situacion-del-pais-desde-el-19-de-octubre\nPlot por @gorkang") +
      scale_color_brewer(palette = "Paired", name = "")
  
}