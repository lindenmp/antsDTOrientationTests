#!/bin/bash

in_file='/usr/local/fsl/data/standard/FSL_HCP1065_FA_1mm.nii.gz'
out_file='/Users/lindenmp/Dropbox/Work/git/antsDTOrientationTests/FSL_HCP1065_FA_2mm.nii.gz'

flirt -interp nearestneighbour -in ${in_file} -ref ${in_file} -applyisoxfm 2 -out ${out_file}
