# volumetric_analysis 🧠
Repository on subcortical volume quantification

// It contains two scripts:
1. A FSL bash script that used fslstats to quantify the volumes of 15 subcortical brain structures
2. A R script to compare the normalized subcortical volumes determined in 1. by treatment group and timepoint 

// First steps..

You need to make sure you have on your main directory:
1. A folder with your FSL sienax results (Total brain volume and V-scaling factor estimates)
2. A folder with your FSL FIRST results ('T1_first_all_fast_firstseg.nii.gz' files with the segmentation output)

In order to run the bash script type these commmands on Mac terminal:

```

$ cd path_to_script

$ chmod a+x Subcortical_Volumes_normalized.sh

$ ./Subcortical_Volumes_normalized.sh
```

// If you use any of these in your research, please don't forget to acknowledge our work.
