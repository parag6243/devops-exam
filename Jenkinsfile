pipeline{
    agent any
    environment {
        AWS_REGION = 'ap-south-1'
        SUBNET_ID = ''
    }
    stages{
        stage("TF Init"){
            steps{
                script{
                        echo "Executing Terraform Init"
                        sh 'terraform init'
                    }
                
            }
        }
        stage("TF Validate"){
            steps{
                script{
                        echo "Validating Terraform Code"
                        sh 'terraform validate'
                    }
                
            }
        }
        stage("TF Plan"){
            steps{
                script{
                        echo "Executing Terraform Plan"
                        sh 'terraform plan'
                    }
                
            }
        }
        stage("TF Apply"){
            steps{
                script{
                        echo "Executing terraform apply"
                        sh 'terraform apply -auto-approve'
                    }
                
            }
        }

        stage('Get Subnet ID') {
            steps {
                script {
                    // Get the subnet ID from Terraform output
                    def output = sh(script: 'terraform output -json', returnStdout: true)
                    def json = readJSON(text: output)
                    env.SUBNET_ID = json.private_subnet.value
                }
            }
        }
        stage('Invoke Lambda') {
            steps {
                script {
                    echo "Invoking your AWS Lambda"
                    sh "aws lambda invoke --function-name my_lambda_function --log-type Tail response.json"
                    def response = readFile('response.json')
                    def jsonResponse = readJSON(text: response)
                    echo "Lambda Response: ${jsonResponse.LogResult}"
                    // Decode base64 response
                    def decodedResponse = new String(jsonResponse.LogResult.decodeBase64())
                    echo "Decoded Response: ${decodedResponse}"
                }
            }
        }
    }
}
