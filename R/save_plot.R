save_plot <- function(plot_object, plot_name) {
  
  today_date = format(Sys.Date(), format = "%Y-%m-%d")
  ggsave(paste0("outputs/", today_date, "_", plot_name ,".png"), plot_object, width = 15, height = 10, dpi = 200)
  ggsave(paste0("outputs/", "LAST_", plot_name ,".png"), plot_object, width = 15, height = 10, dpi = 200)
  
}
