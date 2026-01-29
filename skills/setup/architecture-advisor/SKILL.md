---
name: architecture-advisor
description: >
  Recommends technology stacks based on project requirements, goals, or requirements documents.
  Trigger: When choosing tech stack, planning architecture, processing requirements documents.
license: Apache-2.0
metadata:
  author: agentic-boost
  version: '1.0'
  scope: [root]
  auto_invoke:
    - 'Choosing technology stack'
    - 'Planning project architecture'
    - 'Processing requirements document'
    - 'Suggesting tech for new project'
    - 'What tech should I use'
allowed-tools: [Read, Glob, Grep, WebSearch, Write]
---

## Purpose

Provides technology recommendations based on project goals, requirements, or existing analysis.
Acts as a knowledgeable guide for technology decisions.

**Key principle**: This skill recommends and advises. It does NOT scaffold - that's `project-bootstrap`'s job.

## When to Use

- Starting a brand new project (greenfield)
- Evaluating technology choices for new features
- Processing requirements documents (PRD, RFC, spec)
- When user asks "what tech should I use for X?"
- When user provides requirements and wants architecture guidance

## When NOT to Use

- For scaffolding directories → use `project-bootstrap`
- For analyzing existing projects → use `project-analyzer`
- For auditing best practices → use `best-practices-auditor`

---

## Workflow

```
1. ANALYZE CURRENT STATE
   ├─ Invoke `project-analyzer` first
   └─ Understand what exists (if anything)

2. GATHER REQUIREMENTS
   ├─ From user questions
   ├─ From requirements document
   └─ From interactive interview

3. RESEARCH (optional)
   ├─ Use WebSearch for modern tool comparisons
   └─ Validate recommendations against current best practices

4. GENERATE RECOMMENDATIONS
   ├─ Primary stack recommendation
   ├─ Supporting tools
   ├─ Structure recommendation
   └─ Rationale for choices

5. PRESENT TO USER
   ├─ Show recommendation with rationale
   ├─ Show alternatives considered
   └─ Ask for approval

6. IF APPROVED
   └─ Invoke `project-bootstrap` with approved configuration
```

---

## Interview Questions

When gathering requirements interactively, ask these questions:

### 1. Project Type

```
What type of project are you building?
1. Web application (frontend + backend)
2. API/Backend service only
3. Frontend/UI only
4. CLI tool
5. Library/SDK
6. Mobile application
7. Desktop application
```

### 2. Scale & Complexity

```
What's the expected scale?
1. Personal/hobby project
2. Small team (2-5 developers)
3. Medium team (5-20 developers)
4. Large team/enterprise (20+ developers)
```

### 3. Key Requirements

```
What are your key requirements? (select all that apply)
1. Real-time features (WebSocket, live updates)
2. Heavy data processing
3. High performance/low latency
4. Offline support
5. Multi-platform (web + mobile)
6. Strong typing
7. Rapid prototyping
```

### 4. Team Expertise

```
What's your team's expertise?
1. JavaScript/TypeScript
2. Python
3. Go
4. Rust
5. Java/Kotlin
6. C#/.NET
7. Multiple/flexible
```

### 5. Deployment Target

```
Where will this be deployed?
1. Cloud (AWS, GCP, Azure)
2. Self-hosted/on-premise
3. Edge/serverless
4. Container orchestration (Kubernetes)
5. Simple VPS/VM
```

---

## Stack Recommendations

### Web Application (Full Stack)

**For rapid development + TypeScript team:**

```yaml
recommendation:
  primary:
    language: TypeScript
    framework: Next.js 14+
    runtime: Node.js
  database:
    primary: PostgreSQL
    orm: Prisma
  styling: Tailwind CSS
  auth: NextAuth.js or Clerk
  deployment: Vercel or Docker
rationale:
  - 'Full-stack in one framework'
  - 'Excellent DX with TypeScript'
  - 'Built-in SSR/SSG for performance'
  - 'Large ecosystem and community'
```

**For high performance + scalability:**

```yaml
recommendation:
  primary:
    language: Go or Rust
    framework: Gin (Go) or Axum (Rust)
  frontend:
    language: TypeScript
    framework: React or Svelte
  database:
    primary: PostgreSQL
    cache: Redis
  deployment: Kubernetes
rationale:
  - 'Compiled languages for backend performance'
  - 'Separate frontend allows independent scaling'
  - 'Production-ready for high traffic'
```

### API/Backend Only

**For Python team + ML/Data:**

```yaml
recommendation:
  primary:
    language: Python
    framework: FastAPI
    runtime: uvicorn
  database:
    primary: PostgreSQL
    orm: SQLAlchemy or SQLModel
  validation: Pydantic
  docs: Auto-generated OpenAPI
rationale:
  - 'Async support for high concurrency'
  - 'Native typing with Pydantic'
  - 'Excellent for ML integration'
  - 'Auto-generated API docs'
```

**For microservices:**

```yaml
recommendation:
  primary:
    language: Go
    framework: Go-kit or standard library
  communication: gRPC + REST
  discovery: Consul or Kubernetes DNS
  observability: OpenTelemetry
rationale:
  - 'Small binary size, fast startup'
  - 'Excellent concurrency model'
  - 'gRPC for internal, REST for external'
```

### CLI Tool

**For cross-platform distribution:**

```yaml
recommendation:
  primary:
    language: Go
    libraries: Cobra + Viper
  distribution: Single binary
rationale:
  - 'Compiles to single binary'
  - 'No runtime dependencies'
  - 'Cross-compile easily'
```

**For rapid development:**

```yaml
recommendation:
  primary:
    language: TypeScript
    runtime: Bun or Node.js
    libraries: Commander + Inquirer
  distribution: npm package
rationale:
  - 'Familiar for JS/TS teams'
  - 'Rich ecosystem'
  - 'Easy npm distribution'
```

### Library/SDK

**For TypeScript ecosystem:**

```yaml
recommendation:
  primary:
    language: TypeScript
    build: tsup or unbuild
    testing: Vitest
  distribution: npm
  docs: TypeDoc or TSDoc
rationale:
  - 'First-class TypeScript support'
  - 'Tree-shakeable ESM output'
  - 'Type definitions included'
```

**For multi-language SDK:**

```yaml
recommendation:
  approach: OpenAPI-first
  spec: OpenAPI 3.1
  generators: openapi-generator
  testing: Contract testing
rationale:
  - 'Single source of truth'
  - 'Generate SDKs for any language'
  - 'Consistent across platforms'
```

---

## Using WebSearch for Research

When user wants modern tool recommendations, use WebSearch to:

### Research Queries

```
"best {category} tools 2026"
"{tool1} vs {tool2} comparison 2026"
"{framework} alternatives 2026"
"modern {language} web framework comparison"
```

### Validation Criteria

Before recommending a tool found via WebSearch:

| Criterion        | Threshold  |
| ---------------- | ---------- |
| GitHub stars     | > 5,000    |
| Weekly downloads | > 50,000   |
| Last commit      | < 30 days  |
| Age              | > 6 months |
| Documentation    | Complete   |

### Example Research Flow

```
User: "What's the best Python web framework for 2026?"

1. WebSearch: "best Python web framework 2026 comparison"
2. WebSearch: "FastAPI vs Django vs Flask 2026"
3. Validate findings against criteria
4. Present comparison:
   - FastAPI: Best for APIs, async, modern
   - Django: Best for full-featured apps, batteries included
   - Litestar: Modern alternative to FastAPI
```

---

## Handling Existing Projects

If `project-analyzer` detects an existing stack:

### Compatible Addition

```
Existing: TypeScript + React
User wants: Add backend

Recommendation:
- Add Next.js API routes (same codebase)
- OR add separate FastAPI service (if Python team)

Rationale:
- Keeps tech stack cohesive
- Doesn't conflict with existing setup
```

### Migration Path

```
Existing: JavaScript (no types)
User wants: Better type safety

Recommendation:
- Incremental TypeScript migration
- Add tsconfig.json with allowJs: true
- Migrate file by file

NOT recommended:
- Rewrite everything at once
- Switch to different language
```

---

## Output Format

### Recommendation Report

```markdown
## Architecture Recommendation

### Summary

{one-line summary of recommended stack}

### Primary Stack

| Component | Technology | Rationale                   |
| --------- | ---------- | --------------------------- |
| Language  | TypeScript | Type safety, team expertise |
| Framework | Next.js 14 | Full-stack, excellent DX    |
| Database  | PostgreSQL | Reliable, scalable          |
| ORM       | Prisma     | Type-safe queries           |

### Supporting Tools

| Category | Tool         | Purpose           |
| -------- | ------------ | ----------------- |
| Styling  | Tailwind CSS | Utility-first CSS |
| Auth     | NextAuth.js  | Authentication    |
| Testing  | Vitest       | Fast unit tests   |
| E2E      | Playwright   | Browser testing   |

### Project Structure
```

project/
├── src/
│ ├── app/ # Next.js app router
│ ├── components/ # React components
│ ├── lib/ # Utilities
│ └── server/ # Server-side code
├── prisma/ # Database schema
└── tests/

```

### Alternatives Considered

| Alternative | Trade-offs |
|-------------|------------|
| Remix | Better data loading, smaller ecosystem |
| SvelteKit | Faster runtime, less React expertise |

### Next Steps

1. **Approve this recommendation** to proceed with scaffolding
2. **Request changes** if you want different tech choices
3. **Ask for more research** on specific alternatives

Would you like me to proceed with scaffolding this structure?
```

---

## Integration with Other Skills

### Before Advising

```
ALWAYS invoke `project-analyzer` first to understand:
- Is project empty or has existing code?
- What stack already exists?
- What agentic-boost setup is present?
```

### After Approval

```
IF user approves recommendation:
  1. Invoke `project-bootstrap` with:
     - project_type: from recommendation
     - components: from structure
     - tech_stack: for documentation

  2. Suggest next steps:
     - "Set up quality gates" → invoke setup-quality
     - "Configure IDE" → run setup.sh
```

### Example Handoff

```
User: "Yes, proceed with that recommendation"

Agent:
"Great! I'll now invoke the `project-bootstrap` skill to create the structure.

Creating:
- Multi-component structure
- Components: api, web
- Stack: TypeScript, Next.js, FastAPI

[Invokes project-bootstrap]

Structure created! Next steps:
1. Set up quality gates? (I can invoke setup-quality)
2. Configure your IDE? (run ./skills/setup/setup.sh)
"
```

---

## Requirements Document Processing

When user provides a PRD or requirements document:

### Extraction Process

```
1. READ document thoroughly
2. IDENTIFY technical constraints:
   - Performance requirements
   - Scale expectations
   - Integration needs
   - Compliance requirements
3. IDENTIFY functional requirements:
   - Core features
   - User types
   - Data needs
4. MAP to technology decisions
5. GENERATE recommendation
```

### Example

```
User provides: "PRD for e-commerce platform"

Extracted:
- 10k concurrent users → need scalable backend
- Real-time inventory → need WebSocket or SSE
- Payment processing → need PCI compliance
- Mobile app later → need API-first design

Recommendation:
- Backend: Go + Gin (performance, concurrency)
- Frontend: Next.js (SEO for e-commerce)
- Database: PostgreSQL + Redis
- Architecture: API-first for mobile readiness
```
