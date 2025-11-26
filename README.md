# 🧠 Origin Take-Home Assignment — Therapist Session Dashboard
**Stack:** TypeScript · Next.js 15+ (App Router) · React 19 · REST API · Postgres (Neon) · TailwindCSS  

---

## ✉️ Overview
Welcome 👋 — and thanks for taking the time to complete Origin Therapy’s take-home challenge.  
This exercise mirrors real full-stack work at **Origin**: connecting clean backend APIs to polished, type-safe UIs.

You’ll build a small **Therapist Session Dashboard** using **Next.js 15+**, **TypeScript**, **React 19** and a provided **Neon Postgres** database.

Feel free to use **AI coding assistants** (Cursor, Copilot, Claude, etc.) — we care most about structure, clarity, and UX judgment.

---

## 🎯 Goal
Build a small **full-stack web app** where therapists can view and update their upcoming sessions.

You’ll:
1. Connect to a provided **Postgres database** (already seeded with mock data).  
2. Build a small **REST API** that handles CRUD.  
3. Create a **Next.js UI** that consumes that API and presents a usable dashboard.  

---

## 🧱 Database Access
You’ll receive your personal **Neon connection string** by email.

Add it to a local `.env.local` file:
```bash
DATABASE_URL="postgresql://takehome_user:password@ep-example.neon.tech/neon?branch=takehome-yourname&sslmode=require"
```

This connects to your own isolated branch seeded with mock data for:
- Therapists  
- Patients  
- Sessions  

You can safely modify session data (no schema changes).

---

## 🧩 Requirements

### 1️⃣ Backend (REST API)
- Connect to the provided **Postgres** database.  
- Design and implement a **RESTful API** (TypeScript; **pg**, **Drizzle**, or **Prisma**) for these capabilities:

| Capability | Details |
|------------|---------|
| List sessions | Join with therapist + patient names; support **server-side** filtering (at least `status`, ideally `therapist`) and **pagination** |
| Create session | Add a new session |
| Update session | Update fields (e.g., status change) |
| List therapists | For dropdown/select UI |
| List patients | For dropdown/select UI |

- **Your design decisions** (1-2 paragraphs in your README): URL structure and HTTP methods, query parameter conventions, response envelope, error format.  
- **Validation**: Use **Zod** (or similar) to validate request bodies; return `400` with descriptive errors.  
- **Error handling**: Return appropriate HTTP status codes (`201 / 400 / 404 / 500`) with a consistent error response shape.  
- **Query efficiency**: Join therapist/patient names efficiently; avoid N+1 queries.  

**Example error response envelope**
```json
{ "error": { "code": "VALIDATION_ERROR", "message": "Invalid status value" } }
```

---

### 2️⃣ Frontend (UI)
- Display sessions in a responsive table or card layout.  
- Show therapist name, patient name, date/time, and status.  
- **Filtering**: Filter by therapist and status.  
- **Pagination**: Implement pagination that works with the backend.  
- **Operations**: Create sessions and update status.  
- **Loading & error states**: Include loading, error, and empty states.  
- **Modern React**: Use **React Suspense** for data loading (e.g., sessions list) with a fallback; keep components lean and organized.  
- Style with **TailwindCSS** — clean and readable.

### 3️⃣ Bonus (Optional)
- Server-side: add rate limiting or request logging middleware.  
- Server-side: add a `/api/sessions/stats` endpoint (e.g., sessions per therapist, completion rate).  
- Server-side: add date-range filtering or sorting for sessions.  
- Frontend: URL-synced filters/search/sort so the view is shareable/bookmarkable.  
- Frontend: optimistic updates with rollback on failure for status changes.  
- Frontend: virtualized table for large datasets.  
- Frontend: toast/notification system for CRUD feedback.  
- DevOps: add basic API tests (Jest/Vitest).  
- Explain: in README, describe how you’d add authentication.

---

### 4️⃣ Deployment & Notes
- Deploy to [Vercel](https://vercel.com) or [Render](https://render.com).  
- Think about errors/edge cases/security/auth/scalability. If you don't have time to implement them, mention how you would handle them in the README file.

---

## 🧰 Setup

### 1. Clone / Install
```bash
git clone https://github.com/Origin-Therapy/origin-takehome-interview.git
cd origin-takehome-interview
npm install
```

### 2. Environment Variables
Create a `.env.local` file:
```bash
DATABASE_URL="your-connection-string"
```

### 3. Run Locally
```bash
npm run dev
# open http://localhost:3000
```

---

## 🧾 Submission
When finished, please send:
1. A link to your **GitHub repo** (public or invite us).  
2. A short section in your README titled **“Design Choices”** explaining:  
   - How you approached the problem  
   - Any trade-offs or assumptions  
   - What you’d improve with more time  
   - Your API design (URLs/methods, filtering, pagination, response/error formats)  
   - How you structured queries and handled validation  
   - Frontend architecture decisions (state management, component organization)
3. *(Optional)* A 2–3 minute Loom or screen recording showing your app.

Email your submission to **ni@joinoriginspeech.com**.

---

## 🗓 Timeline
Please submit within **6 hours** of receiving your database URL.  
If you’re short on time, prioritize what best shows your strengths; quality over completeness.  
Remember: a well-executed **70%** is better than a rushed **100%**.

---

## 🧮 Evaluation Rubric (30 pts)

| Category | Points | What We Look For |
|-----------|--------|-----------------|
| Backend API Design | 5 | RESTful resource naming, appropriate methods/status codes, sensible query params, consistent response envelope |
| Backend Data Layer | 5 | Efficient joins, server-side filtering/pagination (at least status), no N+1 |
| Input Validation & Errors | 5 | Zod (or similar) schemas, descriptive 400s, graceful error handling |
| Frontend Implementation | 5 | Functional UI, filters/pagination aligned with backend, clear loading/error/empty states, Suspense (e.g., sessions list) |
| Code Quality & TypeScript | 5 | Clean types, no `any`, logical file organization, readable code |
| Documentation / Reasoning | 5 | README clarity on decisions (API design, queries, state, trade-offs) |

✅ *Bonus (+5 pts)* for stats endpoint, rate limiting, URL sync, optimistic rollback, tests, virtualization, or other thoughtful additions.

---

## 🧱 Database Schema (for reference)

```sql
CREATE TABLE therapists (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  specialty TEXT
);

CREATE TABLE patients (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  dob DATE
);

CREATE TABLE sessions (
  id SERIAL PRIMARY KEY,
  therapist_id INT REFERENCES therapists(id),
  patient_id INT REFERENCES patients(id),
  date TIMESTAMP NOT NULL,
  status TEXT CHECK (status IN ('Scheduled','Completed','Canceled','No Show')) DEFAULT 'Scheduled'
);
```

**Example Row**

| Therapist | Patient | Date | Status |
|------------|----------|------|--------|
| Anna SLP | Ariel Underwood | 2025-11-08 09:00 | Scheduled |

---

## 💬 Questions
If anything’s unclear or your DB connection fails, email **ni@joinoriginspeech.com** — we’ll help quickly.

---

## 📘 Helpful Links
- [Next.js App Router Docs](https://nextjs.org/docs/app)  
- [Next.js API Routes](https://nextjs.org/docs/pages/building-your-application/routing/api-routes)  
- [Drizzle ORM Docs](https://orm.drizzle.team/docs/overview)  
- [TailwindCSS Docs](https://tailwindcss.com/docs)  
- [Neon Postgres](https://neon.tech/docs/introduction)

---

**Good luck — and have fun building!**  
We’re excited to see how you approach full-stack problems thoughtfully and pragmatically.  

—  
**Ni & the Origin Team**  
[joinoriginspeech.com](https://joinoriginspeech.com)

---

## ⚠️ Notice
This repository is for Origin Therapy’s engineering take-home assignment.  
It’s provided publicly so candidates can easily access the instructions.  
Please do not submit pull requests or use this repository for other purposes.
