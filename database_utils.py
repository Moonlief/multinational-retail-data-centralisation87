
class DatabaseConnector:
    def __init__(self):
        self.host = None
        self.user = None
        self.password = None
        self.database = None
        self.port = None
        self.engine = None


    def read_db_creds (self,yaml_file):
        import yaml
        with open(yaml_file, 'r') as credentials:
            data_loaded = yaml.safe_load(credentials)
        self.host= data_loaded['HOST']
        self.user = data_loaded['USER']
        self.password = data_loaded['PASSWORD']
        self.database = data_loaded['DATABASE']
        self.port = data_loaded['PORT']
        
        print("Credentials loaded sucessfully!!")
        return yaml_file

   


    def init_db_engine(self):
        from sqlalchemy import create_engine
        DATABASE_TYPE = 'postgresql'
        DBAPI = 'psycopg2'
        self.engine = create_engine(f"{DATABASE_TYPE}+{DBAPI}://{self.user}:{self.password}@{self.host}:{self.port}/{self.database}")
        
        connection = self.engine.execution_options(isolation_level='AUTOCOMMIT').connect()
        print("Connection successful!")
        return connection

    def init_db_engine_postgresql(self):
        from sqlalchemy import create_engine
        self.engine = create_engine(f"postgresql://{self.user}:{self.password}@{self.host}:{self.port}/{self.database}")
        connection = self.engine.execution_options(isolation_level='AUTOCOMMIT').connect()
        print("Connection successful!")
        return connection

    
    def list_db_tables(self):
        from sqlalchemy import inspect
        inspector = inspect(self.engine)
        tables =inspector.get_table_names()
        print("Tables in the database:", tables)
        return tables
    
    def upload_to_db(self,connection, df, table_name):
        engine = connection
        df.to_sql(table_name, engine, if_exists='replace', index=False)
        print(f"Data uploaded successfully to {table_name} table.")


