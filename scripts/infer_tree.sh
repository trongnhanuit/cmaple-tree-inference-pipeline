#!bin/bash

###### handle arguments ######

ALN_DIR=$1 # aln dir
TREE_DIR=$2 # tree dir
CMAPLE_PATH=$3 # path to CMAPLE executable
ML_TREE_PREFIX=$4 # The prefix of ML trees


### pre steps #####



############

aln_files=$(ls  "${ALN_DIR}"/*.maple)
for aln in ${aln_files}; do
    echo "Inferring a phylogenetic tree from ${aln}"
    ./${CMAPLE_PATH} -aln ${ALN_DIR}/${aln} -pre ${ALN_DIR}/${ML_TREE_PREFIX}${aln} ${params.CMAPLE_PARAMS}
done
                        
echo "Moving the ML trees to ${TREE_DIR}"
mkdir -p ${TREE_DIR}
mv ${ALN_DIR}/${ML_TREE_PREFIX}${aln}*treefile ${TREE_DIR}