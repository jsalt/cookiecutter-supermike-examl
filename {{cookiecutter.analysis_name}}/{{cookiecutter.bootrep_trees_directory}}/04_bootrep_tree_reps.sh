#!/bin/bash
#PBS -q single
#PBS -l nodes=1:ppn=1
#PBS -l walltime=8:00:00
#PBS -o 04_bootrep_tree_reps.stdout
#PBS -e 04_bootrep_tree_reps.stderr
#PBS -N 04_bootrep_bstrap
#PBS -A {{cookiecutter.allocation_name}}

export workdir={{cookiecutter.top_level_directory}}/{{cookiecutter.analysis_name}}
export bootrep=$workdir/{{cookiecutter.bootrep_trees_directory}}
export bootrep_reps=$bootrep/{{cookiecutter.bootrep_trees_reps_directory}}
export phylip=$workdir/{{cookiecutter.phylip_file}}
export reps={{cookiecutter.number_of_bootreps}}

# compute some values on the fly
rep_iterator=$(({{cookiecutter.number_of_bootreps}} - 1))

# processing starts
date

# ========= Regular bootstrapping =================
# mkdir -p $bootrep_reps
# cd $bootrep_reps
# there seems to be a bug in raxml w/ full paths and bootstrapping
# use symlink to get around it
# ln -s $phylip
# generate $reps bootreps from phylip file
# raxmlHPC-AVX -N $reps -b $RANDOM -f j -m GTRGAMMA -s {{cookiecutter.phylip_file}} -n REPS

# ========== Multi-locus bootstrapping ============
# generate $reps bootreps from folder of aligned nexus files
cd $bootrep
# get folder name from phylip alignment file
base=`basename ${phylip}`
root="${base%.*}"
python ~/phyluce/bin/align/phyluce_align_generate_concatenated_multilocus_bootstraps \
   --alignments $workdir/$root \
   --output $bootrep_reps \
   --bootreps $reps \
   --prefix {{cookiecutter.phylip_file}}

# convert those bootreps to binary format
cd $bootrep_reps
for i in  $(seq 0 $rep_iterator);
do
    parse-examl -m DNA -s {{cookiecutter.phylip_file}}.BS$i -n BS$i;
done
# processing ends
date
# done
exit 0

