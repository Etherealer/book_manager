from PyQt6.QtCore import QDate
from PyQt6.QtGui import QStandardItemModel
from PyQt6.QtWidgets import QWidget, QTableView, QMessageBox, QHeaderView

from backend.book import all_book_info_search, book_remove, book_borrow
from frontend.book_info import BookInfoDialog
from frontend.book_search import BookSearchDialog
from frontend.ui import Ui_book
from utils import table_data_draw


class BookForm(QWidget, Ui_book):
    """ 图书管理页面 """
    def __init__(self, username, user_type, parent=None):
        super(BookForm, self).__init__(parent)
        self.setupUi(self)
        self.username = username
        if user_type == "读者":
            self.pushButton_3.setVisible(False)
            self.pushButton_4.setVisible(False)
            self.pushButton_2.setVisible(False)
        if user_type == "管理员":
            self.pushButton_5.setVisible(False)

        self.pushButton_2.clicked.connect(self.book_add)
        self.pushButton.clicked.connect(self.book_search)
        self.pushButton_6.clicked.connect(self.all_book_info)
        self.pushButton_3.clicked.connect(self.book_change)
        self.pushButton_4.clicked.connect(self.book_remove)
        self.pushButton_5.clicked.connect(self.book_borrow)

        self.model = QStandardItemModel()
        self.model.setHorizontalHeaderLabels(
            ['图书编号', 'ISBN', '书名', '作者', '出版社', '页数', '出版日期', '总数', '借阅人数'])

        header = self.tableView.horizontalHeader()
        header.setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        self.all_book_info()

        self.tableView.setSelectionBehavior(QTableView.SelectionBehavior.SelectRows)

    def book_add(self):
        page = BookInfoDialog(0)
        page.exec()
        self.all_book_info()

    def book_search(self):
        page = BookSearchDialog(self.tableView, self.model)
        page.exec()

    def book_borrow(self):
        index = self.tableView.selectionModel().selectedRows()
        if not index:
            message = "您未选择要借阅的书籍，请点击书籍信息后再点击该按钮"
            QMessageBox.warning(self, "警告", message, QMessageBox.StandardButton.Yes)
            return
        book_id = self.model.item(index[0].row(), 0).text()
        res = book_borrow(self.username, book_id)
        if res[0]:
            self.all_book_info()
            QMessageBox.warning(self, "提醒", '借阅成功', QMessageBox.StandardButton.Yes)
        else:
            QMessageBox.warning(self, "警告", res[1], QMessageBox.StandardButton.Yes)

    def all_book_info(self):
        data = all_book_info_search()
        table_data_draw(self.tableView, self.model, data)

    def book_change(self):
        index = self.tableView.selectionModel().selectedRows()
        if not index:
            QMessageBox.warning(self, "警告", "您未选择要修改的书籍，请点击书籍信息后再点击该按钮",
                                QMessageBox.StandardButton.Yes)
            return

        page = BookInfoDialog(1)
        row_data = [self.model.item(index[0].row(), i).text() for i in range(self.model.columnCount())]
        page.lineEdit_7.setText(row_data[0])
        page.lineEdit.setText(row_data[1])
        page.lineEdit_2.setText(row_data[2])
        page.lineEdit_6.setText(row_data[3])
        page.lineEdit_3.setText(row_data[4])
        page.lineEdit_4.setText(row_data[5])
        page.dateEdit.setDate(QDate.fromString(row_data[6], 'yyyy-MM-dd'))
        page.lineEdit_5.setText(row_data[7])
        page.exec()
        self.all_book_info()

    def book_remove(self):
        index = self.tableView.selectionModel().selectedRows()
        if not index:
            QMessageBox.warning(self, "警告", "您未选择要下架的书籍，请点击书籍信息后再点击该按钮",
                                QMessageBox.StandardButton.Yes)
            return
        book_id = self.model.item(index[0].row(), 0).text()
        res = book_remove(book_id)
        if res[0]:
            self.all_book_info()
        else:
            QMessageBox.warning(self, "警告", res[1], QMessageBox.StandardButton.Yes)
