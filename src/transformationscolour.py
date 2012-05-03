# I:/My Dropbox/tools/transformationscolour.py
#Writes a Graphviz graph of transformations from a transformations text file
# If pydot and Graphviz are available, a png image of the graph and html version are also created
#
# Joseph Guillaume 20090130
import sys
###############################
#Parameters
default_transformation_file=sys.argv[1]
#"all_transformations.txt" #Only used if there the script was run without argument
output_dot_file=sys.argv[2]
#"transformations.graph"

max_num_chars_in_description=70 #only fields of length < max(description_length,max_num_chars_in_description) will be shown in full on the graph
do_html=True #Whether html output should be made. Requires availability of pydot

# graphviz_location={'dot':'C:\\Program Files\\Graphviz2.26.3\\bin\\dot.exe'} 
graphviz_location={'dot':'C:\\Program Files\\Graphviz 2.21\\bin\\dot.exe'}
#Only necessary if pydot can't find graphviz by itself. Set to None otherwise
###############################

#Check if pydot is available
try:
	import pydot
	use_pydot=True
	#If pydot can't find the Graphviz executables, explicitly give the location below
	if not pydot.find_graphviz() and not graphviz_location:
		print "Graphviz not found, only outputting .graph file"
		use_pydot=False
except:
	print "pydot not available, use graphviz directly to convert the graph to an image"
	use_pydot=False
if not use_pydot: do_html=False

import sys,os

#Set input transformation file
if len(sys.argv)>1: transformation_file=sys.argv[1]
else: transformation_file=default_transformation_file

#Read transformation file into list of dicts 'transformations'
transformations=[]
key=None
for l in file(transformation_file):
	if l.startswith("Transformation"):
		#print newt
		if key: transformations+=[newt]
		else: transformations=[]
		newt=dict()
	elif l.startswith("\t\t"):
		#print "Value",l.strip()
		if not key: raise Error
		if newt.has_key(key): newt[key]+=[l.strip()]
		else: newt[key]=[l.strip()]
	elif l.startswith("\t"):
		#print "Key",l.strip()
		key=l.strip()

transformations+=[newt]


#Write Graphviz file in '.dot' format
#For output to the command line, use:
#       import sys
#       outf=sys.stdout

outf=file(output_dot_file,"w")
outf.write("digraph transformations {\n")

#Represent data sources with dummy names and labels instead of directly with names
#For pydot's benefit
use_dummy_ds=True
data_sources=dict()
def get_dsid(dsname):
	if not data_sources.has_key(dsname):
		data_sources[dsname]="ds"+str(len(data_sources.keys())+1)
		outf.write("%s [ label=\"%s\" ]\n" % (data_sources[dsname],dsname.replace("\"","'").replace("\\","/")))
	return(data_sources[dsname])

#Output for each transformation
#tid CANNOT be relied upon between runs as a unique identifier for transformations
tid=1
for t in transformations:
        #Inputs, output and description are the only required fields, but we allow them to be missing here
	if not t.has_key("inputs"): t["inputs"]=[]
	if not t.has_key("output"): t["output"]=[]
	if not t.has_key("description"): t["description"]=[]

	#Special field dontshow prevents the transformation from appearing in the graph
	if not t.has_key("dontshow"):
		#print len(t["description"][0]) #how long are the fields to be displayed
		
		wanted_keys=list(t.keys())
		for k in ["inputs","output","description"]: wanted_keys.remove(k)
		wanted_keys=["description"]+wanted_keys

                #Calculate the length of fields to display in the graph, otherwise display "..."
		try:
			description_length=len(", ".join(t["description"]))
			numchars=max(description_length,max_num_chars_in_description)
		except: numchars=max_num_chars_in_description

		def join_trunc(k,numchars=numchars):
			text=", ".join(t[k])
			if len(text)>numchars: return("...")
			else: return(text)
		
		wanted_text=[ join_trunc(k) for k in wanted_keys]

		text_keys="|".join(wanted_keys).replace("\"","!").replace("}","!").replace("{","!")
		text_values="|".join(wanted_text).replace("\"","''").replace("}","!").replace("{","!")

                #HTML output
		extra=""
		if do_html:
			extra=', URL="START\NEND"'
			try: os.mkdir(output_dot_file+"_files")
			except: pass
			outt=file("%s_files/t%s.txt" % (output_dot_file,str(tid)),"w")
			outt.write("Transformation\n")

			temp_keys=list(t.keys())
			for k in ["inputs","output","description"]: temp_keys.remove(k)
			for k in ["description","inputs","output"]+temp_keys:
				outt.write("\t%s\n" % k)
				for l in t[k]:
					outt.write("\t\t%s\n" % l)
			outt.close()

        #Actually write the node and edges to file
		if t.has_key("TASK"): 
			outf.write("t%s [ shape=record, style=filled, color=\"indianred\", label=\"{{ {%s} | {%s} }}\" %s ]\n" % (tid,text_keys,text_values,extra))
		else: 
			outf.write("t%s [ shape=record, label=\"{{ {%s} | {%s} }}\" %s ]\n" % (tid,text_keys,text_values,extra))

		if t.has_key("KEYNODE"): 
			outf.write("t%s [ shape=record, style=filled, color=\"palegreen\", label=\"{{ {%s} | {%s} }}\" %s ]\n" % (tid,text_keys,text_values,extra))
		else: 
			outf.write("t%s [ shape=record, label=\"{{ {%s} | {%s} }}\" %s ]\n" % (tid,text_keys,text_values,extra))
		
		for i in t["inputs"]:
			if use_dummy_ds:
				iname=i.strip().split("\t")[0]
				outf.write("%s -> t%s\n" % (get_dsid(iname), tid))
			else: outf.write("\"%s\" -> t%s\n" % (iname, tid))
		for o in t["output"]:
			if use_dummy_ds:
				oname=o.strip().split("\t")[0]
				outf.write("t%s -> %s\n" % (tid,get_dsid(oname)))
			else: outf.write("t%s -> \"%s\"\n" % (tid,oname))
		
		tid+=1

outf.write("}")
outf.close()



#If pydot is available, draw the graph and if wanted, the html output
if use_pydot:
	dot=pydot.graph_from_dot_file(output_dot_file)
	dot.set_graphviz_executables(graphviz_location)
	dot.write_png(output_dot_file+".png")
	if do_html:
		dot.write_jpg(output_dot_file+"_files/"+output_dot_file+".jpg")
		dot.write_cmapx(output_dot_file+"_files/"+output_dot_file+"_temp.html")
		import re
		
		htmlf=file(output_dot_file+".html","w")
		htmlf.write("""
<SCRIPT TYPE="text/javascript">
<!--
function popup(mylink)
{
if (! window.focus)return true;
var href;
if (typeof(mylink) == 'string')
   href=mylink;
else
   href=mylink.href;
window.open(href, "transformation", 'width=800,height=480,scrollbars=yes');
return false;
}
//-->
</SCRIPT>
""")
		for l in file(output_dot_file+"_files/"+output_dot_file+"_temp.html"):
			m=re.search('href="START(.*)END"',l)
			if m: htmlf.write(l.strip().replace('href="START%sEND"' % m.groups()[0],
							    'onClick=popup("%s_files/%s.txt")' % (output_dot_file,m.groups()[0]))+"\n")
			else: htmlf.write(l.strip()+"\n")
		htmlf.write('<IMG SRC="%s_files/%s.jpg" USEMAP="#transformations" />' % (output_dot_file,output_dot_file))
		htmlf.close()
			

