# Pastel Notes

A cute pastel pink and yellow notes and tasks web application with rounded corners and a playful aesthetic.

## Tech Stack

- **Frontend**: Next.js 14, React 18, TypeScript, Tailwind CSS, shadcn/ui components
- **Backend**: Node.js, Express.js, JSON file storage
- **Package Manager**: pnpm

## Project Structure

```
pastel-notes/
├── backend/                    # Express.js API server
│   ├── server.js               # Main server entry point
│   ├── routes/
│   │   ├── notes.js            # Notes CRUD API endpoints
│   │   └── tasks.js            # Tasks CRUD API endpoints
│   ├── data/
│   │   ├── notes.json          # Notes data storage
│   │   └── tasks.json          # Tasks data storage
│   └── package.json
├── frontend/                   # Next.js application
│   ├── app/
│   │   ├── page.tsx            # Home/Dashboard page
│   │   ├── notes/page.tsx      # Notes management page
│   │   ├── tasks/page.tsx      # Tasks management page
│   │   ├── layout.tsx          # Root layout
│   │   └── globals.css         # Global styles & theme
│   ├── components/
│   │   ├── ui/                 # shadcn/ui base components
│   │   ├── notes/              # Note-specific components
│   │   ├── tasks/              # Task-specific components
│   │   └── layout/             # Layout components (Sidebar, MainLayout)
│   ├── lib/
│   │   ├── api.ts              # API client functions
│   │   └── utils.ts            # Utility functions
│   └── package.json
├── Dockerfile                  # Docker build configuration
├── start.sh                    # Container startup script
├── .dockerignore               # Docker build exclusions
├── README.md                   # This file
├── FAQ.md                      # Frequently asked questions
├── FILES_RELATIONSHIP.md       # File dependency documentation
└── LOW_LEVEL_DESIGN.md         # Technical design document
```

## Quick Start

### Prerequisites

- Node.js 18+ installed
- pnpm installed (`npm install -g pnpm`)

### Installation

1. Clone the repository and navigate to the project:
   ```bash
   cd pastel-notes
   ```

2. Install backend dependencies:
   ```bash
   cd backend
   pnpm install
   ```

3. Install frontend dependencies:
   ```bash
   cd ../frontend
   pnpm install
   ```

### Running the Application

1. Start the backend server (from `backend/` directory):
   ```bash
   pnpm dev
   ```
   Backend runs on http://localhost:3001

2. In a new terminal, start the frontend (from `frontend/` directory):
   ```bash
   pnpm dev
   ```
   Frontend runs on http://localhost:3000

## Docker

### Prerequisites

- Docker installed on your system

### Build and Run with Docker

1. Build the Docker image:
   ```bash
   docker build -t pastel-notes .
   ```

2. Run the container with persistent data:
   ```bash
   docker run -p 3000:3000 -p 3001:3001 -v pastel-data:/app/backend/data pastel-notes
   ```

3. Open http://localhost:3000 in your browser

### Docker Details

- **Image**: Node.js 20 Alpine (lightweight)
- **Ports**: 3000 (frontend), 3001 (backend API)
- **Health Check**: Built-in health check on port 3000
- **Data**: Persists in the `pastel-data` Docker volume

### Data Persistence

The `-v pastel-data:/app/backend/data` flag creates a named volume that stores your notes and tasks. Your data will persist across container restarts and rebuilds.

To start fresh (clear all data):
```bash
docker volume rm pastel-data
```

### Stopping the Container

```bash
# Find the container ID
docker ps

# Stop the container
docker stop <container-id>
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/notes | Get all notes |
| POST | /api/notes | Create a new note |
| PUT | /api/notes/:id | Update a note |
| DELETE | /api/notes/:id | Delete a note |
| GET | /api/tasks | Get all tasks |
| POST | /api/tasks | Create a new task |
| PUT | /api/tasks/:id | Update a task |
| DELETE | /api/tasks/:id | Delete a task |
| GET | /api/health | Health check endpoint |

## Data Models

### Note
```typescript
interface Note {
  id: string;
  title: string;
  content: string;
  createdAt: string;
  updatedAt: string;
}
```

### Task
```typescript
interface Task {
  id: string;
  title: string;
  description: string;
  completed: boolean;
  createdAt: string;
  updatedAt: string;
}
```

## Design Theme

- **Primary Color**: Pastel Pink (#FFB6C1, #FFC0CB range)
- **Secondary Color**: Pastel Yellow (#FFFACD, #FFE4B5 range)
- **Border Radius**: Large rounded corners (16px-24px)
- **Font**: Quicksand (playful, rounded sans-serif)
- **Style**: Soft shadows, gentle gradients, cute aesthetic

## Features

- Create, edit, and delete notes
- Create, edit, delete, and complete tasks
- Responsive sidebar navigation
- Dashboard with quick stats and recent items
- Beautiful loading states with skeleton animations
- Hover effects and smooth transitions

## Development

### Adding New shadcn/ui Components

Components are manually created in `frontend/components/ui/`. Follow the existing patterns for styling with the pastel theme.

### Modifying the Theme

Edit `frontend/tailwind.config.ts` to adjust colors, and `frontend/app/globals.css` for CSS variables.

## License

MIT
