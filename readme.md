# Multi-Level Featurization of GPCR-Ligand Interaction Patterns and Prediction of Ligand Functions from Selectivity to Biased Activation

## Description:

Here, the Machine Learning based Classifiers have been built to learn the various interaction of GPCR protein-ligand complexes. These interactions are further learned using the SHAP plot. 

<p align="center">
  <img src="https://user-images.githubusercontent.com/51576785/229001792-230f8050-1bff-47c2-a69a-dde9e7b3928d.png"/>
</p>

#### Figure: The overall workflow for GPCR classification modeling.

## Requirements:
The following programs/packages must be installed.
1.	Maestro from Schrodinger Suite (any commercial version accepted) (https://schrodinger.com)
2.	KNIME Analytics Platform (KNIME Version 4.1.4) (https://www.knime.com/downloads)
3.	Python (Version 3.7)
4.	Keras (Version 2.8.0)
5.	Tensorflow (Version 1.14.0)
6.	SHAP (Version 0.39.0) (https://github.com/slundberg/shap)
7.	Biopandas (http://rasbt.github.io/biopandas)
8.	FuzCav (http://bioinfo-pharma.u-strasbg.fr/labwebsite/download.html)
9.	ICHEM (http://bioinfo-pharma.u-strasbg.fr/labwebsite/download.html)
      
      a. License for ICHEM can be requested from Dr. Didier Rognan (rognan@unistra.fr)
10.	E3FP (https://github.com/keiserlab/e3fp)
11.	Sckit-learn (Version 0.23.2)
12.	Catboost (Version 1.0.5) (https://catboost.ai)
13.	LGBM (Version 3.3.2) (https://lightgbm.readthedocs.io/en/v3.3.2/Installation-Guide.html)
14.	mlxtend (Version 0.19.0) (http://rasbt.github.io/mlxtend)

## Procedure:
## The following steps has been designed to calculate the Optimized GPCR features.

### Step 1: Collect the Data and Preprocess it:
1.	Collect the GPCR protein-ligand data from GPCRdb and GPCR-EXP.
       a)	GPCRdb: https://gpcrdb.org/structure
       b)	GPCR-EXP: https://zhanggroup.org/GPCR-EXP (From the download page; download the Superposed GPCRs: ``“pdb_overlays.tar.gz”``.)
2.	After collecting all PDBs for GPCR, check the common PDBs and remove the duplicates.

### Step 2: Prepare the GPCRs complexes.
1.	Prepare all the proteins using ``“Protein-Preparation Wizard of Schrodinger Suite”`` for missing atoms, add Hydrogens, assigning the correct protonation state of amino acid residues and minimization of heavy atoms.

### Step 3: Run the Geomtery Optimization Job.
1. After preparing the GPCRs complexes, split it into `{pdbid}_protein.mol2` and `{pdbid}_ligand.mol2`.
2. Create a maine folder and arrange all files like this, where {pdbid} is the actual PDB ID of respective protein.
   
         {pdbid}/{pdbid}_protein.mol2
       
         {pdbid}/{pdbid}_ligand.mol2
     
3. Use the script under the Processing Folder for batch optimization.
   
         sh run_szybki.sh
   
4. After the optimization, multiple files will be produced, however, we have to use the following two files for further processing.
   
         {pdbid}_opt_7.0_PB.mol2
         {pdbid}_opt_protein.pdb
   
5. Now extract the pocket from `{pdbid}_opt_protein.pdb` using `{pdbid}_opt_7.0_PB.mol2` as bound ligand (Keep the residues within 7.0 Å from the bound ligand) and save them as `{pdbid}_opt_pocket.mol2`.

   (The user can use the maestro or any other related program for this task)
   
6. Convert the `{pdbid}_opt_protein.pdb` into `{pdbid}_opt_protein.mol2`.
7. From Step 3, we will receive the following files.
    
        {pdbid}_opt_7.0_PB.mol2
        {pdbid}_opt_pocket.mol2
        {pdbid}_opt_protein.mol2
        
### Step 4: Obtained the GPCR generic numbering system protein file.
1. Use the `{pdbid}_opt_protein.pdb` in Step 3 (job # 4) to generate the `GPCR generic residue numbering system` file for each protein.
   
    a. Using the following web link, and upload your `{pdbid}_opt_protein.pdb` to the server, which will generate `{pdbid}_protein_GPCRDB.pdb` file.

       https://gpcrdb.org/structure/generic_numbering_index
    
    b. Use the following Jupyter notebook under Data Preparation Folder to convert `{pdbid}_protein_GPCRDB.pdb` into `{pdbid}_protein_GPCRDB.csv` file. `(Batch execution supported)`

          Convert_GPCRPDBs_to_PandasDataframe.ipynb

### Step 5: Calculate the INT_Feat, POCK_Feat, LIG_Feat.
1. Generate the Interaction Feature (INT_Feat): Use the `{pdbid}_opt_protein.mol2` and `{pdbid}_opt_7.0_PB.mol2` as input for Interaction Features generation `(*.ifp)`.
   
   Use the following script under the Feature Generation Folder for batch execution
   
        sh INT_Feat_Gen.sh
   
2. Generate the Pocket Feature (POCK_Feat): Using the `{pdbid}_opt_pocket.mol2` as input for pocket features generation to `*.txt` file.

   Use the follwing script under the Feature Generation Folder step by step for batch execution:

        sh step1.POCK_Feat_Gen_tagged.sh
        sh step2.POCK_Feat_Gen_listtagged.sh
        sh step3.POCK_Feat_Gen_fp.sh
   
3. Generate the Ligand Feature (LIG_Feat): Save all the Optimized ligand from GPCR PDBs, into `*.sdf file` and use the same `*.sdf file` as input to generate the E3FP fingerprint and save them into the `*.csv file`.

   Use the script under the Feature Generation for batch execution
   
        python LIG_Feat_Gen.py
   
### Step 6: GPCR feature compilation using the KNIME workflow to make a feature matrix:
1. To generate a feature matrix using the KNIME, the following four files are required.
   
   a. All `{pdbid}_protein_GPCRDB.csv`. (Step 4)
   b. All Interaction feature file `*.ifp`. (Step 5 (job # 1))
   c. Pocket feature file `*.txt`. (Step 5 (job # 2))
   d. Ligand feature file `*.csv`. (Step 5 (job # 3))
   
3. Use the following KNIME workflow under Feature Embedding to process all the above 4 input file.

        GPCR_KNIME_WORKFLOW.knwf
   
5. This KNIME Workflow will compile all the features and will produce a feature matrix file in `*.csv`, which can be used to build the various machine learning models.
6. To `train, validate and test` the binary and biased activation classification model, use the following Jupyter Notebook file under Model Building Folder.

         BINARY_OPT_GPCR_CLASSIFICATION_MODELS.ipynb
         BIASED_ACTIVATION_GPCR_CLASSIFICATION_MODELS.ipynb
   
8. The features can be further analyzed using the python library `SHAP`.

   Run the following Jupyter Notebook under the Model Analysis Folder to create the various plots.

        BINARY_OPT_GPCR_CLASSIFICATION_MODELS_SHAP_ANALYSIS.ipynb
        BIASED_ACTIVATION_GPCR_CLASSIFICATION_MODELS_SHAP_ANALYSIS.ipynb

#### For any queries regarding the above work, kindly contact Prof. Mi-hyun Kim (kmh0515@gachon.ac.kr) or Dr. Surendra Kumar (surendramph@gmail.com).
