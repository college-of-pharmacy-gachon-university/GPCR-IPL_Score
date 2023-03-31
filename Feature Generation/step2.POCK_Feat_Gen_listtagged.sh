#!/bin/bash

#Modify the BASEDIR, and TARGETDIR PATH

BASEDIR="/home/surendra/GPCR_DATA"

TARGETDIR="${BASEDIR}/szybki_pocket_mol2"

for TARGET in ${TARGETDIR}/* ; do
    	TARGET=$(basename "$TARGET")
	echo ${TARGETDIR}/${TARGET}/${TARGET}_tagged.mol2 >> listtagged

done




