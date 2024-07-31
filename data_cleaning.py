

import pandas as pd
import re
import numpy as np



class DataCleaning:


    def clean_user_data(self,df):
        
        print("Checking for Null values:")
        df_na = df.isna().mean()*100
        print(df_na)

        print("Deleting rows with more than 2 Null values")
        drop_df=df.dropna(axis=0, thresh=2)
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


    def convert_product_weights(self, products_df):

        products_df = products_df.dropna(subset=['weight']).copy()
        products_df.loc[:, 'weight'] = products_df['weight'].str.replace('g .', 'g')

        def convert_to_kg(weight):
            def calculate_single_value(weight):
                if ' x ' in weight:
                    weight = weight.replace('g', '').split(' x ')
                    first_part = float(weight[0].strip())
                    second_part = float(weight[1].strip())
                    return first_part * second_part
                return None

            def convert_single_unit(value, unit):
                if unit == 'kg':
                    return float(value)
                elif unit == 'g':
                    return float(value) / 1000
                elif unit == 'ml':
                    return float(value) * 0.001
                elif unit == 'oz':
                    return float(value) * 0.0283495
                else:
                    return None

            # Check if weight contains ' x ' to calculate the combined value
            combined_value = calculate_single_value(weight)
            if combined_value is not None:
                return convert_single_unit(combined_value, 'g') 

            # If not, split the weight into value and unit
            for unit in ['kg', 'g', 'ml', 'oz']:
                if unit in weight:
                    value = weight.replace(unit, '').strip()
                    return convert_single_unit(value, unit)
            
            return None  
        
        products_df.loc[:, 'weight_kg'] = products_df['weight'].apply(convert_to_kg)


        return products_df
    

    
    def clean_products_data(self, products_df):
        products_df = products_df.dropna(subset=['weight_kg'])
        return products_df
    

    def date_formatting(self, df, column):
        df[column] = pd.to_datetime(df[column], errors='coerce')
        return df
    
    def email_clean(self, df, column):
        df[column] = df[column].apply(lambda x: x if '@' in str(x) else np.nan)
        return df
    

    def gibberish_clean(self, df,column_string):
        pattern = r'\d'
        gib_rows= df[column_string].str.contains(pattern, regex=True, na=False)
        #drop_df= df[~ gib_rows]
        return(gib_rows)

    
    def null_replace(self, df):
        replace_df = df.replace('NULL', pd.NA)
        #drop_df = replace_df.dropna(axis=0, thresh=2)
        return replace_df
    
    



        


