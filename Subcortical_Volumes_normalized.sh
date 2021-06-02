#!/bin/sh

## Batch script to do volume quantification of each subcortical brain structure
## Uses as input the fslanat output from the FIRST segmentation 'T1_first_all_fast_firstseg.nii.gz'

## Set case numbers

subjs="Case01 Case02 Case03 Case04 Case05" # Change/add your subjects' folder names

## Set main directory

cd /Users/Ana/volumetryfolder # Write the path name to the location where you want to save your output .csv file

## Create column names

echo "Case" "VLeft_Thalamus" "VLeft_Caudate" "VLeft_Putamen" "VLeft_Pallidum" "VLeft_Hippocampus" "VLeft_Amygdala" "VLeft_Accumbens" "VRight_Thalamus" "VRight_Caudate" "VRight_Putamen" "VRight_Pallidum" "VRight_Hippocampus" "VRight_Amygdala" "VRight_Accumbens" "VBrainstem">> Subcortical_Volumes_Normalized.csv

## Repeat recursively for all cases

for s in ${subjs} ; do

Vscaling=`echo $(cat /Users/Ana/volumetryfolder/sienax/${s}_sienax/report.sienax | awk '/VSCALING/ {print $2}')`;

## Left Hemisphere

tissuevol_L_Thalamus=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 9.5 -u 10.5 -V | awk '{print $2}'`; 
tissuevol_L_Thalamus_normalized=`echo "$tissuevol_L_Thalamus * $Vscaling" | bc -l`;

tissuevol_L_Caudate=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 10.5 -u 11.5 -V | awk '{print $2}'`;
tissuevol_L_Caudate_normalized=`echo "$tissuevol_L_Caudate * $Vscaling" | bc -l`;

tissuevol_L_Putamen=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 11.5 -u 12.5 -V | awk '{print $2}'`;
tissuevol_L_Putamen_normalized=`echo "$tissuevol_L_Putamen * $Vscaling" | bc -l`;

tissuevol_L_Pallidum=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 12.5 -u 13.5 -V | awk '{print $2}'`;
tissuevol_L_Pallidum_normalized=`echo "$tissuevol_L_Pallidum * $Vscaling" | bc -l`;

tissuevol_L_Hippocampus=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 16.5 -u 17.5 -V | awk '{print $2}'`;
tissuevol_L_Hippocampus_normalized=`echo "$tissuevol_L_Hippocampus * $Vscaling" | bc -l`;

tissuevol_L_Amygdala=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 17.5 -u 18.5 -V | awk '{print $2}'`;
tissuevol_L_Amygdala_normalized=`echo "$tissuevol_L_Amygdala * $Vscaling" | bc -l`;

tissuevol_L_Accumbens=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 25.5 -u 26.5 -V | awk '{print $2}'`;
tissuevol_L_Accumbens_normalized=`echo "$tissuevol_L_Accumbens * $Vscaling" | bc -l`;

## Right Hemisphere

tissuevol_R_Thalamus=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 48.5 -u 49.5 -V | awk '{print $2}'`;
tissuevol_R_Thalamus_normalized=`echo "$tissuevol_R_Thalamus * $Vscaling" | bc -l`; 

tissuevol_R_Caudate=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 49.5 -u 50.5 -V | awk '{print $2}'`;
tissuevol_R_Caudate_normalized=`echo "$tissuevol_R_Caudate * $Vscaling" | bc -l`;

tissuevol_R_Putamen=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 50.5 -u 51.5 -V | awk '{print $2}'`;
tissuevol_R_Putamen_normalized=`echo "$tissuevol_R_Putamen * $Vscaling" | bc -l`;

tissuevol_R_Pallidum=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 51.5 -u 52.5 -V | awk '{print $2}'`;
tissuevol_R_Pallidum_normalized=`echo "$tissuevol_R_Pallidum * $Vscaling" | bc -l`;

tissuevol_R_Hippocampus=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 52.5 -u 53.5 -V | awk '{print $2}'`;
tissuevol_R_Hippocampus_normalized=`echo "$tissuevol_R_Hippocampus * $Vscaling" | bc -l`;

tissuevol_R_Amygdala=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 53.5 -u 54.5 -V | awk '{print $2}'`;
tissuevol_R_Amygdala_normalized=`echo "$tissuevol_R_Amygdala * $Vscaling" | bc -l`;

tissuevol_R_Accumbens=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 57.5 -u 58.5 -V | awk '{print $2}'`;
tissuevol_R_Accumbens_normalized=`echo "$tissuevol_R_Accumbens * $Vscaling" | bc -l`; 

## Both sided
	
tissuevol_Brainstem=`$FSLDIR/bin/fslstats /Users/Ana/volumetryfolder/first/${s}/T1_first_all_fast_firstseg.nii.gz -l 15.5 -u 16.5 -V | awk '{print $2}'`;
tissuevol_Brainstem_normalized=`echo "$tissuevol_Brainstem * $Vscaling" | bc -l`;


echo ${s} $tissuevol_L_Thalamus_normalized $tissuevol_L_Caudate_normalized $tissuevol_L_Putamen_normalized $tissuevol_L_Pallidum_normalized $tissuevol_L_Hippocampus_normalized $tissuevol_L_Amygdala_normalized $tissuevol_L_Accumbens_normalized 		$tissuevol_R_Thalamus_normalized $tissuevol_R_Caudate_normalized $tissuevol_R_Putamen_normalized $tissuevol_R_Pallidum_normalized $tissuevol_R_Hippocampus_normalized $tissuevol_R_Amygdala_normalized $tissuevol_R_Accumbens_normalized $tissuevol_Brainstem_normalized >> Subcortical_Volumes_Normalized.csv

done
