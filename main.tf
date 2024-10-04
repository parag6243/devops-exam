# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = data.aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = "ap-south-1a"  # Change as needed
  map_public_ip_on_launch = false
}

# Routing Table
resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.nat.id
  }
}

# Associate Route Table with Private Subnet
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Security Group for Lambda
resource "aws_security_group" "lambda_sg" {
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["10.0.0.0/16"]  # Modify as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Lambda Function
resource "aws_lambda_function" "my_lambda2" {
  function_name = "my_lambda_function2"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8" 
  role          = data.aws_iam_role.lambda.arn
  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
 # Path to your Lambda package
  source_code_hash = filebase64sha256("lambda/lambda_functionnew.zip")
   filename         = "lambda/lambda_functionnew.zip" 
}
