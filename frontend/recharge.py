import decimal

from PyQt6.QtWidgets import QDialog, QDialogButtonBox, QMessageBox

from backend.reader import balance_recharge
from frontend.ui import Ui_recharge


class RechargeDialog(QDialog, Ui_recharge):
    """ 余额充值界面 """
    def __init__(self, username, parent=None):
        super(RechargeDialog, self).__init__(parent)
        self.setupUi(self)

        self.username = username

        self.buttonBox.accepted.connect(self.on_accept)
        self.buttonBox.rejected.connect(self.reject)
        self.buttonBox.button(QDialogButtonBox.StandardButton.Ok).setText('确认')
        self.buttonBox.button(QDialogButtonBox.StandardButton.Cancel).setText('取消')

    def on_accept(self):
        money = decimal.Decimal(str(self.doubleSpinBox.text()))
        res = balance_recharge(self.username, money)
        if res[0]:
            QMessageBox.warning(self, "提醒", '充值成功', QMessageBox.StandardButton.Yes)
            return self.accept()
        else:
            QMessageBox.warning(self, "警告", res[1], QMessageBox.StandardButton.Yes)
