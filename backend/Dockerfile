# Stage 1: Builder
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files and install all dependencies (including devDependencies)
COPY package*.json ./
RUN npm install

# Copy Prisma schema and generate client BEFORE copying the rest of the source
# This helps with caching if only the source code changes, not the schema
COPY prisma ./prisma
RUN npx prisma generate

# Copy the rest of the application code
COPY . .

# Compile TypeScript to JavaScript in the dist/ folder
RUN npm run build


# Stage 2: Production
FROM node:20-alpine

WORKDIR /app

# Install curl for the HEALTHCHECK
RUN apk add --no-cache curl

# Copy package files and install ONLY production dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy the generated Prisma client from the builder stage
# Prisma generates its engine and types inside node_modules/.prisma
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma ./node_modules/@prisma

# Copy the compiled output from the builder stage
COPY --from=builder /app/dist ./dist

# Create uploads directory (since we currently store photos locally)
# and ensure the node user owns it
RUN mkdir -p uploads && chown -R node:node /app

# Switch to the non-root 'node' user for security
USER node

EXPOSE 3000

# Healthcheck to verify the server is responding
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Start the application using the compiled JavaScript
CMD ["npm", "start"]
