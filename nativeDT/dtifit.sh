#!/bin/bash

subject=$1

mkdir -p fsl/$subject

dtifit -k /Users/lindenmp/${subject}/T1w/Diffusion/data.nii.gz \
	-o fsl/${subject}/${subject} \
	-m /Users/lindenmp/${subject}/T1w/Diffusion/nodif_brain_mask.nii.gz \
	-r /Users/lindenmp/${subject}/T1w/Diffusion/bvecs \
	-b /Users/lindenmp/${subject}/T1w/Diffusion/bvals \
	--save_tensor
