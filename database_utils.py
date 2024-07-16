



class DatabaseConnector:
    def __init__(self):
        self.host = None
        self.user = None
        self.password = None
        self.database = None
        self.port = None
        self.engine = None


    def read_db_creds (self):
        import yaml
        with open('/Users/student/AICORE/AWS/Project_3/db_creds.yaml', 'r') as credentials:
            data_loaded = yaml.safe_load(credentials)
        self.host= data_loaded['RDS_HOST']
        self.user = data_loaded['RDS_USER']
        self.password = data_loaded['RDS_PASSWORD']
        self.database = data_loaded['RDS_DATABASE']
        self.port = data_loaded['RDS_PORT']
        print("Credentials loaded successfully!")


    def init_db_engine(self):
        from sqlalchemy import create_engine
        DATABASE_TYPE = 'postgresql'
        DBAPI = 'psycopg2'
        engine = create_engine(f"{DATABASE_TYPE}+{DBAPI}://{self.user}:{self.password}@{self.host}:{self.port}/{self.database}")
        connection = engine.execution_options(isolation_level='AUTOCOMMIT').connect()
        print("Connection successful!")
        return connection
    
    def list_db_tables(self):
        from sqlalchemy import inspect
        inspector = inspect(self.engine)
        inspector.get_table_names()
    
    #def upload_to_db():


connector = DatabaseConnector()
connector.read_db_creds()
connector.init_db_engine()
connector.list_db_tables()

