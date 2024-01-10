from PyQt6.QtWidgets import QDialog, QDialogButtonBox, QMessageBox

from backend.common import password_change
from frontend.ui import Ui_passwordChange


class PasswordChangeDialog(QDialog, Ui_passwordChange):
    """ 密码修改界面 """
    def __init__(self, username, user_type, parent=None):
        super(PasswordChangeDialog, self).__init__(parent)
        self.setupUi(self)
        self.username = username
        self.user_type = user_type
        self.buttonBox.accepted.connect(self.on_accept)
        self.buttonBox.rejected.connect(self.reject)
        self.buttonBox.button(QDialogButtonBox.StandardButton.Ok).setText('确认')
        self.buttonBox.button(QDialogButtonBox.StandardButton.Cancel).setText('取消')

    def on_accept(self):
        old_password = self.lineEdit.text()
        old_password_confirm = self.lineEdit_2.text()
        new_password = self.lineEdit_3.text()
        res = password_change(self.username, self.user_type, old_password, old_password_confirm, new_password)
        if res[0]:
            return self.accept()
        else:
            QMessageBox.warning(self, "警告", res[1], QMessageBox.StandardButton.Yes)
