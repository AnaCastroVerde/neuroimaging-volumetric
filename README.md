# neuroimaging-volumetric 🧠
This repository offers tools for performing a subcortical volume quantification on brain Magnetic Resonance Imaging (MRI) imaging data. The purpose of these tools is to do a volumetric quantification of subcortical brain structures to study the potential effects of the chemo-brain in patients with breast cancer.

### Repository Structure
It contains two scripts:
- 'Subcortical_Volumes_normalized.sh': An FSL - compreensive MRI analysis tools from FMRIB Software Library, version 5.0.10 (1) - bash script that uses FSLstats to quantify the volumes of 15 subcortical brain structures (bilateral nucleus accumbens, amygdala, caudate, hippocampus, globus pallidum, putamen, and thalamus, and brainstem)
- 'Subcortical_volumes_comparison_3groups.R': An R script to compare the normalized subcortical volumes of healthy controls (HC) and breast cancer patients (BC) determined in the first step, using unpaired and paired t-tests, respectively, between HC vs BC at baseline (M0) and BC at M0 vs BC at 6 months after treatment (M6).

### Usage
For running the subcortical quantification, the following must be provided on your main directory:
1. A folder with your FSL SIENAX results (Total brain volume and V-scaling factor estimates).
2. A folder with your FSL FIRST results ('T1_first_all_fast_firstseg.nii.gz' files with the segmentation output).

In order to run the bash script type these commmands on the command line:
```
$ cd path_to_script

$ chmod a+x Subcortical_Volumes_normalized.sh

$ ./Subcortical_Volumes_normalized.sh
```

### Acknowledgements
Our work is based on the following FSL tools:
(1) M.W. Woolrich, S. Jbabdi, B. Patenaude, M. Chappell, S. Makni, T. Behrens, C. Beckmann, M. Jenkinson, S.M. Smith. Bayesian analysis of neuroimaging data in FSL. NeuroImage, 45:S173-86, 2009

If you use any of these in your research, please don't forget to acknowledge our work.


