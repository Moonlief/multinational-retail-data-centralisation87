

import pandas as pd
import re


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
    
    def called_clean_store_data(self, df_api):

        print("Checking for Null values:")
        pdf_na = df_api.isna().mean()*100
        print(pdf_na)

        print("Deleting rows with more than 4 Null values")
        drop_pdf =df_api.dropna(axis=0, thresh=4)
        print(drop_pdf)

        print("Looking for duplicates:")
        print(df_api.duplicated())

        print("checking data types for each columns")
        print(df_api.info())

        return df_api


    def convert_product_weights(self, csv_df):
        def convert_weight(weight):
            weight = re.sub(r'[^\d.]+', '', str(weight))
            
            if 'kg' in weight:
                con_weight = weight.replace('kg', '').strip()
                return float(con_weight)
            elif 'g' in weight:
                con_weight = weight.replace('g', '').strip()

                return float(con_weight)/1000
            elif 'ml' in weight:
                con_weight = weight.replace('ml', '').strip()
                return float(con_weight)/1000
            else:
                return float(weight) 

        csv_df['weight'] = csv_df['weight'].apply(convert_weight)
        print(csv_df['weight'].isna().sum())
        csv_df['weight'].fillna(csv_df['weight'].mean(), inplace=True)
        return csv_df









