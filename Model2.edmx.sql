
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 06/24/2020 15:00:21
-- Generated from EDMX file: D:\בראודה\טכנולוגיית web\NEW\TaskManagementSystem\Model2.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [sw_lab];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_tbUsersTasks_tbUsers]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[tbUsersTasks] DROP CONSTRAINT [FK_tbUsersTasks_tbUsers];
GO
IF OBJECT_ID(N'[dbo].[FK_tbUsersTasks_tbTasks]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[tbUsersTasks] DROP CONSTRAINT [FK_tbUsersTasks_tbTasks];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[tbUsers]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tbUsers];
GO
IF OBJECT_ID(N'[dbo].[tbTasks]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tbTasks];
GO
IF OBJECT_ID(N'[dbo].[tbGroup]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tbGroup];
GO
IF OBJECT_ID(N'[dbo].[tbUsersTasks]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tbUsersTasks];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'tbUsers'
CREATE TABLE [dbo].[tbUsers] (
    [UserID] int IDENTITY(1,1) NOT NULL,
    [Email] nvarchar(max)  NOT NULL,
    [Password] nvarchar(50)  NOT NULL,
    [Username] nvarchar(50)  NULL,
    [FirstName] nvarchar(50)  NULL,
    [LastName] nvarchar(50)  NULL
);
GO

-- Creating table 'tbTasks'
CREATE TABLE [dbo].[tbTasks] (
    [TaskId] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(max)  NOT NULL,
    [Priority] smallint  NOT NULL,
    [Status] smallint  NOT NULL,
    [Details] nvarchar(max)  NOT NULL,
    [ToDate] datetime  NOT NULL
);
GO

-- Creating table 'tbGroup'
CREATE TABLE [dbo].[tbGroup] (
    [Id] int IDENTITY(1,1) NOT NULL
);
GO

-- Creating table 'tbUsersTasks'
CREATE TABLE [dbo].[tbUsersTasks] (
    [tbUsers_UserID] int  NOT NULL,
    [tbTasks_TaskId] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [UserID] in table 'tbUsers'
ALTER TABLE [dbo].[tbUsers]
ADD CONSTRAINT [PK_tbUsers]
    PRIMARY KEY CLUSTERED ([UserID] ASC);
GO

-- Creating primary key on [TaskId] in table 'tbTasks'
ALTER TABLE [dbo].[tbTasks]
ADD CONSTRAINT [PK_tbTasks]
    PRIMARY KEY CLUSTERED ([TaskId] ASC);
GO

-- Creating primary key on [Id] in table 'tbGroup'
ALTER TABLE [dbo].[tbGroup]
ADD CONSTRAINT [PK_tbGroup]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [tbUsers_UserID], [tbTasks_TaskId] in table 'tbUsersTasks'
ALTER TABLE [dbo].[tbUsersTasks]
ADD CONSTRAINT [PK_tbUsersTasks]
    PRIMARY KEY CLUSTERED ([tbUsers_UserID], [tbTasks_TaskId] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [tbUsers_UserID] in table 'tbUsersTasks'
ALTER TABLE [dbo].[tbUsersTasks]
ADD CONSTRAINT [FK_tbUsersTasks_tbUsers]
    FOREIGN KEY ([tbUsers_UserID])
    REFERENCES [dbo].[tbUsers]
        ([UserID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [tbTasks_TaskId] in table 'tbUsersTasks'
ALTER TABLE [dbo].[tbUsersTasks]
ADD CONSTRAINT [FK_tbUsersTasks_tbTasks]
    FOREIGN KEY ([tbTasks_TaskId])
    REFERENCES [dbo].[tbTasks]
        ([TaskId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_tbUsersTasks_tbTasks'
CREATE INDEX [IX_FK_tbUsersTasks_tbTasks]
ON [dbo].[tbUsersTasks]
    ([tbTasks_TaskId]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------