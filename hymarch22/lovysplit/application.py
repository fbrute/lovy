from datetime import datetime
import helloview
import os
import tkinter as tk
from tkinter import ttk


class Application(tk.Tk):
    """ Application root window """
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.title("LovySplit Application")
        self.resizable(width=False, height=False)

        ttk.Label(
            self,
            text="LovySplit Application",
            font=("TkDefaultFont", 16)
        ).grid(row=0)

        self.scenarioform = scenarioform.ScenarioForm(self)
        self.recordform.grid(row=1, padx=10)

        self.savebutton = ttk.Button(
            self,
            text="Save",
            command=self.on_save
        )
        self.savebutton.grid(sticky=tk.E, row=2, padx=10)

        # status bar
        self.status = tk.StringVar()
        self.statusbar = ttk.Label(self, textvariable=self.status)
        self.statusbar.grid(sticky=(tk.W + tk.E), row=3, padx=10)

    def on_save(self):
        datestring = datetime.today().strftime("%Y-%m-%d")
        filename = "abq_data_record_{}.csv".format(datestring)
        newfile = not os.path.exists(filename)

        data = self.recordform.get()

        with open(filename, 'a') as fh:
            csvwriter = csv.DictWriter(fh, fieldnames=data.keys())
            if newfile:
                csvwriter.writeheader()
            csvwriter.writerow(data)


if __name__ == '__main__':
    app = Application()
    app.mainloop()
