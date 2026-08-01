# Employee Records Management System

## Project Overview
The Employee Records Management System is a clean, production-quality CRUD application designed to serve as a foundation for demonstrating enterprise Azure DevOps practices. It provides role-based access for Administrators to manage employee records, and for Employees to manage their personal profiles.

## Features
- **Role-Based Access Control (RBAC)**: Distinct permissions for `ADMIN` and `EMPLOYEE` roles.
- **Authentication**: Secure JWT-based authentication with bcrypt password hashing.
- **Admin Dashboard**: Full CRUD capabilities for managing employee records, including real-time search filtering.
- **Employee Self-Service**: Employees can view and update their own personal information securely.
- **Profile Photo Uploads**: Both admins and employees can upload profile pictures, validated and stored securely.
- **Responsive UI**: A modern, clean frontend built with React and Tailwind CSS.
- **Centralized Error Handling**: Standardized API error responses and user-friendly UI notifications.

## Technology Stack
**Backend**:
- Node.js & Express
- TypeScript
- PostgreSQL (Database)
- Prisma (ORM)
- JWT (Authentication)
- Zod (Validation)
- Multer (File Uploads)

**Frontend**:
- React & Vite
- TypeScript
- Tailwind CSS v4
- React Router
- Axios
- Lucide React (Icons)

## Project Structure
```text
project1/
├── backend/            # Express REST API
│   ├── prisma/         # Database schema & migrations
│   ├── src/
│   │   ├── controllers/# Route handlers
│   │   ├── middlewares/# Auth, Error, Upload logic
│   │   ├── routes/     # API route definitions
│   │   ├── utils/      # Helpers (Prisma Client)
│   │   └── validations/# Zod schemas
├── frontend/           # React SPA
│   ├── src/
│   │   ├── components/ # Reusable UI components & layouts
│   │   ├── contexts/   # Global state (AuthContext)
│   │   ├── pages/      # Route pages (Login, Dashboard, Profile)
│   │   └── services/   # Axios configuration
├── docs/               # Documentation
└── docker-compose.yml  # Multi-container orchestration
```

## Environment Variables
The application relies on the following environment variables:

**Backend (`backend/.env`)**:
- `DATABASE_URL`: Connection string for PostgreSQL.
- `PORT`: Server port (default 3000).
- `JWT_SECRET`: Secret key for signing tokens.

**Frontend (`frontend/.env` optional)**:
- `VITE_API_URL`: Base URL of the backend API.

## Local Setup
1. **Clone the repository.**
2. **Setup Backend**:
   - Navigate to `backend/` and run `npm install`.
   - Configure your `.env` with a local PostgreSQL connection.
   - Run `npx prisma migrate dev` and `npm run seed`.
   - Start the server with `npm run dev`.
3. **Setup Frontend**:
   - Navigate to `frontend/` and run `npm install`.
   - Start the dev server with `npm run dev`.

## Docker Setup
To run the entire application stack (PostgreSQL, Backend, Frontend) via Docker Compose:
```bash
docker-compose up -d --build
```
- Frontend will be accessible at `http://localhost:5173`
- Backend will be accessible at `http://localhost:3000`

## API Documentation
Complete API documentation for the backend endpoints can be found in [docs/api.md](./docs/api.md).

## Future Improvements
As this project serves as a baseline for Azure DevOps demonstrations, future enhancements will include:
- Migrating local file uploads to **Azure Blob Storage**.
- Container orchestration via **Azure App Service** or **AKS**.
- Infrastructure as Code (IaC) using **Terraform**.
- Secure secrets management via **Azure Key Vault**.
- CI/CD Pipelines utilizing **Azure DevOps Pipelines**.
- Centralized telemetry with **Application Insights**.
# employee-records-management
