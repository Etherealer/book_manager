import pymssql

from utils import database

user_type_dict = {"读者": "reader", "管理员": "admin"}


def user_login(username, password, user_type):
    """
    用户登录
    """
    database.cursor.execute(f"SELECT dbo.user_login_check('{username}','{password}','{user_type_dict[user_type]}')")
    return database.cursor.fetchone()[0]


def password_change(username, user_type, old_password, old_password_confirm, new_password):
    """
    密码修改
    """
    func_name = None
    if user_type_dict[user_type] == 'admin':
        func_name = 'admin_password_change'
    if user_type_dict[user_type] == 'reader':
        func_name = 'reader_password_change'
    args = [username, old_password, old_password_confirm, new_password, pymssql.output(str)]
    output = database.cursor.callproc(func_name, args)

    if output[-1] == '':
        return True, ''
    else:
        return False, output[-1]


if __name__ == '__main__':
    print(user_login('admin', 'admin', '管理员'))
