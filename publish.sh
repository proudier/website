#!/bin/bash

. ~/.ovh

lftp -u ${USER},${PASSWD} -e "mirror --verbose --parallel=4 --delete --reverse _site/ www; quit" ${URL}
if [ $? -eq 0 ]; then
	logger $0 - Push to OVH: success
else
	logger $O - Push to OVH: failure
	exit
fi

