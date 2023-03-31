#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import numpy as np
from rdkit import Chem
from e3fp.fingerprint.generate import fp, fprints_dict_from_mol, fprints_dict_from_sdf
from e3fp.conformer.generate import generate_conformers
from e3fp.pipeline import fprints_from_sdf, fprints_from_mol
from e3fp.fingerprint.fprint import save, savez
from rdkit.Chem.Draw import IPythonConsole
from rdkit.Chem import Draw
from rdkit.Chem import DataStructs
from rdkit.Chem import AllChem
from e3fp.fingerprint.metrics import fprint_metrics
IPythonConsole.ipython_useSVG=True


# # 3d Fingerprint Generation

mol2 = [ mol for mol in Chem.SDMolSupplier( "gpcd_db.sdf") ]
fpdicts2 = [ fprints_dict_from_mol( mol) for mol in mol2 ]

names2 = []
fp2 = []
binfp2 = []
RFP2 = []
fp_Keys2 = []
for i in range(0, len(fpdicts2)):
    names2.append(fpdicts2[i][5][0].name)
    fp_Keys2.append(list(fpdicts2[i][5][0].counts.keys()))
    fp2.append(fpdicts2[i][5])
    RFP2.append(fp2[i][0].fold().to_rdkit())
    binfp2.append(fp2[i][0].fold().to_rdkit().ToBitString())
result2 = pd.DataFrame([names2,fp_Keys2, binfp2]).T
result2.columns = ['Name', 'FP_Keys(3D)', 'FP_Rdkit BitVector(1024)']
result2.index = result2['Name']
result2.iloc[:, 1:].to_csv('gpcd.csv')