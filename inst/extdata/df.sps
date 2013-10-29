DATA LIST FILE= “df.sav”  free
/ id p.code p.label Nwcnf'f'  .

VARIABLE LABELS
id "id !@#$%^" 
 p.code "Profession code" 
 p.label "Profession with human readable information" 
 Nwcnf'f' "Variable label for variable x.var" 
 .

VALUE LABELS
/
p.label  
1 "0" 
 2 "Financial analysts" 
 3 "<NA>" 
 4 "Nurses" 
 5 "Optometrists" 
/
Nwcnf'f'  
1 "A" 
 2 "B" 
 3 "C" 
 4 "D" 
 5 "E" 
 6 "F" 
.

EXECUTE.
