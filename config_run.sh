#!/bin/bash
#
#PBS -N batch_run
#PBS -l select=1:ncpus=20:mem=124gb
#PBS -l walltime=4:00:00
#PBS -j eo

module add ansys/18.1
module add gnu-parallel

INPUT_FOLDER=Inputs

cd $PBS_O_WORKDIR

rm -rf $SCRATCH

mkdir /local_scratch/$USER
SCRATCH=/local_scratch/$USER

cp $PBS_O_WORKDIR/$INPUT_FOLDER/*.txt $SCRATCH
cp $PBS_O_WORKDIR/$INPUT_FOLDER/*.mac $SCRATCH

ls $SCRATCH/*.txt | parallel -j20 'ansys181 -dir /local_scratch/echodor/ -j $RANDOM -s read -l en-us -b -i {}'
cp $SCRATCH/*t.txt $PBS_O_WORKDIR/$INPUT_FOLDER

# TIME=$(date +"%m-%d_%H-%M")
# mkdir $PBS_O_WORKDIR/parametric_test_$TIME

rm -rf $SCRATCH