import pymssql

from utils import database, convert_empty_strings_to_none


def reader_add(reader_id=None, id_card=None, name=None, gender=None, reader_type=None):
    """
    读者添加
    """
    args = [reader_id, id_card, name, gender, reader_type, pymssql.output(str)]
    args = convert_empty_strings_to_none(args)
    output = database.cursor.callproc('reader_add', args)
    if output[-1] == '':
        return True, ''
    else:
        return False, output[-1]


def all_reader_info_search():
    """
    获取所有的读者信息
    """
    database.cursor.callproc('all_reader_info_search')
    if database.cursor.description is not None:
        result = database.cursor.fetchall()
        return result
    return []


def reader_update(reader_id=None, id_card=None, name=None, gender=None, reader_type=None):
    """
    读者信息更新
    """
    args = [reader_id, id_card, name, gender, reader_type, pymssql.output(str)]
    output = database.cursor.callproc('reader_update', args)
    if output[-1] == '':
        return True, ''
    else:
        return False, output[-1]


def reader_remove(reader_id=None):
    """
    读者删除
    """
    output = database.cursor.callproc('reader_delete', [reader_id, pymssql.output(str)])
    if output[-1] == '':
        return True, ''
    else:
        return False, output[-1]


def reader_search(reader_id=None, id_card=None, name=None):
    """
    读者查询
    """
    args = convert_empty_strings_to_none([reader_id, name, id_card])
    try:
        database.cursor.callproc('reader_search', args)
        result = database.cursor.fetchall()
    except pymssql.StandardError:
        return False
    return result


def reader_history_borrow_info_search(reader_id=None):
    """
    读者历史借阅信息查询
    """
    database.cursor.callproc('reader_history_borrow_info_search', [reader_id])
    if database.cursor.description is not None:
        result = database.cursor.fetchall()
        return result
    else:
        return []


def reader_recharge_info_search(reader_id=None):
    """
    读者充值扣款信息查询
    """
    database.cursor.callproc('recharge_deduction_search', [reader_id])
    if database.cursor.description is not None:
        result = database.cursor.fetchall()
        return result
    else:
        return False


def reader_borrow_info_search(reader_id=None, id_card=None, name=None):
    """
    根据读者编号或身份证号或姓名查询读者的借阅信息(管理员)
    """
    args = convert_empty_strings_to_none([reader_id, name, id_card])
    database.cursor.callproc('reader_borrow_info_search', args)
    if database.cursor.description is not None:
        result = database.cursor.fetchall()
        return result
    else:
        return False


def balance_recharge(reader_id=None, money=None):
    """
    余额充值
    """
    args = [reader_id, money, pymssql.output(str)]
    output = database.cursor.callproc('reader_recharge', args)
    if output[-1] == '':
        return True, ''
    else:
        return False, output[-1]


def reader_self_borrow_info_search(reader_id=None):
    """
    读者借阅信息查询(读者)
    """
    database.cursor.callproc('reader_self_borrow_info_search', [reader_id])
    if database.cursor.description is not None:
        result = database.cursor.fetchall()
        return result
    else:
        return []


def reset_password(reader_id=None):
    """
    重置读者密码
    """
    try:
        database.cursor.callproc('reader_password_reset', [reader_id])
    except pymssql.StandardError:
        return False
    return True


if __name__ == '__main__':
    print(all_reader_info_search())
