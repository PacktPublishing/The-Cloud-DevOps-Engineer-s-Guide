import express from 'express';
import cors from 'cors';
import notesRoutes from './routes/notes.js';
import tasksRoutes from './routes/tasks.js';

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/notes', notesRoutes);
app.use('/api/tasks', tasksRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Pastel Notes API is running!' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🌸 Pastel Notes API running on http://localhost:${PORT}`);
});
