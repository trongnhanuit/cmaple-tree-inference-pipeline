//  a JenkinsFile to build iqtree
// paramters
//  1. git branch
// 2. git url


properties([
    parameters([
        // string(name: 'BRANCH', defaultValue: 'master', description: 'Branch to build'),
        string(name: 'ALN_REMOTE_DIR', defaultValue: 'aln/aln_10_taxa', description: 'The directory containing the testing alignments'),
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
        
        /*GITHUB_REPO_URL = "https://github.com/iqtree/cmaple.git"
        GITHUB_REPO_NAME = "cmaple"
        BUILD_SCRIPTS = "${WORKING_DIR}/build-scripts"
        REPO_DIR = "${WORKING_DIR}/${GITHUB_REPO_NAME}"
        BUILD_OUTPUT_DIR = "${WORKING_DIR}/builds"
        BUILD_DEFAULT = "${BUILD_OUTPUT_DIR}/build-default"*/

    }
    stages {
    	stage('Download testing data') {
            steps {
                script {
                    sh """
                        ssh ${NCI_ALIAS} << EOF
                        mkdir -p ${WORKING_DIR}
                        cd  ${WORKING_DIR}
                        git clone --recursive ${TEST_DATA_REPO_URL}
                        mkdir -p ${ALN_DIR}
                        cp ${TEST_DATA_REPO_DIR}/${params.BRANCH}/*.* ${ALN_DIR}
                        rm -rf ${TEST_DATA_REPO_DIR}
                        exit
                        EOF
                        """
                }
            }
        }
    /*// ssh to NCI_ALIAS and scp build-scripts to working dir in NCI
        stage('Copy build scripts') {
            steps {
                script {
                    sh "pwd"
                    sh """
                        ssh ${NCI_ALIAS} << EOF
                        mkdir -p ${WORKING_DIR}
                        mkdir -p ${BUILD_SCRIPTS}
                        exit
                        EOF
                        """
                    sh "scp -r build-scripts/* ${NCI_ALIAS}:${BUILD_SCRIPTS}"
                }
            }
        }
        stage('Setup environment') {
            steps {
                script {
                    sh """
                        ssh ${NCI_ALIAS} << EOF
                        mkdir -p ${WORKING_DIR}
                        cd  ${WORKING_DIR}
                        git clone --recursive ${GITHUB_REPO_URL}
                        cd ${GITHUB_REPO_NAME}
                        git checkout ${params.BRANCH}
                        mkdir -p ${BUILD_OUTPUT_DIR}
                        cd ${BUILD_OUTPUT_DIR}
                        rm -rf *
                        exit
                        EOF
                        """
                }
            }
        }
        stage("Build: Build Default") {
            steps {
                script {
                    sh """
                        ssh ${NCI_ALIAS} << EOF

                                              
                        echo "building CMAPLE"                        
                        sh ${BUILD_SCRIPTS}/jenkins-cmake-build-default.sh ${BUILD_DEFAULT} ${REPO_DIR}
                        
                       
                        exit
                        EOF
                        """
                }
            }
        }*/

        stage ('Verify') {
            steps {
                script {
                    sh "ssh ${NCI_ALIAS} 'ls -lia ${WORKING_DIR} && ls -ila ${ALN_DIR}'"

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
    // sh "ssh ${NCI_ALIAS} 'rm -rf ${REPO_DIR} ${BUILD_SCRIPTS}'"
}