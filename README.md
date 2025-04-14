# 📚 Library Management System - Database Design

This project provides a complete Entity-Relationship (E-R) diagram and relational schema mapping for a library management system. The system is designed to manage employees, floors, books, users, authors, publishers, borrowing transactions, and more. It is developed as part of an **ASP.NET Course** database project.

---

## 🧠 Project Description

The database system is designed to handle the following entities and relationships:

### 👥 Employees
- **Attributes**: `Emp_Id (PK)`, `Fname`, `Lname`, `Email`, `Salary`, `DateOfBirth`, `Bonus`, `Address`, `Phone_Number`
- Each employee:
  - Works on **one floor**
  - May supervise other employees (recursive relationship)
  - May manage one floor (with `Hiring_Date`)
  - Records data for multiple users and borrow transactions

### 🏢 Floors
- **Attributes**: `Floor_No (PK)`, `Num_Blocks`
- One **employee manages** each floor
- Each floor contains:
  - Many **employees**
  - Multiple **shelves**

### 👤 Users
- **Attributes**: `SSN (PK)`, `Name`, `Email`, `Phones`
- Each user’s data is recorded by **one employee**

### 📘 Books
- **Attributes**: `Book_Id (PK)`, `Title`
- Each book:
  - May be written by **one or more authors**
  - Is published by **one publisher**
  - Belongs to **one category**
  - Is placed on **one shelf**
  - Can be borrowed by users

### ✍️ Authors
- **Attributes**: `Author_Id (PK)`, `Name`
- Each author may have written multiple books

### 🏢 Publishers
- **Attributes**: `Publisher_Id (PK)`, `Name`
- A publisher may publish multiple books

### 🗂️ Categories
- **Attributes**: `Category_Id (PK)`, `Cat_Name`
- A category may include many books

### 🗄️ Shelves
- **Attributes**: `Code (PK)`
- Each shelf belongs to a floor and may contain multiple books

### 🔄 Borrowing
- **Attributes**: `User_SSN (FK)`, `Book_Id (FK)`, `Emp_Id (FK)`, `Date_Borrowed`, `Due_Date`, `Amount_Paid`
- Each borrow is recorded by an employee

---

## 🛠️ E-R Diagram

The E-R diagram includes the following:
- Entities: Employee, Floor, User, Book, Author, Publisher, Category, Shelf
- Relationships: Works_On, Manages, Records, Writes, Publishes, Categorized_As, Located_At, Borrow

