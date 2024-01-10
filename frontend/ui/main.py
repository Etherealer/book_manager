# Form implementation generated from reading ui file 'main.ui'
#
# Created by: PyQt6 UI code generator 6.4.2
#
# WARNING: Any manual changes made to this file will be lost when pyuic6 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt6 import QtCore, QtGui, QtWidgets


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(1056, 600)
        self.centralwidget = QtWidgets.QWidget(parent=MainWindow)
        self.centralwidget.setStyleSheet("QWidget#tool{background:rgb(84,92,100);}\n"
"QWidget#tool>QPushButton{border:none;background:rgb(84,92,100);color:white;min-height:55px;font:14px \"Microsoft YaHei UI\";}\n"
"QWidget#tool>QPushButton:checked{background:rgb(67,74,80);}")
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout_2 = QtWidgets.QGridLayout(self.centralwidget)
        self.gridLayout_2.setContentsMargins(0, 0, 0, 0)
        self.gridLayout_2.setSpacing(0)
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.tool = QtWidgets.QWidget(parent=self.centralwidget)
        self.tool.setMinimumSize(QtCore.QSize(120, 0))
        self.tool.setObjectName("tool")
        self.gridLayout = QtWidgets.QGridLayout(self.tool)
        self.gridLayout.setContentsMargins(0, 0, 0, 0)
        self.gridLayout.setSpacing(0)
        self.gridLayout.setObjectName("gridLayout")
        spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Policy.Minimum, QtWidgets.QSizePolicy.Policy.Expanding)
        self.gridLayout.addItem(spacerItem, 5, 0, 1, 1)
        self.btn_password_change = QtWidgets.QPushButton(parent=self.tool)
        self.btn_password_change.setCheckable(True)
        self.btn_password_change.setObjectName("btn_password_change")
        self.gridLayout.addWidget(self.btn_password_change, 4, 0, 1, 1)
        self.btn_borrow_manage = QtWidgets.QPushButton(parent=self.tool)
        self.btn_borrow_manage.setCheckable(True)
        self.btn_borrow_manage.setObjectName("btn_borrow_manage")
        self.buttonGroup = QtWidgets.QButtonGroup(MainWindow)
        self.buttonGroup.setObjectName("buttonGroup")
        self.buttonGroup.addButton(self.btn_borrow_manage)
        self.gridLayout.addWidget(self.btn_borrow_manage, 2, 0, 1, 1)
        self.btn_book_manage = QtWidgets.QPushButton(parent=self.tool)
        self.btn_book_manage.setCheckable(True)
        self.btn_book_manage.setChecked(True)
        self.btn_book_manage.setObjectName("btn_book_manage")
        self.buttonGroup.addButton(self.btn_book_manage)
        self.gridLayout.addWidget(self.btn_book_manage, 0, 0, 1, 1)
        self.btn_user_center = QtWidgets.QPushButton(parent=self.tool)
        self.btn_user_center.setCheckable(True)
        self.btn_user_center.setObjectName("btn_user_center")
        self.buttonGroup.addButton(self.btn_user_center)
        self.gridLayout.addWidget(self.btn_user_center, 3, 0, 1, 1)
        self.btn_reader_manage = QtWidgets.QPushButton(parent=self.tool)
        self.btn_reader_manage.setCheckable(True)
        self.btn_reader_manage.setObjectName("btn_reader_manage")
        self.buttonGroup.addButton(self.btn_reader_manage)
        self.gridLayout.addWidget(self.btn_reader_manage, 1, 0, 1, 1)
        self.gridLayout_2.addWidget(self.tool, 0, 0, 1, 1)
        self.stackedWidget = QtWidgets.QStackedWidget(parent=self.centralwidget)
        self.stackedWidget.setStyleSheet("QstackedWidget{background:gray}")
        self.stackedWidget.setObjectName("stackedWidget")
        self.gridLayout_2.addWidget(self.stackedWidget, 0, 1, 1, 1)
        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "图书管理系统"))
        self.btn_password_change.setText(_translate("MainWindow", "修改密码"))
        self.btn_borrow_manage.setText(_translate("MainWindow", "借阅管理"))
        self.btn_book_manage.setText(_translate("MainWindow", "图书管理"))
        self.btn_user_center.setText(_translate("MainWindow", "个人中心"))
        self.btn_reader_manage.setText(_translate("MainWindow", "读者管理"))
