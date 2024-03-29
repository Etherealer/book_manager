USE [master]
GO
/****** Object:  Database [books]    Script Date: 2024/1/6 17:36:55 ******/
CREATE DATABASE [books]
CONTAINMENT = NONE
WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [books] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [books].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [books] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [books] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [books] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [books] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [books] SET ARITHABORT OFF 
GO
ALTER DATABASE [books] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [books] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [books] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [books] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [books] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [books] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [books] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [books] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [books] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [books] SET  DISABLE_BROKER 
GO
ALTER DATABASE [books] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [books] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [books] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [books] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [books] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [books] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [books] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [books] SET RECOVERY FULL 
GO
ALTER DATABASE [books] SET  MULTI_USER 
GO
ALTER DATABASE [books] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [books] SET DB_CHAINING OFF 
GO
ALTER DATABASE [books] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [books] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [books] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [books] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'books', N'ON'
GO
ALTER DATABASE [books] SET QUERY_STORE = ON
GO
ALTER DATABASE [books] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [books]
GO
/****** Object:  UserDefinedFunction [dbo].[reader_max_borrow_check]    Script Date: 2024/1/6 17:36:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[reader_max_borrow_check] (@readerId CHAR(12))
RETURNS BIT
AS
BEGIN
    -- 声明返回变量
    DECLARE @result BIT

    -- 获取读者类型的最大借书限制
    DECLARE @maxLimit INT
    SELECT @maxLimit = rt.max_borrow_num
    FROM reader_types rt
    JOIN reader r ON rt.id = r.type
    WHERE r.id = @readerId

    -- 计算当前借书数量
    DECLARE @currentBorrowCount INT
    SELECT @currentBorrowCount = COUNT(*)
    FROM borrow
    WHERE reader_id = @readerId
    
    -- 判断是否达到或超过限制
    IF @currentBorrowCount >= @maxLimit OR @maxLimit IS NULL 
        SET @result = 1 -- 达到或超过限制
    ELSE
        SET @result = 0 -- 未达到限制
    RETURN @result
END
GO
/****** Object:  UserDefinedFunction [dbo].[user_login_check]    Script Date: 2024/1/6 17:36:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[user_login_check]
(
    @username VARCHAR(12),
    @password VARCHAR(6),
    @user_type VARCHAR(6)
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT;

    IF @user_type = 'admin'
    BEGIN
        IF EXISTS (SELECT 1 FROM administrator WHERE username = @username AND password = @password)
            SET @result = 1;  -- 登录成功
        ELSE
            SET @result = 0;  -- 登录失败
    END
    ELSE IF @user_type = 'reader'
    BEGIN
        IF EXISTS (SELECT 1 FROM reader WHERE id = @username AND password = @password)
            SET @result = 1;  -- 登录成功
        ELSE
            SET @result = 0;  -- 登录失败
    END
    ELSE
        SET @result = 0;  -- 无效的用户类型

    RETURN @result;
END
GO
/****** Object:  Table [dbo].[administrator]    Script Date: 2024/1/6 17:36:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[administrator](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](12) NULL,
	[password] [varchar](12) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[book]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[book](
	[id] [char](7) NOT NULL,
	[isbn] [char](13) NULL,
	[author] [nvarchar](30) NULL,
	[name] [nvarchar](30) NOT NULL,
	[press] [nvarchar](30) NULL,
	[page] [int] NULL,
	[publish_date] [date] NULL,
	[num] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[borrow]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[borrow](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [char](12) NOT NULL,
	[book_id] [char](7) NOT NULL,
	[loan_date] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[history_book]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[history_book](
	[id] [char](7) NOT NULL,
	[isbn] [char](13) NULL,
	[author] [nvarchar](30) NULL,
	[name] [nvarchar](30) NOT NULL,
	[press] [nvarchar](30) NULL,
	[page] [int] NULL,
	[publish_date] [date] NULL,
	[num] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[history_borrow]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[history_borrow](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [char](12) NOT NULL,
	[book_id] [char](7) NOT NULL,
	[loan_date] [date] NOT NULL,
	[return_date] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[history_reader]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[history_reader](
	[id] [char](12) NOT NULL,
	[id_card] [char](18) NULL,
	[name] [nvarchar](30) NOT NULL,
	[gender] [int] NULL,
	[type] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[money_types]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[money_types](
	[id] [int] NOT NULL,
	[name] [nchar](2) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reader]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reader](
	[id] [char](12) NOT NULL,
	[id_card] [char](18) NULL,
	[name] [nvarchar](30) NOT NULL,
	[gender] [int] NULL,
	[type] [int] NULL,
	[balance] [money] NULL,
	[password] [char](6) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reader_genders]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reader_genders](
	[id] [int] NOT NULL,
	[name] [nchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reader_types]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reader_types](
	[id] [int] NOT NULL,
	[name] [nvarchar](3) NULL,
	[max_borrow_num] [int] NOT NULL,
	[max_borrow_time] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[recharge_deduction]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[recharge_deduction](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[type] [int] NOT NULL,
	[amount] [money] NOT NULL,
	[reader_id] [char](12) NOT NULL,
	[create_date] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[administrator] ON 

INSERT [dbo].[administrator] ([id], [username], [password]) VALUES (1, N'admin', N'admin')
SET IDENTITY_INSERT [dbo].[administrator] OFF
GO
INSERT [dbo].[book] ([id], [isbn], [author], [name], [press], [page], [publish_date], [num]) VALUES (N'0000002', N'9787544607513', NULL, N'翻译概论', NULL, 300, CAST(N'2000-01-02' AS Date), 10)
INSERT [dbo].[book] ([id], [isbn], [author], [name], [press], [page], [publish_date], [num]) VALUES (N'0000003', N'9787800945120', N'柳萌', N'历史痕迹 中国当代文化书系', N'大众文艺出版社', NULL, CAST(N'2000-01-01' AS Date), 2)
INSERT [dbo].[book] ([id], [isbn], [author], [name], [press], [page], [publish_date], [num]) VALUES (N'0000004', N'9787513536509', NULL, N'简明中西翻译史', NULL, NULL, CAST(N'2013-11-01' AS Date), 20)
GO
SET IDENTITY_INSERT [dbo].[borrow] ON 

INSERT [dbo].[borrow] ([id], [reader_id], [book_id], [loan_date]) VALUES (10, N'202400000002', N'0000004', CAST(N'2024-01-06' AS Date))
SET IDENTITY_INSERT [dbo].[borrow] OFF
GO
INSERT [dbo].[history_book] ([id], [isbn], [author], [name], [press], [page], [publish_date], [num]) VALUES (N'0000001', N'9787513506915', N'刘宓庆', N'翻译美学理论', N'外语教学与研究出版社', NULL, CAST(N'2011-03-02' AS Date), 1)
GO
SET IDENTITY_INSERT [dbo].[history_borrow] ON 

INSERT [dbo].[history_borrow] ([id], [reader_id], [book_id], [loan_date], [return_date]) VALUES (5, N'202400000000', N'0000003', CAST(N'2023-12-01' AS Date), CAST(N'2024-01-06' AS Date))
INSERT [dbo].[history_borrow] ([id], [reader_id], [book_id], [loan_date], [return_date]) VALUES (6, N'202400000002', N'0000001', CAST(N'2024-01-06' AS Date), CAST(N'2024-01-06' AS Date))
INSERT [dbo].[history_borrow] ([id], [reader_id], [book_id], [loan_date], [return_date]) VALUES (7, N'202400000000', N'0000002', CAST(N'2024-01-06' AS Date), CAST(N'2024-01-06' AS Date))
INSERT [dbo].[history_borrow] ([id], [reader_id], [book_id], [loan_date], [return_date]) VALUES (8, N'202400000000', N'0000004', CAST(N'2023-10-17' AS Date), CAST(N'2024-01-06' AS Date))
INSERT [dbo].[history_borrow] ([id], [reader_id], [book_id], [loan_date], [return_date]) VALUES (9, N'202400000000', N'0000004', CAST(N'2023-01-02' AS Date), CAST(N'2024-01-06' AS Date))
INSERT [dbo].[history_borrow] ([id], [reader_id], [book_id], [loan_date], [return_date]) VALUES (10, N'202400000000', N'0000004', CAST(N'2024-01-06' AS Date), CAST(N'2024-01-06' AS Date))
INSERT [dbo].[history_borrow] ([id], [reader_id], [book_id], [loan_date], [return_date]) VALUES (11, N'202400000000', N'0000002', CAST(N'2024-01-06' AS Date), CAST(N'2024-01-06' AS Date))
INSERT [dbo].[history_borrow] ([id], [reader_id], [book_id], [loan_date], [return_date]) VALUES (12, N'202400000000', N'0000002', CAST(N'2024-01-06' AS Date), CAST(N'2024-01-06' AS Date))
INSERT [dbo].[history_borrow] ([id], [reader_id], [book_id], [loan_date], [return_date]) VALUES (13, N'202400000000', N'0000002', CAST(N'2024-01-06' AS Date), CAST(N'2024-01-06' AS Date))
INSERT [dbo].[history_borrow] ([id], [reader_id], [book_id], [loan_date], [return_date]) VALUES (14, N'202400000000', N'0000002', CAST(N'2024-01-06' AS Date), CAST(N'2024-01-06' AS Date))
SET IDENTITY_INSERT [dbo].[history_borrow] OFF
GO
INSERT [dbo].[money_types] ([id], [name]) VALUES (1, N'充值')
INSERT [dbo].[money_types] ([id], [name]) VALUES (2, N'扣款')
GO
INSERT [dbo].[reader] ([id], [id_card], [name], [gender], [type], [balance], [password]) VALUES (N'202400000000', N'210811196005132133', N'张三', 2, 4, 10.0000, N'123456')
INSERT [dbo].[reader] ([id], [id_card], [name], [gender], [type], [balance], [password]) VALUES (N'202400000001', NULL, N'李四', NULL, NULL, 0.0000, N'123456')
INSERT [dbo].[reader] ([id], [id_card], [name], [gender], [type], [balance], [password]) VALUES (N'202400000002', N'211322198509260317', N'王五', NULL, 3, 0.0000, N'123456')
GO
INSERT [dbo].[reader_genders] ([id], [name]) VALUES (1, N'男')
INSERT [dbo].[reader_genders] ([id], [name]) VALUES (2, N'女')
GO
INSERT [dbo].[reader_types] ([id], [name], [max_borrow_num], [max_borrow_time]) VALUES (1, N'教师', 50, 180)
INSERT [dbo].[reader_types] ([id], [name], [max_borrow_num], [max_borrow_time]) VALUES (2, N'研究生', 30, 180)
INSERT [dbo].[reader_types] ([id], [name], [max_borrow_num], [max_borrow_time]) VALUES (3, N'本科生', 10, 60)
INSERT [dbo].[reader_types] ([id], [name], [max_borrow_num], [max_borrow_time]) VALUES (4, N'其他', 5, 30)
GO
SET IDENTITY_INSERT [dbo].[recharge_deduction] ON 

INSERT [dbo].[recharge_deduction] ([id], [type], [amount], [reader_id], [create_date]) VALUES (5, 1, 10.0000, N'202400000000', CAST(N'2024-01-06' AS Date))
SET IDENTITY_INSERT [dbo].[recharge_deduction] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__administ__F3DBC572C184EED3]    Script Date: 2024/1/6 17:36:56 ******/
ALTER TABLE [dbo].[administrator] ADD UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__book__99F9D0A46B0F1C8D]    Script Date: 2024/1/6 17:36:56 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ__book__99F9D0A46B0F1C8D] ON [dbo].[book]
(
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__history___99F9D0A42EF2FD9B]    Script Date: 2024/1/6 17:36:56 ******/
ALTER TABLE [dbo].[history_book] ADD UNIQUE NONCLUSTERED 
(
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__history___C71FE3665B28160D]    Script Date: 2024/1/6 17:36:56 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ__history___C71FE3665B28160D] ON [dbo].[history_reader]
(
	[id_card] ASC
)
WHERE ([id_card] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__reader__C71FE36637E8A512]    Script Date: 2024/1/6 17:36:56 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ__reader__C71FE36637E8A512] ON [dbo].[reader]
(
	[id_card] ASC
)
WHERE ([id_card] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[book] ADD  DEFAULT ((1)) FOR [num]
GO
ALTER TABLE [dbo].[borrow] ADD  DEFAULT (getdate()) FOR [loan_date]
GO
ALTER TABLE [dbo].[history_book] ADD  DEFAULT ((1)) FOR [num]
GO
ALTER TABLE [dbo].[history_borrow] ADD  DEFAULT (getdate()) FOR [return_date]
GO
ALTER TABLE [dbo].[reader] ADD  DEFAULT ((0)) FOR [balance]
GO
ALTER TABLE [dbo].[reader] ADD  DEFAULT ('123456') FOR [password]
GO
ALTER TABLE [dbo].[reader_types] ADD  DEFAULT ((0)) FOR [max_borrow_num]
GO
ALTER TABLE [dbo].[reader_types] ADD  DEFAULT ((0)) FOR [max_borrow_time]
GO
ALTER TABLE [dbo].[recharge_deduction] ADD  DEFAULT (getdate()) FOR [create_date]
GO
ALTER TABLE [dbo].[borrow]  WITH CHECK ADD FOREIGN KEY([book_id])
REFERENCES [dbo].[book] ([id])
GO
ALTER TABLE [dbo].[borrow]  WITH CHECK ADD FOREIGN KEY([reader_id])
REFERENCES [dbo].[reader] ([id])
GO
ALTER TABLE [dbo].[history_reader]  WITH CHECK ADD FOREIGN KEY([gender])
REFERENCES [dbo].[reader_genders] ([id])
GO
ALTER TABLE [dbo].[history_reader]  WITH CHECK ADD FOREIGN KEY([type])
REFERENCES [dbo].[reader_types] ([id])
GO
ALTER TABLE [dbo].[reader]  WITH CHECK ADD FOREIGN KEY([gender])
REFERENCES [dbo].[reader_genders] ([id])
GO
ALTER TABLE [dbo].[reader]  WITH CHECK ADD FOREIGN KEY([type])
REFERENCES [dbo].[reader_types] ([id])
GO
ALTER TABLE [dbo].[recharge_deduction]  WITH CHECK ADD FOREIGN KEY([reader_id])
REFERENCES [dbo].[reader] ([id])
GO
ALTER TABLE [dbo].[recharge_deduction]  WITH CHECK ADD FOREIGN KEY([type])
REFERENCES [dbo].[money_types] ([id])
GO
ALTER TABLE [dbo].[reader]  WITH CHECK ADD CHECK  (([balance]>=(0)))
GO
/****** Object:  StoredProcedure [dbo].[admin_password_change]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[admin_password_change]
    @username varchar(12),
    @oldPassword varchar(12),
    @oldPasswordConfirm varchar(12),
    @newPassword varchar(12),
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
    
    SET @errorMessage = NULL
    -- 检查两次密码是否相同
    IF @oldPassword != @oldPasswordConfirm
    BEGIN
        SET @errorMessage = N'两次输入的原密码不匹配'
        RETURN
    END
    -- 检查原密码是否存在
    IF NOT EXISTS (SELECT * FROM administrator WHERE username = @username AND password = @oldPassword)
    BEGIN
        SET @errorMessage = N'原密码错误'
        RETURN
    END
    -- 更新管理员密码
    UPDATE administrator
    SET password = @newPassword
    WHERE username = @username
    
END
GO
/****** Object:  StoredProcedure [dbo].[all_book_info_search]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[all_book_info_search]
AS
BEGIN
    -- 获取所有书籍信息以及对应的借阅人数
    SELECT
        b.id,
        b.isbn,
        b.name,
        b.author,
        b.press,
        b.page,
        b.publish_date,
        b.num,
        COUNT(br.id) AS borrow_count  -- 计算每本书的借阅次数
    FROM
        book b
    LEFT JOIN
        borrow br ON b.id = br.book_id
    GROUP BY
        b.id,
        b.isbn,
        b.author,
        b.name,
        b.press,
        b.page,
        b.publish_date,
        b.num
END
GO
/****** Object:  StoredProcedure [dbo].[all_reader_info_search]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[all_reader_info_search]
AS
BEGIN
    -- 获取所有读者的信息以及借阅书籍的总数
    SELECT
        r.id,
        r.id_card,
        r.name,
        rg.name AS gender_name,
        rt.name AS type_name,
        r.balance,
        ISNULL(b.borrow_count, 0) AS borrow_count
    FROM
        reader r
    LEFT JOIN
        reader_genders rg ON r.gender = rg.id
    LEFT JOIN
        reader_types rt ON r.type = rt.id
    LEFT JOIN
        (SELECT
             reader_id,
             COUNT(*) AS borrow_count
         FROM
             borrow
         GROUP BY
             reader_id) b ON r.id = b.reader_id
END
GO
/****** Object:  StoredProcedure [dbo].[book_borrow]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[book_borrow]
    @readerId CHAR(12),
    @bookId CHAR(7),
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
    SET @errorMessage = NULL
    -- 检查读者是否达到最大借阅数量 0 代表没有 1 代表达到
    IF dbo.reader_max_borrow_check (@readerId) = 0
    BEGIN
        -- 检查书籍是否存在
        DECLARE @bookNum INT
        SELECT @bookNum = num FROM book WHERE id = @bookId

        IF @bookNum IS NULL
        BEGIN
            SET @errorMessage = N'无此书籍'
            RETURN
        END
        -- 检查书籍是否有足够的库存
        DECLARE @bookCount INT
        SELECT @bookCount = COUNT(*) FROM borrow WHERE book_id = @bookId

        IF @bookCount < @bookNum
        BEGIN
            -- 插入借阅记录
            INSERT INTO borrow (reader_id, book_id, loan_date)
            VALUES (@readerId, @bookId, GETDATE())
        END
        ELSE
        BEGIN
            -- 库存不足
            SET @errorMessage = N'书籍库存不足'
            RETURN
        END
    END
    ELSE
    BEGIN
        -- 已达到最大借阅数量
        SET @errorMessage = N'已达到最大借阅数量'
        RETURN
    END
END
GO
/****** Object:  StoredProcedure [dbo].[book_remove]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[book_remove]
    @bookId CHAR(7),
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
    SET @errorMessage = NULL
    -- 检查是否有未归还的借阅记录
    IF EXISTS (SELECT * FROM borrow WHERE book_id = @bookId)
    BEGIN
        -- 如果有未归还的借阅记录，下架失败
        SET @errorMessage = N'此书仍有人借阅，不能下架'
        RETURN
    END

    -- 开始事务
    BEGIN TRANSACTION
    BEGIN TRY
        -- 将图书信息复制到历史图书库中
        INSERT INTO history_book (id, isbn, author, name, press, page, publish_date, num)
        SELECT id, isbn, author, name, press, page, publish_date, num
        FROM book
        WHERE id = @bookId
        -- 从当前库存中移除图书
        DELETE FROM book WHERE id = @bookId
        -- 提交事务
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- 如果出现错误，回滚事务
        ROLLBACK TRANSACTION
        SET @errorMessage = N'下架图书过程中出现错误'
        RETURN
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[book_return]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[book_return]
    @readerId CHAR(12),
    @bookId CHAR(7),
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
    SET @errorMessage = NULL
    DECLARE @Result BIT
    
    BEGIN TRANSACTION
    -- 调用逾期扣款存储过程，并获取结果
    EXEC deduct_overdue_fee @readerId, @bookId, @Result OUTPUT
    -- 检查逾期扣款结果
    IF @Result = 1
    BEGIN TRY
            -- 将借阅记录移动到历史借阅表
            INSERT INTO history_borrow (reader_id, book_id, loan_date, return_date)
            SELECT TOP (1) reader_id, book_id, loan_date, GETDATE()
            FROM borrow
            WHERE reader_id = @readerId AND book_id = @bookId

            -- 从当前借阅表中删除记录
            DELETE TOP (1) FROM borrow
            WHERE reader_id = @readerId AND book_id = @bookId
            -- 提交事务
            COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- 如果出现错误，回滚事务
        ROLLBACK TRANSACTION
        SET @errorMessage = N'图书归还失败'
        RETURN
    END CATCH
    ELSE
    BEGIN
        -- 逾期扣款失败
        SET @errorMessage = N'逾期扣款失败，无法归还图书，请先充值'
        ROLLBACK TRANSACTION
    END
END
GO
/****** Object:  StoredProcedure [dbo].[book_search]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[book_search]
    @id char(7) = NULL,
    @isbn char(13) = NULL,
    @name nvarchar(30) = NULL,
    @author nvarchar(30) = NULL,
    @press nvarchar(30) = NULL
AS
BEGIN
    -- 根据给定的字段查询图书所有信息以及借阅人数 (部分字段可以为空)
    SELECT b.*, COUNT(br.book_id) AS borrow_count
    FROM book b
    LEFT JOIN borrow br ON b.id = br.book_id
    WHERE (@id IS NULL OR b.id = @id)
      AND (@isbn IS NULL OR b.isbn = @isbn)
      AND (@name IS NULL OR b.name LIKE '%' + @name + '%')
      AND (@author IS NULL OR b.author = @author)
      AND (@press IS NULL OR b.press = @press)
    GROUP BY b.id, b.isbn, b.author, b.name, b.press, b.page, b.publish_date, b.num
END
GO
/****** Object:  StoredProcedure [dbo].[book_shelve]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[book_shelve]
    @isbn         CHAR(13),
    @author       NVARCHAR(30),
    @name         NVARCHAR(30),
    @press        NVARCHAR(30),
    @page         INT,
    @publish_date DATE,
    @num          INT = 1,
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
   SET @errorMessage = NULL
   DECLARE @existingId CHAR(7) = NULL
    -- 检查 'name' 是否为空
    IF @name IS NULL
    BEGIN
        SET @errorMessage = N'书名不能为空'
        RETURN
    END

    -- 检查 'isbn' 是否唯一
    IF EXISTS (SELECT 1 FROM book WHERE isbn = @isbn)
    BEGIN
        SET @errorMessage = N'该书籍(ISBN)已经存在'
        RETURN
    END
    
    BEGIN TRANSACTION
    BEGIN TRY
        -- 检查 'history_book' 表中是否存在相同的 'isbn'
        IF EXISTS (SELECT 1 FROM history_book WHERE isbn = @isbn)
        BEGIN
            SELECT @existingId = id FROM history_book WHERE isbn = @isbn
            -- 如果存在，删除这些记录
            DELETE FROM history_book WHERE isbn = @isbn
        END

        -- 插入书籍数据
        INSERT INTO book (id, isbn, author, name, press, page, publish_date, num)
        VALUES (@existingId, @isbn, @author, @name, @press, @page, @publish_date, @num)
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- 如果在执行过程中发生错误，则回滚事务
        ROLLBACK TRANSACTION
        SET @errorMessage = ERROR_MESSAGE()
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[book_update]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[book_update]
    @id char(7),
    @isbn char(13) = NULL,
    @author nvarchar(30) = NULL,
    @name nvarchar(30) = NULL,
    @press nvarchar(30) = NULL,
    @page int = NULL,
    @publish_date date = NULL,
    @num  int = NULL,
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
    SET @errorMessage = NULL
    DECLARE @currentBorrowCount INT
    -- 查询书籍当前的借阅人数
    SELECT @currentBorrowCount = COUNT(*)
    FROM borrow
    WHERE book_id = @id
    -- 书籍数量不能为空
    IF @num IS NULL
    BEGIN
        SET @errorMessage = N'书籍数量不能为空'
        RETURN
    END
    -- 如果当前借阅人数小于等于更新更新后的数量则更新信息
    IF @currentBorrowCount <= @num
        UPDATE book
        SET isbn = @isbn,
            author = @author,
            name = @name,
            press = @press,
            page = @page,
            publish_date = @publish_date,
            num = @num
        WHERE id = @id
    ELSE
        SET @errorMessage = N'图书总数必须大于当前借阅数量'
END
GO
/****** Object:  StoredProcedure [dbo].[deduct_overdue_fee]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deduct_overdue_fee]
    @readerId CHAR(12),
    @bookId CHAR(7),
    @Result BIT OUTPUT 
AS
BEGIN
    DECLARE @loanDate DATE;
    DECLARE @maxBorrowTime INT;
    DECLARE @overdueDays INT;
    DECLARE @deduction MONEY;
    DECLARE @balance MONEY;
    DECLARE @moneyTypeId INT;

    -- 获取借阅日期
    SELECT @loanDate = loan_date FROM borrow WHERE reader_id = @readerId AND book_id = @bookId
    -- 获取读者类型和最大借阅时间
    SELECT @maxBorrowTime = rt.max_borrow_time
    FROM reader r
    JOIN reader_types rt ON r.type = rt.id
    WHERE r.id = @readerId

    -- 计算逾期天数
    SET @overdueDays = DATEDIFF(DAY, DATEADD(DAY, @maxBorrowTime, @loanDate), GETDATE())

    IF @overdueDays > 0
    BEGIN
        -- 计算应扣款金额
        SET @deduction = @overdueDays * 0.1
        -- 检查读者余额
        SELECT @balance = balance FROM reader WHERE id = @readerId
        IF @balance >= @deduction
            BEGIN
                -- 进行扣款
                UPDATE reader SET balance = balance - @deduction WHERE id = @readerId
                -- 获取扣款类型ID
                SELECT @moneyTypeId = id FROM money_types WHERE name = N'扣款'
                -- 在recharge_deduction表中插入扣款记录
                INSERT INTO recharge_deduction (type, amount, reader_id, create_date)
                VALUES (@moneyTypeId, @deduction, @readerId, GETDATE())
                SET @Result = 1
                END
            ELSE
                BEGIN
                    SET @Result = 0
                END
        END
    ELSE
        BEGIN
            SET @Result = 1
        END
END
GO
/****** Object:  StoredProcedure [dbo].[reader_add]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reader_add]
    @id CHAR(12),
    @id_card CHAR(18),
    @name NVARCHAR(30),
    @genderName NCHAR,
    @readerType NVARCHAR(3),
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
    SET @errorMessage = NULL

    IF @id IS NULL OR @name IS NULL
    BEGIN
        SET @errorMessage = N'读者编号或姓名不能为空'
        RETURN
    END

    DECLARE @genderID INT=NULL
    DECLARE @typeID INT=NULL
    -- 查询 性别 ID
    IF @genderName IS NOT NULL
    BEGIN
        SELECT @genderID = id FROM reader_genders WHERE name = @genderName;
    END
    -- 查询 读者类型 ID
    IF @readerType IS NOT NULL
    BEGIN
        SELECT @typeID = id FROM reader_types WHERE name = @readerType;
        IF @typeID IS NULL
        BEGIN
            SET @errorMessage = N'未找到匹配的读者类型'
            RETURN
        END
    END
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- 检查 'history_reader' 表中是否存在相同的 'id'
        IF EXISTS (SELECT 1 FROM history_reader WHERE id = @id)
        BEGIN
            -- 如果存在，删除这些记录
            DELETE FROM history_reader WHERE id = @id
        END

        INSERT INTO reader (id, id_card, name, gender, type)
        VALUES (@id, @id_card, @name, @genderID, @typeID);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- 如果在执行过程中发生错误，则回滚事务
        ROLLBACK TRANSACTION

        SET @errorMessage = ERROR_MESSAGE()
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[reader_borrow_info_search]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reader_borrow_info_search]
    @ReaderId CHAR(12) = NULL,
    @ReaderName NVARCHAR(30) = NULL,
    @IdCard CHAR(18) = NULL
AS
BEGIN
    -- 根据给定的三个字段中的部分字段信息组合获取读者的借阅信息
    SELECT
        r.id,
        b.book_id,
        r.name,
        bk.name,
        b.loan_date
    FROM
        borrow b
    INNER JOIN
        reader r ON b.reader_id = r.id
    INNER JOIN
        book bk ON b.book_id = bk.id
    WHERE
        (@ReaderId IS NULL OR r.id = @ReaderId)
        AND (@ReaderName IS NULL OR r.name = @ReaderName)
        AND (@IdCard IS NULL OR r.id_card = @IdCard)
END
GO
/****** Object:  StoredProcedure [dbo].[reader_delete]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reader_delete]
    @readerId CHAR(12),
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
    SET @errorMessage = NULL
    -- 检查是否有未归还的借阅记录
    IF EXISTS (SELECT * FROM borrow WHERE reader_id = @readerId)
    BEGIN
        -- 如果有未归还的借阅记录，不能删除读者
        SET @errorMessage = N'此读者还有未归还的借阅记录，无法删除'
        RETURN 
    END

    -- 开始事务
    BEGIN TRANSACTION
    BEGIN TRY
        -- 将读者信息复制到历史读者库中
        INSERT INTO history_reader (id, id_card, name, gender, type)
        SELECT id, id_card, name, gender, type
        FROM reader
        WHERE id = @readerId
        -- 删除读者的所有充值扣款信息
        DELETE FROM recharge_deduction WHERE reader_id = @readerId
        -- 从读者表中删除读者
        DELETE FROM reader WHERE id = @readerId
        -- 提交事务
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- 如果出现错误，回滚事务
        ROLLBACK TRANSACTION
        SET @errorMessage = N'删除读者过程中出现错误'
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[reader_history_borrow_info_search]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reader_history_borrow_info_search]
    @ReaderId CHAR(12)
AS
BEGIN
    -- 获取读者的历史借阅信息
    -- 如果对应书籍id不在book表中则在history_book表中查询
    SELECT
        COALESCE(b.isbn, hb.isbn),
        COALESCE(b.name, hb.name),
        COALESCE(b.author, hb.author),
        COALESCE(b.press, hb.press),
        COALESCE(b.page, hb.page),
        COALESCE(b.publish_date, hb.publish_date),
        h.loan_date,
        h.return_date
    FROM
        history_borrow h
    LEFT JOIN
        book b ON h.book_id = b.id
    LEFT JOIN
        history_book hb ON h.book_id = hb.id
    WHERE
        h.reader_id = @ReaderId
END;
GO
/****** Object:  StoredProcedure [dbo].[reader_password_change]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reader_password_change]
    @userID char(12),
    @oldPassword char(6),
    @oldPasswordConfirm char(6),
    @newPassword char(6),
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
    SET @errorMessage = NULL
    -- 检查两次原密码是否相同
    IF @oldPassword != @oldPasswordConfirm
    BEGIN
        SET @errorMessage = N'两次输入的原密码不匹配'
        RETURN
    END
    -- 检查原密码是否正确
    IF NOT EXISTS (SELECT * FROM reader WHERE id = @userID AND password = @oldPassword)
    BEGIN
        SET @errorMessage = N'原密码错误'
        RETURN
    END
    -- 更新密码
    UPDATE reader
    SET password = @newPassword
    WHERE id = @userID
END
GO
/****** Object:  StoredProcedure [dbo].[reader_password_reset]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reader_password_reset]
    @id CHAR(12)
AS
BEGIN
    -- 读者编号不能为空
    IF @id IS NULL
    BEGIN
        RAISERROR(N'必须提供读者编号', 16, 1);
    END
    -- 定义默认密码
    DECLARE @defaultPassword CHAR(6) = '123456';

    -- 更新reader表中的密码字段
    UPDATE reader
    SET password = @defaultPassword
    WHERE id = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[reader_recharge]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reader_recharge]
    @reader_id CHAR(12),
    @amount MONEY,
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
    SET @errorMessage = NULL
    -- 检查充值金额是否有效
    IF @amount <= 0
    BEGIN
        SET @errorMessage = N'无效的充值金额'
        RETURN
    END
    
    -- 检查读者ID是否存在
    IF NOT EXISTS (SELECT 1 FROM reader WHERE id = @reader_id)
    BEGIN
        SET @errorMessage = N'无效的读者ID'
        RETURN
    END

    DECLARE @rechargeType INT=NULL
    SELECT @rechargeType = id FROM money_types WHERE name = N'充值';

    -- 开始事务
    BEGIN TRANSACTION;

    BEGIN TRY
        -- 更新读者余额
        UPDATE reader
        SET balance = balance + @amount
        WHERE id = @reader_id;

        -- 插入充值记录
        INSERT INTO recharge_deduction (type, amount, reader_id)
        VALUES (@rechargeType, @amount, @reader_id);
        -- 提交事务
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @errorMessage = N'发生错误，请重新尝试。'
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[reader_search]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reader_search]
    @readerId CHAR(12) = NULL,
    @readerName NVARCHAR(30) = NULL,
    @readerIdCard CHAR(18) = NULL
AS
BEGIN
    -- 查询读者的信息以及借阅总数
    SELECT
        r.id,
        r.id_card,
        r.name,
        rg.name AS gender_name,
        rt.name AS type_name,
        r.balance,
        ISNULL(b.borrow_count, 0) AS borrow_count
    FROM
        reader r
    LEFT JOIN
        reader_genders rg ON r.gender = rg.id
    LEFT JOIN
        reader_types rt ON r.type = rt.id
    LEFT JOIN
        (SELECT
             reader_id,
             COUNT(*) AS borrow_count
         FROM
             borrow
         GROUP BY
             reader_id) b ON r.id = b.reader_id
    WHERE
        (r.id = @readerId OR @readerId IS NULL)
        AND (r.name = @readerName OR @readerName IS NULL)
        AND (r.id_card = @readerIdCard OR @readerIdCard IS NULL);
END;
GO
/****** Object:  StoredProcedure [dbo].[reader_self_borrow_info_search]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reader_self_borrow_info_search]
    @ReaderId CHAR(12)
AS
BEGIN
    -- 查询读者的借阅信息(读者)
    SELECT
        bk.id,
        bk.isbn,
        bk.name,
        bk.author,
        bk.press,
        bk.page,
        bk.publish_date,
        b.loan_date
    FROM
        borrow b
    INNER JOIN
        book bk ON b.book_id = bk.id
    WHERE
        b.reader_id = @ReaderId;
END
GO
/****** Object:  StoredProcedure [dbo].[reader_update]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[reader_update]
    @id CHAR(12),
    @id_card CHAR(18),
    @name NVARCHAR(30),
    @genderName NCHAR,
    @readerType NVARCHAR(3),
    @errorMessage nvarchar(100) OUTPUT
AS
BEGIN
    SET @errorMessage = NULL

    DECLARE @genderID INT
    DECLARE @typeID INT=NULL
    -- 根据新提供的性别名称查询性别ID
    IF @genderName IS NOT NULL
    BEGIN
        SELECT @genderID = id FROM reader_genders WHERE name = @genderName;
    END

    IF @readerType IS NOT NULL
    BEGIN
        SELECT @typeID = id FROM reader_types WHERE name = @readerType;
        IF @typeID IS NULL
        BEGIN
            SET @errorMessage = N'未找到匹配的读者类型'
            RETURN
        END
    END

    UPDATE reader
    SET id_card = @id_card,
        name = @name,
        gender = @genderID,
        type = @typeID
    WHERE id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[recharge_deduction_search]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[recharge_deduction_search]
    @readerId CHAR(12)
AS
BEGIN
    -- 查询读者的充值扣款记录
    SELECT mt.name AS type_name, rd.amount, rd.create_date
    FROM recharge_deduction rd
    INNER JOIN money_types mt ON rd.type = mt.id
    WHERE rd.reader_id = @readerId
END
GO
/****** Object:  Trigger [dbo].[TR_Book_Insert]    Script Date: 2024/1/6 17:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_Book_Insert]
ON [dbo].[book]
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @maxId INT, @maxIdHistory INT, @newId CHAR(7), @existingId CHAR(7);
    -- 检查是否存在传递的 'id'
    SELECT @existingId = id FROM inserted
    IF @existingId IS NULL
    BEGIN
        -- 从 book 表获取当前最大的数字部分
        SELECT @maxId = ISNULL(MAX(CAST(id AS INT)), 0) FROM book;
        -- 从 history_book 表获取当前最大的数字部分
        SELECT @maxIdHistory = ISNULL(MAX(CAST(id AS INT)), 0) FROM history_book;
        -- 比较两个表中的最大值并选取较大的一个
        IF @maxIdHistory > @maxId
            SET @maxId = @maxIdHistory;
        -- 递增最大值
        SET @maxId = @maxId + 1;
        -- 构造新的 ID
        SET @newId = RIGHT('0000000' + CAST(@maxId AS VARCHAR(7)), 7);
    END
    ELSE
    BEGIN
        SET @newId = @existingId
    END
    -- 插入新行
    INSERT INTO book (id, isbn, author, name, press, page, publish_date, num)
    SELECT @newId, isbn, author, name, press, page, publish_date, num
    FROM inserted;
END;
GO
ALTER TABLE [dbo].[book] ENABLE TRIGGER [TR_Book_Insert]
GO
USE [master]
GO
ALTER DATABASE [books] SET  READ_WRITE 
GO
