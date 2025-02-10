pipeline {
    agent any

    parameters {
        string(name: 'TERRAFORM_FILES', defaultValue: 'lambda_function.tf,s3_bucket.tf', description: 'Comma-separated list of Terraform files to apply')
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
                    def files = TERRAFORM_FILES.split(',')
                    files.each { file ->
                        powershell "terraform init ${file}"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    def files = TERRAFORM_FILES.split(',')
                    files.each { file ->
                        powershell "terraform plan -out=tfplan_${file} ${file}"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    def files = TERRAFORM_FILES.split(',')
                    files.each { file ->
                        powershell "terraform apply -auto-approve tfplan_${file}"
                    }
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

