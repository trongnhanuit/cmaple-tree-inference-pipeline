//  a JenkinsFile to build iqtree
// paramters
//  1. git branch
// 2. git url


properties([
    parameters([
    	booleanParam(defaultValue: false, description: 'Re-build CMAPLE?', name: 'BUILD_CMAPLE'),
        string(name: 'CMAPLE_BRANCH', defaultValue: 'main', description: 'Branch to build CMAPLE'),
        booleanParam(defaultValue: true, description: 'Download testing data?', name: 'DOWNLOAD_DATA'),
        string(name: 'ALN_REMOTE_DIR', defaultValue: 'aln/aln_10_taxa', description: 'The (remote) directory containing the testing alignments'),
        string(name: 'ALN_LOCAL_DIR', defaultValue: '', description: 'The (local, if applicable?) directory containing the testing alignments'),
        booleanParam(defaultValue: true, description: 'Infer ML trees?', name: 'INFER_TREE'),
        string(name: 'MODEL', defaultValue: 'GTR', description: 'Substitution model'),
    ])
])
pipeline {
    agent any
    environment {
        NCI_ALIAS = "gadi"
        WORKING_DIR = "/scratch/dx61/tl8625/cmaple/ci-cd"
        TEST_DATA_REPO_NAME = "cmaple-testing-data"
        TEST_DATA_REPO_URL = "https://github.com/trongnhanuit/${TEST_DATA_REPO_NAME}.git" 
        TEST_DATA_REPO_DIR = "${WORKING_DIR}/${TEST_DATA_REPO_NAME}"
        DATA_DIR = "${WORKING_DIR}/data"
        ALN_DIR = "${DATA_DIR}/aln"
        TREE_DIR = "${DATA_DIR}/tree"
        SCRIPTS_DIR = "${WORKING_DIR}/scripts"
        BUILD_DIR = "${WORKING_DIR}/builds/build-default"
        CMAPLE_PATH = "${BUILD_DIR}/cmaple"
        ML_TREE_PREFIX = "ML_tree_"
    }
    stages {
    	stage("Build CMAPLE") {
            steps {
                script {
                	if (params.BUILD_CMAPLE) {
                        echo 'Building CMAPLE'
                        // trigger jenkins cmaple-build
                        build job: 'cmaple-build', parameters: [string(name: 'BRANCH', value: CMAPLE_BRANCH)]

                    }
                    else {
                        echo 'Skip building CMAPLE'
                    }
                }
            }
        }
    	stage('Download testing data') {
            steps {
                script {
                	if (params.DOWNLOAD_DATA) {
                		if (params.ALN_LOCAL_DIR != '')
                		{
                			sh """
                        		ssh -tt ${NCI_ALIAS} << EOF
                        		mkdir -p ${WORKING_DIR}
                        		cd  ${WORKING_DIR}
                        		mkdir -p ${ALN_DIR}
                        		exit
                        		EOF
                        		"""
                        	sh "scp -r ${params.ALN_LOCAL_DIR}/*.* ${NCI_ALIAS}:${ALN_DIR}"
                		}
                		else
                		{
                    		sh """
                        		ssh -tt ${NCI_ALIAS} << EOF
                        		mkdir -p ${WORKING_DIR}
                        		cd  ${WORKING_DIR}
                        		git clone --recursive ${TEST_DATA_REPO_URL}
                        		mkdir -p ${ALN_DIR}
                        		cp ${TEST_DATA_REPO_DIR}/${params.ALN_REMOTE_DIR}/*.* ${ALN_DIR}
                        		rm -rf ${TEST_DATA_REPO_DIR}
                        		exit
                        		EOF
                        		"""
                        }
                    }
                }
            }
        }
        stage('Infer trees') {
            steps {
                script {
                	if (params.INFER_TREE) {
                		sh """
                        	ssh -tt ${NCI_ALIAS} << EOF
                        	mkdir -p ${SCRIPTS_DIR}
                        	exit
                        	EOF
                        	"""
                		sh "scp -r scripts/* ${NCI_ALIAS}:${SCRIPTS_DIR}"
                    	sh """
                        	ssh -tt ${NCI_ALIAS} << EOF

                                              
                        	echo "Inferring ML trees by CMAPLE"                        
                        	sh ${SCRIPTS_DIR}/infer_tree.sh ${ALN_DIR} ${TREE_DIR} ${CMAPLE_PATH} ${ML_TREE_PREFIX} ${params.MODEL}
                        
                       
                        	exit
                        	EOF
                        	"""
                        }
                }
            }
        }
        stage ('Verify') {
            steps {
                script {
                	sh """
                        ssh -tt ${NCI_ALIAS} << EOF
                        cd  ${WORKING_DIR}
                        echo "Files in ${WORKING_DIR}"
                        ls -ila ${WORKING_DIR}
                        echo "Files in ${ALN_DIR}"
                        ls -ila ${ALN_DIR}
                        echo "Files in ${TREE_DIR}"
                        ls -ila ${TREE_DIR}
                        exit
                        EOF
                        """
                }
            }
        }


    }
    post {
        always {
            echo 'Cleaning up workspace'
            cleanWs()
        }
    }
}

def void cleanWs() {
    // ssh to NCI_ALIAS and remove the working directory
    // sh "ssh -tt ${NCI_ALIAS} 'rm -rf ${REPO_DIR} ${BUILD_SCRIPTS}'"
}