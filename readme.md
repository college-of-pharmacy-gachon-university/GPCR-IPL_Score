# Revisiting the Interaction of GPCR based on a Machine Learning Classifier
## Description:

Here, the Machine Learning based Classifiers have been built to learn the interaction of GPCR protein-ligand complexes. The interactions are further learned using the SHAP plot. 

<p align="center">
  <img src="https://user-images.githubusercontent.com/51576785/229001792-230f8050-1bff-47c2-a69a-dde9e7b3928d.png"/>
</p>

#### Figure: The overall workflow for GPCR classification modeling.

## Requirement:
The following programs/packages should be installed.
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
1.	Collect the GPCR protein-ligand data from GPCRdb and GPCR-EXP.
        
       a)	GPCRdb: https://gpcrdb.org/structure
        
       b)	GPCR-EXP: https://zhanggroup.org/GPCR-EXP (From the download page; download the Superposed GPCRs: ``“pdb_overlays.tar.gz”``.)
       
2.	After collecting all PDBs for GPCR, check the common PDBs and remove the duplicates.

3.	Prepare all the proteins using ``“Protein-Preparation Wizard of Schrodinger Suite”`` for missing atoms, add Hydrogens, assigning the correct protonation state of amino acid residues and minimization of heavy atoms.

4.	The following files must be collected on `prepared protein` before generating all features.
  
    a)	Save prepared protein into a PDB format file `{pdbid}_protein.pdb` to generate the `GPCR generic residue numbering system` file for each protein.
          
       i.	Using the following web link, the GPCR generic residue numbering file can be generated for each PDB file.
       https://gpcrdb.org/structure/generic_numbering_index
       
       ii.	This will assign the generic residue numbering system to the input file `{pdbid}_protein.pdb` and produces the output file `{pdbid}_protein_GPCRDB.pdb`.
       
       iii.	Use the Jupyter notebook under Data Preparation Folder to convert `*.pdb` into `*.csv file`. `(Batch execution supported)`
                
        Convert_GPCRPDBs_to_PandasDataframe.ipynb
       
    b)	Save prepared protein into a MOL2 format file `{pdbid}_protein.mol2` to perform `in-situ minimization` using the `Szybki (OpenEye Scientific Software)`.
    
    c)	Save the prepared protein into a MOL2 format file `{pdbid}_ pocket.mol2` after trimming the binding site residues within 7.0 Å from the bound ligand.

5. #### Workflow on Non-Optimized GPCR feature generation:
  
    a)	Generate the Interaction Feature (INT_Feat): Use the `{pdbid}_ pocket.mol2` and bound ligand in `*.mol2` as input for Interaction Features generation (`*.ifp`).
    
       Use the following script under the Feature Generation Folder for batch execution 
       sh INT_Feat_Gen.sh
       
    b)	Generate the Pocket Feature (POCK_Feat): Use the `{pdbid}_ pocket.mol2` as input for pocket features generation to `*.txt` file.
    
        Use the follwing script under the Feature Generation Folder step by step for batch execution:
        sh step1.POCK_Feat_Gen_tagged.sh
        sh step2.POCK_Feat_Gen_listtagged.sh
        sh step3.POCK_Feat_Gen_fp.sh
        
    c)	Generate the Ligand Feature (LIG_Feat): Save all the Non-Optimized ligand from GPCR PDBs, into `*.sdf file` and use the same `*.sdf file` as input to generate the 3D fingerprint and save them into the `*.csv file`.
    
        Use the following script under the Feature Generation Folder 
        python LIG_Feat_Gen.py
        
6. #### Workflow on Optimized GPCR feature generation:

     a)	Using the `{pdbid}_ protein.mol2` and bound ligand `*.mol2` perform the `in-situ optimization` of ligand and binding site residue using the `Szybki (OpenEye Scientific Software)`.

        Use the script under the Processing Folder for batch execution
        sh run_szybki.sh
        
    b) After optimization, the output file `{pdbid}_ opt_complex.mol2` is produced, which must be split into protein and ligand.
    
    c) From the optimized complex, trim the binding site residues within 7.0 Å from the bound ligand and save the trimmed protein file as mol2 file `{pdbid}_opt_pocket.mol2`. `(The user can use the maestro or any other related program for the this task)`
    
    d) The optimized protein and ligand files are further used as an input file to generate the various features like as above in the case of Section 5.
    
    e) Generate the Interaction Feature (INT_Feat): Use the `{pdbid}_opt_pocket.mol2` and bound ligand in `*.mol2` as input for Interaction Features generation (`*.ifp`).

        Use the following script under the Feature Generation Folder for batch execution
        sh INT_Feat_Gen.sh
     
    f) Generate the Pocket Feature (POCK_Feat): Using the `{pdbid}_opt_pocket.mol2` as input for pocket features generation to `*.txt` file.
        
        Use the follwing script under the Feature Generation Folder step by step for batch execution:
        sh step1.POCK_Feat_Gen_tagged.sh
        sh step2.POCK_Feat_Gen_listtagged.sh
        sh step3.POCK_Feat_Gen_fp.sh
        
    g) Generate the Ligand Feature (LIG_Feat): Save all the Optimized ligand from GPCR PDBs, into `*.sdf file` and use the same `*.sdf file` as input to generate the E3FP fingerprint and save them into the `*.csv file`.
    
        Use the script under the Feature Generation for batch execution
        python LIG_Feat_Gen.py

7. #### GPCR feature compilation using the KNIME workflow to make a feature matrix:

    a) To generate a feature matrix using the KNIME, the following four files are required.
    
    i. GPCR generic residue number file from `4(a(iii))`.
    
    ii.	Interaction feature file `*.ifp` from `5(a) or 6(f)`.
    
    iii. Pocket feature file `*.txt` from `5(b) or 6(g)`.
    
    iv.	Ligand feature file `*.csv` from `5(c) or 6(h)`.

    b) This KNIME workflow process the 7(a) i-iv files and tag each amino acid residue according to their `TMs` and finally save all the features into the `*.csv file`.

        Use the following KNIME workflow under Feature Embedding to process all the above 4 input file.
        GPCR_KNIME_WORKFLOW.knwf

8. After receiving the feature matrix from `step.7`, the various machine learning model can be built using the following Jupyter Notebook. However, this notebook shows the best-selected model from binary and multiclass biased activation.

        To `train, validate and test` the binary and multiclass biased activation classification model, use the following Jupyter Notebook file under Model Building Folder.

        BINARY_OPT_GPCR_CLASSIFICATION_MODELS.ipynb
        BIASED_ACTIVATION_GPCR_CLASSIFICATION_MODELS.ipynb
        
9. The best model (Logistic Regression for Binary Classifier and XGB for Multiclass Biased Activation Classifier) was further selected for the SHAP to analyze the feature importance and interpretation.

        Run the following Jupyter Notebook under the Model Analysis Folder to create the various plots.
        
        BINARY_OPT_GPCR_CLASSIFICATION_MODELS_SHAP_ANALYSIS.ipynb
        BIASED_ACTIVATION_GPCR_CLASSIFICATION_MODELS_SHAP_ANALYSIS.ipynb

#### For any queries regarding the above work, kindly contact Prof. Mi-hyun Kim (kmh0515@gachon.ac.kr) or Dr. Surendra Kumar (surendramph@gmail.com).
