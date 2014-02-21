# functions
require(gdata)
?read.xls
# load
df <- read.xls("gantt-tj3.xlsx", sheet = 1, header = TRUE)
str(df)
df
df$task_id  <-  as.character(df$task_id)
df$Effort  <-  as.character(df$Effort)
df$allocate  <-  as.character(df$allocate)
df$BLOCKER  <-  as.character(df$BLOCKER)

r  <- read.xls("gantt-tj3.xlsx", sheet = 2, header = TRUE)
str(r)
# windows excel origin is 1900? or not
df$start <- as.Date(df[,"start"], origin= "1899-12-30")
df

# do
sink("text-gantt.org")
cat(
paste('#+TITLE:     gantt-tj3.org

#+PROPERTY: Effort_ALL 2d 5d 10d 20d 30d 35d 50d

* Action list                                          :taskjuggler_project:
')
)
sink()

#### start ####
for(input_i in 1:nrow(df)){
  #  input_i  <- 1
#  input_j <- gsub(' ', '-', df[input_i,4:6])
  input_j <- df[input_i,]
#sink("text-gantt.org", append = T)
cat(
paste('
** TODO Test tj3 A
    :PROPERTIES:
    :task_id:  ',input_j$task_id,'
    :Effort:   ',input_j$Effort,'
    :allocate: ',input_j$allocate,'
    :END:
')
#sink()
)
}

for(input_r in 1:nrow(r)){
#  input_r  <- 1
  input_jr <- r[input_r,]
#  input_jr
sink("text-gantt.org", append = T)
paste('

* Resources                                            :taskjuggler_resource:
** A
    :PROPERTIES:
    :resource_id: ',r$resource_id[1],'
    :END:
')
)
sink()

sink("text-gantt.org", append = T)
cat('# Local Variables:\n# org-export-taskjuggler-target-version: 3.0\n# org-export-taskjuggler-default-reports: ("include \\"gantexport.tji\\"")\n# End:')
sink()
################################################################
# name:tjclean
tjclean <- function(tjfile, start, duration = '280d', print = TRUE){
  tjout <- gsub('.tjp', '2.tjp', tjfile)
  catn <- function(...) cat(..., sep="\n")
  printFile <- function(filename,n=-1, startdate)
    {
      con = file(filename,"r")
          lines <- readLines(con,n)
          # fix the automatic inserted wrongdate
          lines[1] <- gsub(Sys.Date(), startdate, lines[1])
          lines[1] <- gsub('280d', duration, lines[1])
          lines[26] <- gsub(Sys.Date(), startdate, lines[26])
          catn(lines)
      close(con)
    }

  sink(tjout)
  printFile(tjfile, startdate = start)
  sink()
  if(print == FALSE){
    system(sprintf('tj3 %s', tjout))
  } else {
    sprintf('tj3 %s', tjout)
  }
}

#### test ####
tjclean(tjfile = 'text-gantt.tjp', start = '2013-09-01', duration = '360d', print = FALSE)
