# Extrae y grafica las tablas de: https://www.minsal.cl/reporte-de-lesionados-y-heridos/

# Funciones -------------------------------------------------

source("R/process_table_minsal.R")


# Leer datos ----------------------------------------------------------------------------------

minsalUrl <- "https://www.minsal.cl/reporte-de-lesionados-y-heridos/"
minsalHtml <- minsalUrl %>% read_html()
body <- html_node(minsalHtml, "body")
list_tables <- html_nodes(body, "table") %>% html_table()

list_ps <- html_nodes(body, "p") %>% html_text()
dates_extracted <- grep(".*2019$", list_ps, value = TRUE) %>%
  tibble::enframe() %>%
  mutate(ID = as.integer(name)) %>%
  rename(fecha = value) %>%
  select(-name)


# Preparar datos ------------------------------------------------------------------------------

DF_minsal <- 1:length(list_tables) %>%
  map_df(~ process_table_minsal(list_tables[[.x]]), .id = "ID")

DF_minsal_long <- DF_minsal %>%
  pivot_longer(cols = 4:5) %>%
  filter(V2 != "Acumulado") %>%
  unite(V1:V2, col = "evento", sep = "\n") %>%
  mutate(
    value = as.integer(value),
    ID = as.integer(ID)
  ) %>%
  mutate(ID_order = (max(ID) + 1) - ID) %>%
  mutate(
    evento = gsub("\\*\\*", "\\*", evento),
    evento = gsub("\\*", "", evento),
    evento = gsub("\n", "", evento),
    evento = gsub("12 hrs", "24 hrs", evento),
    evento = gsub("Últimas24 hrs.", " (24h)", evento),
    evento = gsub("Actuales", " (actuales)", evento),
    evento = gsub("Fallecidos", "Fallecidos (acumulado)", evento),
    evento = gsub("Pacientes Hospitalizados_Acumulado", "Pacientes Hospitalizados_Actuales", evento),
    evento = gsub("_", "", evento)
  ) %>%
  left_join(dates_extracted, by = "ID") %>%
  mutate(
    Fecha = as.Date(fecha, "%A %d de %B de %Y"),
    WeekDay = as.factor(weekdays(as.Date(Fecha), abbreviate = TRUE)),
    WeekDay = forcats::fct_relevel(WeekDay, c("sáb", "dom", "lun", "mar", "mié", "jue", "vie"))
  ) %>%
  rename(lugar = name)


# Guarda datos de tabla
save_object(DF_minsal_long, "raw_data_minsal", "data")



# PLOT 1 --------------------------------------------------------------------

plot_minsal <- DF_minsal_long %>%
  ggplot(aes(Fecha, value, color = evento, group = lugar, linetype = lugar, shape = lugar)) +
  geom_point(show.legend = FALSE) +
  geom_smooth(se = FALSE, show.legend = TRUE) +
  facet_wrap(~evento, scales = "free") +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    legend.position = c(1, 0),
    legend.justification = c(1, 0)
  ) +
  scale_x_date(date_labels = "%d-%b", date_breaks = "2 day", limits = as.Date(c(min(DF_minsal_long$Fecha) - 1, max(DF_minsal_long$Fecha) + 1)), expand = c(0, 0)) +
  scale_color_brewer(palette = "Paired") +
  labs(
    x = "",
    y = "número",
    caption = "Fuente: https://www.minsal.cl/reporte-de-lesionados-y-heridos/ \n @gorkang"
  )

# plot_minsal

save_object(plot_minsal, "plot_minsal", "plot")



# PLOT 2 ------------------------------------------------------------------

plot_minsal_heat <- DF_minsal_long %>%
  drop_na() %>%
  group_by(evento) %>%
  mutate(Nor_value = value / max(value)) %>%
  group_by(evento, Fecha) %>%
  summarise(Nor_value = mean(Nor_value)) %>%
  ggplot(aes(Fecha, evento)) +

  geom_tile(aes(fill = Nor_value), colour = "white", height = 1, width = 1, size = 1) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 90, hjust = 1)) +
  guides(fill = guide_legend(title = "Eventos \n(normalizado por tipo)")) +

  labs(
    x = "",
    y = "",
    caption = "Fuente: https://www.minsal.cl/reporte-de-lesionados-y-heridos/\nPlot por @gorkang"
  ) +
  # scale_x_discrete() +
  scale_x_date(
    date_labels = "%d-%b", date_breaks = "2 day", position = "top",
    limits = as.Date(c(min(DF_minsal_long$Fecha) - 1, max(DF_minsal_long$Fecha) + 1)),
    expand = c(0, 0)
  ) +
  scale_fill_distiller(palette = "Blues", direction = 1) +
  coord_fixed()

save_object(plot_minsal_heat, "plot_minsal_global_heatmap", "plot", height_plot = 4)
