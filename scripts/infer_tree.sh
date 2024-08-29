#!bin/bash

###### handle arguments ######

ALN_DIR=$1 # aln dir
TREE_DIR=$2 # tree dir
CMAPLE_PATH=$3 # path to CMAPLE executable
CMAPLE_PARAMS=$4 # CMAPLE params
ML_TREE_PREFIX=$5 # The prefix of ML trees


### pre steps #####



############

for aln_path in "${ALN_DIR}"/*.maple; do
	aln=$(basename "$aln_path")
    echo "Inferring a phylogenetic tree from ${aln}"
    cd ${ALN_DIR} && ${CMAPLE_PATH} -aln ${aln} -pre ${ML_TREE_PREFIX}${aln} ${CMAPLE_PARAMS}
done
                        
echo "Moving the ML trees to ${TREE_DIR}"
mkdir -p ${TREE_DIR}
mv ${ALN_DIR}/${ML_TREE_PREFIX}*treefile ${TREE_DIR}