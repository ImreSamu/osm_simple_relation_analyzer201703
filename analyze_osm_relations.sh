#!/bin/bash

# Analyze Relations With Outer role ..
# This code related with : https://github.com/osmlab/fixing-polygons-in-osm
#
# Requirements:
# - osmium-tool : https://github.com/osmcode/osmium-tool
# - bash;  ( tested with ubuntu linux ) 
#
# Inputs 
# -   ./*.osm.pbf  files in the directory
#
# Outputs 
# -   ./docs/*.md 
#
# Created:  Imre Samu  ( https://github.com/ImreSamu )
#           2017.03.12 
# ----------------------------------------------------------------
#
# OPL format    http://osmcode.org/opl-file-format/
#

_version="[Rv:0.1b]"

osmpbf=dummy.osm.pbf

# Primary osm keys 
osm_primary_keys1="aeroway|amenity|attraction|barrier|boundary|building|craft|emergency|emergency_service|highway|historic|indoor|landuse|leisure"
osm_primary_keys2="man_made|military|natural|network|office|place|power|railway|restriction|route|shop|sport|tourism|waterway|wetland"
osm_primary_keys3="addr:street|area:highway|building:part|building:wall|roof:edge|roof:ridge"


# Primary osm Key+values
osm_primary_keyvalue1="public_transport=platform|public_transport=stop_area"

# Osm keys start with ..   ( Primary Name Spaces )
osm_primary_namespaces1="abandoned:|proposed:|planned:|removed:|razed:|disused:|demolished:|seamark:|was:"








analyze_func_FREQ_RELATION_OUTER_YEAR_VERSION() {
echo " "
echo "### FREQ: Analyze OSM Relations with role=outer without primary OSM keys ( last_mod year + version + osm keys)"
echo "$osmpbf ( $osmtimestamp ) $osmreplication_base_url $_version"
echo " "
echo "|  count  |  last_mod_year, version osm tag combinations "
echo "|  -----: | :--------------------------------------"


osmium cat $osmpbf  --no-progress  -f opl  -t relation | \


  #================= We neeed only  relations with outer roles  =================
  egrep '@outer[, ]' | \
  #================= We need only the  version, year and the osm tags =================
  awk '{print substr($5,1,5), $2, $8 }'  | \
  #================= Filter out primary osm keys  =================
  egrep -v "(T|,)(${osm_primary_keys1})=" | \
  egrep -v "(T|,)(${osm_primary_keys2})=" | \
  egrep -v "(T|,)(${osm_primary_keys3})=" | \
  #================= Filter out primary osm keyvalues  =================
  egrep -v "(T|,)(${osm_primary_keyvalue1})" | \
  #================= Filter out Special  OSM Name spaces -   like:  abandoned:*   ;  osm keys start with ... =================
  egrep -v "(T|,)(${osm_primary_namespaces1})" | \


  #================= Add comma to end of the lines - for detecting osm values =================
  sed -e 's/$/,/' | \

  #================= Replace  type=  for preserving type values  =================
  sed -e 's/Ttype=/Ttype@/' | \
  sed -e 's/,type=/,type@/' | \

  # ================= Cut out osm values =================
  sed -e "s/=[^,]*,/=,/g"  | \

  # ================= Add space separator for readibility  =================
  sed -e "s/,/, /g" | \

  # ================= Replace first char  to  markdown separator  =================  
  sed -e "s/^./ |  y/g" | \

  #================= Sort and Count  uniq combinations =================
  sort     | \
  uniq -c  | \
  sort -nr | \

  #================= Replace back :  type@ to type=    =================  
  sed -e 's/type@/type=/' | \

  # ================= add special first char for markdown table  =================   
  sed 's/^/|/'

echo " "

}











analyze_func_FREQ_RELATION_OUTER() {
echo " "
echo "### FREQ: Analyze OSM Relations with role=outer without primary OSM keys "
echo "$osmpbf ( $osmtimestamp ) $osmreplication_base_url $_version"
echo " "
echo "|  count  |  osm tag combinations "
echo "|  -----: | :---------------------------"


osmium cat $osmpbf  --no-progress  -f opl,add_metadata=false -t relation | \


  #================= We neeed only  relations with outer roles  =================
  egrep '@outer[, ]' | \
  #================= We need only the osm tags =================
  cut -d' ' -f2 | \
  #================= Filter out primary osm keys  =================
  egrep -v "(T|,)(${osm_primary_keys1})=" | \
  egrep -v "(T|,)(${osm_primary_keys2})=" | \
  egrep -v "(T|,)(${osm_primary_keys3})=" | \
  #================= Filter out primary osm keyvalues  =================
  egrep -v "(T|,)(${osm_primary_keyvalue1})" | \
  #================= Filter out Special  OSM Name spaces -   like:  abandoned:*   ;  osm keys start with ... =================
  egrep -v "(T|,)(${osm_primary_namespaces1})" | \


  #================= Add comma to end of the lines - for detecting osm values =================
  sed -e 's/$/,/' | \

  #================= Replace  type=  for preserving type values  =================
  sed -e 's/Ttype=/Ttype@/' | \
  sed -e 's/,type=/,type@/' | \

  # ================= Cut out osm values =================
  sed -e "s/=[^,]*,/=,/g"  | \

  # ================= Add space separator for readibility  =================
  sed -e "s/,/, /g" | \

  # ================= Replace first char (T) to  markdown separator  =================  
  sed -e "s/^./ |  /g" | \

  #================= Sort and Count  uniq combinations =================
  sort     | \
  uniq -c  | \
  sort -nr | \

  #================= Replace back :  type@ to type=    =================  
  sed -e 's/type@/type=/' | \

  # ================= add special first char for markdown table  =================   
  sed 's/^/|/'

echo " "

}




analyze_func_LIST_RELATION_OUTER() {

echo " "
echo "### LIST of Problematic/OldStyle OSM Relations with role=outer "
echo "$osmpbf ( $osmtimestamp ) $osmreplication_base_url $_version"
echo "Not included: type=multipolygon "
echo " "
echo "|  url                                      |  osm tags  "
echo "| :---------------------------------------  | :---------------------------"
osmium cat $osmpbf  --no-progress  -f opl,add_metadata=false -t relation | \


  #================= We neeed only  relations with outer roles  =================
  egrep '@outer[, ]' | \
  #================= We need only the  osm_id + osm tags =================
  cut -d' ' -f1,2 | \
  #================= Filter exact osm key= =================
  egrep -v "(T|,)(${osm_primary_keys1})=" | \
  egrep -v "(T|,)(${osm_primary_keys2})=" | \
  egrep -v "(T|,)(${osm_primary_keys3})=" | \
  #================= Filter out primary osm keyvalues  =================
  egrep -v "(T|,)(${osm_primary_keyvalue1})" | \
  #================= Filter osm name spaces -   like:  abandoned:*   ;  osm keys start with ... =================
  egrep -v "(T|,)(${osm_primary_namespaces1})" | \

  #================= Add comma to end of the lines - for detecting osm values =================
  sed -e 's/$/,/' | \

   # ================= filter out simple type=multipolygon =================
  egrep -v 'Ttype=multipolygon,$' | \

  # ================= Replace first char to  osm link  =================  
  sed -e "s#^.#| http://www.openstreetmap.org/relation/#g" | \

  # ================= Replace "T"  =================  
  sed -e "s# T# | #g"   

echo " "
}












analyze_func_FREQ_RELATION_NO_TYPE() {
echo " "
echo "### FREQ_RELATION_NO_TYPE: Analyze OSM Relations without type= "
echo "$osmpbf ( $osmtimestamp ) $osmreplication_base_url $_version"
echo " "
echo "|  count  |  osm tag combinations "
echo "|  -----: | :---------------------------"


osmium cat $osmpbf  --no-progress  -f opl,add_metadata=false -t relation | \

  cut -d' ' -f2 | \
  #================= Filter out primary osm keys  =================
  egrep -v "(T|,)type=" | \
  
  #================= Add comma to end of the lines - for detecting osm values =================
  sed -e 's/$/,/' | \

  # ================= Cut out osm values =================
  sed -e "s/=[^,]*,/=,/g"  | \

  # ================= Add space separator for readibility  =================
  sed -e "s/,/, /g" | \

  # ================= Replace first char (T) to  markdown separator  =================  
  sed -e "s/^./ |  /g" | \

  #================= Sort and Count  uniq combinations =================
  sort     | \
  uniq -c  | \
  sort -nr | \

  # ================= add special first char for markdown table  =================   
  sed 's/^/|/'

echo " "

}





analyze_func_LIST_RELATION_NO_TYPE () {

echo " "
echo "### LIST_RELATION_NO_TYPE: List OSM Relations without type= "
echo "$osmpbf ( $osmtimestamp ) $osmreplication_base_url $_version"
echo " "
echo "|  url                                      |  osm tags  "
echo "| :---------------------------------------  | :---------------------------"
osmium cat $osmpbf  --no-progress  -f opl,add_metadata=false -t relation | \


  #================= We need only the  osm_id + osm tags =================
  cut -d' ' -f1,2 | \
  #================= Filter out primary osm keys  =================
  egrep -v "(T|,)type=" | \


  #================= Add comma to end of the lines - for detecting osm values =================
  sed -e 's/$/,/' | \

  # ================= Replace first char to  osm link  =================  
  sed -e "s#^.#| http://www.openstreetmap.org/relation/#g" | \

  # ================= Replace "T"  =================  
  sed -e "s# T# | #g"   

echo " "
}






outdirs=./docs
indexpage=${outdirs}/index.md
mkdir -p ${outdirs}
rm    -f ${outdirs}/*.md

echo "# OpenStreetMap simple relation statistics "  > $indexpage
echo " "  >> $indexpage
echo "## Reports: "  >> $indexpage
for osmpbf in *.osm.pbf; 
do 
 echo "==== Processing: $osmpbf  ======" 

 osmtimestamp=$(osmium fileinfo --get=header.option.osmosis_replication_timestamp $osmpbf)
 osmreplication_base_url=$(osmium fileinfo --get=header.option.osmosis_replication_base_url  $osmpbf)

 # Generate reports
 analyze_func_FREQ_RELATION_OUTER_YEAR_VERSION > ${outdirs}/${osmpbf}_FREQ_RELATION_OUTER_YEAR_VERSION.md
 analyze_func_FREQ_RELATION_OUTER    > ${outdirs}/${osmpbf}_FREQ_RELATION_OUTER.md
 analyze_func_LIST_RELATION_OUTER    > ${outdirs}/${osmpbf}_LIST_RELATION_OUTER.md
 analyze_func_FREQ_RELATION_NO_TYPE  > ${outdirs}/${osmpbf}_FREQ_RELATION_NO_TYPE.md
 analyze_func_LIST_RELATION_NO_TYPE  > ${outdirs}/${osmpbf}_LIST_RELATION_NO_TYPE.md

 # Generate indexpage
 echo "### ${osmpbf} ($osmtimestamp)  "  >> $indexpage

 echo " * [FREQ_RELATION_OUTER](${osmpbf}_FREQ_RELATION_OUTER.md) "  >> $indexpage
 echo " * [LIST_RELATION_OUTER](${osmpbf}_LIST_RELATION_OUTER.md) "  >> $indexpage
 echo " * [FREQ_RELATION_NO_TYPE](${osmpbf}_FREQ_RELATION_NO_TYPE.md) "  >> $indexpage
 echo " * [LIST_RELATION_NO_TYPE](${osmpbf}_LIST_RELATION_NO_TYPE.md) "  >> $indexpage
 echo " * [FREQ_RELATION_OUTER_YEAR_VERSION](${osmpbf}_FREQ_RELATION_OUTER_YEAR_VERSION.md) "  >> $indexpage

done

echo "## Footnote: "  >> $indexpage
echo "Powered by : [osmium-tool](http://osmcode.org/osmium-tool/) "  >> $indexpage
echo "Generated from [OpenStreetMap Open data (ODBL License)](http://www.openstreetmap.org/copyright) "  >> $indexpage

echo "----- Finished  -------" 

