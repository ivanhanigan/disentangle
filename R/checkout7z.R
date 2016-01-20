
#' @name 7z_checkout
#' @title 7z checkout files
#' @param archive_id a name
#' @param dirlist a list of paths
#' @param loc_7z a path to your 7z location 
#' @param checkin_or_out this creates a flag file called checkedin or checkedout in the dirs 
#' @return cmd line
#' @export
#'
checkout7z <- function(archive_id  = "versions/air_pollution_testing_checkin_to_q_drive",
                       dirlist = c("Air_pollution_modelling_LUR_Western_Sydney/LUR_Western_Sydney_passive_samplers/",
                         "projects/Air_Pollution_Monitoring_Stations_NSW/AP_monitor_NSW_2014_2015/"),
                       loc_7z = "c:\\Users\\ivan.hanigan\\Documents\\7-zip\\7z.exe"
  ){
  
  cmd <- sprintf('"%s" a -t7z %s_%s.7z "%s"',
                 loc_7z,
                 archive_id,
                 gsub(":", "-", gsub(" ", "-", Sys.time())),
                 paste(dirlist, sep = "", collapse = '" "')
                 )
  #cat(cmd)
  return(cmd)
}
