
import pandas as pd

class DataExtractor:
   


    def __init__(self,connector):
        self.connector = connector


    def read_rds_table (self,table_name):
        query = f"SELECT * FROM {table_name}"
        df = pd.read_sql(query, self.connector)
        self.connector.close()
        return df
        






