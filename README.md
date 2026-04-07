# 💰 Finance Tracker API

A robust and scalable financial management system designed to handle personal transactions, budgets, and financial insights.

This project goes beyond a simple expense tracker — it focuses on **software engineering principles**, **backend architecture**, and **real-world financial modeling**, aiming to simulate a production-level system.

---

## 🚀 Project Overview

The **Finance Tracker API** is a backend system that allows users to manage their financial life through:

- Tracking income and expenses
- Categorizing transactions
- Managing multiple accounts
- Generating reports and insights
- Planning budgets and recurring transactions

The goal is to build a **clean, scalable, and production-ready API**, applying strong concepts of:

- Relational database modeling
- Business logic design
- Data consistency and transactions
- API architecture

---

## 🧠 Core Objectives

- Build a **real-world backend system**
- Apply **advanced SQL concepts** (JOINs, aggregations, indexing)
- Design a **well-structured relational database**
- Implement **clean architecture principles**
- Ensure **data integrity and performance**
- Practice **Docker-based environments**
- Explore **AI-assisted development** with full code validation

---

## 🏗️ Architecture & Tech Stack

**Backend:**
- Python
- FastAPI

**Database:**
- PostgreSQL
- SQL (advanced queries, joins, aggregations)

**DevOps:**
- Docker & Docker Compose
- Linux environment
- Environment variables

**Other:**
- SQLAlchemy (ORM)
- Git & GitHub
- Automated tests (planned)

---

## 🧩 Database Design

The system is built with a **relational and scalable schema**, supporting complex financial operations.

### Main Entities:

- **Accounts** → Represents financial sources (bank, wallet, credit card)
- **Categories** → Classifies transactions (food, transport, salary)
- **Transactions** → All money movements (income/expense)
- **Tags** → Flexible labels (e.g., "travel", "urgent")
- **Transaction_Tags** → Many-to-many relationship
- **Budgets** → Monthly spending limits per category
- **Recurring Transactions** → Automated repeated entries
- **Audit Log** → Full history of system changes

---

## ⚙️ Features

### 🟢 Basic
- CRUD operations for transactions
- Category management
- Automatic balance calculation
- Monthly reports
- Date filtering

### 🔵 Intermediate
- Dashboard with financial summaries
- Month-to-month comparison
- Top spending categories
- Full transaction history
- Search by description

### 🟣 Advanced
- Multiple accounts support
- Recurring transactions (subscriptions, salary)
- Budget control per category
- Alerts for budget overflow
- Soft delete (data is never permanently lost)

### 🔴 Expert-Level
- Automatic financial insights (rule-based or AI)
- Future balance prediction
- Export to CSV/PDF
- Full audit system (change tracking)
- Tag system (beyond categories)

---

## 🔌 API Design

The API follows **REST principles**, including:

- Proper HTTP methods (GET, POST, PUT, DELETE)
- Status codes
- Input validation
- Structured responses

Endpoints are organized by domain:
- `/transactions`
- `/categories`
- `/accounts`
- `/budgets`
- `/reports`

---

## 📈 Development Roadmap

### 1. Planning
- Define features
- Design database schema
- Map endpoints

### 2. Environment Setup
- Python virtual environment
- Install dependencies
- Configure PostgreSQL / Docker

### 3. Database Modeling
- Create tables with proper relationships
- Define constraints and cascading rules
- Optimize with indexes
- Test queries manually

### 4. API Development
- Initialize FastAPI server
- Create base routes

### 5. Business Logic
- Implement validations
- Financial calculations
- Domain rules

### 6. Database Integration
- ORM (SQLAlchemy)
- Data persistence and retrieval

### 7. Advanced Features
- Reports and aggregations
- Filters and analytics

### 8. Dockerization
- API container
- Database container

### 9. Testing
- Endpoint testing
- Business rule validation

### 10. Refinement
- Error handling
- Logging
- Documentation (this README 😄)

---

## 🧪 Testing Strategy

- Unit tests for business logic
- Integration tests for endpoints
- Manual query validation
- Edge case handling

---

## 📊 Future Improvements

- Frontend dashboard (React or similar)
- Authentication & authorization
- Multi-user support
- Real-time analytics
- AI-powered financial recommendations

---

## 🤖 AI Usage

This project experiments with **AI-assisted development tools**, while maintaining strict control over:

- Code quality
- Logical correctness
- Architecture decisions

All generated code is **reviewed, tested, and validated manually**.

---

## 📌 Final Thoughts

This project is designed as a **portfolio-level backend system**, focusing on:

- Depth over simplicity
- Real-world complexity
- Clean and maintainable code

---

## 📎 Author

Developed by **Josué Marcos**  
