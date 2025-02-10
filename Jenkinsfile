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
        stage('Checkout from GitHub') {
            steps {
                git 'https://github.com/jfarrell720/CloudScripts.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    def files = params.TERRAFORM_FILES.split(',')
                    files.each { file ->
                        sh "terraform init ${file}"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    def files = params.TERRAFORM_FILES.split(',')
                    files.each { file ->
                        sh "terraform plan -out=tfplan_${file} ${file}"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    def files = params.TERRAFORM_FILES.split(',')
                    files.each { file ->
                        sh "terraform apply -auto-approve tfplan_${file}"
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
