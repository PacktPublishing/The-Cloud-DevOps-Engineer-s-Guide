"use client";

import { useState, useEffect } from "react";
import { Plus, StickyNote } from "lucide-react";
import { Button } from "@/components/ui/button";
import { NoteCard } from "@/components/notes/NoteCard";
import { NoteForm } from "@/components/notes/NoteForm";
import { MainLayout } from "@/components/layout/MainLayout";
import { notesApi, Note } from "@/lib/api";

export default function NotesPage() {
  const [notes, setNotes] = useState<Note[]>([]);
  const [loading, setLoading] = useState(true);
  const [formOpen, setFormOpen] = useState(false);
  const [editingNote, setEditingNote] = useState<Note | null>(null);

  const fetchNotes = async () => {
    try {
      const data = await notesApi.getAll();
      setNotes(data.sort((a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime()));
    } catch (error) {
      console.error("Failed to fetch notes:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchNotes();
  }, []);

  const handleCreate = async (data: { title: string; content: string }) => {
    try {
      await notesApi.create(data);
      fetchNotes();
    } catch (error) {
      console.error("Failed to create note:", error);
    }
  };

  const handleUpdate = async (data: { title: string; content: string }) => {
    if (!editingNote) return;
    try {
      await notesApi.update(editingNote.id, data);
      fetchNotes();
      setEditingNote(null);
    } catch (error) {
      console.error("Failed to update note:", error);
    }
  };

  const handleDelete = async (id: string) => {
    try {
      await notesApi.delete(id);
      fetchNotes();
    } catch (error) {
      console.error("Failed to delete note:", error);
    }
  };

  const handleEdit = (note: Note) => {
    setEditingNote(note);
    setFormOpen(true);
  };

  const handleFormSubmit = (data: { title: string; content: string }) => {
    if (editingNote) {
      handleUpdate(data);
    } else {
      handleCreate(data);
    }
  };

  const handleFormClose = (open: boolean) => {
    setFormOpen(open);
    if (!open) setEditingNote(null);
  };

  return (
    <MainLayout>
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="p-3 rounded-2xl bg-gradient-to-br from-pastel-pink-300 to-pastel-yellow-300">
            <StickyNote className="h-6 w-6 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-pastel-pink-500">My Notes</h1>
            <p className="text-sm text-muted-foreground">
              {notes.length} {notes.length === 1 ? "note" : "notes"}
            </p>
          </div>
        </div>
        <Button onClick={() => setFormOpen(true)} className="gap-2">
          <Plus className="h-4 w-4" />
          New Note
        </Button>
      </div>

      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {[...Array(6)].map((_, i) => (
            <div
              key={i}
              className="h-48 rounded-3xl bg-gradient-to-br from-pastel-pink-100 to-pastel-yellow-100 animate-pulse"
            />
          ))}
        </div>
      ) : notes.length === 0 ? (
        <div className="text-center py-16">
          <div className="inline-flex p-6 rounded-full bg-gradient-to-br from-pastel-pink-100 to-pastel-yellow-100 mb-4">
            <StickyNote className="h-12 w-12 text-pastel-pink-400" />
          </div>
          <h3 className="text-lg font-medium text-muted-foreground mb-2">
            No notes yet
          </h3>
          <p className="text-sm text-muted-foreground mb-4">
            Create your first note to get started!
          </p>
          <Button onClick={() => setFormOpen(true)} className="gap-2">
            <Plus className="h-4 w-4" />
            Create Note
          </Button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {notes.map((note) => (
            <NoteCard
              key={note.id}
              note={note}
              onEdit={handleEdit}
              onDelete={handleDelete}
            />
          ))}
        </div>
      )}

      <NoteForm
        open={formOpen}
        onOpenChange={handleFormClose}
        note={editingNote}
        onSubmit={handleFormSubmit}
      />
    </div>
    </MainLayout>
  );
}
