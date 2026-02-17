"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { StickyNote, CheckSquare, Sparkles, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { MainLayout } from "@/components/layout/MainLayout";
import { notesApi, tasksApi, Note, Task } from "@/lib/api";

export default function HomePage() {
  const [notes, setNotes] = useState<Note[]>([]);
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [notesData, tasksData] = await Promise.all([
          notesApi.getAll(),
          tasksApi.getAll(),
        ]);
        setNotes(notesData.slice(0, 3));
        setTasks(tasksData.filter((t) => !t.completed).slice(0, 4));
      } catch (error) {
        console.error("Failed to fetch data:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const completedTasks = tasks.filter((t) => t.completed).length;
  const totalTasks = tasks.length;

  return (
    <MainLayout>
      <div className="space-y-8">
        {/* Welcome Section */}
        <div className="text-center py-8">
          <div className="inline-flex p-4 rounded-full bg-gradient-to-br from-pastel-pink-200 to-pastel-yellow-200 mb-4 shadow-cute-lg">
            <Sparkles className="h-10 w-10 text-pastel-pink-500" />
          </div>
          <h1 className="text-4xl font-bold bg-gradient-to-r from-pastel-pink-500 via-pastel-pink-400 to-pastel-yellow-500 bg-clip-text text-transparent mb-2">
            Welcome to Pastel Notes!
          </h1>
          <p className="text-muted-foreground text-lg">
            Your cute companion for notes and tasks
          </p>
        </div>

        {/* Quick Stats */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Card className="bg-gradient-to-br from-pastel-pink-50 to-pastel-pink-100 border-pastel-pink-200">
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-lg font-medium">Notes</CardTitle>
              <StickyNote className="h-5 w-5 text-pastel-pink-400" />
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-pastel-pink-500">
                {loading ? "..." : notes.length}
              </div>
              <p className="text-xs text-muted-foreground">Total notes created</p>
              <Link href="/notes">
                <Button variant="ghost" size="sm" className="mt-2 gap-1 px-0 hover:bg-transparent hover:text-pastel-pink-500">
                  View all <ArrowRight className="h-4 w-4" />
                </Button>
              </Link>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-pastel-yellow-50 to-pastel-yellow-100 border-pastel-yellow-300">
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-lg font-medium">Tasks</CardTitle>
              <CheckSquare className="h-5 w-5 text-pastel-yellow-500" />
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-pastel-yellow-600">
                {loading ? "..." : `${completedTasks}/${totalTasks}`}
              </div>
              <p className="text-xs text-muted-foreground">Tasks completed</p>
              <Link href="/tasks">
                <Button variant="ghost" size="sm" className="mt-2 gap-1 px-0 hover:bg-transparent hover:text-pastel-yellow-600">
                  View all <ArrowRight className="h-4 w-4" />
                </Button>
              </Link>
            </CardContent>
          </Card>
        </div>

        {/* Recent Notes */}
        <div>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-semibold text-pastel-pink-500">Recent Notes</h2>
            <Link href="/notes">
              <Button variant="outline" size="sm" className="gap-1">
                See all <ArrowRight className="h-4 w-4" />
              </Button>
            </Link>
          </div>
          {loading ? (
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {[...Array(3)].map((_, i) => (
                <div
                  key={i}
                  className="h-32 rounded-3xl bg-gradient-to-br from-pastel-pink-100 to-pastel-yellow-100 animate-pulse"
                />
              ))}
            </div>
          ) : notes.length === 0 ? (
            <Card className="text-center py-8">
              <CardContent>
                <StickyNote className="h-8 w-8 text-pastel-pink-300 mx-auto mb-2" />
                <p className="text-muted-foreground">No notes yet. Create your first one!</p>
                <Link href="/notes">
                  <Button className="mt-4">Create Note</Button>
                </Link>
              </CardContent>
            </Card>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {notes.map((note) => (
                <Link key={note.id} href="/notes">
                  <Card className="h-full hover:scale-[1.02] transition-transform bg-gradient-to-br from-white to-pastel-pink-50">
                    <CardHeader className="pb-2">
                      <CardTitle className="text-base line-clamp-1">{note.title}</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <p className="text-sm text-muted-foreground line-clamp-2">
                        {note.content || "No content"}
                      </p>
                    </CardContent>
                  </Card>
                </Link>
              ))}
            </div>
          )}
        </div>

        {/* Pending Tasks */}
        <div>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-semibold text-pastel-yellow-600">Pending Tasks</h2>
            <Link href="/tasks">
              <Button variant="outline" size="sm" className="gap-1">
                See all <ArrowRight className="h-4 w-4" />
              </Button>
            </Link>
          </div>
          {loading ? (
            <div className="space-y-3">
              {[...Array(3)].map((_, i) => (
                <div
                  key={i}
                  className="h-16 rounded-2xl bg-gradient-to-br from-pastel-yellow-100 to-pastel-pink-100 animate-pulse"
                />
              ))}
            </div>
          ) : tasks.length === 0 ? (
            <Card className="text-center py-8">
              <CardContent>
                <CheckSquare className="h-8 w-8 text-pastel-yellow-400 mx-auto mb-2" />
                <p className="text-muted-foreground">No pending tasks. You're all caught up!</p>
                <Link href="/tasks">
                  <Button variant="secondary" className="mt-4">Add Task</Button>
                </Link>
              </CardContent>
            </Card>
          ) : (
            <div className="space-y-2">
              {tasks.map((task) => (
                <Link key={task.id} href="/tasks">
                  <Card className="hover:scale-[1.01] transition-transform bg-gradient-to-r from-white to-pastel-yellow-50">
                    <CardContent className="py-4 flex items-center gap-3">
                      <div className="h-4 w-4 rounded-md border-2 border-pastel-yellow-400" />
                      <div className="flex-1 min-w-0">
                        <p className="font-medium truncate">{task.title}</p>
                        {task.description && (
                          <p className="text-xs text-muted-foreground truncate">
                            {task.description}
                          </p>
                        )}
                      </div>
                    </CardContent>
                  </Card>
                </Link>
              ))}
            </div>
          )}
        </div>
      </div>
    </MainLayout>
  );
}
