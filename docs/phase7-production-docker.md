# Phase 7: Production Docker Setup

This document records the steps, architectural decisions, and troubleshooting strategies used to convert our development Docker environment into a production-ready setup suitable for Azure App Service.

## 1. Objectives Achieved
- Converted both `frontend` and `backend` to use **multi-stage Docker builds**.
- Replaced the frontend Vite development server with **Nginx** for high-performance static asset serving.
- Implemented **non-root users** in the backend container for enhanced security.
- Added **`.dockerignore`** files to minimize build contexts and exclude sensitive files (e.g., `.env`).
- Added robust **`HEALTHCHECK`** instructions so container orchestrators (like Azure App Service) can auto-recover deadlocked services.
- Respected the constraint to **keep `docker-compose.yml` unchanged**, acting strictly as a local execution harness.

## 2. Important Architectural Fixes

### A. Prisma Generated Artifacts
**The Issue:** `npx prisma generate` creates a highly-optimized Rust query engine binary explicitly for the container's operating system (Alpine Linux) inside `node_modules/.prisma/client`.
**The Solution:** In our multi-stage backend Dockerfile, we explicitly copied `/app/node_modules/.prisma` and `/app/node_modules/@prisma` from the `builder` stage into the production stage. Without this, Prisma cannot query the database in production.

### B. Strict TypeScript Compilation Errors
**The Issue:** During the `docker-compose build` step, both the React frontend (via `tsc -b`) and Express backend (via `tsc`) failed to compile. Vite and `ts-node-dev` inherently mask unused variables and loose typing in development mode, but the strict production build command `npm run build` caught them.
**The Solution:** We manually audited and fixed the TypeScript code:
- Removed unused `React` imports across frontend components.
- Fixed the `User` interface in `AuthContext.tsx` to include `photoUrl?: string | null;`.
- Fixed `ReactNode` type-only import requirements in `AuthContext.tsx`.
- Explicitly cast `req.params.id as string` in `employeeController.ts` before passing it to `parseInt()` to satisfy strict typing rules.
- Suppressed loose generic typings in `errorHandler.ts` for Zod by casting `err as any`.

### C. The Nginx Port Mapping Mismatch (Infrastructure-Driven Configuration)
**The Issue:** The frontend container failed to serve `localhost:5173`. We configured Nginx to listen on its default port `80`, but the existing `docker-compose.yml` (which we were instructed not to modify) mapped host port `5173` to container port `5173`. Traffic was successfully hitting the container on port `5173`, but Nginx was ignoring it because it was listening on `80`.
**The Solution:** We practiced infrastructure-driven configuration by adapting the container to match the infrastructure orchestration requirements. We updated `frontend/nginx.conf` to `listen 5173;`, modified `frontend/Dockerfile` to `EXPOSE 5173`, and updated the `HEALTHCHECK` curl command to target `http://localhost:5173/health`.

## 3. Final Dockerfiles Summary
Both Dockerfiles now represent standard industry best practices for Node.js workloads:
- **Builder Stage**: Installs everything (including `devDependencies`), runs TypeScript compilation, and builds static assets.
- **Production Stage**: Copies only compiled artifacts and production-only dependencies (`npm install --omit=dev`), runs as an unprivileged user (backend), and uses specialized servers (Nginx for frontend) resulting in highly secure, minimal image sizes.
