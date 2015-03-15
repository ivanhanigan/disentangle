
gantt_data_prep <- function(
  dat_in = datin
  ){
  dat_in <- timebox(dat_in)
  dat_in[1:5,c("task_id","start_date","end_date", "efforti")]
  str(dat_in)
  dat_in  <- dat_in[,c('container_task_title','task_id','allocated','fte','start_date','efforti','notes','status','blocker','end_date')]
  t(dat_in[1,])
  #dat_in
  # dbSendQuery(ch, "drop table indat")
  # dbWriteTable(ch, "indat", dat_in)
  
  indat <- dat_in
  dat_in_depends <- sqldf("
  select tab1.container_task_title, tab1.task_id, 
  'depends on ' || tab1.blocker || ' from Container ' || tab2.container_task_title as depends_on,
  tab2.end_date as start_date, 
  tab1.efforti, tab1.status
  from
  (
    select t1.container_task_title,
    t1.task_id, t1.blocker,
    t1.start_date,
    t1.end_date,
    t1.efforti, t1.status
    from indat t1
    where t1.blocker is not null
    ) tab1
  join
  indat tab2
  on tab1.blocker = tab2.task_id
  ", drv = "SQLite")
  # cast(tab2.end_date + (tab1.efforti || ' day')::INTERVAL as date) as
  # end_date
  dat_in_depends[1,]
  #dat_in_depends
  dat_in_depends$end_date  <- dat_in_depends$start_date + dat_in_depends$tab1.efforti
  names(dat_in_depends) <- gsub('tab1.', '', names(dat_in_depends))
  
  dat_in <- sqldf("
    select t1.container_task_title,
    t1.task_id, 
    t1.task_id as depends_on,  
    t1.start_date,
    t1.efforti,
    t1.status,
    t1.end_date
    from indat t1
    where t1.blocker is null or t1.blocker = ''
    order by container_task_title
  ", drv = 'SQLite')
  dat_in[,1]
  dat_in <- rbind(dat_in, dat_in_depends)
  dat_in[1,]
  #dat_in
  loc  <- sqldf("select container_task_title from dat_in group by container_task_title", drv = "SQLite")
  loc$loc  <- nrow(loc):1
  loc
  dat_in <- merge(loc, dat_in)
  str(dat_in)
  loc
  dat_out <- as.data.frame(matrix(NA, nrow = 0, ncol = ncol(dat_in) + 1))
  #names(qc) <- c(names(dat_in),"loc2")
  for(loci in loc$loc){
  # loci = loc$loc[1]
  qc <- dat_in[dat_in$loc == loci,]
  qc <- qc[order(qc$start_date),]
  loc2 <- seq(qc$loc[1]-1, qc$loc[1],  1/(length(qc$loc)))
  qc$loc2  <- loc2[(length(loc2)):2] 
  
  dat_out  <- rbind(dat_out, qc)
  
  }
  str(dat_out)
  return(dat_out)
  }
