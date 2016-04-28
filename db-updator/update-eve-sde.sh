#!/bin/sh

# EVE SDE Updater (SDE -> MongoDB)

OUTDATA_DIR="data"
OUTJSON_DIR="$OUTDATA_DIR/json"

rm -rf $OUTDATA_DIR

# Install yamljs
echo "Check js-yaml ..."
IS_INSTALLED_YAMLJS=`npm list -g | grep js-yaml | wc -l`
if [ "$IS_INSTALLED_YAMLJS" = "0" ]; then
	echo "js-yaml is NOT installed. Let me install js-yaml"
	npm install -g js-yaml
else
	echo "js-yaml is already installed."
fi

# Unzip EVE Online SDE
echo "Unzip EVE SDE zip file ..."
unzip $1 -d data

echo "Check if exist yaml files in data directory ..."
NUM_OF_YAMLS=`find data -name *.yaml | wc -l`
if [ "$NUM_OF_YAMLS" = "0" ]; then
	echo "There is no YAMLs. exit."
	exit 1
else
	mkdir -p $OUTJSON_DIR
	YAMLS=`find data -name *.yaml`
	for yaml in $YAMLS
	do
		echo "process $yaml"
		FILENAME=`basename $yaml | awk -F. '{print $1}'`
		OUTPUT_JSON="$OUTJSON_DIR/$FILENAME.json"
		js-yaml $yaml > $OUTPUT_JSON

		echo "convert json object to array"
		TO_CONVERT=`awk "/^{/" $OUTPUT_JSON | wc -l`
		if [ $TO_CONVERT != 0 ];then
			sed -i "s/^{/[/g" $OUTPUT_JSON
			sed -i 's/^  "\([0-9]*\)":/  { "id": \1, "data":/g' $OUTPUT_JSON
			sed -i "s/^  }/  }}/g" $OUTPUT_JSON
			sed -i "s/^}/]/g" $OUTPUT_JSON
		fi

		echo "import $FILENAME to eve-db database (collection : $FILENAME)"
		mongoimport --jsonArray --db eve-db --collection $FILENAME --drop --file $OUTPUT_JSON
	done

	echo "done."
fi
