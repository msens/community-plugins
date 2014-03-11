#!/bin/bash

if [ "$(ls ${deployed.previousContentLocation})" ]; then

echo "There is still content in previousContentLocation to which we can quickly rollback: let's continue symlinking to this previous content."

echo "Rollback: symlinking the previous content back into the web server environment."
echo "Symlink contentroot to previouscontent dir: ${deployed.symlinkedDocumentRoot} -> ${deployed.previousContentLocation}"
ln -sfn ${deployed.previousContentLocation} ${deployed.symlinkedDocumentRoot}

echo "Remove files in nextcontent dir: ${deployed.nextContentLocation}"
rm -rf ${deployed.nextContentLocation}/*

echo "Move all files in actualcontent back to nextcontent dir: ${deployed.actualContentLocation} -> ${deployed.nextContentLocation}"
mv ${deployed.actualContentLocation}/* ${deployed.nextContentLocation}

echo "Copy previouscontent to actualcontent dir: ${deployed.previousContentLocation} -> ${deployed.actualContentLocation} "
cp -rp ${deployed.previousContentLocation}/* ${deployed.actualContentLocation} 

echo "Symlink contentroot to actualcontent dir: ${deployed.symlinkedDocumentRoot} -> ${deployed.actualContentLocation}"
ln -sfn ${deployed.actualContentLocation} ${deployed.symlinkedDocumentRoot}

echo "Remove files in previouscontent dir: ${deployed.previousContentLocation}"
rm -rf ${deployed.previousContentLocation}/* 

else
    echo "WARNING: the previousContentLocation is empty. To be sure that we do not rollback to non-exisiting content, no rollback of content is performed." 
    echo "The previous content will become available in the webserver as soon as the -regular- rollback is complete. Though this will be a bit slower to complete."
    echo "Please redeploy a previous version of the content through deployit."
    echo "It is only possible to -quickly- rollback 1 version of the content."
    echo "As soon as two subsequent succesfull deployments have occured, rollback functionality will become available again."
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