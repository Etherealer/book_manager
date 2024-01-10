from PyQt6.QtGui import QStandardItemModel
from PyQt6.QtWidgets import QWidget, QTableView, QHeaderView, QMessageBox

from backend.book import book_return
from backend.reader import reader_borrow_info_search, reader_self_borrow_info_search
from frontend.recharge import RechargeDialog
from frontend.ui import Ui_borrow
from utils import table_data_draw


class BorrowForm(QWidget, Ui_borrow):
    """ 借阅管理界面 """
    def __init__(self, username, user_type, parent=None):
        super(BorrowForm, self).__init__(parent)
        self.setupUi(self)
        self.username = username
        self.user_type = user_type

        if user_type == "读者":
            self.widget_2.hide()
            self.model = QStandardItemModel()
            self.model.setHorizontalHeaderLabels(
                ['图书编号', 'ISBN', '书名', '作者', '出版社', '页数', '出版日期', '借阅时间'])
        if user_type == "管理员":
            self.pushButton.setVisible(False)
            self.pushButton_2.setVisible(False)
            self.model = QStandardItemModel()
            self.model.setHorizontalHeaderLabels(['读者编号', '图书编号', '读者姓名', '书名', '借阅时间'])

        self.pushButton_3.clicked.connect(self.borrow_search)
        self.pushButton_2.clicked.connect(self.balance_recharge)
        self.pushButton.clicked.connect(self.book_return)
        self.pushButton_4.clicked.connect(self.reader_borrow_info)
        self.tableView.setSelectionBehavior(QTableView.SelectionBehavior.SelectRows)
        header = self.tableView.horizontalHeader()
        header.setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        # self.reader_borrow_info()

    def borrow_search(self):
        search_type = self.comboBox.currentText()
        text = self.lineEdit.text()
        if search_type == '读者编号':
            args = [text, None, None]
        elif search_type == '身份证号':
            args = [None, text, None]
        else:
            args = [None, None, text]
        res = reader_borrow_info_search(*args)
        if res is False:
            QMessageBox.warning(self, "提示", "该用户不存在或无借阅记录", QMessageBox.StandardButton.Yes)
            return
        else:
            table_data_draw(self.tableView, self.model, res)

    def reader_borrow_info(self):
        if self.user_type == '读者':
            data = reader_self_borrow_info_search(self.username)
            table_data_draw(self.tableView, self.model, data)
        if self.user_type == '管理员':
            self.model.removeRows(0, self.model.rowCount())
            self.tableView.setModel(self.model)

    def balance_recharge(self):
        page = RechargeDialog(self.username)
        page.exec()

    def book_return(self):
        index = self.tableView.selectionModel().selectedRows()
        if not index:
            QMessageBox.warning(self, "警告", "您未选择要归还的书籍，请点击书籍后再点击该按钮",
                                QMessageBox.StandardButton.Yes)
            return
        book_id = self.model.item(index[0].row(), 0).text()
        res = book_return(self.username, book_id)
        if res[0]:
            QMessageBox.warning(self, "提醒", '归还成功', QMessageBox.StandardButton.Yes)
            self.reader_borrow_info()
        else:
            QMessageBox.warning(self, "警告", res[1], QMessageBox.StandardButton.Yes)
