# 🧠 Origin Take-Home Assignment — Therapist Session Dashboard
**Stack:** TypeScript · Next.js 14+ (App Router) · REST API · Postgres (Neon) · TailwindCSS  

---

## ✉️ Overview
Welcome 👋 — and thanks for taking the time to complete Origin Therapy’s take-home challenge.  
This exercise mirrors real full-stack work at **Origin**: connecting clean backend APIs to polished, type-safe UIs.

You’ll build a small **Therapist Session Dashboard** using **Next.js**, **TypeScript**, and a provided **Neon Postgres** database.

This assignment is scoped for about **a few hours** of work for someone comfortable with these tools.  
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
- Implement at least these endpoints:
  - Get all sessions → returns all sessions (joined with therapist + patient names)
  - Update a session satus → updates a session’s `status` (e.g. “Completed”)
  - Create a new session → add a new session to the existing sessions
  - Delete a session → delete a session by id
- Use **TypeScript** throughout.  
- Handle validation and errors gracefully (`400 / 404 / 500`).  
- Use either **pg**, **Drizzle**, or **Prisma** for DB access.

---

### 2️⃣ Frontend (UI)
- Display sessions in a responsive table or card layout.  
- Show therapist name, patient name, date/time, and status.  
- Update session status using the REST API.  
- Add a new session.
- Delete an existing session. 
- Include **loading**, **error**, and **empty** states.  
- Style with **TailwindCSS** — clean and readable.

---

### 3️⃣ Others
- Deploy to [Vercel](https://vercel.com) or [Render](https://render.com).  
- Add search / filter (e.g. by therapist or status).  
- Add pagination
- Add optimistic UI updates (update the UI immediately on click).  
- Think about errors/edge cases/security/auth/scalibility. If you don't have time to implement them, mention how you would handle them in the README file.

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
3. *(Optional)* A 2–3 minute Loom or screen recording showing your app.

Email your submission to **ni@joinoriginspeech.com**.

---

## 🗓 Timeline
Please submit within **4 hours** of receiving your database URL.  
Need more time? No problem — just ask.

---

## 🧮 Evaluation Rubric (30 pts)

| Category | Points | What We Look For |
|-----------|--------|-----------------|
| Backend Correctness | 5 | Endpoints work; updates persist |
| Type Safety / Data Modeling | 5 | Clean TypeScript; no `any` |
| Frontend Implementation | 5 | Functional UI fetching real data |
| UX & Visual Polish | 5 | Clear loading/error states |
| Code Structure & Clarity | 5 | Logical, modular organization |
| Documentation / Reasoning | 5 | README clarity and setup instructions |

✅ *Bonus (+5 pts)* for optimistic UI, scalability, error handling, or elegant UX touches.

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
