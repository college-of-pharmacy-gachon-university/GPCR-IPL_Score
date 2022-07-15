#!/bin/bash

FuzCav="/home/surendra/deepchem/PROG/FuzCav"

java -jar $FuzCav/dist/3pointPharCav.jar -d $FuzCav/utils/resDef/tableDefCA.txt -t $FuzCav/utils/triplCav/interval.txt 
-l listtagged -o szybki_pocket_mol2_FP.txt

