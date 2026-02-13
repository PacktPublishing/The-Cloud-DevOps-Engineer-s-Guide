"use client";

import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Pencil, Trash2 } from "lucide-react";
import { Note } from "@/lib/api";

interface NoteCardProps {
  note: Note;
  onEdit: (note: Note) => void;
  onDelete: (id: string) => void;
}

export function NoteCard({ note, onEdit, onDelete }: NoteCardProps) {
  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString("en-US", {
      month: "short",
      day: "numeric",
      year: "numeric",
    });
  };

  return (
    <Card className="group h-full flex flex-col bg-gradient-to-br from-white to-pastel-yellow-100 hover:from-pastel-pink-50 hover:to-pastel-yellow-200">
      <CardHeader className="pb-3">
        <CardTitle className="line-clamp-2 text-lg">{note.title}</CardTitle>
      </CardHeader>
      <CardContent className="flex-1">
        <p className="text-muted-foreground line-clamp-4 whitespace-pre-wrap">
          {note.content || "No content"}
        </p>
      </CardContent>
      <CardFooter className="flex justify-between items-center pt-4 border-t border-pastel-pink-100">
        <span className="text-xs text-muted-foreground">
          {formatDate(note.updatedAt)}
        </span>
        <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => onEdit(note)}
            className="h-8 w-8 rounded-xl"
          >
            <Pencil className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            onClick={() => onDelete(note.id)}
            className="h-8 w-8 rounded-xl text-destructive hover:text-destructive hover:bg-red-50"
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      </CardFooter>
    </Card>
  );
}
