
library(sqldf)
library(lubridate)
library(swishdbtools)


get_gantt_data <- function(
  dbname = 'gantt_todo'
  ,
  test_data = T
  ){
if(test_data != TRUE){
#### name:get_test_data####
if(exists("ch"))  dbDisconnect(ch)
ch <- connect2postgres2(dbname)

datin  <- dbGetQuery(ch,
"
select t1.container_task_title, 
t2.*
from container_task t1
join work_package t2
on t1.id = t2.container_id
where t2.status != 'DONTSHOW'
order by container_task_title"
)
str(datin)
datin_done  <- dbGetQuery(ch,
"
select t1.container_task_title, 
t2.*
from container_task_done t1
join work_package_done t2
on t1.id = t2.container_id
where t2.status != 'DONTSHOW'
"
)
str(datin_done)
datin  <- rbind(datin, datin_done)
} else {
# or simpler
datin  <- read.csv(textConnection("container_task_title, task_id, allocated, fte, blocker, start_date, effort, status, notes
  Container 1, task 0, jim,   1,   ,     2015-01-01, 1m  , DONE,  
  Container 1, task 1, jim,   1,   ,     2015-01-20, 1m  , DONE,  
  Container 1, task 2, bob,   1, task 1,           , 10d , TODO, This is a note 
  Container 2, task 3, sue,   1,   ,     2015-01-01, 2w  , TODO,  
  Container 2, task 4, jim,   1, task 3,           , 2d  , TODO,  
  Container 3, task 5, jimmy, 1, task 3,           , 10d , TODO,  
  Container 3, task 6, jimmy, 1,       , 2015-02-01, 10d , TODO,  
  Container 4, task 7, jimmy, 1, task 0,           , 10d , TODO,  
  Container 5, task 8, sue,   1,       , 2015-01-14, 5d  , TODO,  
  Container 5, task 9, sue,   1, task 8, , 2d            , TODO,  
  Container 5, task 10, sue,   1, task 9, , 2d           , TODO,  
  Container 5, task 11, sue,   1, task 10, , 2d          , TODO,  
  Container 5, task 12, sue,   1, task 11, , 2d          , TODO,  
  Container 5, task 13, sue,   1, task 12, , 2d          , TODO,  
  Container 5, task 14, sue,   1, task 13, , 2d          , TODO,  
  "),
  stringsAsFactor = F, strip.white = T)
  datin$start_date  <- as.Date(datin$start_date)
  str(datin)
  datin[datin$blocker == "","blocker"] <- NA
# datin
}

return(datin)
}
