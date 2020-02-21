#!/bin/bash

binDir=`dirname $0`

if [[ $# -eq 0 ]]; then
    echo " 
  $0 <moving series> 

  Run this from the directory above scripts/ . Output is to reg/ .

  Uses ANTs with ANTSPATH=${ANTSPATH}

"
    exit 1

fi

movingSeries=$1

movingFA="ants/${movingSeries}/${movingSeries}_FA.nii.gz"
movingDT="ants/${movingSeries}/${movingSeries}_DT.nii.gz"

fixedT1="/Users/lindenmp/Dropbox/Work/git/antsDTOrientationTests/FSL_HCP1065_FA_2mm.nii.gz"

if [[ !(-f $fixedT1 && -f $movingFA) ]] ; then
    echo " Missing input images "
    exit 1
fi


outputRoot="reg/${movingSeries}ToTemplate/${movingSeries}ToTemplate_"

regScripts/regHelper.sh $movingFA $movingDT $fixedT1 $outputRoot
