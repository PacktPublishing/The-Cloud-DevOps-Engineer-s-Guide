import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Pastel Notes - Cute Tasks & Notes",
  description: "A cute pastel pink and yellow notes and tasks webapp",
  icons: {
    icon: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}
