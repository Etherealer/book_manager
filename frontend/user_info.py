from PyQt6.QtWidgets import QDialog, QDialogButtonBox, QMessageBox

from backend.reader import reader_add, reader_search, reader_update
from frontend.ui import Ui_userInfo
from utils import LengthIntValidator, table_data_draw


class UserInfoDialog(QDialog, Ui_userInfo):
    """ 读者查询，添加，个人信息修改界面 """
    def __init__(self, status, table, model, parent=None):
        super(UserInfoDialog, self).__init__(parent)
        self.setupUi(self)
        self.status = status
        self.table = table
        self.model = model

        if self.status == 0:
            self.label_10.setText('读者添加')
            self.setWindowTitle('读者添加')
        if self.status == 1:
            self.label_10.setText('读者查询')
            self.setWindowTitle('读者查询')
            self.label_7.hide()
            self.comboBox.hide()
            self.label_2.hide()
            self.comboBox_2.hide()
        if self.status == 2:
            self.lineEdit.setReadOnly(True)
            self.label_10.setText('读者修改')
            self.setWindowTitle('读者修改')
        if self.status == 3:
            self.label.hide()
            self.lineEdit.hide()
            self.label_2.hide()
            self.comboBox_2.hide()
            self.label_10.setText('个人信息修改')
            self.setWindowTitle('个人信息修改')

        self.lineEdit.setValidator(LengthIntValidator(12))
        self.lineEdit_9.setValidator(LengthIntValidator(18))

        self.buttonBox.accepted.connect(self.on_accept)
        self.buttonBox.rejected.connect(self.reject)
        self.buttonBox.button(QDialogButtonBox.StandardButton.Ok).setText('确认')
        self.buttonBox.button(QDialogButtonBox.StandardButton.Cancel).setText('取消')

    def on_accept(self):
        id_card = self.lineEdit_9.text()
        name = self.lineEdit_7.text()
        gender = self.comboBox.currentText()
        reader_id = self.lineEdit.text()
        reader_type = self.comboBox_2.currentText()
        if len(id_card) != 18 and id_card != '':
            QMessageBox.warning(self, "警告", "身份证号应为18位", QMessageBox.StandardButton.Yes)
            return

        if self.status == 0:
            if len(name) == '':
                QMessageBox.warning(self, "警告", "读者姓名不能为空", QMessageBox.StandardButton.Yes)
                return
            if reader_id == '':
                QMessageBox.warning(self, "警告", "请输入读者编号", QMessageBox.StandardButton.Yes)
                return
            if len(reader_id) != 12:
                QMessageBox.warning(self, "警告", "读者编号应为12位", QMessageBox.StandardButton.Yes)
                return
            res = reader_add(reader_id, id_card, name, gender, reader_type)

            if res[0] is False:
                QMessageBox.warning(self, "警告", res[1], QMessageBox.StandardButton.Yes)
                return
            return self.accept()
        elif self.status == 1:
            res = reader_search(reader_id, id_card, name)
            if res is False:
                QMessageBox.warning(self, "提示", "该用户不存在，请重新检索", QMessageBox.StandardButton.Yes)
            else:
                table_data_draw(self.table, self.model, res)
                return self.accept()
        elif self.status == 2:
            res = reader_update(reader_id, id_card, name, gender, reader_type)
            if res:
                return self.accept()
            else:
                QMessageBox.warning(self, "警告", '用户信息修改失败，请重试', QMessageBox.StandardButton.Yes)

        elif self.status == 3:
            res = reader_update(reader_id, id_card, name, gender, reader_type)
            if res:
                return self.accept()
            else:
                QMessageBox.warning(self, "警告", '个人信息修改失败，请重试', QMessageBox.StandardButton.Yes)
