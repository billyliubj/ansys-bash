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

ls $SCRATCH/*.txt | parallel -j24 'ansys181 -dir /local_scratch/echodor/ -j $RANDOM -s read -l en-us -b -i {}'

cd /local_scratch/echodor/ # MATLAB needs to be run from current directory

# Prevent MATLAB from using all cores of a node (kills job if takes more than initially allocated) and run post-processing script
taskset -c 0-$(($OMP_NUM_THREADS-1)) matlab -nodisplay -nodesktop -nosplash -r Results_Read

cp $SCRATCH/*.mat $PBS_O_WORKDIR/$INPUT_FOLDER

rm -rf $SCRATCH
