from PyQt6.QtWidgets import QDialog, QMessageBox

from backend import user_login
from frontend.main import MainWindow
from frontend.ui import Ui_login


class LoginDialog(QDialog, Ui_login):
    """ 登录界面 """
    def __init__(self, parent=None):
        super(LoginDialog, self).__init__(parent)
        self.main = None
        self.password = None
        self.username = None
        self.setupUi(self)

        self.pushButton_2.clicked.connect(self.exit)
        self.pushButton.clicked.connect(self.login)
        self.pushButton.setShortcut("enter")

    def exit(self):
        buttons = QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No
        rec_code = QMessageBox.question(self, "确认", "您确认要退出吗？", buttons)
        if rec_code != QMessageBox.StandardButton.No:
            self.close()

    def login(self):
        username = self.username.text()
        password = self.password.text()
        if username == '' or password == '':
            QMessageBox.warning(self, "警告", "请输入用户名/密码", QMessageBox.StandardButton.Yes)
            return

        if user_login(username, password, self.type.currentText()):
            self.username = username
            self.password = password
            self.main = MainWindow(username, self.type.currentText())
            self.main.show()
            self.close()
        else:
            QMessageBox.warning(self, "警告", "密码错误，请重新输入！", QMessageBox.StandardButton.Yes)
