
################################################################
# name:names_lcu
require(devtools)
load_all()
# kudos
# http://blog.i2pi.com/post/52812976752/joshs-postgresql-database-conventions

dat  <- read.csv(textConnection(
"All names,should be lowercase with underscores,.,R does support ,AnYSortOF casing that you’d like, but it makes some programming painful,2/1 avoid number at start also avoid symbols (eg. % & !)
table,,,,,
column,,,,,
sequence,,,,,
index,,,,,
constraint,,,,,
role,,,,,
etc,,,,,,
"), header = F, stringsAsFactor=F)
strng <- dat[1,]
strng
lcu(strng)

dat  <- read.csv(textConnection(
"All names,  should be lowercase with underscores, ., R does support , AnYSortOF casing that you’d like, but it makes some programming painful,2/1 avoid number at start also avoid symbols (eg. % & !)
table,,,,,
column,,,,,
sequence,,,,,
index,,,,,
constraint,,,,,
role,,,,,
etc,,,,,,
"), header = T, stringsAsFactor=F)
names(dat)
gsub("\\.", "_", tolower(names(dat)))
names(dat) <- names_lcu(dat)
names(dat)
