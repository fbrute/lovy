import tkinter as tk
from tkinter import ttk
from tkinter.filedialog import askopenfilename
from pathlib import Path


class SelectFileDialog(tk.Tk):

    def __init__(self):
        super().__init__()
        # create the root window
        self.geometry('200x100')
        self.resizable(False, False)
        self.title('Select a file')
        self.columnconfigure(0, weight=1)
        self.rowconfigure(0, weight=1)

        # open button
        open_button = ttk.Button(
            self,
            text='Open Files',
            command=self.select_files
        )
        open_button.pack(expand=True)

        close_button = ttk.Button(
            self,
            text='Quit Dialog',
            command=self.destroy
        )
        close_button.pack(expand=True)

        self.mainloop()
        # self.destroy()

    def select_files(self):

        filetypes = (
            ('text files', '*.xlsx'),
            ('All files', '*.*')
        )

        filename = askopenfilename(
            title="Open scenarios file",
            initialdir="~/Documents/trafin/lovy/data/retrostat",
            filetypes=filetypes
        )

        type(self).result = Path(filename)


def run():
    main()


def main():
    SelectFileDialog()
    return(SelectFileDialog.result)


if __name__ == "__main__":
    print(main())
