#!/bin/bash

subject=100307

scriptdir='/Users/lindenmp/Dropbox/Work/git/antsDTOrientationTests'

${scriptdir}/resliceTemplate.sh

${scriptdir}/nativeDT/dtifit.sh $subject

${scriptdir}/nativeDT/convertDT.sh $subject

${scriptdir}/regScripts/regToMNI.sh $subject
    
