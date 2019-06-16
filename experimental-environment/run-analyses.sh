#!/bin/bash

ANALYZE_PYTHON_DIR="analyze_results.py"
ANALYZE_WORKLOAD_DIR="analyze_workloads.py"
ANALYZE_R_DIR="analyze_metrics.r"
SAMPLE_DATA_DIR="../simulator-prototype/sample-data"

EXPERIMENTS_DIR="."

# To create all workload output folders
WORKLOADS_INTERVAL=$(ls "output")
#WORKLOADS_INTERVAL=$(ls "out2")

#WORKLOADS=$(ls "../simulator-prototype/sample-data")
WORKLOADS=('1w_03-05-2019' '1w_10-05-2019' '1w_17-05-2019' '1w_24-05-2019')
#WORKLOADS=('3d_09-05-2019')
#WORKLOADS=('3d_09-05-2019_long' '3d_09-05-2019_short')
#WORKLOADS=("3d_09-05-2019")
#WORKLOADS=('1w_03-05-2019_long' '1w_10-05-2019_long' '1w_17-05-2019_long' '1w_24-05-2019_long' '1w_03-05-2019_short' '1w_10-05-2019_short' '1w_17-05-2019_short' '1w_24-05-2019_short')

# To copy the input data from the simulator-prototype folder to data folder
echo " "
echo ">> ------------------------------------------------------------ <<"
echo "                Preparing the analyzes folder"
echo ">> ------------------------------------------------------------ <<"
echo " "

ARRAY_SCHEDS=('qarnotNodeSched' 'qarnotNodeSchedAndrei' 'qarnotNodeSchedReplicate3LeastLoaded' 'qarnotNodeSchedReplicate10LeastLoaded' 'qarnotNodeSchedFullReplicate')
#ARRAY_SCHEDS=('qarnotNodeSched' 'qarnotNodeSchedStatic')

mkdir "analyzes"
for workload_exp in ${WORKLOADS[@]} #$WORKLOADS_INTERVAL 
do
    mkdir "analyzes/${workload_exp}"
    mkdir "output/${workload_exp}"
    cp "${SAMPLE_DATA_DIR}/${workload_exp}/workload.json" "output/${workload_exp}/."
#    for sched in "${ARRAY_SCHEDS[@]}"
#    do
#        mv "output/${workload_exp}_${sched}_150" "output/${workload_exp}/${sched}"
#   done
done
echo " >> Done"


# To access all workloads data folder, copy and execute the python script analyze_results.py
echo " "
echo ">> ------------------------------------------------------------ <<"
echo "                      Generating the analyzes"
echo ">> ------------------------------------------------------------ <<"
echo " "
for workload in ${WORKLOADS[@]} #$WORKLOADS_INTERVAL
do    
    echo "      >> ${workload}"
    cd "output/${workload}/"

    #echo "      >> Copying the analyze_results.py"
    #cp "../../${ANALYZE_PYTHON_DIR}" "."

    #echo "      >> Copying the analyze_metrics.r"
    #cp "../../${ANALYZE_R_DIR}" "."
    
    chmod +x analyze_results.py
    #chmod +x analyze_metrics.r
    
    echo "      >> Executing the analyzes"
    ./analyze_results.py
    #./analyze_metrics.r
    
    #echo "mv scheduling_metrics.pdf" "../../analyzes/${workload}/"
    #mv "scheduling_metrics.pdf" "../../analyzes/${workload}/"
    echo " >> Done"
    echo " "
    cd "../.."
done

echo "      >> Copying the analyze_workloads.py"
pwd
cp "${ANALYZE_WORKLOAD_DIR}" "output/."
cd "output"
chmod +x analyze_workloads.py
echo "      >> Executing the workload analyzes"
./analyze_workloads.py
cd .. 

echo " "
echo ">> ------------------------------------------------------------ <<"
echo " "