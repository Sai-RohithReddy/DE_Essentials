import boto3
import csv
from io import StringIO

def lambda_handler(event, context):
    s3_bucket = None
    input_s3_key = None
    
    for record in event["Records"]:
        s3_bucket = record["s3"]["bucket"]["name"]
        input_s3_key = record["s3"]["object"]["key"]

    # Initialize the S3 client
    s3 = boto3.client('s3')

    try:
        # Read the CSV file from S3
        print('Reading file ' + input_s3_key +  ' from S3 bucket : ' + s3_bucket)
        response = s3.get_object(Bucket=s3_bucket, Key=input_s3_key)
        csv_content = response['Body'].read().decode('utf-8')

        valid_data = ''
        number_of_fields = None
        IS_HEADER = True
        
        # Parse the CSV content using the csv module
        csv_reader = csv.reader(StringIO(csv_content))
        for row in csv_reader:
            if (IS_HEADER):
                number_of_fields = len(row)
                IS_HEADER = False
                valid_data += ",".join(row) + "\n"
            else:
                if(number_of_fields != len(row)):
                    print('Invalid data detected ::> ' + str(row))
                elif( row[0] == '' or row[0] == ''):
                    print('Invalid emp_id detected ::> ' + str(row))
                else:
                    valid_data += ",".join(row) + "\n"
            
        output_s3_key = 'output_data/employee/sample_emp_data.csv'
    
        print('Writing file ' + output_s3_key +  ' into S3 bucket : ' + s3_bucket)
        write_data_to_s3(valid_data, s3_bucket, output_s3_key)
        
        return {
            'statusCode': 200,
            'body': 'CSV file read successfully'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'Error reading CSV file: {str(e)}'
        }
        


def write_data_to_s3(data, bucket_name, object_key):
    try:
        # Initialize the S3 client
        s3 = boto3.client('s3')

        # Write the data to S3
        s3.put_object(Bucket=bucket_name, Key=object_key, Body=data)

        return True
        
    except Exception as e:
        print(f"Error writing data to S3: {str(e)}")
        return False



