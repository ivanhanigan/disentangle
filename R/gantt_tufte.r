
# func
library(sqldf)
library(lubridate)
library(swishdbtools)
ch <- connect2postgres('localhost','gantt_tufte2', 'w2p_user', p='xpassword')
pgListTables(ch, "public")

# load
datin  <- read.csv(textConnection("container_task_title, task_id, allocated, fte, blocker, start_date, effort
Container 1, task 0, jim,   1,   ,     2014-12-01, 1m
Container 1, task 1, jim,   1,   ,     2014-12-20, 1m
Container 1, task 2, bob,   1, task 1,           , 10d 
Container 2, task 3, sue,   1,   ,     2014-12-01, 2w
Container 2, task 4, jim,   1, task 3,           , 2d
Container 3, task 5, jimmy, 1, task 3,           , 10d
Container 3, task 6, jimmy, 1,       , 2015-01-01, 10d
Container 4, task 7, jimmy, 1, task 3,           , 10d
"),
stringsAsFactor = F, strip.white = T)
datin$start_date  <- as.Date(datin$start_date)
str(datin)
datin

cnt  <- sqldf("select container_task from datin group by container_task", drv = "SQLite")
cnt$key_contact  <- NA
cnt$abstract  <- NA
cnt
dbWriteTable(ch, "container_task", cnt, append = T)
cnt  <- dbReadTable(ch, "container_task")
cnt

paste(  names(datin), sep = "", collapse = ", ")
datin2  <- sqldf("select id as container_id, task_id, allocated, fte, blocker, start_date, effort
from cnt
join datin
on cnt.container_task_title = datin.container_task", drv = "SQLite")
datin2
datin2$notes_issues  <- NA
dbWriteTable(ch, "work_package", datin2, append = T)

# psql got munteded, so revert to sqlite, tried swapping to sqlite, noto

## drv <- dbDriver("SQLite")
## tfile <- tempfile()
## con <- dbConnect(drv, dbname = "~/tools/web2py/applications/gantt_tufte/databases/storage.sqlite")
## dbListTables(con)
## datin2 <- dbGetQuery(con , "select * from work_package")
## dbWriteTable(ch, "work_package", datin2, append = T)


# ended up deleteing from the applications folder

################################################################ 
gantt_tufte_preprocessing  <- function(
  indat = datin
  ){
  # self join to collect the dependencies
  # paste(names(datint), sep = "", collapse = ", ")
  library(sqldf)
  library(lubridate)
  indat
  #indat$indat_id <- paste(indat$container_task, indat$task_id, sep = "_")
  # self join to return dependents
  indat2 <- sqldf("
  select t1.container_task,
  t1.task_id as predecessor,
  t2.task_id, t2.efforti,
  t1.end
  from indat t1
  left join
  indat t2
  on t1.task_id = t2.blocker
  
  ", drv = 'SQLite')
  #where t2.task_id is not null 
  indat2
  # get any other containers... not sure this helps
  indat2_1 <- sqldf("select t1.container_task, t1.predecessor, t2.predecessor as task_id,
  t2.efforti,
  t2.end
  from indat2 t1
  join
  indat2 t2
  where t1.predecessor = t2.task_id")
  indat2_1
  indat2$start  <- indat2$end 
  indat2$end  <- indat2$start + indat2$efforti
  indat2_1$start  <- indat2_1$end 
  indat2_1$end  <- indat2_1$start + indat2_1$efforti
  indat2  <- indat2[!is.na(indat2$start) & !is.na(indat2$end) ,]
  indat2
  indat2_1
  indat2 <- rbind(indat2, indat2_1)
  
  indat2 <- unique(indat2)
  # now you know the start of the dependents
  
  # now get other independent tasks
  indat3 <- sqldf("select container_task,
  task_id as predecessor,
  task_id,
  efforti,
  end, start
  from indat
  where start is not null
  ")
  # TODO at this point need to figure out how to get proper locs
  #indat3$loc <- nrow(indat3):1
  indat3
  indat2 
  # add loc of siblings
  ## indatx <- sqldf("select t1.*, t2.loc
  ## from indat2 t1
  ## left join
  ## indat3 t2
  ## where (t1.predecessor = t2.task_id)
  ## and t1.task_id is not null
  ## ")
  #indatx
  
  indat4 <- rbind(indat2, indat3)
  indat4 <- indat4[order(indat4$start),]
  indat4[order(indat4$container_task),]
  indat4 
  return(indat4)
}
datin2 <- indat4
#datin2 <- gantt_tufte_preprocessing(datin)
#str(datin2)

################################################################
# plot
dat_out <- get_gantt_data(test_data = F)
svg("AAPL.svg",width=26,height=14)
#gantt_tufte <- function(
  indat = dat_out
  ,
  smidge_lab = .15
  ,
  focal_date = '2015-01-12' # Sys.Date()
  ,
  time_box = 7 * 3
  ,
  end_task_ticks = F

  cex_context_ylab = 0.2

  cex_context_xlab = 0.5

cex_context_points = 0.5

cex_detail_ylab = 0.7

cex_detail_points = 0.7

cex_detail_labels = 0.7
#  ){
  focal_date <- as.Date(focal_date)
  m <- matrix(c(1,2), 2, 1)
  layout(m, widths=c(1), heights=c(.5,4))
  par(mar = c(3,16,2,1))
  # layout.show(2)
  yrange <- c((min(indat$loc2) - smidge_lab), (max(indat$loc2) + smidge_lab))
  xrange  <- c(min(indat$start_date, na.rm = T),max(indat$end, na.rm=T))
  # xrange
  #### context ####
  
  plot(xrange, yrange, type = 'n', xlab = "", ylab = "", axes = F )
  indat_lab  <- sqldf("select container_task_title, loc from indat group by container_task_title, loc", drv = "SQLite")
  mtext(c(indat_lab$container_task_title), 2, las =1, at = indat_lab$loc, cex = cex_context_ylab)

  polygon(c(focal_date, focal_date + time_box, focal_date + time_box, focal_date), c(rep(yrange[1],2), rep(yrange[2],2)), col = 'lightyellow', border = 'lightyellow')
  points(indat$start_date, indat$loc, pch = 16, cex = cex_context_points)
  #text(indat$start_date, indat$loc - smidge_lab, labels = indat$task_id, pos = 4)
  js <- indat$loc
  for(i in 1:nrow(indat)){
  # = 1
    segments(indat$start_date[i] , js[i] , indat$start_date[i] , max(indat$loc) + 1 , lty = 3)
    segments(indat$start_date[i] , js[i] , indat$end[i] , js[i] )
  }
  #segments(focal_date, yrange[1], focal_date, yrange[2], 'red')
  xstart_date <- ifelse(wday(xrange[1]) != 1, xrange[1] - (wday(xrange[1]) - 2), xrange[1])
  xend <- ifelse(wday(xrange[2]) != 7, xrange[2] + (5-wday(xrange[2])), xrange[2] )
  at_dates  <- seq(xstart_date, xend, 7)
  label_dates  <-
    paste(month(as.Date(at_dates, "1970-01-01"), label = T),
    day(as.Date(at_dates, "1970-01-01")),
    sep = "-")

  axis(1, at = at_dates, labels = label_dates, cex.axis = cex_context_xlab)
  #axis(3)

  
  #### detail ####
  js <- indat$loc2
  
  plot(c(focal_date, focal_date + time_box), yrange, type = 'n', xlab = "", ylab = "", axes = F)
       
  mtext(c(indat_lab$container_task_title), 2, las =1, at = indat_lab$loc, cex = cex_detail_ylab)
  points(indat$start_date, indat$loc2, pch = 16, cex = cex_detail_points)
  text(indat$start_date, indat$loc2 - smidge_lab, labels = indat$task_id, pos = 4,
       cex = cex_detail_labels)
  bumped_up <- indat[indat$start_date < focal_date,]
  text(focal_date, bumped_up$loc2 - smidge_lab, labels = bumped_up$task_id, pos = 4,
       cex = cex_detail_labels)
  for(i in 1:nrow(indat)){
  # = 1
    segments(indat$start_date[i] , js[i] , indat$start_date[i] , max(indat$loc2) + 1 , lty = 3)
    segments(indat$start_date[i] , js[i] , indat$end[i] , js[i] )
  }
  #segments(focal_date, yrange[1], focal_date, yrange[2], 'red')
  xstart_date <- ifelse(wday(focal_date) != 1, focal_date - (wday(focal_date) - 2), focal_date)
  xend <- ifelse(wday(focal_date + time_box) != 7, (focal_date + time_box) + (5-wday(focal_date + time_box)), (focal_date + time_box))
  at_dates  <- seq(xstart_date, xend, 1)
  at_dates2  <- seq(xstart_date, xend, 7)
  
  label_dates  <-
    paste(month(as.Date(at_dates2, "1970-01-01"), label = T),
    day(as.Date(at_dates2, "1970-01-01")),
    sep = "-")

  axis(1, at = at_dates, labels = F)
  axis(1, at = at_dates2, labels = label_dates)
  #segments(min(xrange), min(yrange) - .09, max(xrange), min(yrange) - .09)
  axis(3, at = at_dates, labels = F)
  axis(3, at = at_dates2, labels = label_dates)
  #segments(min(xrange), max(yrange) + .09, max(xrange), max(yrange) + .09)  
  
# }
#ls()
#gantt_tufte(datin2, focal_date = as.Date("2014-12-10"))
dev.off()
