#!/bin/bash

BASEDIR="/home/surendra/deepchem/GPCR_DATA"

TARGETDIR="${BASEDIR}/szybki_pocket_mol2"

for TARGET in ${TARGETDIR}/* ; do
    	TARGET=$(basename "$TARGET")
	echo ${TARGETDIR}/${TARGET}/${TARGET}_tagged.mol2 >> listtagged

done




