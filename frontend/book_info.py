from PyQt6.QtGui import QIntValidator
from PyQt6.QtWidgets import QDialog, QDialogButtonBox, QMessageBox

from backend.book import book_shelve, book_update
from frontend.ui import Ui_bookInfo
from utils import LengthIntValidator


class BookInfoDialog(QDialog, Ui_bookInfo):
    """ 图书信息增加修改界面 """
    def __init__(self, status, parent=None):
        super(BookInfoDialog, self).__init__(parent)
        self.setupUi(self)
        self.status = status
        if self.status == 0:
            self.label_9.hide()
            self.lineEdit_7.hide()

        self.dateEdit.setDisplayFormat('yyyy-MM-dd')

        self.lineEdit.setValidator(LengthIntValidator(13))
        self.lineEdit_4.setValidator(QIntValidator())
        self.lineEdit_5.setValidator(QIntValidator())

        self.buttonBox.accepted.connect(self.on_accept)
        self.buttonBox.rejected.connect(self.reject)
        self.buttonBox.button(QDialogButtonBox.StandardButton.Ok).setText('确认')
        self.buttonBox.button(QDialogButtonBox.StandardButton.Cancel).setText('取消')

    def on_accept(self):
        isbn = self.lineEdit.text()
        name = self.lineEdit_2.text()
        author = self.lineEdit_6.text()
        press = self.lineEdit_3.text()
        page = self.lineEdit_4.text()
        num = self.lineEdit_5.text()
        publish_date = self.dateEdit.date().toString('yyyy-MM-dd')
        if len(isbn) != 13:
            QMessageBox.warning(self, "警告", 'ISBN应为13位', QMessageBox.StandardButton.Yes)
            return
        res = None
        if self.status == 0:
            if num == '':
                QMessageBox.warning(self, "警告", '上架数量不能为空', QMessageBox.StandardButton.Yes)
                return
            res = book_shelve(isbn, author, name, press, page, publish_date, num)
        if self.status == 1:
            book_id = self.lineEdit_7.text()
            res = book_update(book_id, isbn, author, name, press, page, publish_date, num)
        if res[0]:
            return self.accept()
        else:
            QMessageBox.warning(self, "警告", res[1], QMessageBox.StandardButton.Yes)
