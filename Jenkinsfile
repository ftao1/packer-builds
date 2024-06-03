pipeline {
    agent any

    stages {
        stage('Packer build Rocky image') {
            steps {
                dir('rocky94') {
                    sh """
                    packer init .
                    packer build -force -timestamp-ui rocky94.pkr.hcl
                    """
                }
            }
        }

        stage('Create Vagrant box') {
            steps {
                dir('rocky94/output') {
                    sh """
                    vagrant box add -f Rocky94 Rocky94.box
                    """
                }
            }
        }
    }
}

