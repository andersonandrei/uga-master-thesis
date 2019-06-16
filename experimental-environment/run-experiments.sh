#!/bin/bash

ANALYZE_PYTHON_DIR="analyze_results.py"
ANALYZE_R_DIR="analyze_metrics.r"
SAMPLE_DATA_DIR="../simulator-prototype/sample-data"

EXPERIMENTS_DIR="."

#if [ $1 == '1' ] ; then
#    SCHEDS="qarnotNodeSched"
#elif [ $1 == '2' ] ; then
#    SCHEDS="qarnotNodeSchedAndrei"
#elif [ $1 == '3' ] ; then
#    SCHEDS="qarnotNodeSchedReplicate3LeastLoaded"
#elif [ $1 == '4' ] ; then
#    SCHEDS="qarnotNodeSchedReplicate10LeastLoaded"
#elif [ $1 == '5' ] ; then
#    SCHEDS="qarnotNodeSchedFullReplicate"
#else
#    SCHEDS=("qarnotNodeSched" "qarnotNodeSchedLocalityBased" "qarnotNodeSchedReplicate3LeastLoaded" "qarnotNodeSchedReplicate10LeastLoaded" "qarnotNodeSchedFullReplicate")
#fi

#echo $SCHEDS

WORKLOADS=$(ls "../simulator-prototype/sample-data")
#WORKLOADS=("1w_17-05-2019")

echo ">> ------------------------------------------------------------ <<"
echo "                     Starting the script"
echo ">> ------------------------------------------------------------ <<"
echo " "
# To run the experiments in the simulator-prototype/sample-data using robin scripts

cd $EXPERIMENTS_DIR
#echo "Setting the nix-shell"
#nix-shell shell.nix
echo "  >> Creating the yaml files and executing with robin"
mkdir yaml output
chmod +x create-yaml.py

for workload in $WORKLOADS
do
    echo "      >> ${workload}"
    ./create-yaml.py -i $workload -s qarnotNodeSched --update 150
    ./create-yaml.py -i $workload -s qarnotNodeSchedAndrei --update 150
    ./create-yaml.py -i $workload -s qarnotNodeSchedReplicate3LeastLoaded --update 150
    ./create-yaml.py -i $workload -s qarnotNodeSchedReplicate10LeastLoaded --update 150
    ./create-yaml.py -i $workload -s qarnotNodeSchedFullReplicate --update 150
    ./create-yaml.py -i $workload -s qarnotNodeSchedReplicateOnSubmit --update 150

    robin "yaml/${workload}_qarnotNodeSched_150.yaml"
    robin "yaml/${workload}_qarnotNodeSchedAndrei_150.yaml"
    robin "yaml/${workload}_qarnotNodeSchedReplicate3LeastLoaded_150.yaml"
    robin "yaml/${workload}_qarnotNodeSchedReplicate10LeastLoaded_150.yaml"
    robin "yaml/${workload}_qarnotNodeSchedFullReplicate_150.yaml"
    robin "yaml/${workload}_qarnotNodeSchedReplicateOnSubmit_150.yaml"
done
echo " "
echo ">> ------------------------------------------------------------ <<"
echo "             Executing the simulations using robin"
echo ">> ------------------------------------------------------------ <<"
echo " "
#YAML_FILES=$(ls "yaml/")

#echo $YAML_FILES
#cd yaml
#for experiment in $YAML_FILES
#do
#   echo "      >> robin ${experiment}"
#    echo " "
#    robin "yaml/${experiment}"
#    echo " "
#done
