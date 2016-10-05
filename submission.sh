#!/bin/bash

module load openmpi-x86_64

#location of metanetwork synapse scripts (i.e. the directory this script should be in)
#pathv=`dirname $0`
pathv=$( cd $(dirname $0) ; pwd -P )
pathv=${pathv}!

. $pathv/config.sh

#number of cores to reserve for MICor jobs
nthreadsLight=80

#number of cores to reserve for regression jobs
nthreads=120

#number of cores to reserve for computationally intensive jobs
nthreadsHeavy=240

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/annoFile.txt"

#path to csv file with provenance to add to file on synapse
provenanceFile="$outputpath/provenanceFile.txt"

### build nets ###

lightNets=( "c3net" "mrnet" "wgcnaTOM" )

nets=( "lassoAIC" "lassoBIC" "lassoCV1se" "lassoCVmin" "ridgeAIC" "ridgeBIC" "ridgeCV1se" "ridgeCVmin" "sparrowZ" "sparrow2Z" )

heavyNets=( "genie3" "tigress" )

for net in ${lightNets[@]}; do
	qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreadsLight,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreadsLight -S /bin/bash -V -cwd -N "$net" -e "$errorOutput/${net}error.txt" -o "$outOutput/${net}out.txt" $pathv/networkScripts/${net}.sh
done

for net in ${nets[@]}; do
	qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "$net" -e "$errorOutput/${net}error.txt" -o "$outOutput/${net}out.txt" $pathv/networkScripts/${net}.sh
done

for net in ${heavyNets[@]}; do
	qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreadsHeavy,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreadsHeavy -S /bin/bash -V -cwd -N "$net" -e "$errorOutput/${net}error.txt" -o "$outOutput/${net}out.txt" $pathv/networkScripts/${net}.sh
done
