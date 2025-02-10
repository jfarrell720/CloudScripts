pipeline {
    agent any

    parameters {
        string(name: 'TERRAFORM_DIRECTORY', defaultValue: 'terraform', description: 'Directory containing Terraform configuration')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Terraform Init') {
            steps {
                script {
                    powershell """
                        cd ${params.TERRAFORM_DIRECTORY}
                        terraform init
                    """
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    powershell """
                        cd ${params.TERRAFORM_DIRECTORY}
                        terraform plan -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    powershell """
                        cd ${params.TERRAFORM_DIRECTORY}
                        terraform apply -auto-approve tfplan
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
    }
}
