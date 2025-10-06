# Database Schema Documentation

## Overview

This document outlines the complete database schema for the CSR CRM system, designed to support multi-tenant operations, role-based access control, and comprehensive project management.

## Database Design Principles

- **Normalization**: 3NF compliance to reduce redundancy
- **Scalability**: Designed for horizontal scaling
- **Security**: Row-level security and audit trails
- **Performance**: Optimized indexes and query patterns
- **Flexibility**: Extensible schema for future requirements

## Core Entities

### 1. Users Table

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    avatar_url TEXT,
    role user_role NOT NULL,
    status user_status DEFAULT 'active',
    email_verified BOOLEAN DEFAULT false,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

CREATE TYPE user_role AS ENUM (
    'csr_manager',
    'finance_officer', 
    'monitoring_evaluation_officer',
    'recipient',
    'editor'
);

CREATE TYPE user_status AS ENUM (
    'active',
    'inactive',
    'suspended',
    'pending_verification'
);
```

### 2. Organizations Table

```sql
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    registration_number VARCHAR(100),
    tax_id VARCHAR(100),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    logo_url TEXT,
    status organization_status DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TYPE organization_status AS ENUM (
    'active',
    'inactive',
    'suspended'
);
```

### 3. MOUs (Memorandums of Understanding)

```sql
CREATE TABLE mous (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mou_number VARCHAR(100) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    recipient_id UUID NOT NULL REFERENCES users(id),
    organization_id UUID REFERENCES organizations(id),
    total_amount DECIMAL(15,2) NOT NULL,
    disbursed_amount DECIMAL(15,2) DEFAULT 0,
    remaining_amount DECIMAL(15,2) GENERATED ALWAYS AS (total_amount - disbursed_amount) STORED,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status mou_status DEFAULT 'draft',
    signed_date DATE,
    document_url TEXT,
    terms_conditions TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

CREATE TYPE mou_status AS ENUM (
    'draft',
    'pending_approval',
    'active',
    'completed',
    'terminated',
    'expired'
);
```

### 4. Projects Table

```sql
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_code VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    mou_id UUID REFERENCES mous(id),
    recipient_id UUID NOT NULL REFERENCES users(id),
    sector project_sector NOT NULL,
    estimated_budget DECIMAL(15,2) NOT NULL,
    actual_expenditure DECIMAL(15,2) DEFAULT 0,
    remaining_budget DECIMAL(15,2) GENERATED ALWAYS AS (estimated_budget - actual_expenditure) STORED,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status project_status DEFAULT 'planning',
    progress_percentage INTEGER DEFAULT 0 CHECK (progress_percentage >= 0 AND progress_percentage <= 100),
    location VARCHAR(255),
    beneficiaries_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

CREATE TYPE project_sector AS ENUM (
    'education',
    'health',
    'infrastructure',
    'agriculture',
    'environment',
    'technology',
    'community_development',
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

### 5. Milestones Table

```sql
CREATE TABLE milestones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE NOT NULL,
    completion_date DATE,
    progress_percentage INTEGER DEFAULT 0 CHECK (progress_percentage >= 0 AND progress_percentage <= 100),
    status milestone_status DEFAULT 'pending',
    notes TEXT,
    budget_allocated DECIMAL(15,2) DEFAULT 0,
    budget_spent DECIMAL(15,2) DEFAULT 0,
    order_index INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

CREATE TYPE milestone_status AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'overdue',
    'cancelled'
);
```

### 6. Budgets Table

```sql
CREATE TABLE budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    financial_year INTEGER NOT NULL,
    total_budget DECIMAL(15,2) NOT NULL,
    allocated_amount DECIMAL(15,2) DEFAULT 0,
    spent_amount DECIMAL(15,2) DEFAULT 0,
    remaining_amount DECIMAL(15,2) GENERATED ALWAYS AS (total_budget - spent_amount) STORED,
    status budget_status DEFAULT 'draft',
    approved_date DATE,
    approved_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id)
);

CREATE TYPE budget_status AS ENUM (
    'draft',
    'pending_approval',
    'approved',
    'active',
    'closed'
);
```

### 7. Budget Allocations Table

```sql
CREATE TABLE budget_allocations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    budget_id UUID NOT NULL REFERENCES budgets(id) ON DELETE CASCADE,
    sector project_sector NOT NULL,
    allocated_amount DECIMAL(15,2) NOT NULL,
    spent_amount DECIMAL(15,2) DEFAULT 0,
    remaining_amount DECIMAL(15,2) GENERATED ALWAYS AS (allocated_amount - spent_amount) STORED,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 8. Surveys Table

```sql
CREATE TABLE surveys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    project_id UUID REFERENCES projects(id),
    mou_id UUID REFERENCES mous(id),
    survey_type survey_type NOT NULL,
    status survey_status DEFAULT 'draft',
    start_date DATE,
    end_date DATE,
    questions JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id)
);

CREATE TYPE survey_type AS ENUM (
    'baseline',
    'midline',
    'endline',
    'impact_assessment',
    'satisfaction',
    'monitoring'
);

CREATE TYPE survey_status AS ENUM (
    'draft',
    'active',
    'closed',
    'archived'
);
```

### 9. Survey Responses Table

```sql
CREATE TABLE survey_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    survey_id UUID NOT NULL REFERENCES surveys(id) ON DELETE CASCADE,
    respondent_id UUID NOT NULL REFERENCES users(id),
    responses JSONB NOT NULL,
    completion_status response_status DEFAULT 'in_progress',
    submitted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TYPE response_status AS ENUM (
    'in_progress',
    'completed',
    'submitted'
);
```

### 10. KPIs Table

```sql
CREATE TABLE kpis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES projects(id),
    survey_id UUID REFERENCES surveys(id),
    kpi_name VARCHAR(255) NOT NULL,
    kpi_description TEXT,
    target_value DECIMAL(15,2),
    actual_value DECIMAL(15,2),
    unit VARCHAR(50),
    calculation_method TEXT,
    data_source VARCHAR(255),
    measurement_date DATE,
    status kpi_status DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TYPE kpi_status AS ENUM (
    'active',
    'achieved',
    'not_achieved',
    'discontinued'
);
```

### 11. Messages Table

```sql
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL REFERENCES users(id),
    recipient_id UUID NOT NULL REFERENCES users(id),
    project_id UUID REFERENCES projects(id),
    subject VARCHAR(255),
    content TEXT NOT NULL,
    message_type message_type DEFAULT 'general',
    priority message_priority DEFAULT 'normal',
    status message_status DEFAULT 'sent',
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TYPE message_type AS ENUM (
    'general',
    'project_update',
    'milestone_notification',
    'survey_assignment',
    'system_notification'
);

CREATE TYPE message_priority AS ENUM (
    'low',
    'normal',
    'high',
    'urgent'
);

CREATE TYPE message_status AS ENUM (
    'draft',
    'sent',
    'delivered',
    'read'
);
```

### 12. File Attachments Table

```sql
CREATE TABLE file_attachments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type attachment_entity_type NOT NULL,
    entity_id UUID NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    uploaded_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TYPE attachment_entity_type AS ENUM (
    'project',
    'milestone',
    'mou',
    'message',
    'survey_response',
    'user_profile'
);
```

### 13. Notifications Table

```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    notification_type notification_type NOT NULL,
    entity_type VARCHAR(50),
    entity_id UUID,
    priority notification_priority DEFAULT 'normal',
    status notification_status DEFAULT 'unread',
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TYPE notification_type AS ENUM (
    'milestone_due',
    'project_update',
    'survey_assigned',
    'message_received',
    'budget_alert',
    'system_update'
);

CREATE TYPE notification_priority AS ENUM (
    'low',
    'normal',
    'high',
    'critical'
);

CREATE TYPE notification_status AS ENUM (
    'unread',
    'read',
    'archived'
);
```

### 14. Content Management (CMS) Tables

```sql
CREATE TABLE content_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    content TEXT NOT NULL,
    excerpt TEXT,
    featured_image_url TEXT,
    post_type content_type DEFAULT 'blog',
    status content_status DEFAULT 'draft',
    published_at TIMESTAMP WITH TIME ZONE,
    author_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TYPE content_type AS ENUM (
    'blog',
    'news',
    'announcement',
    'project_story'
);

CREATE TYPE content_status AS ENUM (
    'draft',
    'published',
    'archived'
);
```

### 15. Audit Log Table

```sql
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id UUID NOT NULL,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## Indexes for Performance

```sql
-- User indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);

-- Project indexes
CREATE INDEX idx_projects_recipient ON projects(recipient_id);
CREATE INDEX idx_projects_mou ON projects(mou_id);
CREATE INDEX idx_projects_sector ON projects(sector);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_dates ON projects(start_date, end_date);

-- Milestone indexes
CREATE INDEX idx_milestones_project ON milestones(project_id);
CREATE INDEX idx_milestones_due_date ON milestones(due_date);
CREATE INDEX idx_milestones_status ON milestones(status);

-- Message indexes
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_messages_recipient ON messages(recipient_id);
CREATE INDEX idx_messages_project ON messages(project_id);
CREATE INDEX idx_messages_created ON messages(created_at DESC);

-- Notification indexes
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_status ON notifications(status);
CREATE INDEX idx_notifications_created ON notifications(created_at DESC);

-- Survey indexes
CREATE INDEX idx_surveys_project ON surveys(project_id);
CREATE INDEX idx_survey_responses_survey ON survey_responses(survey_id);
CREATE INDEX idx_survey_responses_respondent ON survey_responses(respondent_id);

-- Budget indexes
CREATE INDEX idx_budgets_financial_year ON budgets(financial_year);
CREATE INDEX idx_budget_allocations_budget ON budget_allocations(budget_id);
CREATE INDEX idx_budget_allocations_sector ON budget_allocations(sector);

-- File attachment indexes
CREATE INDEX idx_file_attachments_entity ON file_attachments(entity_type, entity_id);

-- Audit log indexes
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);
```

## Views for Common Queries

```sql
-- Project summary view
CREATE VIEW project_summary AS
SELECT 
    p.id,
    p.project_code,
    p.title,
    p.sector,
    p.status,
    p.progress_percentage,
    p.estimated_budget,
    p.actual_expenditure,
    p.remaining_budget,
    u.first_name || ' ' || u.last_name AS recipient_name,
    o.name AS organization_name,
    COUNT(m.id) AS total_milestones,
    COUNT(CASE WHEN m.status = 'completed' THEN 1 END) AS completed_milestones
FROM projects p
LEFT JOIN users u ON p.recipient_id = u.id
LEFT JOIN mous mo ON p.mou_id = mo.id
LEFT JOIN organizations o ON mo.organization_id = o.id
LEFT JOIN milestones m ON p.id = m.project_id
GROUP BY p.id, u.first_name, u.last_name, o.name;

-- Budget utilization view
CREATE VIEW budget_utilization AS
SELECT 
    b.financial_year,
    ba.sector,
    ba.allocated_amount,
    ba.spent_amount,
    ba.remaining_amount,
    ROUND((ba.spent_amount / ba.allocated_amount * 100), 2) AS utilization_percentage
FROM budgets b
JOIN budget_allocations ba ON b.id = ba.budget_id
WHERE b.status = 'active';

-- User dashboard stats view
CREATE VIEW user_dashboard_stats AS
SELECT 
    u.id AS user_id,
    u.role,
    COUNT(DISTINCT p.id) AS total_projects,
    COUNT(DISTINCT CASE WHEN p.status = 'active' THEN p.id END) AS active_projects,
    COUNT(DISTINCT CASE WHEN p.status = 'completed' THEN p.id END) AS completed_projects,
    COUNT(DISTINCT m.id) AS total_milestones,
    COUNT(DISTINCT CASE WHEN m.status = 'completed' THEN m.id END) AS completed_milestones,
    COUNT(DISTINCT CASE WHEN n.status = 'unread' THEN n.id END) AS unread_notifications
FROM users u
LEFT JOIN projects p ON u.id = p.recipient_id
LEFT JOIN milestones m ON p.id = m.project_id
LEFT JOIN notifications n ON u.id = n.user_id
GROUP BY u.id, u.role;
```

## Security Considerations

### Row Level Security (RLS)

```sql
-- Enable RLS on sensitive tables
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;

-- Example RLS policies
CREATE POLICY project_access_policy ON projects
    FOR ALL TO authenticated
    USING (
        recipient_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() 
            AND role IN ('csr_manager', 'monitoring_evaluation_officer')
        )
    );

CREATE POLICY message_access_policy ON messages
    FOR ALL TO authenticated
    USING (
        sender_id = auth.uid() OR 
        recipient_id = auth.uid()
    );
```

### Data Encryption

- Sensitive fields should be encrypted at rest
- Use application-level encryption for PII data
- Implement field-level encryption for financial data

## Backup and Recovery

- Daily automated backups
- Point-in-time recovery capability
- Cross-region backup replication
- Regular backup restoration testing

## Migration Strategy

1. **Version Control**: Use database migration tools (Flyway, Liquibase)
2. **Rollback Plans**: Every migration should have a rollback script
3. **Testing**: Test migrations on staging environment first
4. **Monitoring**: Monitor performance impact of schema changes

## Performance Optimization

- **Partitioning**: Consider partitioning large tables by date
- **Archiving**: Archive old data to separate tables
- **Caching**: Implement Redis caching for frequently accessed data
- **Connection Pooling**: Use connection pooling for better performance

## Monitoring and Maintenance

- **Query Performance**: Monitor slow queries and optimize
- **Index Usage**: Regular index usage analysis
- **Storage Growth**: Monitor database size and growth patterns
- **Health Checks**: Automated database health monitoring

This schema provides a robust foundation for the CSR CRM system with proper normalization, security, and performance considerations.
