pipeline {
    agent any

    environment {
        VAGRANT_BOX_PATH = "/vagrant_boxes/Rocky94.box"
    }

    stages {
        stage('Setup') {
            steps {
                script {
                    wrap([$class: 'BuildUser']) {
                        def userId = env.BUILD_USER_ID ?: "jenkins" // Default to 'jenkins' if not found
                        echo "Build initiated by: ${userId}"

                        // Store userId in environment variable for use in other stages
                        env.INITIATING_USER = userId

                        // Create the /ISO and /vagrant_boxes directories if it doesn't exist
                        sh """
                        sudo mkdir -p /ISO /vagrant_boxes
                        sudo chown jenkins:jenkins /ISO /vagrant_boxes
                        """
                    }
                }
            }
        }

        stage('Packer build Rocky image') {
            steps {
                // Packer build Rocky Linux
                dir('rocky94') {
                    sh """
                    packer init .
                    packer build -force -timestamp-ui rocky94.pkr.hcl
                    """
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // Remove lock files in /ISO
                    sh """
                    sudo rm -rf /ISO/*.lock
                    """
                }
            }
        }

        stage('Verify Vagrant Box Path') {
            steps {
                // Verify the Vagrant box file exists and has the correct permissions
                sh """
                if [ -f ${VAGRANT_BOX_PATH} ]; then
                    echo "Vagrant box file exists: ${VAGRANT_BOX_PATH}"
                    ls -l ${VAGRANT_BOX_PATH}
                else
                    echo "Vagrant box file does not exist: ${VAGRANT_BOX_PATH}"
                    exit 1
                fi
                """
            }
        }

        stage('Add Vagrant Box') {
            steps {
                script {
                    def userId = env.INITIATING_USER
                    def boxPath = VAGRANT_BOX_PATH
                    def boxName = "Rocky94"
                    echo "Adding Vagrant box as user: ${userId}"

                    // Use sudo to switch to the initiating user and add the Vagrant box
                    sh """
                    sudo -u ${userId} vagrant box add -f ${boxPath} --name ${boxName}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
