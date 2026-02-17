"use client";

import { useState, useEffect } from "react";
import { Plus, CheckSquare, Circle, CheckCircle2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { TaskCard } from "@/components/tasks/TaskCard";
import { TaskForm } from "@/components/tasks/TaskForm";
import { MainLayout } from "@/components/layout/MainLayout";
import { tasksApi, Task } from "@/lib/api";

export default function TasksPage() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const [formOpen, setFormOpen] = useState(false);
  const [editingTask, setEditingTask] = useState<Task | null>(null);

  const fetchTasks = async () => {
    try {
      const data = await tasksApi.getAll();
      // Sort: incomplete first, then by updatedAt
      setTasks(
        data.sort((a, b) => {
          if (a.completed !== b.completed) return a.completed ? 1 : -1;
          return new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime();
        })
      );
    } catch (error) {
      console.error("Failed to fetch tasks:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTasks();
  }, []);

  const handleCreate = async (data: { title: string; description: string }) => {
    try {
      await tasksApi.create(data);
      fetchTasks();
    } catch (error) {
      console.error("Failed to create task:", error);
    }
  };

  const handleUpdate = async (data: { title: string; description: string }) => {
    if (!editingTask) return;
    try {
      await tasksApi.update(editingTask.id, data);
      fetchTasks();
      setEditingTask(null);
    } catch (error) {
      console.error("Failed to update task:", error);
    }
  };

  const handleToggle = async (id: string, completed: boolean) => {
    try {
      await tasksApi.update(id, { completed });
      fetchTasks();
    } catch (error) {
      console.error("Failed to toggle task:", error);
    }
  };

  const handleDelete = async (id: string) => {
    try {
      await tasksApi.delete(id);
      fetchTasks();
    } catch (error) {
      console.error("Failed to delete task:", error);
    }
  };

  const handleEdit = (task: Task) => {
    setEditingTask(task);
    setFormOpen(true);
  };

  const handleFormSubmit = (data: { title: string; description: string }) => {
    if (editingTask) {
      handleUpdate(data);
    } else {
      handleCreate(data);
    }
  };

  const handleFormClose = (open: boolean) => {
    setFormOpen(open);
    if (!open) setEditingTask(null);
  };

  const completedCount = tasks.filter((t) => t.completed).length;
  const totalCount = tasks.length;

  return (
    <MainLayout>
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="p-3 rounded-2xl bg-gradient-to-br from-pastel-yellow-300 to-pastel-pink-300">
            <CheckSquare className="h-6 w-6 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-pastel-pink-500">My Tasks</h1>
            <p className="text-sm text-muted-foreground flex items-center gap-2">
              <span className="flex items-center gap-1">
                <Circle className="h-3 w-3" />
                {totalCount - completedCount} pending
              </span>
              <span className="flex items-center gap-1">
                <CheckCircle2 className="h-3 w-3 text-green-500" />
                {completedCount} completed
              </span>
            </p>
          </div>
        </div>
        <Button onClick={() => setFormOpen(true)} variant="secondary" className="gap-2">
          <Plus className="h-4 w-4" />
          New Task
        </Button>
      </div>

      {loading ? (
        <div className="space-y-3">
          {[...Array(4)].map((_, i) => (
            <div
              key={i}
              className="h-24 rounded-3xl bg-gradient-to-br from-pastel-pink-100 to-pastel-yellow-100 animate-pulse"
            />
          ))}
        </div>
      ) : tasks.length === 0 ? (
        <div className="text-center py-16">
          <div className="inline-flex p-6 rounded-full bg-gradient-to-br from-pastel-yellow-100 to-pastel-pink-100 mb-4">
            <CheckSquare className="h-12 w-12 text-pastel-yellow-500" />
          </div>
          <h3 className="text-lg font-medium text-muted-foreground mb-2">
            No tasks yet
          </h3>
          <p className="text-sm text-muted-foreground mb-4">
            Add your first task to stay organized!
          </p>
          <Button onClick={() => setFormOpen(true)} variant="secondary" className="gap-2">
            <Plus className="h-4 w-4" />
            Create Task
          </Button>
        </div>
      ) : (
        <div className="space-y-3">
          {tasks.map((task) => (
            <TaskCard
              key={task.id}
              task={task}
              onEdit={handleEdit}
              onDelete={handleDelete}
              onToggle={handleToggle}
            />
          ))}
        </div>
      )}

      <TaskForm
        open={formOpen}
        onOpenChange={handleFormClose}
        task={editingTask}
        onSubmit={handleFormSubmit}
      />
    </div>
    </MainLayout>
  );
}
