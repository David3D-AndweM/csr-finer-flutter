# UI/UX Wireframes and Design System

## Design Philosophy

The CSR CRM system follows a **clean, professional, and accessible design** approach that prioritizes:

- **Clarity**: Clear information hierarchy and intuitive navigation
- **Efficiency**: Streamlined workflows for different user roles
- **Accessibility**: WCAG 2.1 AA compliance for inclusive design
- **Consistency**: Unified design language across all platforms
- **Responsiveness**: Seamless experience across desktop, tablet, and mobile

## Design System Foundation

### Color Palette

#### Primary Colors
```
Primary Blue: #2563EB (rgb(37, 99, 235))
Primary Dark: #1E40AF (rgb(30, 64, 175))
Primary Light: #DBEAFE (rgb(219, 234, 254))
```

#### Secondary Colors
```
Success Green: #10B981 (rgb(16, 185, 129))
Warning Orange: #F59E0B (rgb(245, 158, 11))
Error Red: #EF4444 (rgb(239, 68, 68))
Info Cyan: #06B6D4 (rgb(6, 182, 212))
```

#### Neutral Colors
```
Gray 900: #111827 (Primary Text)
Gray 700: #374151 (Secondary Text)
Gray 500: #6B7280 (Muted Text)
Gray 300: #D1D5DB (Borders)
Gray 100: #F3F4F6 (Background)
Gray 50: #F9FAFB (Light Background)
White: #FFFFFF
```

#### Role-Based Accent Colors
```
CSR Manager: #8B5CF6 (Purple)
Finance Officer: #10B981 (Green)
M&E Officer: #F59E0B (Orange)
Recipient: #06B6D4 (Cyan)
Editor: #EC4899 (Pink)
```

### Typography

#### Font Stack
```
Primary: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif
Monospace: 'JetBrains Mono', 'Fira Code', Consolas, monospace
```

#### Font Sizes & Weights
```
Heading 1: 32px, Font Weight 700 (Bold)
Heading 2: 24px, Font Weight 600 (Semi-Bold)
Heading 3: 20px, Font Weight 600 (Semi-Bold)
Heading 4: 18px, Font Weight 600 (Semi-Bold)
Body Large: 16px, Font Weight 400 (Regular)
Body: 14px, Font Weight 400 (Regular)
Body Small: 12px, Font Weight 400 (Regular)
Caption: 11px, Font Weight 500 (Medium)
```

### Spacing System

```
XS: 4px
SM: 8px
MD: 16px
LG: 24px
XL: 32px
2XL: 48px
3XL: 64px
```

### Border Radius

```
Small: 4px (buttons, inputs)
Medium: 8px (cards, modals)
Large: 12px (containers)
Rounded: 50% (avatars, icons)
```

### Shadows

```
Small: 0 1px 2px 0 rgba(0, 0, 0, 0.05)
Medium: 0 4px 6px -1px rgba(0, 0, 0, 0.1)
Large: 0 10px 15px -3px rgba(0, 0, 0, 0.1)
XL: 0 20px 25px -5px rgba(0, 0, 0, 0.1)
```

## Component Library

### Buttons

#### Primary Button
```
Background: Primary Blue (#2563EB)
Text: White
Padding: 12px 24px
Border Radius: 8px
Font Weight: 600
Hover: Primary Dark (#1E40AF)
```

#### Secondary Button
```
Background: Transparent
Border: 1px solid Primary Blue
Text: Primary Blue
Padding: 12px 24px
Border Radius: 8px
Font Weight: 600
Hover: Primary Light background
```

#### Danger Button
```
Background: Error Red (#EF4444)
Text: White
Padding: 12px 24px
Border Radius: 8px
Font Weight: 600
Hover: Darker red
```

### Form Elements

#### Input Fields
```
Background: White
Border: 1px solid Gray 300
Padding: 12px 16px
Border Radius: 8px
Font Size: 14px
Focus: Primary Blue border, blue shadow
Error: Red border, red shadow
```

#### Select Dropdowns
```
Same as input fields
Dropdown icon: Chevron down
Options: White background, hover Gray 50
```

#### Checkboxes & Radio Buttons
```
Size: 20px x 20px
Border: 2px solid Gray 300
Checked: Primary Blue background
Border Radius: 4px (checkbox), 50% (radio)
```

### Cards

#### Standard Card
```
Background: White
Border: 1px solid Gray 200
Border Radius: 12px
Padding: 24px
Shadow: Medium shadow
```

#### Dashboard Card
```
Background: White
Border: None
Border Radius: 12px
Padding: 20px
Shadow: Small shadow
```

### Navigation

#### Sidebar Navigation
```
Width: 280px (desktop), collapsible
Background: White
Border Right: 1px solid Gray 200
Items: 48px height, 16px padding
Active: Primary Light background, Primary Blue text
Hover: Gray 50 background
```

#### Top Navigation
```
Height: 64px
Background: White
Border Bottom: 1px solid Gray 200
Shadow: Small shadow
```

## Wireframes by User Role

### 1. CSR Manager Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│ CSR CRM                    🔔 Notifications    👤 Profile Menu  │
├─────────────────────────────────────────────────────────────────┤
│ 📊 Dashboard │                                                  │
│ 📋 Projects  │  📈 Overview Cards                               │
│ 💰 Budgets   │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐│
│ 📊 Reports   │  │ Total   │ │ Active  │ │ Budget  │ │ KPIs    ││
│ 👥 Users     │  │Projects │ │Projects │ │Utilized │ │Achieved ││
│ ⚙️ Settings  │  │   45    │ │   23    │ │   78%   │ │   85%   ││
│              │  └─────────┘ └─────────┘ └─────────┘ └─────────┘│
│              │                                                  │
│              │  📊 Budget Utilization Chart                    │
│              │  ┌─────────────────────────────────────────────┐│
│              │  │ [Bar Chart showing sector-wise spending]    ││
│              │  └─────────────────────────────────────────────┘│
│              │                                                  │
│              │  📋 Recent Projects                             │
│              │  ┌─────────────────────────────────────────────┐│
│              │  │ Project Name    │ Status    │ Progress │ Due ││
│              │  │ Education Init  │ Active    │ 65%      │ ... ││
│              │  │ Health Program  │ Planning  │ 20%      │ ... ││
│              │  └─────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

### 2. Recipient Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│ CSR CRM                    🔔 Notifications    👤 Profile Menu  │
├─────────────────────────────────────────────────────────────────┤
│ 📊 Dashboard │                                                  │
│ 📋 My Projects│  💼 MOU Overview                                │
│ 📝 Milestones│  ┌─────────────────────────────────────────────┐│
│ 📊 Surveys   │  │ MOU: Community Development 2024            ││
│ 💬 Messages  │  │ Total: $50,000 │ Disbursed: $30,000        ││
│ 📄 Reports   │  │ Remaining: $20,000 │ Projects: 3           ││
│              │  └─────────────────────────────────────────────┘│
│              │                                                  │
│              │  📋 My Active Projects                          │
│              │  ┌─────────────────────────────────────────────┐│
│              │  │ 🎓 School Infrastructure                    ││
│              │  │ Progress: ████████░░ 80%                    ││
│              │  │ Budget: $15,000 │ Spent: $12,000           ││
│              │  │ Next Milestone: Foundation Complete         ││
│              │  └─────────────────────────────────────────────┘│
│              │                                                  │
│              │  📝 Pending Actions                             │
│              │  ┌─────────────────────────────────────────────┐│
│              │  │ • Update milestone: Foundation work         ││
│              │  │ • Complete survey: Impact Assessment        ││
│              │  │ • Review message from CSR Manager          ││
│              │  └─────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

### 3. Finance Officer Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│ CSR CRM                    🔔 Notifications    👤 Profile Menu  │
├─────────────────────────────────────────────────────────────────┤
│ 📊 Dashboard │                                                  │
│ 💰 Budgets   │  💰 Financial Year 2024 Overview               │
│ 📊 Allocations│ ┌─────────────────────────────────────────────┐│
│ 📈 Reports   │  │ Total Budget: $500,000                      ││
│ 📋 Expenses  │  │ Allocated: $450,000 │ Spent: $320,000      ││
│ ⚙️ Settings  │  │ Remaining: $180,000 │ Utilization: 64%     ││
│              │  └─────────────────────────────────────────────┘│
│              │                                                  │
│              │  📊 Sector-wise Allocation                      │
│              │  ┌─────────────────────────────────────────────┐│
│              │  │ Education    ████████████░░░░ 60% ($120K)   ││
│              │  │ Health       ████████░░░░░░░░ 40% ($80K)    ││
│              │  │ Infrastructure ██████░░░░░░░░░ 30% ($60K)   ││
│              │  │ Agriculture  ████░░░░░░░░░░░░ 20% ($40K)    ││
│              │  └─────────────────────────────────────────────┘│
│              │                                                  │
│              │  📋 Recent Transactions                         │
│              │  ┌─────────────────────────────────────────────┐│
│              │  │ Date       │ Project        │ Amount │ Type  ││
│              │  │ 2024-10-05 │ School Build   │ $5,000 │ Exp   ││
│              │  │ 2024-10-03 │ Health Program │ $3,200 │ Exp   ││
│              │  └─────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

### 4. M&E Officer Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│ CSR CRM                    🔔 Notifications    👤 Profile Menu  │
├─────────────────────────────────────────────────────────────────┤
│ 📊 Dashboard │                                                  │
│ 📋 Projects  │  📊 Monitoring Overview                         │
│ 📝 Milestones│  ┌─────────────────────────────────────────────┐│
│ 📊 KPIs      │  │ Projects Monitored: 25 │ On Track: 18      ││
│ 📋 Surveys   │  │ Overdue Milestones: 3  │ KPIs Met: 85%     ││
│ 📄 Reports   │  └─────────────────────────────────────────────┘│
│              │                                                  │
│              │  ⚠️ Attention Required                          │
│              │  ┌─────────────────────────────────────────────┐│
│              │  │ 🔴 School Project - Milestone overdue       ││
│              │  │ 🟡 Health Program - Survey pending          ││
│              │  │ 🟡 Infrastructure - Budget variance         ││
│              │  └─────────────────────────────────────────────┘│
│              │                                                  │
│              │  📊 KPI Performance                             │
│              │  ┌─────────────────────────────────────────────┐│
│              │  │ Beneficiaries Reached: 1,250 / 1,500       ││
│              │  │ ████████████████░░░░ 83%                    ││
│              │  │                                             ││
│              │  │ Project Completion Rate: 78%                ││
│              │  │ ███████████████░░░░░ 78%                    ││
│              │  └─────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

### 5. Editor Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│ CSR CRM                    🔔 Notifications    👤 Profile Menu  │
├─────────────────────────────────────────────────────────────────┤
│ 📊 Dashboard │                                                  │
│ 📝 Content   │  📝 Content Management                          │
│ 📊 Statistics│  ┌─────────────────────────────────────────────┐│
│ 📸 Media     │  │ Published Posts: 12 │ Draft Posts: 3        ││
│ ⚙️ Settings  │  │ Total Views: 2,450  │ This Month: 340       ││
│              │  └─────────────────────────────────────────────┘│
│              │                                                  │
│              │  📋 Recent Posts                                │
│              │  ┌─────────────────────────────────────────────┐│
│              │  │ 📝 Success Story: Rural Education           ││
│              │  │    Status: Published │ Views: 245           ││
│              │  │                                             ││
│              │  │ 📰 Monthly Impact Report                    ││
│              │  │    Status: Draft │ Last Edit: 2 days ago   ││
│              │  └─────────────────────────────────────────────┘│
│              │                                                  │
│              │  📊 Project Statistics                          │
│              │  ┌─────────────────────────────────────────────┐│
│              │  │ Active Projects: 23                         ││
│              │  │ Completed This Month: 4                     ││
│              │  │ Total Beneficiaries: 1,250                  ││
│              │  │ Budget Utilization: 68%                     ││
│              │  └─────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

## Mobile Responsive Design

### Mobile Navigation
```
┌─────────────────────┐
│ ☰ CSR CRM      🔔👤 │
├─────────────────────┤
│                     │
│  📊 Dashboard Cards │
│  ┌─────┐ ┌─────┐    │
│  │Total│ │Active│   │
│  │ 45  │ │ 23  │    │
│  └─────┘ └─────┘    │
│                     │
│  ┌─────┐ ┌─────┐    │
│  │Budget│ │KPIs │   │
│  │ 78% │ │ 85% │    │
│  └─────┘ └─────┘    │
│                     │
│  📋 Recent Projects │
│  ┌─────────────────┐│
│  │ Education Init  ││
│  │ Status: Active  ││
│  │ Progress: 65%   ││
│  └─────────────────┘│
│                     │
└─────────────────────┘
```

### Tablet Layout
```
┌─────────────────────────────────────────────┐
│ CSR CRM              🔔 Notifications  👤   │
├─────────────────────────────────────────────┤
│ 📊 📋 💰 📊 👥 │                            │
│ Dashboard      │  📈 Overview Cards         │
│ Projects       │  ┌─────┐ ┌─────┐ ┌─────┐  │
│ Budgets        │  │Total│ │Active│ │Budget│ │
│ Reports        │  │ 45  │ │ 23  │ │ 78% │  │
│ Users          │  └─────┘ └─────┘ └─────┘  │
│                │                            │
│                │  📊 Chart Area             │
│                │  ┌─────────────────────────┐│
│                │  │ [Budget Chart]          ││
│                │  └─────────────────────────┘│
│                │                            │
│                │  📋 Projects List          │
│                │  ┌─────────────────────────┐│
│                │  │ Project │ Status │ Due  ││
│                │  │ Edu Init│ Active │ ... ││
│                │  └─────────────────────────┘│
└─────────────────────────────────────────────┘
```

## Accessibility Features

### WCAG 2.1 AA Compliance
- **Color Contrast**: Minimum 4.5:1 ratio for normal text, 3:1 for large text
- **Keyboard Navigation**: Full keyboard accessibility with visible focus indicators
- **Screen Reader Support**: Proper ARIA labels and semantic HTML
- **Alternative Text**: All images have descriptive alt text
- **Form Labels**: All form inputs have associated labels

### Focus Management
```
Focus Ring: 2px solid Primary Blue with 2px offset
Skip Links: "Skip to main content" for keyboard users
Focus Trap: Modal dialogs trap focus within
Logical Tab Order: Sequential navigation through interactive elements
```

### High Contrast Mode
```
Background: #000000 (Black)
Text: #FFFFFF (White)
Borders: #FFFFFF (White)
Focus: #FFFF00 (Yellow)
```

## Animation and Transitions

### Micro-interactions
```
Button Hover: 150ms ease-in-out transform scale(1.02)
Card Hover: 200ms ease-in-out shadow elevation
Page Transitions: 300ms ease-in-out slide/fade
Loading States: Skeleton screens with shimmer effect
```

### Loading States
```
Skeleton Cards: Gray 200 background with animated shimmer
Spinners: Primary Blue rotating circle
Progress Bars: Primary Blue with smooth animation
Button Loading: Spinner replaces text, button disabled
```

## Error States and Feedback

### Form Validation
```
Error Messages: Red text below input fields
Success Messages: Green text with checkmark icon
Warning Messages: Orange text with warning icon
Info Messages: Blue text with info icon
```

### Empty States
```
Illustration: Simple, friendly graphics
Headline: Clear explanation of empty state
Action Button: Primary CTA to resolve empty state
Secondary Text: Additional context or help
```

## Data Visualization

### Charts and Graphs
```
Color Palette: Primary Blue, Success Green, Warning Orange, Info Cyan
Bar Charts: Rounded corners, hover effects
Line Charts: Smooth curves, data point highlights
Pie Charts: Clear labels, percentage display
Progress Bars: Animated fill, percentage text
```

### Tables
```
Header: Gray 50 background, bold text
Rows: Alternating white/gray 25 backgrounds
Hover: Gray 50 background highlight
Sorting: Arrow indicators in headers
Pagination: Standard prev/next with page numbers
```

## Implementation Guidelines

### Flutter Specific
```
Theme: Use Flutter's ThemeData for consistent styling
Responsive: Use LayoutBuilder and MediaQuery for responsive design
Animations: Use Flutter's built-in animation widgets
Accessibility: Implement Semantics widgets for screen readers
Testing: Use Flutter's widget testing for UI components
```

### Design Tokens
```
Colors: Define in theme configuration
Spacing: Use consistent spacing scale
Typography: Define text styles in theme
Shadows: Use BoxShadow with consistent elevation
Border Radius: Define standard radius values
```

This comprehensive design system ensures consistency, accessibility, and professional appearance across all platforms while maintaining the flexibility needed for different user roles and workflows.
