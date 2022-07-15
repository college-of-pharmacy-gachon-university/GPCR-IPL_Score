#!/bin/bash

BASEDIR="/home/surendra/deepchem/GPCR_DATA"

TARGETDIR="${BASEDIR}/PL_Data"

for TARGET in ${TARGETDIR}/* ; do
    	TARGET=$(basename "$TARGET")
	szybki -in ${TARGETDIR}/${TARGET}/${TARGET}_ligand_AM1.mol2 -protein ${TARGETDIR}/${TARGET}/${TARGET}_protein.mol2 -out ${TARGETDIR}/${TARGET}/${TARGET}_opt_7.0_PB.mol2 -log ${TARGETDIR}/${TARGET}/${TARGET}_1 -out_protein ${TARGETDIR}/${TARGET}/${TARGET}_opt_protein.pdb -out_complex ${TARGETDIR}/${TARGET}/${TARGET}_opt_complex.pdb -flextype residue -optGeometry cart -flexdist 7.0 -protein_elec PB -sdtag all -mpi_np 20

done
