# Use the official Bun image as the base
FROM oven/bun:1 AS builder

# Set working directory
WORKDIR /app

# Copy package.json, bun.lockb (if exists), and apps/web directory
COPY package.json bun.lockb* ./
COPY apps/web ./apps/web

# Navigate to the web app directory
WORKDIR /app/apps/web

# Install dependencies
RUN bun install

# Run database migrations
# Note: DATABASE_URL must be set during the build or handled separately
# For Render, migrations are typically run at startup
# RUN bun run db:migrate

# Build the application (if applicable, e.g., for Next.js or similar)
RUN bun run build

# Production stage
FROM oven/bun:1-slim

# Set working directory
WORKDIR /app

# Copy built artifacts and necessary files from builder
COPY --from=builder /app/apps/web /app

# Expose the port the app runs on
EXPOSE 3000

# Set environment variable defaults
ENV NODE_ENV=production
ENV PORT=3000

# Start the application
CMD ["bun", "run", "start"]
