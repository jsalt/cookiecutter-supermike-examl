#!/bin/bash
#PBS -q single
#PBS -l nodes=1:ppn=1
#PBS -l walltime=0:10:00
#PBS -o 07_examl_summary.stdout
#PBS -e 07_examl_summary.stderr
#PBS -N 07_examl_sum
#PBS -A {{cookiecutter.allocation_name}}

export workdir={{cookiecutter.top_level_directory}}/{{cookiecutter.analysis_name}}
export best=$workdir/{{cookiecutter.best_trees_directory}}
export bootrep=$workdir/{{cookiecutter.bootrep_trees_directory}}
export phylip={{cookiecutter.top_level_directory}}/{{cookiecutter.phylip_file}}

base=`basename ${phylip}`
root="${base%.*}"

# processing starts
date
# find out tree with best likelihood
cd $best
# get highest likelihood value (= lowest absolute value) 
likelihood=$(cat ExaML_info.T* | grep 'Likelihood of' | sed 's/Likelihood of best tree: -//' | sort -n | head -1)
# get name of tree with highest likelihood value
besttree=$(grep -l $likelihood ExaML_info.T* | sed 's/ExaML_info.//')
# print best tree and likelihood
echo Best tree is $besttree with likelihood -$likelihood
# summarize tree using sumtrees.py
cd $workdir
sumtrees.py -o $root.ExaML.tre -t $best/ExaML_result.$besttree $bootrep/ExaML_result.T*
sumtrees.py -o $root.ExaML.con.tre $bootrep/ExaML_result.T*
# processing ends
date
# done
exit 0
