#!bin/bash

###### handle arguments ######

ALN_DIR=$1 # aln dir
TREE_DIR=$2 # tree dir
CMAPLE_PATH=$3 # path to CMAPLE executable
ML_TREE_PREFIX=$4 # The prefix of ML trees
CMAPLE_PARAMS="-overwrite" # CMAPLE params


### pre steps #####



############

for aln_path in "${ALN_DIR}"/*.maple; do
	aln=$(basename "$aln_path")
    echo "Inferring a phylogenetic tree from ${aln}"
    cd ${ALN_DIR} && ${CMAPLE_PATH} -aln ${aln} -pre ${ML_TREE_PREFIX}${aln} ${CMAPLE_PARAMS}
done
                        
echo "Moving the ML trees to ${TREE_DIR}"
mkdir -p ${TREE_DIR}
# remove old results
rm -f ${TREE_DIR}/${ML_TREE_PREFIX}*treefile
# copy new results
mv ${ALN_DIR}/${ML_TREE_PREFIX}*treefile ${TREE_DIR}