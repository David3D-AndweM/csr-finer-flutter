# 🏗️ Backend Architecture Specification

## Overview

The CSR CRM backend follows a **microservices architecture** with **RESTful APIs** and **real-time capabilities**. This document provides comprehensive specifications for backend implementation, allowing flexibility in technology choices while maintaining consistent interfaces.

## Architecture Patterns

### Microservices Design
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   API Gateway   │    │  Load Balancer  │    │   CDN/Static    │
│   (Kong/Nginx)  │    │                 │    │     Assets      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
    ┌────────────────────────────┼────────────────────────────┐
    │                            │                            │
┌───▼────┐  ┌─────────┐  ┌──────▼──┐  ┌─────────┐  ┌─────────┐
│  Auth  │  │ Users   │  │Projects │  │ Finance │  │ Reports │
│Service │  │Service  │  │Service  │  │ Service │  │ Service │
└────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘
     │           │           │           │           │
┌────▼───────────▼───────────▼───────────▼───────────▼────┐
│                 Shared Database Layer                   │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │  Users  │ │Projects │ │ Finance │ │ Reports │       │
│  │   DB    │ │   DB    │ │   DB    │ │   DB    │       │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘       │
└─────────────────────────────────────────────────────────┘
```

## Core Services

### 1. Authentication Service
**Responsibilities:**
- User authentication and authorization
- JWT token management
- Role-based access control (RBAC)
- Password management and security

**Endpoints:**
```http
POST   /api/v1/auth/login
POST   /api/v1/auth/logout
POST   /api/v1/auth/refresh
POST   /api/v1/auth/forgot-password
POST   /api/v1/auth/reset-password
GET    /api/v1/auth/profile
PUT    /api/v1/auth/profile
```

### 2. User Management Service
**Responsibilities:**
- User CRUD operations
- Role and permission management
- User profile management
- Organization/recipient management

**Endpoints:**
```http
GET    /api/v1/users
POST   /api/v1/users
GET    /api/v1/users/{id}
PUT    /api/v1/users/{id}
DELETE /api/v1/users/{id}
GET    /api/v1/users/{id}/roles
PUT    /api/v1/users/{id}/roles
```

### 3. Project Management Service
**Responsibilities:**
- Project lifecycle management
- Milestone tracking
- Project-recipient associations
- Project status and progress

**Endpoints:**
```http
GET    /api/v1/projects
POST   /api/v1/projects
GET    /api/v1/projects/{id}
PUT    /api/v1/projects/{id}
DELETE /api/v1/projects/{id}
GET    /api/v1/projects/{id}/milestones
POST   /api/v1/projects/{id}/milestones
PUT    /api/v1/projects/{id}/milestones/{milestoneId}
GET    /api/v1/projects/{id}/recipients
```

### 4. Finance Management Service
**Responsibilities:**
- Budget creation and management
- Financial tracking and reporting
- Expense management
- Fund allocation and disbursement

**Endpoints:**
```http
GET    /api/v1/budgets
POST   /api/v1/budgets
GET    /api/v1/budgets/{id}
PUT    /api/v1/budgets/{id}
GET    /api/v1/budgets/sectors
GET    /api/v1/expenses
POST   /api/v1/expenses
GET    /api/v1/financial-reports
```

### 5. Survey & KPI Service
**Responsibilities:**
- Survey creation and management
- Response collection and processing
- KPI calculation and tracking
- Analytics and insights

**Endpoints:**
```http
GET    /api/v1/surveys
POST   /api/v1/surveys
GET    /api/v1/surveys/{id}
PUT    /api/v1/surveys/{id}
POST   /api/v1/surveys/{id}/responses
GET    /api/v1/surveys/{id}/responses
GET    /api/v1/kpis
GET    /api/v1/kpis/project/{projectId}
```

### 6. Messaging Service
**Responsibilities:**
- Real-time messaging
- Notification management
- Message threading
- File attachments

**Endpoints:**
```http
GET    /api/v1/messages
POST   /api/v1/messages
GET    /api/v1/messages/conversations
GET    /api/v1/messages/conversations/{id}
POST   /api/v1/notifications
GET    /api/v1/notifications
PUT    /api/v1/notifications/{id}/read
```

### 7. File Management Service
**Responsibilities:**
- File upload and storage
- Document management
- Image processing
- File security and access control

**Endpoints:**
```http
POST   /api/v1/files/upload
GET    /api/v1/files/{id}
DELETE /api/v1/files/{id}
GET    /api/v1/files/project/{projectId}
POST   /api/v1/files/bulk-upload
```

### 8. Reporting Service
**Responsibilities:**
- Report generation
- Data aggregation
- Export functionality (PDF, CSV, Excel)
- Dashboard data preparation

**Endpoints:**
```http
GET    /api/v1/reports/dashboard/{role}
GET    /api/v1/reports/projects
GET    /api/v1/reports/financial
GET    /api/v1/reports/kpi
POST   /api/v1/reports/export
GET    /api/v1/reports/export/{id}/download
```

## Database Schema

### Core Entities

#### Users Table
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role user_role NOT NULL,
    organization_id UUID REFERENCES organizations(id),
    is_active BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE user_role AS ENUM (
    'csr_manager',
    'finance_officer', 
    'me_officer',
    'recipient',
    'editor'
);
```

#### Organizations Table
```sql
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type organization_type NOT NULL,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    address TEXT,
    mou_signed BOOLEAN DEFAULT false,
    mou_date DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE organization_type AS ENUM (
    'internal',
    'recipient_partner',
    'vendor'
);
```

#### Projects Table
```sql
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    sector project_sector NOT NULL,
    status project_status DEFAULT 'planning',
    start_date DATE,
    end_date DATE,
    estimated_budget DECIMAL(15,2),
    actual_expenditure DECIMAL(15,2) DEFAULT 0,
    organization_id UUID REFERENCES organizations(id),
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE project_sector AS ENUM (
    'education',
    'health',
    'infrastructure',
    'agriculture',
    'other'
);

CREATE TYPE project_status AS ENUM (
    'planning',
    'active',
    'on_hold',
    'completed',
    'cancelled'
);
```

#### Milestones Table
```sql
CREATE TABLE milestones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE,
    completion_percentage INTEGER DEFAULT 0 CHECK (completion_percentage >= 0 AND completion_percentage <= 100),
    status milestone_status DEFAULT 'pending',
    notes TEXT,
    approved_by UUID REFERENCES users(id),
    approved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE milestone_status AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'overdue',
    'approved'
);
```

#### Budgets Table
```sql
CREATE TABLE budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    financial_year INTEGER NOT NULL,
    total_budget DECIMAL(15,2) NOT NULL,
    allocated_amount DECIMAL(15,2) DEFAULT 0,
    spent_amount DECIMAL(15,2) DEFAULT 0,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Budget Allocations Table
```sql
CREATE TABLE budget_allocations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    budget_id UUID REFERENCES budgets(id) ON DELETE CASCADE,
    sector project_sector NOT NULL,
    allocated_amount DECIMAL(15,2) NOT NULL,
    spent_amount DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## API Specifications

### Authentication

#### Login Request
```json
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

#### Login Response
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "csr_manager",
      "organization": {
        "id": "uuid",
        "name": "Organization Name"
      }
    },
    "tokens": {
      "accessToken": "jwt_access_token",
      "refreshToken": "jwt_refresh_token",
      "expiresIn": 3600
    }
  }
}
```

### Project Management

#### Create Project Request
```json
POST /api/v1/projects
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "title": "Rural Education Initiative",
  "description": "Building schools in rural areas",
  "sector": "education",
  "startDate": "2024-01-01",
  "endDate": "2024-12-31",
  "estimatedBudget": 500000.00,
  "organizationId": "recipient_org_uuid"
}
```

#### Project Response
```json
{
  "success": true,
  "data": {
    "id": "project_uuid",
    "title": "Rural Education Initiative",
    "description": "Building schools in rural areas",
    "sector": "education",
    "status": "planning",
    "startDate": "2024-01-01",
    "endDate": "2024-12-31",
    "estimatedBudget": 500000.00,
    "actualExpenditure": 0.00,
    "organization": {
      "id": "uuid",
      "name": "Partner Organization"
    },
    "milestones": [],
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  }
}
```

## Real-time Features

### WebSocket Implementation

#### Connection
```javascript
// Client connection
const ws = new WebSocket('wss://api.csrcrm.com/ws?token=jwt_token');

// Server authentication
ws.on('connection', (socket) => {
  const token = socket.handshake.query.token;
  const user = verifyJWT(token);
  socket.join(`user_${user.id}`);
  socket.join(`org_${user.organizationId}`);
});
```

#### Message Types
```json
// New message notification
{
  "type": "new_message",
  "data": {
    "conversationId": "uuid",
    "message": {
      "id": "uuid",
      "content": "Message content",
      "sender": {
        "id": "uuid",
        "name": "John Doe"
      },
      "timestamp": "2024-01-01T00:00:00Z"
    }
  }
}

// Milestone update notification
{
  "type": "milestone_updated",
  "data": {
    "projectId": "uuid",
    "milestoneId": "uuid",
    "status": "completed",
    "completionPercentage": 100
  }
}
```

## Security Implementation

### JWT Token Structure
```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT"
  },
  "payload": {
    "sub": "user_uuid",
    "email": "user@example.com",
    "role": "csr_manager",
    "org": "org_uuid",
    "iat": 1640995200,
    "exp": 1640998800
  }
}
```

### Role-Based Access Control
```yaml
roles:
  csr_manager:
    permissions:
      - projects:read:all
      - projects:write:all
      - budgets:read:all
      - budgets:write:all
      - users:read:all
      - reports:read:all
      
  recipient:
    permissions:
      - projects:read:own
      - projects:write:own
      - milestones:write:own
      - surveys:write:own
      - messages:read:own
      - messages:write:own
      
  finance_officer:
    permissions:
      - budgets:read:all
      - budgets:write:all
      - expenses:read:all
      - expenses:write:all
      - reports:read:financial
```

## Error Handling

### Standard Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "field": "email",
      "message": "Email format is invalid"
    },
    "timestamp": "2024-01-01T00:00:00Z",
    "requestId": "req_uuid"
  }
}
```

### HTTP Status Codes
| Code | Description | Usage |
|------|-------------|-------|
| 200 | OK | Successful GET, PUT requests |
| 201 | Created | Successful POST requests |
| 204 | No Content | Successful DELETE requests |
| 400 | Bad Request | Invalid request data |
| 401 | Unauthorized | Authentication required |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Resource already exists |
| 422 | Unprocessable Entity | Validation errors |
| 500 | Internal Server Error | Server-side errors |

## Performance Considerations

### Caching Strategy
- **Redis**: Session storage, frequently accessed data
- **CDN**: Static assets, file downloads
- **Database**: Query result caching
- **Application**: In-memory caching for reference data

### Database Optimization
- **Indexing**: Strategic indexes on frequently queried columns
- **Partitioning**: Large tables partitioned by date/organization
- **Connection Pooling**: Efficient database connection management
- **Read Replicas**: Separate read/write operations

### API Rate Limiting
```yaml
rate_limits:
  authentication:
    requests: 5
    window: 60s
    
  general_api:
    requests: 100
    window: 60s
    
  file_upload:
    requests: 10
    window: 60s
    size_limit: 50MB
```

---

*This backend architecture provides a robust, scalable foundation for the CSR CRM system while maintaining flexibility for implementation choices.*