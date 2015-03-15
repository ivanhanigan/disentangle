
################################################################
# plot 

gantt_tufte <- function(
  indat = dat_out
  ,
  smidge_lab = .15
  ,
  focal_date = '2015-01-18' # Sys.Date()
  , 
  show_today = TRUE
  ,
  time_box = 7 * 2.5
  ,
  end_task_ticks = F
  ,
  cex_context_ylab = 0.2
  ,
  cex_context_xlab = 0.5
  ,
  cex_context_points = 0.5
  ,
  min_context_xrange =  NA
  , 
  max_context_xrange = NA
  ,
  cex_detail_ylab = 0.7
  ,
  cex_detail_xlab = 1
  ,
  cex_detail_points = 0.7
  ,
  cex_detail_labels = 0.7
  ){
  focal_date <- as.Date(focal_date)
  m <- matrix(c(1,2), 2, 1)
  layout(m, widths=c(1), heights=c(.75,4))
  par(mar = c(3,16,2,1))
  # layout.show(2)


  yrange <- c((min(indat$loc2) - smidge_lab), (max(indat$loc2) + smidge_lab))
  if(!is.na(min_context_xrange)){
  xmin <- as.Date(min_context_xrange)    
  } else {
  xmin <- min(indat$start_date, na.rm = T)
  }
  if(!is.na(max_context_xrange)){
  xmax <- as.Date(max_context_xrange)    
  } else {
  xmax <- max(indat$start_date, na.rm = T)
  }

  xrange  <- c(xmin,xmax)
  
  # xrange
  #### context ####
  
  plot(xrange, yrange, type = 'n', xlab = "", ylab = "", axes = F )
  indat_lab  <- sqldf("select container_task_title, loc from indat group by container_task_title, loc", drv = "SQLite")
  mtext(c(indat_lab$container_task_title), 2, las =1, at = indat_lab$loc, cex = cex_context_ylab)

  polygon(c(focal_date, focal_date + time_box, focal_date + time_box, focal_date), c(rep(yrange[1],2), rep(yrange[2],2)), col = 'lightyellow', border = 'lightyellow')
# DONE is grey
indat_done <- indat[indat$status == 'DONE',]
  points(indat_done$start_date, indat_done$loc2, pch = 16, cex = cex_context_points, col = 'grey')
  #text(indat_done$start_date, indat_done$loc2 - smidge_lab, labels = indat_done$task_id, pos = 4)
  js <- indat_done$loc2
  for(i in 1:nrow(indat_done)){
  # = 1
    segments(indat_done$start_date[i] , js[i] , indat_done$start_date[i] , max(indat_done$loc2) + 1 , lty = 3, col = 'grey')
    segments(indat_done$start_date[i] , js[i] , indat_done$end_date[i] , js[i], col = 'grey')
  }
# indat todo is black
indat_todo <- indat[indat$status == 'TODO',]
  points(indat_todo$start_date, indat_todo$loc2, pch = 16, cex = cex_context_points)
  #text(indat_todo$start_date, indat_todo$loc2 - smidge_lab, labels = indat_todo$task_id, pos = 4)
  js <- indat_todo$loc2
  for(i in 1:nrow(indat_todo)){
  # = 1
    segments(indat_todo$start_date[i] , js[i] , indat_todo$start_date[i] , max(indat_todo$loc2) + 1 , lty = 3)
    segments(indat_todo$start_date[i] , js[i] , indat_todo$end_date[i] , js[i] )
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
  if(show_today) segments(Sys.Date(), min(js), Sys.Date(), max(js), lty = 2, col = 'blue')
  
  #### detail ####
  js <- indat$loc2
  # todo
  plot(c(focal_date, focal_date + time_box), yrange, type = 'n', xlab = "", ylab = "", axes = F)
       
  mtext(c(indat_lab$container_task_title), 2, las =1, at = indat_lab$loc, cex = cex_detail_ylab)
  points(indat$start_date, indat$loc2, pch = 16, cex = cex_detail_points)
  text(indat$start_date, indat$loc2 - smidge_lab, labels = indat$task_id, pos = 4,
       cex = cex_detail_labels)
  for(i in 1:nrow(indat)){
  # = 1
    segments(indat$start_date[i] , js[i] , indat$start_date[i] , max(indat$loc2) + 1 , lty = 3,
      col = ifelse(indat$status[i] == "DONE", "grey","black"))
    segments(indat$start_date[i] , js[i] , indat$end_date[i] , js[i],
      col = ifelse(indat$status[i] == "DONE", "grey","black"))
  }
  # done
  indat_done  <- indat[indat$status == "DONE",]
  points(indat_done$start_date, indat_done$loc2, pch = 16, cex = cex_detail_points, col = "darkgrey")
  text(indat_done$start_date, indat_done$loc2 - smidge_lab, labels = indat_done$task_id, pos = 4,
       cex = cex_detail_labels, col = "darkgrey")  
  for(i in 1:nrow(indat_done)){
  # = 1
    segments(indat_done$start_date[i] , indat_done$loc2[i] , indat_done$start_date[i] , max(indat_done$loc2) + 1 , lty = 3, col = 'darkgrey')
    segments(indat_done$start_date[i] , indat_done$loc2[i] , indat_done$end_date[i] , indat_done$loc2[i], col = 'darkgrey' )
  }

  # continuing

  bumped_up <- indat[indat$start_date < focal_date & indat$status != 'DONE',]
  if(nrow(bumped_up) > 0){
  text(focal_date, bumped_up$loc2 - smidge_lab, labels = bumped_up$task_id, pos = 4,
       cex = cex_detail_labels, col = 'darkred')
  }

  bumped_up2 <- indat[indat$start_date < focal_date & indat$status == 'DONE' & indat$end_date >= focal_date,]
  if(nrow(bumped_up2) > 0){
  text(focal_date, bumped_up2$loc2 - smidge_lab, labels = bumped_up2$task_id, pos = 4,
       cex = cex_detail_labels, col = 'grey')
  }
  
  # overdue
  ## bumped_up <- indat[indat$end_date < focal_date & indat$status != 'DONE',]
  ## text(focal_date, bumped_up$loc2 - smidge_lab, labels = bumped_up$task_id, pos = 4,
  ##      cex = cex_detail_labels, col = 'darkorange')
  
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
  axis(1, at = at_dates2, labels = label_dates,  cex = cex_detail_xlab)
  #segments(min(xrange), min(yrange) - .09, max(xrange), min(yrange) - .09)
  axis(3, at = at_dates, labels = F)
  axis(3, at = at_dates2, labels = label_dates)
  #segments(min(xrange), max(yrange) + .09, max(xrange), max(yrange) + .09)  
  if(show_today) segments(Sys.Date(), min(js), Sys.Date(), max(js) + 1, lty = 2, col = 'blue')
  
}
#ls()
