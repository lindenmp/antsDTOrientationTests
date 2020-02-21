#!/bin/bash

subject=$1

tmpDir=ants/${subject}/tmp

mkdir -p $tmpDir

${ANTSPATH}ImageMath 3 ${tmpDir}/${subject}_dtUpper.nii.gz 4DTensorTo3DTensor fsl/${subject}/${subject}_tensor.nii.gz

comps=(xx xy xz yy yz zz)

for (( i=0; i < 6; i++ )); do
  ${ANTSPATH}ImageMath 3 ${tmpDir}/${subject}_comp_d${comps[$i]}.nii.gz TensorToVectorComponent ${tmpDir}/${subject}_dtUpper.nii.gz $((i+3))
done

${ANTSPATH}ImageMath 3 ants/${subject}/${subject}_DT.nii.gz ComponentTo3DTensor ${tmpDir}/${subject}_comp_d .nii.gz

${ANTSPATH}ImageMath 3 ants/${subject}/${subject}_FA.nii.gz TensorFA ants/${subject}/${subject}_DT.nii.gz

rm ${tmpDir}/*
rmdir ${tmpDir}
