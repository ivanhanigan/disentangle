
#### name:working-with-dates####
http://stackoverflow.com/questions/15686451/dates-from-excel-to-r-platform-dependency

  Quoting `?as.Date'

  ## date given as number of days since 1900-01-01 (a date in 1989)
  as.Date(32768, origin = "1900-01-01")
  ## Excel is said to use 1900-01-01 as day 1 (Windows default) or
  ## 1904-01-01 as day 0 (Mac default), but this is complicated by Excel
  ## treating 1900 as a leap year.
  ## So for dates (post-1901) from Windows Excel
  as.Date(35981, origin = "1899-12-30") # 1998-07-05
  ## and Mac Excel
  as.Date(34519, origin = "1904-01-01") # 1998-07-05
  ## (these values come from http://support.microsoft.com/kb/214330)
