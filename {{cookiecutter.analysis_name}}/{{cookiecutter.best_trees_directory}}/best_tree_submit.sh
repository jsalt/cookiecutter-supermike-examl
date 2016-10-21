#!/bin/bash

FIRST=$(qsub 01_best_tree_binary.sh)
echo $FIRST
SECOND=$(qsub -W depend=afterok:$FIRST 02_best_tree_parsimony.sh)
echo $SECOND
THIRD=$(qsub -W depend=afterok:$SECOND 03_best_tree_examl.sh)
echo $THIRD
