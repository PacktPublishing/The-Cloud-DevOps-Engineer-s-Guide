import express from 'express';
import { readFileSync, writeFileSync } from 'fs';
import { v4 as uuidv4 } from 'uuid';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const DATA_FILE = join(__dirname, '../data/notes.json');

const router = express.Router();

// Helper functions
const readNotes = () => {
  try {
    const data = readFileSync(DATA_FILE, 'utf-8');
    return JSON.parse(data);
  } catch {
    return [];
  }
};

const writeNotes = (notes) => {
  writeFileSync(DATA_FILE, JSON.stringify(notes, null, 2));
};

// GET all notes
router.get('/', (req, res) => {
  const notes = readNotes();
  res.json(notes);
});

// GET single note
router.get('/:id', (req, res) => {
  const notes = readNotes();
  const note = notes.find((n) => n.id === req.params.id);
  if (!note) {
    return res.status(404).json({ error: 'Note not found' });
  }
  res.json(note);
});

// POST create note
router.post('/', (req, res) => {
  const { title, content } = req.body;
  if (!title) {
    return res.status(400).json({ error: 'Title is required' });
  }

  const notes = readNotes();
  const newNote = {
    id: uuidv4(),
    title,
    content: content || '',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  notes.push(newNote);
  writeNotes(notes);
  res.status(201).json(newNote);
});

// PUT update note
router.put('/:id', (req, res) => {
  const { title, content } = req.body;
  const notes = readNotes();
  const index = notes.findIndex((n) => n.id === req.params.id);

  if (index === -1) {
    return res.status(404).json({ error: 'Note not found' });
  }

  notes[index] = {
    ...notes[index],
    title: title ?? notes[index].title,
    content: content ?? notes[index].content,
    updatedAt: new Date().toISOString(),
  };

  writeNotes(notes);
  res.json(notes[index]);
});

// DELETE note
router.delete('/:id', (req, res) => {
  const notes = readNotes();
  const index = notes.findIndex((n) => n.id === req.params.id);

  if (index === -1) {
    return res.status(404).json({ error: 'Note not found' });
  }

  notes.splice(index, 1);
  writeNotes(notes);
  res.status(204).send();
});

export default router;
