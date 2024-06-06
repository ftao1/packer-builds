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
    }
}
