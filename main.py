import sys

from PyQt6.QtWidgets import QApplication

from frontend import LoginDialog

if __name__ == '__main__':
    # 应用入口
    app = QApplication(sys.argv)
    ui = LoginDialog()
    ui.show()
    sys.exit(app.exec())
