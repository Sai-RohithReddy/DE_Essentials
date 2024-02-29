import os
import boto3
import requests

os.environ.setdefault('AWS_DEFAULT', 'default')

s3_client = boto3.client('s3')

file = '2021-01-15-0.json.gz'
res = requests.get(f'https://data.gharchive.org/{file}')

upload_res = s3_client.put_object(
    Bucket='rr-github',
    Key='2021-01-15-0.json.gz',
    Body=res.content
  )

print(upload_res)