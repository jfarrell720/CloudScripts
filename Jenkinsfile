pipeline {
    agent any

    parameters {
        string(name: 'TERRAFORM_FILES', defaultValue: 'LambdaRoles.tf,FetchTimeLambda.tf', description: 'Comma-separated list of Terraform files to build')
        string(name: 'GITHUB_REPO', defaultValue: 'https://github.com/jfarrell720/CloudScripts.git', description: 'GitHub repository URL')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the code from GitHub
                    git url: "${params.GITHUB_REPO}", branch: 'main'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Split the input files into an array
                    def terraformFiles = params.TERRAFORM_FILES.split(',')
                    
                    // Check if any of the specified Terraform files have changed
                    def changes = sh(script: "git diff --name-only HEAD~1", returnStdout: true).trim()
                    
                    // Only run Terraform Init if any of the specified files have changed
                    def shouldRunInit = terraformFiles.any { file -> changes.contains(file) }
                    if (shouldRunInit) {
                        echo 'Relevant Terraform files changed, proceeding with terraform init.'
                        powershell """
                            terraform init
                        """
                    } else {
                        echo 'No relevant changes detected for Terraform Init.'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    def terraformFiles = params.TERRAFORM_FILES.split(',')
                    def changes = sh(script: "git diff --name-only HEAD~1", returnStdout: true).trim()

                    // Only run Terraform Plan if any of the specified files have changed
                    def shouldRunPlan = terraformFiles.any { file -> changes.contains(file) }
                    if (shouldRunPlan) {
                        echo 'Relevant Terraform files changed, proceeding with terraform plan.'
                        powershell """
                            terraform plan -out=tfplan
                        """
                    } else {
                        echo 'No relevant changes detected for Terraform Plan.'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    def terraformFiles = params.TERRAFORM_FILES.split(',')
                    def changes = sh(script: "git diff --name-only HEAD~1", returnStdout: true).trim()

                    // Only run Terraform Apply if any of the specified files have changed
                    def shouldRunApply = terraformFiles.any { file -> changes.contains(file) }
                    if (shouldRunApply) {
                        echo 'Relevant Terraform files changed, proceeding with terraform apply.'
                        powershell """
                            terraform apply -auto-approve tfplan
                        """
                    } else {
                        echo 'No relevant changes detected for Terraform Apply.'
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
