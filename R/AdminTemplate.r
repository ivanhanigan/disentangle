
################################################################
# name:R-AdminTemplate
AdminTemplate <- function(rootdir = getwd()){
  if(!exists(rootdir)) dir.create(rootdir)
  dir.create(file.path(rootdir,'01_planning'))
  dir.create(file.path(rootdir,'01_planning','proposal'))
  dir.create(file.path(rootdir,'01_planning','scheduling'))
  dir.create(file.path(rootdir,'02_budget'))
  dir.create(file.path(rootdir,'03_communication'))
  dir.create(file.path(rootdir,'04_reporting_and_meetings'))
  file.create(file.path(rootdir,'contact_details.txt'))
  file.create(file.path(rootdir,'README.md'))
  }
