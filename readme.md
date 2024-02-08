# Multi-Level Featurization of GPCR-Ligand Interaction Patterns and Prediction of Ligand Functions from Selectivity to Biased Activation

## Description:

In this work, machine learning-based classifiers have been developed to elucidate the diverse interactions inherent in GPCR protein-ligand complexes. To gain deeper insights into the factors influencing these interactions, SHAP (SHapley Additive exPlanations) plots are employed, providing an interpretative framework to understand the contribution of each feature in the machine learning model.

<p align="center">
  <img src="https://user-images.githubusercontent.com/51576785/229001792-230f8050-1bff-47c2-a69a-dde9e7b3928d.png"/>
</p>

#### Figure: The overall workflow for GPCR classification modeling.

## Installation and Usage
### Step 1: Install Anaconda or Miniconda
First, download and install [Anaconda](https://www.anaconda.com/download) or [Miniconda](https://docs.conda.io/en/latest/miniconda.html) based on your preference.

### Step 2: Download the Repository
Clone or download this GitHub repository to your local machine. If you're familiar with Git, you can clone the repository using the following command:
```bash
git clone https://github.com/college-of-pharmacy-gachon-university/GPCR-IPL_Score.git
```
If you're downloading the ZIP file, ensure to unzip it in your desired directory.

### Step 3: Create the Conda Environment
Navigate to the directory containing the `environment.yml` file within the terminal (Linux, macOS) or Anaconda Prompt (Windows). Then, create the `gpcr-ipl` conda environment by executing:
```bash
conda env create -f environment.yml
```
This command reads the `environment.yml` file and installs all specified packages in a new conda environment named `gpcr-ipl`. Wait for the process to complete as it may take some time depending on your internet speed and system performance.

### Step 4: Activate the Environment
Once the environment installation is complete, you can activate the `gpcr-ipl` environment using:
```bash
conda activate gpcr-ipl
```
### Step 5: Using GPCR-IPL Score
With the `gpcr-ipl` environment activated, you're now ready to use the Environment. Follow the specific instructions provided for running scripts or analyzing your data within this environment.

## Additional Standalone Packages Required:

1. **Maestro from Schrodinger Suite** - Any version (either commercial or free) is accepted. For more information and to obtain Maestro, visit [Schrodinger's website](https://schrodinger.com).
      
2. **KNIME Analytics Platform** - Version 4.1.4 recommended. Download KNIME from [here](https://www.knime.com/downloads).

3. **FuzCav** - Available for download at [this link](http://bioinfo-pharma.u-strasbg.fr/labwebsite/download.html). After downloading, unpack the `FuzCav` package on your local machine.

4. **ICHEM** - Obtainable from [here](http://bioinfo-pharma.u-strasbg.fr/labwebsite/download.html). A license for ICHEM can be requested by contacting Dr. Didier Rognan at rognan@unistra.fr. After downloading the `ICHEM` package, please follow the provided instructions to install and configure it properly.

   Set the environment variables for ICHEM using the commands below in your terminal. Replace the paths with the actual locations where you have stored the ICHEM license file and library on your machine:

   ```bash
   export ICHEM_LIC=~/IChem/IChem_gachon.lic
   export ICHEM_LIB=~/IChem/lib
   ```
5. **OpenEye Software** - To download, please visit [OpenEye Software Download Page](https://www.eyesopen.com/customer-software-download). Note that an OpenEye license is required to execute Szybki tasks.
   
## Procedure for Calculating Optimized GPCR Features:

## This procedure outlines the steps necessary to compute optimized features for G-protein-coupled receptors (GPCRs). It involves data collection, preprocessing, and preparation of GPCR complexes.

### Step 1: Data Collection and Preprocessing:
1.	Data Acquisition: Retrieve GPCR protein-ligand data from the following sources:
       a)	GPCRdb: https://gpcrdb.org/structure
       b)	GPCR-EXP: Access GPCR-EXP, and from the download section, procure the Superposed GPCRs file named pdb_overlays.tar.gz. (https://zhanggroup.org/GPCR-EXP)
2.	Data Curation: Post-acquisition, perform a comparative analysis of the collected Protein Data Bank (PDB) files for GPCRs to identify and eliminate any redundant entries, ensuring a unique dataset.

### Step 2: Preparation of GPCR Complexes:
1.	Utilize the "Protein Preparation Wizard" feature within the Schrödinger Suite for the systematic preparation of the GPCR complexes. This preparation includes the following critical steps:
   
      -> Repairing any missing atoms in protein structures.
  	
      -> Adding hydrogen atoms to the structures.

  	  -> Assigning appropriate protonation states to amino acid residues.

  	  -> Executing a minimization process for the heavy atoms to stabilize the structures.

## Procedure for Calculating Optimized GPCR Features:

### Step 3: Run the Geomtery Optimization Job.
1. Splitting GPCR Complexes: Post-preparation, divide the GPCR complexes into two files per complex: {pdbid}_protein.mol2 and {pdbid}_ligand.mol2. ({pdbid} represents the actual PDB ID of the respective protein).
2. File Organization: Create a main folder and organize the files as follows:
   
         {pdbid}/{pdbid}_protein.mol2
       
         {pdbid}/{pdbid}_ligand.mol2
     
3. Batch Optimization: Execute the optimization process using the script located in the Processing Folder:
   
         sh run_szybki.sh
   
4. Post-optimization, focus on the following two files for further processing:
   
         {pdbid}_opt_7.0_PB.mol2
         {pdbid}_opt_protein.pdb
   
5. Pocket Extraction: From {pdbid}_opt_protein.pdb, extract the pocket using {pdbid}_opt_7.0_PB.mol2 as the bound ligand (including residues within 7.0 Å from the ligand). Save this as {pdbid}_opt_pocket.mol2. This can be done using Maestro or other relevant software.
6. File Conversion: Convert {pdbid}_opt_protein.pdb into {pdbid}_opt_protein.mol2.
7. Upon completion of Step 3, you should have the following files:
    
        {pdbid}_opt_7.0_PB.mol2
        {pdbid}_opt_pocket.mol2
        {pdbid}_opt_protein.mol2
        
### Step 4: Obtain the GPCR Generic Numbering System Protein File.
1. GPCRdb Processing: Use the {pdbid}_opt_protein.pdb file from Step 3 (Job #4), to generate a GPCR generic residue numbering system file for each protein at GPCRdb Generic Numbering Index (https://gpcrdb.org/structure/generic_numbering_index). This will produce a {pdbid}_protein_GPCRDB.pdb file.
2. Conversion to CSV: Utilize the Jupyter notebook in the `Data Preparation Folder`, `Convert_GPCRPDBs_to_PandasDataframe.ipynb`, for batch conversion of {pdbid}_protein_GPCRDB.pdb into {pdbid}_protein_GPCRDB.csv.

### Step 5: Calculate the INT_Feat, POCK_Feat, LIG_Feat features.
1. Interaction Feature (INT_Feat): Generate using {pdbid}_opt_protein.mol2 and {pdbid}_opt_7.0_PB.mol2 as inputs. The script for batch execution is in the `Feature Generation` Folder:
   
        sh INT_Feat_Gen.sh
   
2. Pocket Feature (POCK_Feat): Generate using {pdbid}_opt_pocket.mol2 as input. Execute the following scripts in sequence for batch processing in the `Feature Generation` Folder:
   
        sh step1.POCK_Feat_Gen_tagged.sh
        sh step2.POCK_Feat_Gen_listtagged.sh
        sh step3.POCK_Feat_Gen_fp.sh
   
3. Ligand Feature (LIG_Feat): Save all the Optimized ligand from GPCR PDBs, into `*.sdf file`, process into an E3FP fingerprint and save as a CSV file. Use the following script in the `Feature Generation` Folder for batch execution:
   
        python LIG_Feat_Gen.py
   
### Step 6: Compile GPCR Features Using KNIME Workflow and Build the Classification Model:
1. Feature Matrix Creation: Use KNIME to create a feature matrix. Required input files:
   
   a. All `{pdbid}_protein_GPCRDB.csv`. (from Step 4)
   b. All Interaction feature file `*.ifp` (from Step 5 (job # 1))
   c. Pocket feature file `*.txt` (from Step 5 (job # 2))
   d. Ligand feature file `*.csv` (from Step 5 (job # 3))
   
2. Process these inputs using the KNIME workflow located in the `Feature Embedding` Folder:

        GPCR_KNIME_WORKFLOW.knwf
   
3. This workflow compiles all features into a CSV file suitable for machine learning model development.
4. Model Building and Analysis: Train, validate, and test binary and biased activation classification models using Jupyter Notebook files in the `Model Building` Folder:

         BINARY_OPT_GPCR_CLASSIFICATION_MODELS.ipynb
         BIASED_ACTIVATION_GPCR_CLASSIFICATION_MODELS.ipynb
   
5. Further analyze features using the SHAP Python library by running Jupyter Notebooks in the `Model Analysis` Folder:

        BINARY_OPT_GPCR_CLASSIFICATION_MODELS_SHAP_ANALYSIS.ipynb
        BIASED_ACTIVATION_GPCR_CLASSIFICATION_MODELS_SHAP_ANALYSIS.ipynb

#### For any queries regarding the above work, kindly contact Prof. Mi-hyun Kim (kmh0515@gachon.ac.kr) or Dr. Surendra Kumar (surendramph@gmail.com).
