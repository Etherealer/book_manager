# Form implementation generated from reading ui file 'borrow.ui'
#
# Created by: PyQt6 UI code generator 6.4.2
#
# WARNING: Any manual changes made to this file will be lost when pyuic6 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt6 import QtCore, QtGui, QtWidgets


class Ui_borrow(object):
    def setupUi(self, borrow):
        borrow.setObjectName("borrow")
        borrow.resize(664, 417)
        self.gridLayout_2 = QtWidgets.QGridLayout(borrow)
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.tableView = QtWidgets.QTableView(parent=borrow)
        self.tableView.setObjectName("tableView")
        self.gridLayout_2.addWidget(self.tableView, 1, 0, 1, 1)
        self.widget = QtWidgets.QWidget(parent=borrow)
        self.widget.setObjectName("widget")
        self.gridLayout_3 = QtWidgets.QGridLayout(self.widget)
        self.gridLayout_3.setObjectName("gridLayout_3")
        self.pushButton = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton.setObjectName("pushButton")
        self.gridLayout_3.addWidget(self.pushButton, 0, 0, 1, 1)
        self.widget_2 = QtWidgets.QWidget(parent=self.widget)
        self.widget_2.setObjectName("widget_2")
        self.gridLayout = QtWidgets.QGridLayout(self.widget_2)
        self.gridLayout.setObjectName("gridLayout")
        self.pushButton_3 = QtWidgets.QPushButton(parent=self.widget_2)
        self.pushButton_3.setObjectName("pushButton_3")
        self.gridLayout.addWidget(self.pushButton_3, 0, 2, 1, 1)
        self.comboBox = QtWidgets.QComboBox(parent=self.widget_2)
        self.comboBox.setObjectName("comboBox")
        self.comboBox.addItem("")
        self.comboBox.addItem("")
        self.comboBox.addItem("")
        self.gridLayout.addWidget(self.comboBox, 0, 0, 1, 1)
        self.lineEdit = QtWidgets.QLineEdit(parent=self.widget_2)
        self.lineEdit.setMinimumSize(QtCore.QSize(0, 22))
        self.lineEdit.setFocusPolicy(QtCore.Qt.FocusPolicy.ClickFocus)
        self.lineEdit.setObjectName("lineEdit")
        self.gridLayout.addWidget(self.lineEdit, 0, 1, 1, 1)
        self.pushButton_4 = QtWidgets.QPushButton(parent=self.widget_2)
        self.pushButton_4.setObjectName("pushButton_4")
        self.gridLayout.addWidget(self.pushButton_4, 0, 3, 1, 1)
        self.gridLayout_3.addWidget(self.widget_2, 0, 2, 1, 1)
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Policy.Expanding, QtWidgets.QSizePolicy.Policy.Minimum)
        self.gridLayout_3.addItem(spacerItem, 0, 4, 1, 1)
        self.pushButton_2 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_2.setObjectName("pushButton_2")
        self.gridLayout_3.addWidget(self.pushButton_2, 0, 1, 1, 1)
        self.gridLayout_2.addWidget(self.widget, 0, 0, 1, 1)

        self.retranslateUi(borrow)
        QtCore.QMetaObject.connectSlotsByName(borrow)

    def retranslateUi(self, borrow):
        _translate = QtCore.QCoreApplication.translate
        borrow.setWindowTitle(_translate("borrow", "借阅管理"))
        self.pushButton.setText(_translate("borrow", "图书归还"))
        self.pushButton_3.setText(_translate("borrow", "查询"))
        self.comboBox.setItemText(0, _translate("borrow", "读者编号"))
        self.comboBox.setItemText(1, _translate("borrow", "身份证号"))
        self.comboBox.setItemText(2, _translate("borrow", "姓名"))
        self.pushButton_4.setText(_translate("borrow", "重置"))
        self.pushButton_2.setText(_translate("borrow", "余额充值"))
