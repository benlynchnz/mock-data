#!/bin/bash

function jsonval {
    temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop | cut -d":" -f2| sed -e 's/^ *//g' -e 's/ *$//g'`
    echo ${temp##*|}
}

json=$(cat package.json)
prop='dockerRepo'
repo=`jsonval`

ts=$(date +"%d-%m-%Y_%H-%M-%S")

## Write a new timestamp into the application folder
sed -e "s/<ts>/$ts/g" Dockerfile.tmpl > Dockerfile

## Stop and remove all containers
docker rm $(docker stop -t=1 $(docker ps -q))

# Build container
docker build -t $repo .

# Run docker image
docker run --name ${repo##*/} -d $repo

# Commit & push
docker commit ${repo##*/} $repo
docker push $repo







