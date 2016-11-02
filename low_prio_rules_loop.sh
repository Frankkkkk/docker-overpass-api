#!/bin/bash

#NOTUSED. XXX TODO ? incremental loops ?

source conf.sh

#Do the areas at full once, and then 240 times (~10 days) using delta approach

function apply_rule {
	rule=$1
	echo "Rule $rule start @ $(date)" >> $RULES_LOGFILE

	#Launch the rules query in backgroud
	$BINDIR/osm3s_query --progress --rules < $rule &
	#so we can get its pid
	pid=$!
	#and set it in low priority
	renice -n 19 -p $pid
	ionice -c 2 -n 7 -p $pid
	wait #for it to finish
	echo "Rule $rule end @ $(date)" >> $RULES_LOGFILE
}

while true; do
	#Generate all the areas
	apply_rule $DBDIR/rules/areas.osm3s

	#And generate by diff for >~ 10 days
	for i in `seq 240`; do
		tmp_area_name=$DBDIR/rules/TMP_area_delta
		sed "s/{{area_version}}/$(cat $DB_DIR/area_version)/g" $DB_DIR/rules/areas_delta.osm3s > $tmp_area_name
		apply_rule $tmp_area_name
		sleep 3600 #Wait at least a big hour
	done
done


