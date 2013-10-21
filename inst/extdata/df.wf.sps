DATA LIST FILE= "df.wf.txt"  free (",")
/ id p.code p.label Nwcnf.f.  .

VARIABLE LABELS
id "id" 
 p.code "p.code" 
 p.label "p.label" 
 Nwcnf.f. "New crazy name for 'foo'" 
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
Nwcnf.f.  
1 "A" 
 2 "B" 
 3 "C" 
 4 "D" 
 5 "E" 
 6 "F" 
.

EXECUTE.
