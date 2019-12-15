
DF_minsal_wide = DF_minsal_long %>% 
  select(Fecha, evento, lugar, value) %>% 
  group_by(Fecha, evento) %>% 
  summarise(value = sum(value)) %>% 
  pivot_wider(names_from = evento, values_from = value) %>% 
  ungroup() 

DF_plot = DF %>% 
  full_join(DF_minsal_wide) %>% 
  select(Fecha, `Civiles lesionados`, `Atenciones de Urgencia (24h)`, `Pacientes Hospitalizados (24h)`) %>% 
  pivot_longer(cols = 2:4) %>% 
  mutate(name = 
           case_when(
             name == "Civiles lesionados" ~ "Civiles lesionados - Carabineros_PDI",
             TRUE ~ paste0(name, " - Minsal")
           ))

 
plot_carabinerosPDI_minsal = DF_plot %>% 
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
  # facet_wrap( ~ tipo, scales = "free") +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    legend.position = "bottom",
    # legend.justification = c(1, 0)
  ) +
  guides(col = guide_legend(nrow = 6, byrow = TRUE)) +
  scale_x_date(date_labels = "%d-%b", date_breaks  = "2 day", limits = as.Date(c(min(DF_plot$Fecha) - 1, max(DF_plot$Fecha) + 1)), expand = c(0, 0)) +
  scale_color_manual(values=c("#999999", "#007328", "#56B4E9")) +
  labs(subtitle = "Civiles lesionados, atenciones de Urgencia y Hospitalizaciones",
       x = "",
       y = "número",
       color = "",
       caption = "Datos Carabineros_PDI: http://ddhh.minjusticia.gob.cl/informacion-sobre-la-situacion-del-pais-desde-el-19-de-octubre\nDatos Minsal: https://www.minsal.cl/reporte-de-lesionados-y-heridos/\nPlot por @gorkang")




save_object(plot_carabinerosPDI_minsal, "plot_carabinerosPDI_minsal", "plot")
