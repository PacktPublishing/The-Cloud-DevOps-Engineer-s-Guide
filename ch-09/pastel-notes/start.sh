#!/bin/sh

# =============================================================================
# Pastel Notes - Startup Script
# Runs both backend and frontend services concurrently
# =============================================================================

echo "Starting Pastel Notes..."

# Start backend server in background
echo "Starting backend API server..."
cd /app/backend
node server.js &
BACKEND_PID=$!

# Wait for backend to be ready
sleep 4

# Start frontend server in background
echo "Starting frontend server..."
cd /app/frontend
node_modules/.bin/next start &
FRONTEND_PID=$!

echo ""
echo "Pastel Notes is running!"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:3001"
echo ""

# Handle shutdown gracefully
trap "echo 'Shutting down...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit 0" SIGTERM SIGINT

# Wait for both processes
wait $BACKEND_PID $FRONTEND_PID
