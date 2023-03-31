#!/bin/bash

#Modify the FuzCav PATH

FuzCav="/home/surendra/FuzCav"

java -jar $FuzCav/dist/3pointPharCav.jar -d $FuzCav/utils/resDef/tableDefCA.txt -t $FuzCav/utils/triplCav/interval.txt 
-l listtagged -o szybki_pocket_mol2_FP.txt

