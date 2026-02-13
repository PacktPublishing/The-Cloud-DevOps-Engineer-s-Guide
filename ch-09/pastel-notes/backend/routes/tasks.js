import express from 'express';
import { readFileSync, writeFileSync } from 'fs';
import { v4 as uuidv4 } from 'uuid';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const DATA_FILE = join(__dirname, '../data/tasks.json');

const router = express.Router();

// Helper functions
const readTasks = () => {
  try {
    const data = readFileSync(DATA_FILE, 'utf-8');
    return JSON.parse(data);
  } catch {
    return [];
  }
};

const writeTasks = (tasks) => {
  writeFileSync(DATA_FILE, JSON.stringify(tasks, null, 2));
};

// GET all tasks
router.get('/', (req, res) => {
  const tasks = readTasks();
  res.json(tasks);
});

// GET single task
router.get('/:id', (req, res) => {
  const tasks = readTasks();
  const task = tasks.find((t) => t.id === req.params.id);
  if (!task) {
    return res.status(404).json({ error: 'Task not found' });
  }
  res.json(task);
});

// POST create task
router.post('/', (req, res) => {
  const { title, description } = req.body;
  if (!title) {
    return res.status(400).json({ error: 'Title is required' });
  }

  const tasks = readTasks();
  const newTask = {
    id: uuidv4(),
    title,
    description: description || '',
    completed: false,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  tasks.push(newTask);
  writeTasks(tasks);
  res.status(201).json(newTask);
});

// PUT update task
router.put('/:id', (req, res) => {
  const { title, description, completed } = req.body;
  const tasks = readTasks();
  const index = tasks.findIndex((t) => t.id === req.params.id);

  if (index === -1) {
    return res.status(404).json({ error: 'Task not found' });
  }

  tasks[index] = {
    ...tasks[index],
    title: title ?? tasks[index].title,
    description: description ?? tasks[index].description,
    completed: completed ?? tasks[index].completed,
    updatedAt: new Date().toISOString(),
  };

  writeTasks(tasks);
  res.json(tasks[index]);
});

// DELETE task
router.delete('/:id', (req, res) => {
  const tasks = readTasks();
  const index = tasks.findIndex((t) => t.id === req.params.id);

  if (index === -1) {
    return res.status(404).json({ error: 'Task not found' });
  }

  tasks.splice(index, 1);
  writeTasks(tasks);
  res.status(204).send();
});

export default router;
