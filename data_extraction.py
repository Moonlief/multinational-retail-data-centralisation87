
import pandas as pd
import tabula
import requests
import boto3



class DataExtractor:
   


    def __init__(self,connector):
        self.connector = connector


    def read_rds_table (self,table_name):
        query = f"SELECT * FROM {table_name}"
        read_sql = pd.read_sql(query, self.connector)
        df = pd.DataFrame(read_sql)
        self.connector.close()
        return df
    
    def retrieve_pdf_data(self, pdf_link):
        read_pdf = tabula.read_pdf(pdf_link, pages="all")
        pdf_df_list = [pd.DataFrame(page) for page in read_pdf]
        pdf_df = pd.concat(pdf_df_list, ignore_index=True)
        return pdf_df
    
    def list_number_of_stores(self,endpoint, headers):
        response = requests.get(endpoint, headers=headers)
        if response.status_code == 200:
            data = response.json()
            number_of_stores = data.get('number_stores')
            return(number_of_stores)
        else:
            response.raise_for_status()

    
    
    def retrieve_stores_data(self, endpoint, headers, number_of_stores):
        stores_data = []
        for store_number in range(0, number_of_stores + 1):
            response = requests.get(endpoint.format(store_number=store_number), headers=headers)
            if response.status_code == 200:
                stores_data.append(response.json())
                
            else:
                print(f"Failed to retrieve data for store number {store_number}. Status code: {response.status_code}")
        
        return pd.DataFrame(stores_data)   

 

    
    def download_csv_from_s3(self,s3_bucket, s3_object_key,local_file_path):
        s3 = boto3.client('s3')
        s3.download_file(s3_bucket, s3_object_key, local_file_path)
        df_csv = pd.read_csv(s3_object_key)
        df_s3 = pd.DataFrame(df_csv)
        return df_s3
    
    def extract_json_from_s3(self,s3_bucket, s3_object_key):
        s3 = boto3.client('s3')
        obj = s3.get_object(Bucket=s3_bucket, Key=s3_object_key)
        content = obj['Body'].read().decode('utf-8')
        df_s3 = pd.read_json(content)
        return df_s3
    




        






