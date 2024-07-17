

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

        return df
              
    def clean_card_data(self,clean_pdf):
        print("Checking for Null values:")
        pdf_na = clean_pdf.isna().mean()*100
        print(pdf_na)

        print("Deleting rows with more than 4 Null values")
        drop_pdf =clean_pdf.dropna(axis=0, thresh=4)
        print(drop_pdf)

        print("Looking for duplicates:")
        print(clean_pdf.duplicated())

        print("checking data types for each columns")
        print(clean_pdf.info())

        return clean_pdf
    







