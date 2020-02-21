#!/bin/bash

function get4DVecs() {

    # fslview does not display 5D NIFTI vectors correctly, requires 4D
    
    dt=$1
    vec_label=$2
    vec_idx=$3
    output=$4
    
    tmpFileRoot=`basename ${dt%.nii.gz}`
    
    ${ANTSPATH}ImageMath 3 /tmp/${tmpFileRoot}${vec_label}.nii.gz TensorToVector $dt $vec_idx
    
    for (( i=0; i<3; i++ )); do
        ${ANTSPATH}ImageMath 3 /tmp/${tmpFileRoot}${vec_label}_${i}.nii.gz ExtractVectorComponent /tmp/${tmpFileRoot}${vec_label}.nii.gz $i
    done
    
    ${ANTSPATH}ImageMath 4 ${output} TimeSeriesAssemble 1 0 /tmp/${tmpFileRoot}${vec_label}_0.nii.gz /tmp/${tmpFileRoot}${vec_label}_1.nii.gz /tmp/${tmpFileRoot}${vec_label}_2.nii.gz 
    
}

if [[ $# -eq 0 ]]; then
    echo " 
  $0 <moving> <moving DT> <fixed> <outputRoot> [initialTransform]

  The first moving image is the scalar image that is registered to the fixed image.
  The second one is the DT, which will be warped and reoriented.

  Uses ANTs with ANTSPATH=${ANTSPATH}

"

    exit 1

fi

moving=$1
movingDT=$2
fixed=$3
outputRoot=$4

echo ${moving}
echo ${movingDT}
echo ${fixed}
echo ${outputRoot}

initialTransformOpt=""

if [[ $# -gt 4 ]]; then
    initialTransform="-i $5"
fi

outputDir=`dirname $outputRoot`

if [[ ! -d $outputDir ]]; then
    mkdir -p ${outputDir}
fi

# 1) run ANTs registration
${ANTSPATH}antsRegistrationSyNQuick.sh -p f -f $fixed -m $moving -t s -o $outputRoot $initialTransformOpt

# 2) compose a single warp
${ANTSPATH}antsApplyTransforms -d 3 -i $moving -r $fixed -t ${outputRoot}1Warp.nii.gz -t ${outputRoot}0GenericAffine.mat -o [ ${outputRoot}combinedWarp.nii.gz , 1 ]

# 3) move DT to fixed
${ANTSPATH}antsApplyTransforms -d 3 -e 2 -i $movingDT -r $fixed -t ${outputRoot}combinedWarp.nii.gz -o ${outputRoot}DTDeformed.nii.gz

# 4) reorient warped DT
${ANTSPATH}ReorientTensorImage 3 ${outputRoot}DTDeformed.nii.gz ${outputRoot}DTReorientedWarp.nii.gz ${outputRoot}combinedWarp.nii.gz

# 5) Get vecs
get4DVecs ${outputRoot}DTReorientedWarp.nii.gz V1 2 ${outputRoot}V1Deformed.nii.gz
get4DVecs ${outputRoot}DTReorientedWarp.nii.gz V2 1 ${outputRoot}V2Deformed.nii.gz
get4DVecs ${outputRoot}DTReorientedWarp.nii.gz V3 0 ${outputRoot}V3Deformed.nii.gz

# 5) Get eigenvals
${ANTSPATH}ImageMath 3 ${outputRoot}L1Deformed.nii.gz TensorEigenvalue ${outputRoot}DTReorientedWarp.nii.gz 2
${ANTSPATH}ImageMath 3 ${outputRoot}L2Deformed.nii.gz TensorEigenvalue ${outputRoot}DTReorientedWarp.nii.gz 1
${ANTSPATH}ImageMath 3 ${outputRoot}L3Deformed.nii.gz TensorEigenvalue ${outputRoot}DTReorientedWarp.nii.gz 0
