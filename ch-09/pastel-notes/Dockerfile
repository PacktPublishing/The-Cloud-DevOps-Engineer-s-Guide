# =============================================================================
# Pastel Notes - Multi-stage Dockerfile for smaller final image filesize
# Builds frontend and backend in a single container
# =============================================================================

# -----------------------------------------------------------------------------
# Stage 1: Build the Next.js frontend
# -----------------------------------------------------------------------------
FROM node:20-alpine AS frontend-builder

WORKDIR /app/frontend

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy package files first for better caching
COPY frontend/package.json frontend/pnpm-lock.yaml* ./

# Install dependencies
RUN pnpm install --frozen-lockfile || pnpm install

# Copy frontend source
COPY frontend/ ./

# Build Next.js for production
RUN pnpm build

# -----------------------------------------------------------------------------
# Stage 2: Production image
# -----------------------------------------------------------------------------
FROM node:20-alpine AS production

WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy backend
COPY backend/package.json backend/pnpm-lock.yaml* ./backend/
WORKDIR /app/backend
RUN pnpm install --frozen-lockfile || pnpm install --prod
COPY backend/ ./

# Ensure data directory exists (files are copied from backend/)
RUN mkdir -p data

# Volume for persistent data storage
VOLUME /app/backend/data

# Copy built frontend
WORKDIR /app/frontend
COPY frontend/package.json frontend/pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile || pnpm install --prod
COPY --from=frontend-builder /app/frontend/.next ./.next
COPY --from=frontend-builder /app/frontend/public ./public
COPY frontend/next.config.js ./
COPY frontend/tailwind.config.ts ./
COPY frontend/postcss.config.js ./

# Copy startup script
WORKDIR /app
COPY start.sh ./
RUN chmod +x start.sh

# Expose ports
EXPOSE 3000 3001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000 || exit 1

# Start both services
CMD ["./start.sh"]
