from PyQt6.QtWidgets import QDialog, QDialogButtonBox, QMessageBox

from backend.book import book_search
from frontend.ui import Ui_bookSearch
from utils import table_data_draw
from utils import LengthIntValidator


class BookSearchDialog(QDialog, Ui_bookSearch):
    """ 图书查询界面 """
    def __init__(self, table, model, parent=None):
        super(BookSearchDialog, self).__init__(parent)
        self.setupUi(self)
        self.table = table
        self.model = model

        self.lineEdit.setValidator(LengthIntValidator(7))
        self.lineEdit_2.setValidator(LengthIntValidator(13))

        self.buttonBox.accepted.connect(self.on_accept)
        self.buttonBox.rejected.connect(self.reject)
        self.buttonBox.button(QDialogButtonBox.StandardButton.Ok).setText('确认')
        self.buttonBox.button(QDialogButtonBox.StandardButton.Cancel).setText('取消')

    def on_accept(self):
        book_id = self.lineEdit.text()
        isbn = self.lineEdit_2.text()
        name = self.lineEdit_3.text()
        author = self.lineEdit_4.text()
        press = self.lineEdit_5.text()

        res = book_search(book_id, isbn, name, author, press)
        if res is False:
            QMessageBox.warning(self, "提示", "该书籍不存在，请重新检索", QMessageBox.StandardButton.Yes)
        else:
            table_data_draw(self.table, self.model, res)
            return self.accept()
