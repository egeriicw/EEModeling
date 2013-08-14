
#parse energy database from NREL

from xml.dom import minidom
xmldoc = minidom.parse('~/Data/Energy/NREL/measures.xml')
itemlist = xmldoc.getElementsByTagName('item') 
print len(itemlist)
print itemlist[0].attributes['name'].value
for s in itemlist :
    print s.attributes['name'].value
