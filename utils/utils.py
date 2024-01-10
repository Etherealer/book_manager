import datetime
import decimal

from PyQt6.QtGui import QStandardItem, QValidator


def complete_date(date_str):
    """
    日期处理 对'2014-01'类型日期转为 '2014-01-01'
    """
    try:
        # 尝试用 YYYY-MM-DD 的格式解析日期
        datetime.datetime.strptime(date_str, '%Y-%m-%d')
        return date_str
    except ValueError:
        try:
            # 尝试用 YYYY-MM 的格式解析日期
            datetime.datetime.strptime(date_str, '%Y-%m')
            return date_str + '-01'
        except ValueError:
            # 如果两种格式都不符合，返回错误信息
            return "无效的日期格式"


def convert_empty_strings_to_none(input_list):
    """
    将空字符串转为 None
    """
    return [None if item == '' else item for item in input_list]


def table_data_draw(table, model, data):
    """
    绘制 tableView 表格中的数据
    """
    model.removeRows(0, model.rowCount())
    for row_data in data:
        row = []
        for item in row_data:
            if isinstance(item, datetime.date):
                formatted_date = item.strftime("%Y-%m-%d")
                row.append(QStandardItem(formatted_date))
            elif item is None:
                row.append(QStandardItem(''))
            elif isinstance(item, decimal.Decimal):
                row.append(QStandardItem(f"{item:.2f}"))
            else:
                row.append(QStandardItem(str(item)))
        model.appendRow(row)
    table.setModel(model)


class LengthIntValidator(QValidator):
    """
    长度整数验证器 限制长度不超过给定范围 同时必须为数字
    """
    def __init__(self, length):
        super().__init__()
        self.length = length

    def validate(self, string, pos):
        if len(string) > self.length:
            return QValidator.State.Invalid, string, pos
        if string == '':
            return QValidator.State.Intermediate, string, pos
        if not string.isdigit():
            return QValidator.State.Invalid, string, pos

        if len(string) == self.length:
            return QValidator.State.Acceptable, string, pos

        return QValidator.State.Intermediate, string, pos


def convert_none_to_empty_string(input_list):
    """
    将 None 转为空字符串
    """
    return ['' if item is None else item for item in input_list]
