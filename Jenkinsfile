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
                    powershell "terraform init -chdir=${params.TERRAFORM_DIRECTORY}"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    powershell "terraform -chdir=${params.TERRAFORM_DIRECTORY} plan -out=tfplan"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    powershell "terraform -chdir=${params.TERRAFORM_DIRECTORY} apply -auto-approve tfplan"
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