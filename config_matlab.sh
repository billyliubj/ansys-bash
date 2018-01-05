#!/bin/bash
#
#PBS -N batch_run
#PBS -l select=1:ncpus=24:mem=124gb
#PBS -l walltime=4:00:00
#PBS -j eo

module add ansys/18.1
module add gnu-parallel
module add matlab/2017a

INPUT_FOLDER=Inputs

cd $PBS_O_WORKDIR

rm -rf $SCRATCH

mkdir /local_scratch/$USER
SCRATCH=/local_scratch/$USER

cp -R $PBS_O_WORKDIR/$INPUT_FOLDER/* $SCRATCH
# cp $PBS_O_WORKDIR/$INPUT_FOLDER/*.mac $SCRATCH
# cp $PBS_O_WORKDIR/$INPUT_FOLDER/*.m $SCRATCH
# cp $PBS_O_WORKDIR/$INPUT_FOLDER/*.mat $SCRATCH

ls $SCRATCH/*.txt | parallel -j24 'ansys181 -dir /local_scratch/echodor/ -j $RANDOM -s read -l en-us -b -i {}'

cd /local_scratch/echodor/

taskset -c 0-$(($OMP_NUM_THREADS-1)) matlab -nodisplay -nodesktop -nosplash -r Results_Read

cp $SCRATCH/*.mat $PBS_O_WORKDIR/$INPUT_FOLDER

# TIME=$(date +"%m-%d_%H-%M")
# mkdir $PBS_O_WORKDIR/parametric_test_$TIME

rm -rf $SCRATCH