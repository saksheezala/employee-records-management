# Stage 1: Builder
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

# Copy source code and build the React application
COPY . .
RUN npm run build


# Stage 2: Production Server (Nginx)
FROM nginx:alpine

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy compiled React assets from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 5173
EXPOSE 5173

# Healthcheck to verify Nginx is responding (we added /health in nginx.conf)
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5173/health || exit 1

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
