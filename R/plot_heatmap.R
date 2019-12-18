plot_heatmap <- function(DF) {
  DF %>%
    drop_na() %>%
    group_by(name) %>%
    mutate(Nor_value = value / max(value)) %>%
    group_by(name, WeekDay) %>%
    summarise(Nor_value = mean(Nor_value)) %>%
    ggplot(aes(WeekDay, name)) +

    geom_tile(aes(fill = Nor_value), colour = "white") +
    theme_minimal(base_size = 14) +
    theme(legend.position = "bottom") +
    guides(fill = guide_legend(title = "Eventos \n(normalizado por tipo)")) +

    labs(
      x = "",
      y = "",
      caption = "Fuente: http://ddhh.minjusticia.gob.cl/informacion-sobre-la-situacion-del-pais-desde-el-19-de-octubre\nPlot por @gorkang"
    ) +
    scale_x_discrete(position = "top") +
    scale_fill_distiller(palette = "Blues", direction = 1)
}
