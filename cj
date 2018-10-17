#!/bin/bash

resource=""
data=""
protocol='get'

while getopts "pr:d:" OPT;
do
	case $OPT in
		p)
            protocol='post'
            ;;
        r)
            resource=$OPTARG
            ;;
        d)
            data=$OPTARG
            ;;
    esac
done

if [ "$protocol" == "post" ];
then
    curl -X POST -H 'Content-Type: application/json' \
        -d ${data} \
        ${resource}
elif [ "$protocol" == "get" ];
then
    echo "get"
    curl -i --header "Accept: application/json" "${resource}${payload}"
fi

