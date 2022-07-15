#!/bin/bash

BASEDIR="/home/surendra/deepchem/GPCR_DATA"

TARGETDIR="${BASEDIR}/GPCR_DB_COMBINED"


for TARGET in ${TARGETDIR}/* ; do
    	TARGET=$(basename "$TARGET")
	/home/surendra/IChem/IChem IFP ${TARGETDIR}/${TARGET}/${TARGET}_protein.mol2 ${TARGETDIR}/${TARGET}/${TARGET}_ligand_AM1.mol2 > ${TARGETDIR}/${TARGET}/${TARGET}_ligand.ifp

done
