# save_plot <- function(plot_object, plot_name) {
#   
#   today_date = format(Sys.Date(), format = "%Y-%m-%d")
#   ggsave(paste0("outputs/", today_date, "_", plot_name ,".png"), plot_object, width = 15, height = 10, dpi = 200)
#   ggsave(paste0("outputs/", "LAST_", plot_name ,".png"), plot_object, width = 15, height = 10, dpi = 200)
#   
# }

save_object <- function(object_to_save, object_name, object_type) {

  # object_to_save = DF
  # object_name = "raw_data"
  # object_type = "data"
  
  today_date = format(Sys.Date(), format = "%Y-%m-%d")
  
  if (object_type == "plot") {

    ggsave(paste0("outputs/", object_type, "/", today_date, "_", object_name ,".png"), object_to_save, width = 15, height = 10, dpi = 200)
    ggsave(paste0("outputs/", object_type, "/", "LAST_", object_name ,".png"), object_to_save, width = 15, height = 10, dpi = 200)
    
  } else if (object_type == "data") {

    write_csv(object_to_save, paste0("outputs/", object_type, "/", today_date, "_", object_name ,".csv"))
    write_csv(object_to_save, paste0("outputs/", object_type, "/", "LAST_", object_name ,".csv"))
    
  }
  
}
