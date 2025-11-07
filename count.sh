import tkinter as tk
from tkinter import messagebox
import time
import threading

# ---------------------------
# Countdown Timer Functions
# ---------------------------
class CountdownTimer:
    def __init__(self, root):
        self.root = root
        self.root.title("⏰ Advanced Countdown Timer")
        self.root.geometry("600x500")
        self.root.resizable(False, False)
        self.root.configure(bg="#222831")

        # Variables
        self.days = tk.IntVar(value=0)
        self.hours = tk.IntVar(value=0)
        self.minutes = tk.IntVar(value=0)
        self.seconds = tk.IntVar(value=0)
        self.running = False
        self.remaining = 0

        # Title Label
        tk.Label(root, text="Advanced Countdown Timer",
                 font=("Helvetica", 16, "bold"), bg="#222831", fg="#FFD369").pack(pady=10)

        # Input Frame
        frame = tk.Frame(root, bg="#222831")
        frame.pack(pady=5)

        tk.Label(frame, text="Days:", bg="#222831", fg="white").grid(row=0, column=0, padx=5, pady=5)
        tk.Entry(frame, textvariable=self.days, width=5).grid(row=0, column=1)
        tk.Label(frame, text="Hours:", bg="#222831", fg="white").grid(row=0, column=2, padx=5, pady=5)
        tk.Entry(frame, textvariable=self.hours, width=5).grid(row=0, column=3)
        tk.Label(frame, text="Minutes:", bg="#222831", fg="white").grid(row=0, column=4, padx=5, pady=5)
        tk.Entry(frame, textvariable=self.minutes, width=5).grid(row=0, column=5)
        tk.Label(frame, text="Seconds:", bg="#222831", fg="white").grid(row=0, column=6, padx=5, pady=5)
        tk.Entry(frame, textvariable=self.seconds, width=5).grid(row=0, column=7)

        # Time Display
        self.time_label = tk.Label(root, text="00d:00h:00m:00s", font=("Courier", 20, "bold"),
                                   bg="#222831", fg="#00ADB5")
        self.time_label.pack(pady=20)

        # Buttons Frame
        btn_frame = tk.Frame(root, bg="#222831")
        btn_frame.pack(pady=10)

        tk.Button(btn_frame, text="Start", command=self.start_timer,
                  bg="#00ADB5", fg="white", width=8).grid(row=0, column=0, padx=5)
        tk.Button(btn_frame, text="Pause", command=self.pause_timer,
                  bg="#393E46", fg="white", width=8).grid(row=0, column=1, padx=5)
        tk.Button(btn_frame, text="Resume", command=self.resume_timer,
                  bg="#FFD369", fg="black", width=8).grid(row=0, column=2, padx=5)
        tk.Button(btn_frame, text="Reset", command=self.reset_timer,
                  bg="#FF5722", fg="white", width=8).grid(row=0, column=3, padx=5)

    # ---------------------------
    # Core Timer Logic
    # ---------------------------
    def update_display(self):
        d = self.remaining // 86400
        h = (self.remaining % 86400) // 3600
        m = (self.remaining % 3600) // 60
        s = self.remaining % 60
        self.time_label.config(text=f"{d:02d}d:{h:02d}h:{m:02d}m:{s:02d}s")

    def countdown(self):
        while self.running and self.remaining > 0:
            self.update_display()
            time.sleep(1)
            self.remaining -= 1
        if self.remaining == 0 and self.running:
            self.time_label.config(text="✅ Time's Up!")
            self.root.bell()
            messagebox.showinfo("Timer", "✅ Time’s Up! 🎉")
            self.running = False

    def start_timer(self):
        if self.running:
            messagebox.showwarning("Running", "Timer is already running.")
            return
        total_seconds = (self.days.get() * 86400 +
                         self.hours.get() * 3600 +
                         self.minutes.get() * 60 +
                         self.seconds.get())
        if total_seconds <= 0:
            messagebox.showerror("Invalid", "Please enter a positive time value.")
            return
        self.remaining = total_seconds
        self.running = True
        threading.Thread(target=self.countdown, daemon=True).start()

    def pause_timer(self):
        if self.running:
            self.running = False
            messagebox.showinfo("Paused", "⏸ Timer Paused.")
        else:
            messagebox.showwarning("Not Running", "Timer is not running.")

    def resume_timer(self):
        if not self.running and self.remaining > 0:
            self.running = True
            threading.Thread(target=self.countdown, daemon=True).start()
            messagebox.showinfo("Resumed", "▶ Timer Resumed.")
        else:
            messagebox.showwarning("Invalid", "Nothing to resume.")

    def reset_timer(self):
        self.running = False
        self.remaining = 0
        self.update_display()
        messagebox.showinfo("Reset", "🔁 Timer Reset.")


# ---------------------------
# Run Application
# ---------------------------
if __name__ == "__main__":
    root = tk.Tk()
    app = CountdownTimer(root)
    root.mainloop()
