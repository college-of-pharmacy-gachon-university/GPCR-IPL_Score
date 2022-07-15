# Revisiting the Interaction of GPCR based on a Machine Learning Classifier
## Description:

Here, the Machine Learning based Classifiers have been built to learn the interaction of GPCR protein-ligand complexes. The interactions are further learned using the SHAP analysis. 

## Requirement:
The following programs/packages should be installed.
1.	Maestro from Schrodinger Suite (any commercial version accepted) (https://schrodinger.com)
2.	KNIME Analytics Platform (KNIME Version 4.1.4)
3.	Python (Version 3.7)
4.	Keras (Version 2.8.0)
5.	Tensorflow (Version 1.14.0)
6.	SHAP (Version 0.39.0) (https://github.com/slundberg/shap)
7.	Biopandas
8.	FuzCav (http://bioinfo-pharma.u-strasbg.fr/labwebsite/download.html)
9.	ICHEM (http://bioinfo-pharma.u-strasbg.fr/labwebsite/download.html)
a.	License for ICHEM can be requested from Dr. Didier Rognan (rognan@unistra.fr)
10.	E3FP (https://github.com/keiserlab/e3fp)
a.	Follow the documentation for installation instructions.
11.	Sckit-learn (Version 0.23.2)
12.	Catboost (Version 1.0.5)
13.	LGBM (Version 3.3.2)
14.	mlxtend (Version 0.19.0)

## General Procedure:
1.	Collect the GPCR protein-ligand data from GPCRdb and GPCR-EXP.
        
       a)	GPCRdb: https://gpcrdb.org/structure
        
       b)	GPCR-EXP: https://zhanggroup.org/GPCR-EXP (From the download page; download the Superposed GPCRs: ``“pdb_overlays.tar.gz”``.)
2.	After collecting all PDBs for GPCR, check the common PDBs and remove the duplicates.
3.	Prepare all the proteins using ``“Protein-Preparation Wizard of Schrodinger Suite”`` for missing atoms, adding Hydrogen, assigning the correct protonation state of amino acid residues and minimization of heavy atoms.

4.	The following files must be collected on prepared protein before generating all features.
  
    a)	Save prepared protein into a PDB format file `{pdbid}_protein.pdb` to generate the GPCR generic residue numbering system file for each protein.
          
       i.	Using the following web link, the GPCR generic residue numbering file can be generated for each PDB file.
       https://gpcrdb.org/structure/generic_numbering_index
       
       ii.	This will assign the generic residue numbering system to the input `{pdbid}_protein.pdb file` and produces the output file in `{pdbid}_protein_GPCRDB.pdb`.
       
       iii.	Using the Jupyter Notebook (Convert_GPCRPDBs_to_PandasDataframe.ipynb), convert *.pdb into *.csv file.
       
    b)	Save prepared protein into a MOL2 format file `{pdbid}_ protein.mol2` to perform in-situ minimization using the Szybki (OpenEye Scientific Software).
    
    c)	Save the prepared protein into a MOL2 format file `{pdbid}_ pocket.mol2` after trimming the binding site residues within 7.0 Å from the bound ligand.

5. #### Workflow on Non-Optimized GPCR feature generation:
  
    a)	Generate the Interaction Feature (INT_Feat): Using the `{pdbid}_ pocket.mol2` and bound ligand in *.mol2 as input for ICHEM to generate the `*.ifp`.
    
       Use the following script under the Feature Generation Folder
       sh run-IChem.sh
       
    b)	Generate the Pocket Feature (POCK_Feat): Using the `{pdbid}_ pocket.mol2` as input for FuzCav to generate the pocket features in `*.txt`.
    
        Use the follwing script under the Feature Generation Folder step by step:
        sh step1.fuzcav_tagged.sh
        sh step2.listtagged.sh
        sh step3.fuzcav_fp.sh
        
    c)	Generate the Ligand Feature (LIG_Feat): Save all the Non-Optimized ligand from GPCR PDBs, into `*.sdf file` and using the `*.sdf file` as input to generate the E3FP fingerprint and save them into the `*.csv file`.
    
        Use the following script under the Feature Generation Folder 
        python E3FP_Gen.py
        
6. #### Workflow on Optimized GPCR feature generation:

     a)	Using the `{pdbid}_ protein.mol2` and bound ligand `*.mol2` perform the in-situ optimization of ligand and binding site residue using the Szybki (OpenEye Scientific Software).

        Use the script under the Preprocessing Folder
        sh run_szybki.sh
        
    b) After optimization, the output file `{pdbid}_ opt_complex.mol2` is produced, which must be split into protein and ligand.
    
    c) From the optimized complex trim the binding site residues within 7.0 Å from the bound ligand and save the trimmed protein file as mol2 file `{pdbid}_opt_pocket.mol2`.
    
    i) The user can use the maestro for the above task.
    
    d) The optimized files must be used as an input file to generate the various features like as above.
    
    e) Generate the Interaction Feature (INT_Feat): Using the `{pdbid}_opt_pocket.mol2` and bound ligand in `*.mol2` as input for ICHEM to generate the interaction features `*.ifp`.

        Use the following script under the Feature Generation Folder
        sh run-IChem.sh
     
    f) Generate the Pocket Feature (POCK_Feat): Using the `{pdbid}_opt_pocket.mol2` as input for FuzCav to generate the pocket features in `*.txt`.
        
        Use the follwing script under the Feature Generation Folder step by step:
        sh step1.fuzcav_tagged.sh
        sh step2.listtagged.sh
        sh step3.fuzcav_fp.sh
        
    g) Generate the Ligand Feature (LIG_Feat): Save all the Optimized ligand from GPCR PDBs, into `*.sdf file` and using the `*.sdf file` as input to generate the E3FP fingerprint and save them into the `*.csv file`.
    
        Use the script under the Feature Generation
        python E3FP_Gen.py

7. GPCR feature compilation using the KNIME workflow to make a feature matrix:
    a) To generate a feature matrix using the KNIME Workflow, the following four files are required.
    
    i. GPCR generic residue number file from `4(a(iii))`.
    
    ii.	Interaction feature file `*.ifp` from `5(a) or 6(f)`.
    
    iii. Pocket feature file `*.txt` from `5(b) or 6(g)`.
    
    iv.	Ligand feature file `*.csv` from `5(c) or 6(h)`.

    b) This KNIME workflow process the supplied file and tag each amino acid residue according to their `TMs` and finally save all the features into the `*.csv file`.

        Use the following KNIME workflow under Feature Embedding to process the all the above 4 input file.
        GPCR_PLIP_KNIME_WORKFLOW.knwf

8. After receiving the feature matrix from `step.7`, the various machine learning model can be built using the following Jupyter Notebook. However, this notebook shows the best-selected model from binary and multiclass.

        Use `train, validate and test` the binary and multiclass classification model, 
        the following Jupyter Notebook file under Model Building Folder can be used.

        BINARY_OPT_GPCR_PLIP_CLASSIFICATION_MODELS.ipynb
        MULTICLASS_OPT_GPCR_PLIP_CLASSIFICATION_MODELS.ipynb
        
   Here are the classification metrics best on 10-fold cross validation.
