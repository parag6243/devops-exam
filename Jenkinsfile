pipeline{
    agent any
    stages{
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
            sh 'aws lambda invoke --function-name new_lambda_function --log-type Tail output.txt'
            sh 'cat output.txt '

            
           

        }
    }
}
    }
}