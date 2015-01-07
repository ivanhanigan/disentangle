
# func
library(sqldf)
library(lubridate)

# load
datin  <- read.csv(textConnection("container_task, task_id, allocate, fte, blocker, start, effort
Container 1, task 0, jim,   1,   ,     2014-12-01, 1m
Container 1, task 1, jim,   1,   ,     2014-12-20, 1m
Container 1, task 2, bob,   1, task 1,           , 10d 
Container 2, task 3, sue,   1,   ,     2014-12-01, 2w
Container 2, task 4, jim,   1, task 3,           , 2d
Container 3, task 5, jimmy, 1, task 3,           , 10d
"),
stringsAsFactor = F)
datin$start  <- as.Date(datin$start)
str(datin)
datin

################################################################

# calculate time boxes
timebox <- function(dat_in){
  nameslist <- names(dat_in)
  dat_in$effortt <- as.numeric(gsub("[^\\d]+", "", dat_in$effort, perl=TRUE))
  dat_in$effortd <- gsub("d", 1, gsub("[[:digit:]]+", "", dat_in$effort, perl=TRUE))
  dat_in$effortd <- gsub("w", 7, dat_in$effortd)
  dat_in$effortd <- gsub("m", 30.5, dat_in$effortd)
  dat_in$effortd <- as.numeric(dat_in$effortd)
  dat_in$efforti <- dat_in$effortt * dat_in$effortd
  dat_in$end  <- dat_in$start + dat_in$efforti
  #str(dat_in)
  dat_in <- dat_in[,c(nameslist, "efforti", "end")]
  return(dat_in)
}

 datin <- timebox(datin)
# str(datin)
# datin

################################################################ 
gantt_tufte_preprocessing  <- function(
  indat = datin
  ){
  # self join to collect the dependencies
  # paste(names(datint), sep = "", collapse = ", ")
  library(sqldf)
  library(lubridate)
  indat
  # self join to return dependents
  indat2 <- sqldf("select t1.container_task,
  t1.task_id as predecessor,
  t2.task_id, t2.efforti,
  t1.end
  from indat t1
  left join
  indat t2
  on t1.task_id = t2.blocker
  
  ")
  #where t2.task_id is not null 
  indat2
  # get any other containers
  indat2_1 <- sqldf("select t1.container_task, t2.predecessor, t1.predecessor as task_id,
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
  
  indat2
  # now you know the start of the dependents
  
  # now get other set 
  indat3 <- sqldf("select container_task,
  task_id as predecessor,
  task_id,
  efforti,
  end, start
  from indat
  where start is not null
  ")
  # TODO at this point need to figure out how to get proper locs
  indat3$loc <- nrow(indat3):1
  indat3
  indat2 
  # add loc of siblings
  indatx <- sqldf("select t1.*, t2.loc
  from indat2 t1
  left join
  indat3 t2
  where (t1.predecessor = t2.task_id)
  and t1.task_id is not null
  ")
  indatx
  
  indat4 <- rbind(indat3, indatx)
  indat4 <- indat4[order(indat4$start),]
  indat4 
  return(indat4)
}
datin2 <- indat4
#datin2 <- gantt_tufte_preprocessing(datin)
#str(datin2)

################################################################
# plot
gantt_tufte <- function(
  indat = datin2
  ,
  smidge_lab = .15
  ,
  focal_date = Sys.Date()
  ,
  time_box = 21
  ,
  end_task_ticks = F 
  ){
  m <- matrix(c(1,2), 2, 1)
  layout(m, widths=c(1), heights=c(.9,4))
  par(mar = c(3,8,2,1))
  # layout.show(2)
  yrange <- c((min(indat$loc) - smidge_lab), (max(indat$loc) + smidge_lab))
  xrange  <- c(min(indat$start),max(indat$end))

  #### context ####
  
  plot(xrange, yrange, type = 'n', xlab = "", ylab = "", axes = F )
  mtext(c(indat$container_task), 2, las =1, at = indat$loc, cex = .8)

  polygon(c(focal_date, focal_date + time_box, focal_date + time_box, focal_date), c(rep(yrange[1],2), rep(yrange[2],2)), col = 'lightyellow', border = 'lightyellow')
  points(indat$start, indat$loc, pch = 16)
  #text(indat$start, indat$loc - smidge_lab, labels = indat$task_id, pos = 4)
  js <- indat$loc
  for(i in 1:nrow(indat)){
  # = 1
    segments(indat$start[i] , js[i] , indat$start[i] , max(indat$loc) + 1 , lty = 3)
    segments(indat$start[i] , js[i] , indat$end[i] , js[i] )
  }
  #segments(focal_date, yrange[1], focal_date, yrange[2], 'red')
  xstart <- ifelse(wday(xrange[1]) != 1, xrange[1] - (wday(xrange[1]) - 2), xrange[1])
  xend <- ifelse(wday(xrange[2]) != 7, xrange[2] + (5-wday(xrange[2])), xrange[2] )
  at_dates  <- seq(xstart, xend, 7)
  label_dates  <-
    paste(month(as.Date(at_dates, "1970-01-01"), label = T),
    day(as.Date(at_dates, "1970-01-01")),
    sep = "-")

  axis(1, at = at_dates, labels = label_dates)
  #axis(3)

  
  #### detail ####
  
  plot(c(focal_date, focal_date + time_box), yrange, type = 'n', xlab = "", ylab = "", axes = F )
  mtext(c(indat$container_task), 2, las =1, at = indat$loc, cex = .8)
  points(indat$start, indat$loc, pch = 16)
  text(indat$start, indat$loc - smidge_lab, labels = indat$task_id, pos = 4)
  for(i in 1:nrow(indat)){
  # = 1
    segments(indat$start[i] , js[i] , indat$start[i] , max(indat$loc) + 1 , lty = 3)
    segments(indat$start[i] , js[i] , indat$end[i] , js[i] )
  }
  #segments(focal_date, yrange[1], focal_date, yrange[2], 'red')
  xstart <- ifelse(wday(focal_date) != 1, focal_date - (wday(focal_date) - 2), focal_date)
  xend <- ifelse(wday(focal_date + time_box) != 7, (focal_date + time_box) + (5-wday(focal_date + time_box)), (focal_date + time_box))
  at_dates  <- seq(xstart, xend, 1)
  at_dates2  <- seq(xstart, xend, 7)
  
  label_dates  <-
    paste(month(as.Date(at_dates2, "1970-01-01"), label = T),
    day(as.Date(at_dates2, "1970-01-01")),
    sep = "-")

  axis(1, at = at_dates, labels = F)
  axis(1, at = at_dates2, labels = label_dates)
  segments(min(xrange), min(yrange) - .09, max(xrange), min(yrange) - .09)
  axis(3, at = at_dates, labels = F)
  axis(3, at = at_dates2, labels = label_dates)
  segments(min(xrange), max(yrange) + .09, max(xrange), max(yrange) + .09)  
  
}
#ls()
#gantt_tufte(datin2, focal_date = as.Date("2014-12-10"))
