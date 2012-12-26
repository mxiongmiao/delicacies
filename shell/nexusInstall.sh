#!/bin/bash

installTo="/home/p"
softDir="/home/soft"
nexusFileName="nexus-2.2-01-bundle.tar.gz"
unzipedName="nexus-2.2-01"
lnName="nexus"
downURL="http://www.sonatype.org/downloads/$nexusFileName"

if [ ! -d $installTo ]; then
	mkdir $installTo	
fi
if [ ! -d softDir ]; then
	mkdir $softDir
fi

cd $softDir
wget -c $downURL
cp $nexusFileName $installTo
cd $installTo
tar xvzf $nexusFileName
ln -s $unzipedName $lnName


