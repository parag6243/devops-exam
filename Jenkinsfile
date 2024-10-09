pipeline {
    agent any
    environment {
        AWS_REGION = 'ap-south-1'
        SUBNET_ID = ''
    }
    stages {
        stage("TF Init") {
            steps {
                script {
                    echo "Executing Terraform Init"
                    sh 'terraform init'
                }
            }
        }
        stage("TF Validate") {
            steps {
                script {
                    echo "Validating Terraform Code"
                    sh 'terraform validate'
                }
            }
        }
        stage("TF Plan") {
            steps {
                script {
                    echo "Executing Terraform Plan"
                    sh 'terraform plan'
                }
            }
        }
        stage("TF Apply") {
            steps {
                script {
                    echo "Executing Terraform Apply"
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Get Subnet ID') {
            steps {
                script {
                    echo "Retrieving Subnet ID"
                    def output = sh(script: 'terraform output -json', returnStdout: true).trim()
                    def json = readJSON text: output
                    env.SUBNET_ID = json.private_subnet_id.value
                    echo "Subnet ID: ${env.SUBNET_ID}"
                }
            }
        }
        stage('Invoke Lambda') {
            steps {
                script {
                    echo "Invoking AWS Lambda"
                    def response = sh(
                        script: """
                        aws lambda invoke \
                            --function-name new_lambda_function41 \
                            --payload '{"SUBNET_ID":"${env.SUBNET_ID}"}' \
                            --log-type Tail \
                            --region ${AWS_REGION} \
                            response.json
                        """,
                        returnStdout: true
                    ).trim()
                    
                    def jsonResponse = readJSON text: response
                    echo "Lambda Response: ${jsonResponse.LogResult}"
                    
                    // Decode base64 response
                    def decodedResponse = new String(jsonResponse.LogResult.decodeBase64())
                    echo "Decoded Response: ${decodedResponse}"
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up workspace'
            deleteDir()
        }
    }
}