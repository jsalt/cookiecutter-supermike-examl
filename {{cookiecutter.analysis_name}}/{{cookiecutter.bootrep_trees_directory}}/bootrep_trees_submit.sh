#!/bin/bash

FIRST=$(qsub 04_bootrep_tree_reps.sh)
echo $FIRST
SECOND=$(qsub -W depend=afterok:$FIRST 05_bootrep_tree_parsimony.sh)
echo $SECOND
THIRD=$(qsub -W depend=afterok:$SECOND 06_bootrep_tree_examl.sh)
echo $THIRD
