
# antsDTOrientationTests

Data and code to test DT warping and reorientation in ANTs on HCP data


## Raw data

Subject 100307 downloaded from HCP. Only need processed diffusion data

Template: the HCP1065 FA from FSL

## Run

    cd <my_dir>/antsDTOrientationTests
    ./runAll.sh

## Template
Read in FSL template and downsample to 2mm.

## DT fit

The DT is computed with FSL (dtifit). It is then converted into ANTs format. No
reorientation is applied at this stage, the components are just re-ordered into
a NIFTI standard (lower triangular) file compatible with ITK I/O.

The scripts to do this are in nativeDT/

    dtifit.sh
    convertDT.sh


## Register to Template

Non-linear registration to template is performed using FA image and DT is moved and reoriented.
Eigenvectors and eigenvalues are extracted from DT.

    regToTemplate.sh
	    regHelper.sh


## Registration output

Output files are in reg/100307ToTemplate:

100307ToTemplate_{V1,V2,V3}Deformed.nii.gz - eigenvectors

100307ToTemplate_{L1,L2,L3}Deformed.nii.gz - eigenvalues

100307ToTemplate_DTDeformed.nii.gz - DT warped to template

100307ToTemplate_DTDeformed.nii.gz - DT warped to template and then reoriented

Note, data not uploaded.
