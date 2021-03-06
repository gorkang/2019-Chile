# Extrae y grafica las tablas de: http://ddhh.minjusticia.gob.cl/informacion-sobre-la-situacion-del-pais-desde-el-19-de-octubre


# Funciones ---------------------------------------------------------------

source("R/plot_grouped.R")
source("R/plot_grouped_monthly.R")
source("R/plot_global_heatmap.R")
source("R/plot_heatmap.R")


# Leer datos ----------------------------------------------------------------------------------

source_pdf <- list.files("data", full.names = TRUE) %>% last()
out1 <- extract_tables(source_pdf, method = "lattice")


# Preparar datos ------------------------------------------------------------------------------

# DF = out1[[1]] %>% as.data.frame()
# names_of_rows = DF[1, ] %>% as.array() 
# colnames(DF) = DF[1, ]

DF <- 1:3 %>%
  map_df(~ out1[[.x]] %>% as_tibble()) %>%
  rename(
    Fecha = V1,
    `Eventos graves` = V2,
    `Funcionarios lesionados` = V3,
    `Civiles lesionados` = V4,
    `Detenidos fuera toque queda` = V5,
    `Quebrantamiento toque queda` = V6,
    `Prisiones preventivas` = V7,
    `Buses incendiados` = V8,
    `Vehiculos policiales incendiados` = V9,
    `Ataques metro` = V10
    # `Ataques cuarteles` = V11
  ) %>%
  filter(grepl("^[0-9]", Fecha)) %>%
  mutate(Fecha = as.Date(Fecha, "%d-%m-%Y")) %>%
  mutate_if(is.character, as.integer)


# Guarda datos de tabla
save_object(DF, "raw_data", "data")


DF_plot <- DF %>%
  mutate(
    WeekDay = as.factor(weekdays(Fecha, abbreviate = TRUE)),
    WeekDay = forcats::fct_relevel(WeekDay, c("sáb", "dom", "lun", "mar", "mié", "jue", "vie"))
  ) %>%
  pivot_longer(2:(length(.) - 1)) %>%
  mutate(
    tipo =
      case_when(
        name %in% c("Eventos graves") ~ "Eventos graves",
        name %in% c("Funcionarios lesionados", "Civiles lesionados") ~ "Lesiones",
        name %in% c("Detenidos fuera toque queda", "Quebrantamiento toque queda", "Prisiones preventivas") ~ "Detenciones",
        name %in% c("Ataques cuarteles", "Vehiculos policiales incendiados") ~ "Daños materiales policia",
        name %in% c("Ataques metro", "Buses incendiados") ~ "Daños materiales otros"
      ),
    name = fct_relevel(
      name, "Ataques metro", "Buses incendiados",
      "Ataques cuarteles", "Vehiculos policiales incendiados",
      "Detenidos fuera toque queda", "Quebrantamiento toque queda", "Prisiones preventivas",
      "Eventos graves",
      "Funcionarios lesionados", "Civiles lesionados"
    )
  )


# PLOT 1 ------------------------------------------------------------------

plot1 <- plot_grouped(DF_plot)
save_object(plot1, "plot_grouped", "plot")

plot1m <- plot_grouped_monthly(DF_plot)
save_object(plot1m, "plot_grouped_monthly", "plot")


# PLOT heatmap ------------------------------------------------------------

# plot2 <- plot_heatmap(DF_plot)
# save_object(plot2, "plot_heatmap", "plot")

# PLOT global heatmap ------------------------------------------------------------

plot3 <- plot_global_heatmap(DF_plot)
save_object(plot3, "plot_global_heatmap", "plot", height_plot = 10, width_plot = 25)


# PLOT global heatmap - last 30 days ------------------------------------------------------------

plot4 <- plot_global_heatmap(DF_plot %>% filter(Fecha >= as.Date(Sys.time (), "%d-%m-%Y") - 30))
save_object(plot4, "plot_global_heatmap_30d", "plot", height_plot = 5)
