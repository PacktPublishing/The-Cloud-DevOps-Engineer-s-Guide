# Pastel Notes - FAQ

## General Questions

### What is Pastel Notes?
Pastel Notes is a cute, aesthetic notes and tasks web application with a pastel pink and yellow color scheme. It provides a simple way to organize your thoughts and to-do items.

### What technologies are used?
- **Frontend**: Next.js 14, React 18, TypeScript, Tailwind CSS, shadcn/ui
- **Backend**: Node.js, Express.js
- **Storage**: JSON file-based storage (no database required)
- **Package Manager**: pnpm

---

## Setup & Installation

### How do I install the project?
1. Ensure Node.js 18+ and pnpm are installed
2. Run `pnpm install` in both `backend/` and `frontend/` directories
3. Start backend with `pnpm dev` in `backend/`
4. Start frontend with `pnpm dev` in `frontend/`

### What ports are used?
- Frontend: http://localhost:3000
- Backend API: http://localhost:3001

### Why is the frontend proxying API requests?
The frontend Next.js config (`next.config.js`) includes a rewrite rule that proxies `/api/*` requests to the backend server. This avoids CORS issues during development.

---

## Development Questions

### Where are the UI components?
All shadcn/ui components are in `frontend/components/ui/`. They've been customized with the pastel theme (rounded corners, pink/yellow colors).

### How do I add a new shadcn/ui component?
1. Create a new file in `frontend/components/ui/`
2. Follow the existing component patterns
3. Apply pastel colors using the custom Tailwind classes (`pastel-pink-*`, `pastel-yellow-*`)

### How do I modify the color theme?
Edit these files:
- `frontend/tailwind.config.ts` - Tailwind color definitions
- `frontend/app/globals.css` - CSS variables for shadcn/ui

### Where is the API client code?
All API functions are in `frontend/lib/api.ts`. This file exports `notesApi` and `tasksApi` objects with CRUD methods.

---

## Data Storage

### Where is data stored?
Data is stored in JSON files:
- `backend/data/notes.json` - All notes
- `backend/data/tasks.json` - All tasks

### Is there authentication?
No, this is a single-user application without authentication.

### Can I migrate to a real database?
Yes! The API routes in `backend/routes/` can be modified to use any database. Replace the `readNotes/writeNotes` and `readTasks/writeTasks` helper functions with your database queries.

---

## Troubleshooting

### The frontend shows "Failed to fetch" errors
Make sure the backend server is running on port 3001. Start it with `pnpm dev` in the `backend/` directory.

### Styles look broken
1. Ensure all dependencies are installed (`pnpm install`)
2. Check that Tailwind is properly configured
3. Clear the `.next` cache and restart: `rm -rf .next && pnpm dev`

### API returns 404 errors
Verify the backend is running and check the endpoint path. All routes start with `/api/`.

---

## Feature Questions

### Can I add due dates to tasks?
The current implementation uses basic tasks (title, description, completed status). To add due dates:
1. Update the Task interface in `frontend/lib/api.ts`
2. Modify `backend/routes/tasks.js` to handle the new field
3. Update the TaskForm and TaskCard components

### Can I add categories/tags?
Similar to due dates, you'd need to:
1. Update the data models
2. Modify the API endpoints
3. Update the UI components

### Is there search functionality?
Not currently. To add search:
1. Create a search input component
2. Filter notes/tasks client-side or add a search endpoint

---

## Performance

### How many notes/tasks can the app handle?
JSON file storage works well for hundreds of items. For thousands of items, consider migrating to a database like SQLite or PostgreSQL.

### Is the app optimized for mobile?
The sidebar is fixed-width (desktop-first). For full mobile support, consider adding a collapsible sidebar or mobile navigation.
