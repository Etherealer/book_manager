from PyQt6.QtGui import QStandardItemModel
from PyQt6.QtWidgets import QWidget, QHeaderView, QTableView

from backend.reader import reader_search, reader_history_borrow_info_search, reader_recharge_info_search
from frontend.password_change import PasswordChangeDialog
from frontend.ui import Ui_user
from frontend.user_info import UserInfoDialog
from utils import convert_none_to_empty_string, table_data_draw


class UserForm(QWidget, Ui_user):
    """ 个人中心界面 """
    def __init__(self, username, user_type, parent=None):
        super(UserForm, self).__init__(parent)
        self.setupUi(self)
        self.username = username
        self.user_type = user_type
        self.pushButton.clicked.connect(self.user_info_change)
        self.pushButton_2.clicked.connect(self.user_password_change)

        self.model = QStandardItemModel()
        self.model.setHorizontalHeaderLabels(
            ['ISBN', '书名', '作者', '出版社', '页数', '出版日期', '借阅日期', '归还日期'])

        header = self.tableView.horizontalHeader()
        header.setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        self.tableView.setSelectionMode(QTableView.SelectionMode.NoSelection)

        self.model_2 = QStandardItemModel()
        self.model_2.setHorizontalHeaderLabels(['操作类型', '数额', '操作时间'])

        header = self.tableView_2.horizontalHeader()
        header.setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        self.tableView_2.setSelectionMode(QTableView.SelectionMode.NoSelection)

    def user_info_change(self):
        page = UserInfoDialog(3, None, None)
        page.lineEdit.setText(self.lineEdit.text())
        page.lineEdit_9.setText(self.lineEdit_2.text())
        page.lineEdit_7.setText(self.lineEdit_3.text())
        page.comboBox.setCurrentText(self.lineEdit_4.text())
        page.comboBox_2.setCurrentText(self.lineEdit_5.text())
        page.exec()

    def user_info_search(self):
        res = reader_search(self.username)[0]
        res = convert_none_to_empty_string(res)
        self.lineEdit.setText(res[0])
        self.lineEdit_2.setText(res[1])
        self.lineEdit_6.setText(f"{res[5]:.2f}")
        self.lineEdit_3.setText(res[2])
        self.lineEdit_4.setText(res[3])
        self.lineEdit_5.setText(res[4])

    def user_password_change(self):
        page = PasswordChangeDialog(self.username, self.user_type)
        page.exec()

    def user_history_borrow_info_search(self):
        res = reader_history_borrow_info_search(self.username)
        if res:
            table_data_draw(self.tableView, self.model, res)

    def user_recharge_info_search(self):
        res = reader_recharge_info_search(self.username)
        if res:
            table_data_draw(self.tableView_2, self.model_2, res)

    def init(self):
        self.user_info_search()
        self.user_recharge_info_search()
        self.user_history_borrow_info_search()
