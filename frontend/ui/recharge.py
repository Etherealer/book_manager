# Form implementation generated from reading ui file 'recharge.ui'
#
# Created by: PyQt6 UI code generator 6.4.2
#
# WARNING: Any manual changes made to this file will be lost when pyuic6 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt6 import QtCore, QtGui, QtWidgets


class Ui_recharge(object):
    def setupUi(self, recharge):
        recharge.setObjectName("recharge")
        recharge.resize(227, 165)
        self.gridLayout = QtWidgets.QGridLayout(recharge)
        self.gridLayout.setObjectName("gridLayout")
        self.label_2 = QtWidgets.QLabel(parent=recharge)
        self.label_2.setMaximumSize(QtCore.QSize(40, 16777215))
        self.label_2.setAlignment(QtCore.Qt.AlignmentFlag.AlignRight|QtCore.Qt.AlignmentFlag.AlignTrailing|QtCore.Qt.AlignmentFlag.AlignVCenter)
        self.label_2.setObjectName("label_2")
        self.gridLayout.addWidget(self.label_2, 1, 0, 1, 1)
        self.widget = QtWidgets.QWidget(parent=recharge)
        self.widget.setObjectName("widget")
        self.buttonBox = QtWidgets.QDialogButtonBox(parent=self.widget)
        self.buttonBox.setGeometry(QtCore.QRect(0, 20, 151, 24))
        self.buttonBox.setOrientation(QtCore.Qt.Orientation.Horizontal)
        self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.StandardButton.Cancel|QtWidgets.QDialogButtonBox.StandardButton.Ok)
        self.buttonBox.setObjectName("buttonBox")
        self.gridLayout.addWidget(self.widget, 2, 0, 1, 2)
        self.doubleSpinBox = QtWidgets.QDoubleSpinBox(parent=recharge)
        self.doubleSpinBox.setMinimumSize(QtCore.QSize(0, 30))
        self.doubleSpinBox.setMaximumSize(QtCore.QSize(80, 16777215))
        self.doubleSpinBox.setMaximum(9999.99)
        self.doubleSpinBox.setObjectName("doubleSpinBox")
        self.gridLayout.addWidget(self.doubleSpinBox, 1, 1, 1, 1)
        self.label = QtWidgets.QLabel(parent=recharge)
        self.label.setMinimumSize(QtCore.QSize(0, 40))
        self.label.setStyleSheet("QLabel{font-size:18px}")
        self.label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
        self.label.setObjectName("label")
        self.gridLayout.addWidget(self.label, 0, 0, 1, 2)

        self.retranslateUi(recharge)
        QtCore.QMetaObject.connectSlotsByName(recharge)

    def retranslateUi(self, recharge):
        _translate = QtCore.QCoreApplication.translate
        recharge.setWindowTitle(_translate("recharge", "余额充值"))
        self.label_2.setText(_translate("recharge", "<html><head/><body><p><span style=\" font-size:11pt;\">金额</span></p></body></html>"))
        self.label.setText(_translate("recharge", "余额充值"))
