#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]]; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA to install."
	exit 99
fi

if ! [[ -f ${SERVER_FILES}.zip ]]; then
	rm -fr defaultconfigs config kubejs libraries mods Simple.zip forge*
	curl -Lo ${SERVER_FILES}.zip ${SERVER_FILES_URL} || exit 9
	unzip -u -o ${SERVER_FILES}.zip -d /data
	DIR_TEST=$(find . -type d -maxdepth 1 | tail -1 | sed 's/^.\{2\}//g')
	if [[ $(find . -type d -maxdepth 1 | wc -l) -gt 1 ]]; then
		cd "${DIR_TEST}"
		mv -f * /data
		cd /data
		rm -fr "$DIR_TEST"
	fi
	curl -Lo forge-${FORGE_VERSION}-installer.jar http://files.minecraftforge.net/maven/net/minecraftforge/forge/$FORGE_VERSION/forge-$FORGE_VERSION-installer.jar
	java -jar forge-${FORGE_VERSION}-installer.jar --installServer
fi

if [[ -n "$JVM_OPTS" ]]; then
	sed -i '/-Xm[s,x]/d' user_jvm_args.txt
	for j in ${JVM_OPTS}; do sed -i '$a\'$j'' user_jvm_args.txt; done
fi
if [[ -n "$MOTD" ]]; then
    sed -i "s/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi
if [[ -n "$ALLOWLIST" ]]; then
    echo $ALLOWLIST | awk -v RS=, '{print}' > white-list.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties
chmod 755 run.sh

./run.sh