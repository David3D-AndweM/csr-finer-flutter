# 🔌 CSR CRM API Documentation

## Overview

This document provides comprehensive API specifications for the CSR CRM backend system. The API follows RESTful principles with JWT-based authentication and supports real-time features through WebSocket connections.

## Base Configuration

- **Base URL**: `https://api.csrcrm.com/v1`
- **Authentication**: JWT Bearer Token
- **Content Type**: `application/json`
- **API Version**: v1
- **Rate Limiting**: 1000 requests per hour per user

## Authentication

### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "device_info": {
    "platform": "flutter",
    "device_id": "unique-device-id",
    "app_version": "1.0.0"
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 3600,
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "role": "csr_manager",
      "profile": {
        "first_name": "John",
        "last_name": "Doe",
        "avatar_url": "https://..."
      }
    }
  }
}
```

### Refresh Token
```http
POST /auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Logout
```http
POST /auth/logout
Authorization: Bearer {access_token}
```

## User Management

### Get Current User Profile
```http
GET /users/profile
Authorization: Bearer {access_token}
```

### Update User Profile
```http
PUT /users/profile
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "first_name": "John",
  "last_name": "Doe",
  "phone": "+1234567890",
  "avatar_url": "https://..."
}
```

### Get Users by Role
```http
GET /users?role=recipient&page=1&limit=20
Authorization: Bearer {access_token}
```

## Project Management

### Get Projects
```http
GET /projects?page=1&limit=20&sector=education&status=active
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20, max: 100)
- `sector`: Filter by sector (education, health, infrastructure, agriculture, other)
- `status`: Filter by status (active, completed, suspended)
- `recipient_id`: Filter by recipient organization
- `search`: Search in project title/description

**Response:**
```json
{
  "success": true,
  "data": {
    "projects": [
      {
        "id": "uuid",
        "title": "School Infrastructure Development",
        "description": "Building new classrooms and facilities",
        "sector": "education",
        "status": "active",
        "estimated_budget": 50000.00,
        "actual_expenditure": 25000.00,
        "start_date": "2024-01-01",
        "end_date": "2024-12-31",
        "progress_percentage": 45.5,
        "recipient": {
          "id": "uuid",
          "name": "Education Foundation",
          "contact_person": "Jane Smith"
        },
        "milestones_count": 8,
        "completed_milestones": 3,
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-06-01T12:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 95,
      "items_per_page": 20
    }
  }
}
```

### Create Project
```http
POST /projects
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "title": "New Education Project",
  "description": "Detailed project description",
  "sector": "education",
  "recipient_id": "uuid",
  "estimated_budget": 75000.00,
  "start_date": "2024-07-01",
  "end_date": "2024-12-31",
  "milestones": [
    {
      "title": "Project Planning",
      "description": "Complete project planning phase",
      "due_date": "2024-07-15",
      "budget_allocation": 5000.00
    }
  ]
}
```

### Update Project
```http
PUT /projects/{project_id}
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "title": "Updated Project Title",
  "status": "active",
  "actual_expenditure": 30000.00
}
```

### Get Project Details
```http
GET /projects/{project_id}
Authorization: Bearer {access_token}
```

## Milestone Management

### Get Project Milestones
```http
GET /projects/{project_id}/milestones
Authorization: Bearer {access_token}
```

### Update Milestone
```http
PUT /milestones/{milestone_id}
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

{
  "progress_percentage": 75.0,
  "notes": "Milestone progress update",
  "actual_expenditure": 3500.00,
  "attachments": [file1, file2]
}
```

### Approve/Reject Milestone
```http
POST /milestones/{milestone_id}/review
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "status": "approved", // approved, rejected, needs_revision
  "feedback": "Great progress, approved for next phase"
}
```

## Budget Management

### Get Budgets
```http
GET /budgets?financial_year=2024&sector=education
Authorization: Bearer {access_token}
```

### Create Budget
```http
POST /budgets
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "financial_year": 2024,
  "total_budget": 1000000.00,
  "sector_allocations": {
    "education": 400000.00,
    "health": 300000.00,
    "infrastructure": 200000.00,
    "agriculture": 100000.00
  }
}
```

### Get Budget Analytics
```http
GET /budgets/analytics?financial_year=2024
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "total_allocated": 1000000.00,
    "total_spent": 650000.00,
    "remaining": 350000.00,
    "utilization_percentage": 65.0,
    "sector_breakdown": {
      "education": {
        "allocated": 400000.00,
        "spent": 280000.00,
        "remaining": 120000.00,
        "utilization": 70.0
      }
    },
    "monthly_expenditure": [
      {"month": "2024-01", "amount": 50000.00},
      {"month": "2024-02", "amount": 75000.00}
    ]
  }
}
```

## Survey & KPI Management

### Get Surveys
```http
GET /surveys?project_id={project_id}&status=active
Authorization: Bearer {access_token}
```

### Create Survey
```http
POST /surveys
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "title": "Project Impact Assessment",
  "description": "Quarterly impact assessment survey",
  "project_id": "uuid",
  "questions": [
    {
      "type": "multiple_choice",
      "question": "How would you rate the project impact?",
      "options": ["Excellent", "Good", "Fair", "Poor"],
      "required": true
    },
    {
      "type": "number",
      "question": "Number of beneficiaries reached",
      "required": true,
      "validation": {"min": 0, "max": 10000}
    }
  ],
  "due_date": "2024-07-31"
}
```

### Submit Survey Response
```http
POST /surveys/{survey_id}/responses
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "responses": [
    {
      "question_id": "uuid",
      "answer": "Excellent"
    },
    {
      "question_id": "uuid",
      "answer": 250
    }
  ]
}
```

### Get KPI Analytics
```http
GET /kpis/analytics?project_id={project_id}&period=quarterly
Authorization: Bearer {access_token}
```

## Messaging System

### Get Conversations
```http
GET /messages/conversations?page=1&limit=20
Authorization: Bearer {access_token}
```

### Get Messages
```http
GET /messages/conversations/{conversation_id}/messages?page=1&limit=50
Authorization: Bearer {access_token}
```

### Send Message
```http
POST /messages/conversations/{conversation_id}/messages
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

{
  "content": "Message content",
  "message_type": "text", // text, file, image
  "attachments": [file1, file2]
}
```

### Create Conversation
```http
POST /messages/conversations
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "project_id": "uuid",
  "participants": ["user_id_1", "user_id_2"],
  "title": "Project Discussion"
}
```

## Notification Management

### Get Notifications
```http
GET /notifications?page=1&limit=20&unread_only=true
Authorization: Bearer {access_token}
```

### Mark Notification as Read
```http
PUT /notifications/{notification_id}/read
Authorization: Bearer {access_token}
```

### Update Notification Preferences
```http
PUT /notifications/preferences
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "email_notifications": true,
  "push_notifications": true,
  "notification_types": {
    "milestone_updates": true,
    "survey_assignments": true,
    "message_received": true,
    "budget_alerts": false
  }
}
```

## File Management

### Upload File
```http
POST /files/upload
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

{
  "file": file_data,
  "category": "milestone_attachment", // milestone_attachment, profile_avatar, project_document
  "project_id": "uuid" // optional, for project-related files
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "file_id": "uuid",
    "filename": "document.pdf",
    "file_url": "https://storage.csrcrm.com/files/uuid/document.pdf",
    "file_size": 1024000,
    "mime_type": "application/pdf",
    "uploaded_at": "2024-06-01T12:00:00Z"
  }
}
```

### Get File
```http
GET /files/{file_id}
Authorization: Bearer {access_token}
```

### Delete File
```http
DELETE /files/{file_id}
Authorization: Bearer {access_token}
```

## Reporting & Analytics

### Generate Report
```http
POST /reports/generate
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "report_type": "project_summary", // project_summary, budget_analysis, kpi_report
  "filters": {
    "financial_year": 2024,
    "sector": "education",
    "recipient_id": "uuid",
    "date_range": {
      "start_date": "2024-01-01",
      "end_date": "2024-06-30"
    }
  },
  "format": "pdf", // pdf, csv, excel
  "include_charts": true
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "report_id": "uuid",
    "status": "generating", // generating, completed, failed
    "download_url": null, // Available when status is 'completed'
    "estimated_completion": "2024-06-01T12:05:00Z"
  }
}
```

### Get Report Status
```http
GET /reports/{report_id}/status
Authorization: Bearer {access_token}
```

### Download Report
```http
GET /reports/{report_id}/download
Authorization: Bearer {access_token}
```

## Dashboard Analytics

### Get Dashboard Data
```http
GET /dashboard?role=csr_manager&period=monthly
Authorization: Bearer {access_token}
```

**Response varies by role:**

**CSR Manager Dashboard:**
```json
{
  "success": true,
  "data": {
    "summary": {
      "total_projects": 45,
      "active_projects": 32,
      "completed_projects": 13,
      "total_budget": 2500000.00,
      "budget_utilized": 1750000.00,
      "budget_utilization_percentage": 70.0
    },
    "recent_activities": [
      {
        "type": "milestone_completed",
        "project_title": "School Building Project",
        "description": "Foundation work completed",
        "timestamp": "2024-06-01T10:30:00Z"
      }
    ],
    "sector_performance": {
      "education": {"projects": 15, "budget_used": 600000.00},
      "health": {"projects": 12, "budget_used": 450000.00}
    },
    "kpi_summary": {
      "average_project_completion": 68.5,
      "beneficiaries_reached": 12500,
      "partner_satisfaction": 4.2
    }
  }
}
```

## WebSocket Real-time Features

### Connection
```javascript
// WebSocket connection URL
wss://api.csrcrm.com/ws?token={jwt_token}

// Connection events
{
  "type": "connection",
  "status": "connected",
  "user_id": "uuid"
}
```

### Message Events
```javascript
// New message received
{
  "type": "message_received",
  "data": {
    "conversation_id": "uuid",
    "message": {
      "id": "uuid",
      "content": "New message content",
      "sender": {
        "id": "uuid",
        "name": "John Doe"
      },
      "timestamp": "2024-06-01T12:00:00Z"
    }
  }
}

// Typing indicator
{
  "type": "user_typing",
  "data": {
    "conversation_id": "uuid",
    "user_id": "uuid",
    "is_typing": true
  }
}
```

### Notification Events
```javascript
// New notification
{
  "type": "notification",
  "data": {
    "id": "uuid",
    "title": "Milestone Updated",
    "message": "Project milestone has been updated",
    "type": "milestone_update",
    "project_id": "uuid",
    "timestamp": "2024-06-01T12:00:00Z"
  }
}
```

## Error Handling

### Standard Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": {
      "field_errors": {
        "email": ["Email is required"],
        "password": ["Password must be at least 8 characters"]
      }
    },
    "timestamp": "2024-06-01T12:00:00Z",
    "request_id": "uuid"
  }
}
```

### HTTP Status Codes
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `429` - Rate Limit Exceeded
- `500` - Internal Server Error

### Error Codes
- `VALIDATION_ERROR` - Request validation failed
- `AUTHENTICATION_FAILED` - Invalid credentials
- `AUTHORIZATION_FAILED` - Insufficient permissions
- `RESOURCE_NOT_FOUND` - Requested resource not found
- `RATE_LIMIT_EXCEEDED` - Too many requests
- `FILE_TOO_LARGE` - Uploaded file exceeds size limit
- `INVALID_FILE_TYPE` - Unsupported file type
- `BUSINESS_RULE_VIOLATION` - Business logic constraint violated

## Rate Limiting

- **General API**: 1000 requests per hour per user
- **File Upload**: 100 requests per hour per user
- **Report Generation**: 10 requests per hour per user
- **WebSocket Messages**: 500 messages per hour per user

## Pagination

All list endpoints support pagination:

**Request Parameters:**
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20, max: 100)

**Response Format:**
```json
{
  "data": [...],
  "pagination": {
    "current_page": 1,
    "total_pages": 10,
    "total_items": 200,
    "items_per_page": 20,
    "has_next_page": true,
    "has_previous_page": false
  }
}
```

## API Versioning

- Current version: `v1`
- Version specified in URL: `/v1/endpoint`
- Backward compatibility maintained for at least 12 months
- Deprecation notices provided 6 months in advance

## Security

- **HTTPS Only**: All API calls must use HTTPS
- **JWT Authentication**: Bearer token required for protected endpoints
- **CORS**: Configured for allowed origins
- **Input Validation**: All inputs validated and sanitized
- **Rate Limiting**: Prevents abuse and ensures fair usage
- **File Upload Security**: File type and size validation
- **SQL Injection Protection**: Parameterized queries used
- **XSS Protection**: Output encoding implemented

## Testing

### Postman Collection
A comprehensive Postman collection is available at:
`docs/api/postman/CSR-CRM-API.postman_collection.json`

### API Testing Environment
- **Development**: `https://dev-api.csrcrm.com/v1`
- **Staging**: `https://staging-api.csrcrm.com/v1`
- **Production**: `https://api.csrcrm.com/v1`

### Test Credentials
```json
{
  "csr_manager": {
    "email": "manager@test.csrcrm.com",
    "password": "TestManager123!"
  },
  "recipient": {
    "email": "recipient@test.csrcrm.com",
    "password": "TestRecipient123!"
  },
  "finance_officer": {
    "email": "finance@test.csrcrm.com",
    "password": "TestFinance123!"
  }
}
```

---

**Last Updated**: October 6, 2024  
**API Version**: v1.0.0  
**Documentation Version**: 1.0.0
