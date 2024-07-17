

import pandas as pd


class DataCleaning:


    def clean_user_data(self,df):
        
        print("Checking for Null values:")
        df_na = df.isna().mean()*100
        print(df_na)

        print("Deleting rows with more than 4 Null values")
        drop_df=df.dropna(axis=0, thresh=4)
        print(drop_df)

        print("Looking for duplicates:")
        print(df.duplicated())

        print("checking data types for each columns")
        print(df.info())







