
import pandas as pd
import tabula



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
        print(read_pdf)
        pdf_df_list = [pd.DataFrame(page) for page in read_pdf]
        pdf_df = pd.concat(pdf_df_list, ignore_index=True)
        self.connector.close()
        return pdf_df

        






