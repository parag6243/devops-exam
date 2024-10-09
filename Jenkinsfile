pipeline {
    agent any
    environment {
        AWS_REGION = 'ap-south-1'
        SUBNET_ID = ''
    }    stages{
        stage("TF Init"){
            steps{
                echo "Executing Terraform Init"
                 sh"terraform init" 
            }
        }
        stage("TF Validate"){
            steps{
                echo "Validating Terraform Code"
                sh"terraform validate"
            }
        }
        stage("TF Plan"){
            steps{
                echo "Executing Terraform Plan"
                sh"terraform plan"
            }
        }
        stage('Install Dependencies') {
            steps {
                script {
                    // Install the requests library
                    sh 'pip install requests'
                }
            }
        }
        stage("TF Apply"){
            steps{
                echo "Executing Terraform Apply"
                sh"terraform apply --auto-approve"
            }
        }

        stage('Invoke Lambda') {
    steps {
        script {
            def output = sh(script: 'terraform output -json', returnStdout: true).trim()
                    def json = readJSON text: output
                    env.SUBNET_ID = json.private_subnet_id.value
                    echo "Subnet ID: ${env.SUBNET_ID}"
        }

       stage('Invoke Lambda') {
    steps {
        script {
            echo "Invoking AWS Lambda"
                    def response = sh(script: "aws lambda invoke --function-name new_lambda_function --payload '{\"SUBNET_ID\":\"${env.SUBNET_ID}\"}' --log-type Tail response.json", returnStdout: true)
                    def jsonResponse = readJSON text: response
                    echo "Lambda Response: ${jsonResponse.LogResult}"
                    
                    // Decode base64 response
                    def decodedResponse = new String(jsonResponse.LogResult.decodeBase64())
                    echo "Decoded Response: ${decodedResponse}"
        }
    }
}
    }
}
    