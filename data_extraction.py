
##Create a new Python script named data_extraction.py and within it, create a class named DataExtractor.
##This class will work as a utility class, in it you will be creating methods that help extract data 
# from different data sources.
##The methods contained will be fit to extract data from a particular data source, 
# these sources will include CSV files, an API and an S3 bucket.

import pandas as pd

class DataExtractor:
   


    def __init__(self,engine):
        self.engine = engine

    

    def read_rds_table (self,table):
        table_df = pd.read_sql_table(table, self.engine)
        return table_df
        





data = DataExtractor(connector.engine)
legacy_users_df = data.read_rds_table('legacy_users')


print(legacy_users_df.head())
