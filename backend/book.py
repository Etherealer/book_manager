import pymssql

from utils import database, complete_date, convert_empty_strings_to_none


def book_shelve(isbn=None, author=None, name=None, press=None, page=None, publish_date=None, num=1):
    """
    图书上架
    """
    args = [isbn, author, name, press, page, complete_date(publish_date), num, pymssql.output(str)]
    args = convert_empty_strings_to_none(args)
    output = database.cursor.callproc('book_shelve', args)
    if output[-1] == '':
        return True, ''
    else:
        return False, output[-1]


def book_update(book_id, isbn=None, author=None, name=None, press=None, page=None, publish_date=None, num=None):
    """
    图书信息更新
    """
    args = [book_id, isbn, author, name, press, page, publish_date, num, pymssql.output(str)]
    output = database.cursor.callproc('book_update', args)
    if output[-1] == '':
        return True, ''
    else:
        return False, output[-1]


def book_search(book_id=None, isbn=None, name=None, author=None, press=None):
    """
    图书检索
    """
    args = convert_empty_strings_to_none([book_id, isbn, name, author, press])
    try:
        database.cursor.callproc('book_search', args)
        result = database.cursor.fetchall()
    except pymssql.StandardError:
        return False
    return result


def book_remove(book_id):
    """
    图书下架
    """
    output = database.cursor.callproc('book_remove', [book_id, pymssql.output(str)])
    if output[-1] == '':
        return True, ''
    else:
        return False, output[-1]


def book_borrow(reader_id, book_id):
    """
    图书借阅
    """
    output = database.cursor.callproc('book_borrow', [reader_id, book_id, pymssql.output(str)])
    if output[-1] == '':
        return True, ''
    else:
        return False, output[-1]


def book_return(reader_id=None, book_id=None):
    """
    图书归还
    """
    output = database.cursor.callproc('book_return', [reader_id, book_id, pymssql.output(str)])
    if output[-1] == '':
        return True, ''
    else:
        return False, output[-1]


def all_book_info_search():
    """
    获取所有图书的信息
    """
    database.cursor.callproc('all_book_info_search')
    if database.cursor.description is not None:
        result = database.cursor.fetchall()
        return result
    else:
        return []


if __name__ == '__main__':
    print(all_book_info_search())
