import helloview
import tkinter as tk


class MyApplication(tk.Tk):
    """ Hello world, main application """
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.title("Hellow Tkinter!")
        self.geometry("800x600")
        self.resizable(width=False, height=False)

        helloview.HelloView(self).grid(sticky=(tk.E + tk.W + tk.N + tk.S))
        self.columnconfigure(0, weight=1)


if __name__ == '__main__':
    app = MyApplication()
    app.mainloop()
