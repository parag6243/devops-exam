import json
import boto3
import requests
import os

def lambda_handler(event, context):
    subnet_id = os.environ['SUBNET_ID']
    payload = {
        "subnet_id": subnet_id,
        "name": "Parag Patil",  
        "email": "parag22patil@gmail.com"  
    }

    headers = {'X-Siemens-Auth': 'test'}

    response = requests.post(
        "https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data",
        headers=headers,
        json=payload
    )

    return {
        'statusCode': response.status_code,
        'body': json.dumps(response.json())
    }
