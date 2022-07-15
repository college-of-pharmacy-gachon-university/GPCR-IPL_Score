#!/bin/bash

BASEDIR="/home/surendra/deepchem/GPCR_DATA"

TARGETDIR="${BASEDIR}/szybki_pocket_mol2"

FuzCav="/home/surendra/deepchem/PROG/FuzCav"

for TARGET in ${TARGETDIR}/* ; do
    	TARGET=$(basename "$TARGET")
	$FuzCav/utils/CaTagger.pl ${TARGETDIR}/${TARGET}/${TARGET}_pocket.mol2 > ${TARGETDIR}/${TARGET}/${TARGET}_tagged.mol2

done
