import pymssql
from pymssql import Cursor, Connection


class Database:
    """ 数据库管理类 """
    def __init__(self, host='localhost', username='sa', password='1234', database='books'):
        self.host = host
        self.username = username
        self.password = password
        self.database = database
        self.connection: Connection = self.connect()
        self.connection.autocommit(True)
        self.cursor: Cursor = self.connection.cursor()

    def connect(self):
        return pymssql.connect(self.host, self.username, self.password, self.database)


database = Database()
