"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { StickyNote, CheckSquare, Home, Sparkles } from "lucide-react";
import { cn } from "@/lib/utils";

const navItems = [
  { href: "/", label: "Home", icon: Home },
  { href: "/notes", label: "Notes", icon: StickyNote },
  { href: "/tasks", label: "Tasks", icon: CheckSquare },
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="fixed left-0 top-0 h-full w-64 bg-white/80 backdrop-blur-md border-r-2 border-pastel-pink-100 p-4 flex flex-col">
      {/* Logo */}
      <div className="flex items-center gap-3 px-3 py-4 mb-6">
        <div className="p-2 rounded-2xl bg-gradient-to-br from-pastel-pink-300 to-pastel-yellow-300 shadow-cute">
          <Sparkles className="h-6 w-6 text-white" />
        </div>
        <div>
          <h1 className="font-bold text-xl bg-gradient-to-r from-pastel-pink-500 to-pastel-yellow-500 bg-clip-text text-transparent">
            Pastel Notes
          </h1>
          <p className="text-xs text-muted-foreground">Stay organized, peacefully</p>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 space-y-2">
        {navItems.map((item) => {
          const isActive = pathname === item.href;
          const Icon = item.icon;

          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 font-medium",
                isActive
                  ? "bg-gradient-to-r from-pastel-pink-200 to-pastel-yellow-200 text-pastel-pink-500 shadow-cute"
                  : "hover:bg-pastel-pink-50 text-muted-foreground hover:text-pastel-pink-500"
              )}
            >
              <Icon className="h-5 w-5" />
              {item.label}
            </Link>
          );
        })}
      </nav>

      {/* Footer */}
      <div className="mt-auto pt-4 border-t border-pastel-pink-100">
        <div className="px-3 py-2 text-xs text-muted-foreground text-center">
          Made by Victoria Ripardo
        </div>
      </div>
    </aside>
  );
}
