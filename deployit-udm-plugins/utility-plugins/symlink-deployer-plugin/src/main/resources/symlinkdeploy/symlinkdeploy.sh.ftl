#!/bin/bash

if [ "$(ls ${deployed.nextContentLocation})" ]; then

echo "nextContentLocation contains content: let's continue symlinking this new content."
echo "Symlinking the new code into the webserver environment....."

echo "Symlink contentroot to nextcontent dir: ${deployed.symlinkedDocumentRoot} -> ${deployed.nextContentLocation}"
ln -sfn ${deployed.nextContentLocation} ${deployed.symlinkedDocumentRoot}

echo "Remove files in previouscontent dir: ${deployed.previousContentLocation}"
rm -rf ${deployed.previousContentLocation}/*

echo "Move all files in actualcontent to previouscontent dir: ${deployed.actualContentLocation} -> ${deployed.previousContentLocation}"
mv ${deployed.actualContentLocation}/* ${deployed.previousContentLocation}

echo "Copy nextcontent to actualcontent dir: ${deployed.nextContentLocation} -> ${deployed.actualContentLocation}"
cp -rp ${deployed.nextContentLocation}/* ${deployed.actualContentLocation} 

echo "Symlink contentroot to actualcontent dir: ${deployed.symlinkedDocumentRoot} -> ${deployed.actualContentLocation}"
ln -sfn ${deployed.actualContentLocation} ${deployed.symlinkedDocumentRoot}

echo "Remove files in nextcontent dir as they now have been deployed: ${deployed.nextContentLocation}"
rm -rf ${deployed.nextContentLocation}/* 

else
    echo "nextContentLocation is empty. Stop symlinking new content as there isn't any."
fi


 # Flush the varnish cache when indicated.
<#if (deployed.flushVarnish?? && deployed.flushVarnish)>
 echo "Flushing the Varnish server with url: http://${deployed.hostVarnish}"
 curl -X BAN http://${deployed.hostVarnish}
 </#if>


res=$?
if [ $res != 0 ] ; then
  exit $res
fi
