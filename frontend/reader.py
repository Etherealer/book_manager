from PyQt6.QtGui import QStandardItemModel
from PyQt6.QtWidgets import QWidget, QHeaderView, QMessageBox, QTableView

from backend.reader import all_reader_info_search, reader_remove, reset_password
from frontend.ui import Ui_reader
from frontend.user_info import UserInfoDialog
from utils import table_data_draw


class ReaderForm(QWidget, Ui_reader):
    """ 读者管理界面 """
    def __init__(self, parent=None):
        super(ReaderForm, self).__init__(parent)
        self.setupUi(self)

        self.pushButton.clicked.connect(self.reader_add)
        self.pushButton_2.clicked.connect(self.reader_search)
        self.pushButton_8.clicked.connect(self.all_reader_info)
        self.pushButton_3.clicked.connect(self.reader_update)
        self.pushButton_4.clicked.connect(self.reader_delete)
        self.pushButton_7.clicked.connect(self.password_reset)

        self.model = QStandardItemModel()
        self.model.setHorizontalHeaderLabels(
            ['读者编号', '身份证号', '姓名', '性别', '读者类型', '余额', '借阅总数'])

        self.tableView.setSelectionBehavior(QTableView.SelectionBehavior.SelectRows)
        header = self.tableView.horizontalHeader()
        header.setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        # self.all_reader_info()

    def reader_add(self):
        page = UserInfoDialog(0, self.tableView, self.model)
        page.exec()
        self.all_reader_info()

    def password_reset(self):
        index = self.tableView.selectionModel().selectedRows()
        if not index:
            QMessageBox.warning(self, "警告", "您未选择要重置密码的用户，请点击用户后再点击该按钮",
                                QMessageBox.StandardButton.Yes)
            return
        reader_id = self.model.item(index[0].row(), 0).text()
        res = reset_password(reader_id)
        if res:
            QMessageBox.warning(self, "提醒", '重置密码成功', QMessageBox.StandardButton.Yes)
        else:
            QMessageBox.warning(self, "警告", '重置密码失败，请重新尝试', QMessageBox.StandardButton.Yes)

    def reader_delete(self):
        index = self.tableView.selectionModel().selectedRows()
        if not index:
            QMessageBox.warning(self, "警告", "您未选择要删除的用户，请点击用户后再点击该按钮",
                                QMessageBox.StandardButton.Yes)
            return
        reader_id = self.model.item(index[0].row(), 0).text()
        res = reader_remove(reader_id)
        if res[0]:
            self.all_reader_info()
        else:
            QMessageBox.warning(self, "警告", res[1], QMessageBox.StandardButton.Yes)

    def reader_update(self):
        index = self.tableView.selectionModel().selectedRows()
        if not index:
            QMessageBox.warning(self, "警告", "您未选择要修改的用户，请点击用户后再点击该按钮",
                                QMessageBox.StandardButton.Yes)
            return
        row_data = [self.model.item(index[0].row(), i).text() for i in range(self.model.columnCount())]
        page = UserInfoDialog(2, self.tableView, self.model)
        page.lineEdit_9.setText(row_data[1])
        page.lineEdit_7.setText(row_data[2])
        page.comboBox.setCurrentText(row_data[3])
        page.lineEdit.setText(row_data[0])
        page.comboBox_2.setCurrentText(row_data[4])
        page.exec()
        self.all_reader_info()

    def reader_search(self):
        page = UserInfoDialog(1, self.tableView, self.model)
        page.exec()

    def all_reader_info(self):
        data = all_reader_info_search()
        table_data_draw(self.tableView, self.model, data)
