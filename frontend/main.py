from PyQt6 import QtWidgets

from frontend.book import BookForm
from frontend.borrow import BorrowForm
from frontend.password_change import PasswordChangeDialog
from frontend.reader import ReaderForm
from frontend.ui import Ui_MainWindow
from frontend.user import UserForm


class MainWindow(QtWidgets.QMainWindow, Ui_MainWindow):
    """ 主界面 """
    def __init__(self, username, user_type, parent=None):
        super(MainWindow, self).__init__(parent)
        self.setupUi(self)
        self.username = username
        self.user_type = user_type
        if user_type == "读者":
            self.btn_reader_manage.setVisible(False)
            self.btn_password_change.setVisible(False)
        if user_type == "管理员":
            self.btn_user_center.setVisible(False)

        for btn in self.tool.children():
            if btn.objectName().startswith('btn'):
                btn.clicked.connect(self.menu_change)

        self.btn_password_change.clicked.connect(self.password_change_page)

        self.stackedWidget.addWidget(BookForm(self.username, user_type))
        self.stackedWidget.addWidget(ReaderForm())
        self.stackedWidget.addWidget(BorrowForm(self.username, user_type))
        self.stackedWidget.addWidget(UserForm(self.username, user_type))
        self.stackedWidget.setCurrentIndex(0)

    def password_change_page(self):
        self.btn_password_change.setChecked(True)
        page = PasswordChangeDialog(self.username, self.user_type)
        page.exec()
        self.btn_password_change.setChecked(False)

    def menu_change(self):
        sender = self.sender()
        if sender.objectName() == 'btn_book_manage':
            self.stackedWidget.setCurrentIndex(0)
            self.stackedWidget.widget(0).all_book_info()
        if sender.objectName() == 'btn_reader_manage':
            self.stackedWidget.setCurrentIndex(1)
            self.stackedWidget.widget(1).all_reader_info()
        if sender.objectName() == 'btn_borrow_manage':
            self.stackedWidget.setCurrentIndex(2)
            self.stackedWidget.widget(2).reader_borrow_info()
        if sender.objectName() == 'btn_user_center':
            self.stackedWidget.setCurrentIndex(3)
            self.stackedWidget.widget(3).init()
