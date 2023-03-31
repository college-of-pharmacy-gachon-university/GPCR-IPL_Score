#!/bin/bash

#Modify the BASEDIR, TARGETDIR, FuzCav PATH

BASEDIR="/home/surendra/GPCR_DATA"

TARGETDIR="${BASEDIR}/szybki_pocket_mol2"

FuzCav="/home/surendra/FuzCav"

for TARGET in ${TARGETDIR}/* ; do
    	TARGET=$(basename "$TARGET")
	$FuzCav/utils/CaTagger.pl ${TARGETDIR}/${TARGET}/${TARGET}_pocket.mol2 > ${TARGETDIR}/${TARGET}/${TARGET}_tagged.mol2

done
