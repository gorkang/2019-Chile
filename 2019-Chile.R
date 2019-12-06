# https://gist.github.com/gorkang/84cda9752a7cbe72ac179d81b04e6a2a

# Archivo PDF de: 
  # http://ddhh.minjusticia.gob.cl/informacion-sobre-la-situacion-del-pais-desde-el-19-de-octubre
  # 2019-12-05: https://www.scribd.com/document/438470416/Datos-05-12-19#download

# Librerias -----------------------------------------------------------------------------------

  library(tidyverse)
  library(tabulizer)



# Leer datos ----------------------------------------------------------------------------------

  source_pdf = list.files("data", full.names = TRUE) %>% last()
  out1 <- extract_tables(source_pdf, method = "lattice")


# Preparar datos ------------------------------------------------------------------------------

  DF = 1:2 %>% 
    map_df(~ out1[[.x]]%>% as_tibble) %>% 
    rename(Fecha = V1,
           `Eventos graves` = V2,
           `Funcionarios lesionados` = V3,
           `Civiles lesionados` = V4,
           `Detenidos fuera toque queda` = V5,
           `Quebrantamiento toque queda` = V6,
           `Prisiones preventivas` = V7,
           `Buses incendiados` = V8,
           `Vehiculos policiales incendiados` = V9,
           `Ataques metro` = V10,
           `Ataques cuarteles` = V11) %>% 
    filter(grepl("^[0-9]", Fecha))

  
  DF_plot = DF %>% 
    pivot_longer(2:11) %>% 
    mutate(value = as.numeric(value),
           Fecha = as.Date(Fecha, "%d-%m-%Y"),
           tipo = 
             case_when(
               name %in% c("Eventos graves") ~ "Eventos graves",
               name %in% c("Funcionarios lesionados", "Civiles lesionados") ~ "Lesiones",
               name %in% c("Detenidos fuera toque queda", "Quebrantamiento toque queda", "Prisiones preventivas") ~ "Detenciones",
               name %in% c("Ataques cuarteles", "Vehiculos policiales incendiados") ~ "Daños materiales policia",
               name %in% c("Ataques metro", "Buses incendiados") ~ "Daños materiales otros"),
           name = fct_relevel(name, "Ataques metro", "Buses incendiados", 
                              "Ataques cuarteles", "Vehiculos policiales incendiados",
                              "Detenidos fuera toque queda", "Quebrantamiento toque queda", "Prisiones preventivas",
                              "Eventos graves",
                              "Funcionarios lesionados", "Civiles lesionados"))

  

# PLOT ----------------------------------------------------------------------------------------

  PLOT = ggplot(DF_plot, aes(Fecha, value, color = name, group = name)) +
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

PLOT 

today_date = format(Sys.Date(), format="%Y-%m-%d")
ggsave(paste0("outputs/", today_date, "plot_grouped.png"), PLOT, width = 15, height = 10, dpi = 200)
