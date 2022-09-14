import tkinter as tk
from tkinter import ttk
from tkinter.simpledialog import askstring


def ask_string_dialog(title="Enter a string input dialog", prompt="Please enter a value") -> str:
    root = tk.Tk()
    string = askstring(
        parent=root,
        title=title,
        prompt=prompt
    )
    root.destroy()
    return string


class AskStringDialog(tk.Tk):

    def __init__(self, title="Select a value"):
        super().__init__()
        # create the root window
        self.geometry('200x100')
        self.resizable(False, False)
        self.title = title
        self.columnconfigure(0, weight=1)
        self.rowconfigure(0, weight=1)

        ask_button = ttk.Button(
            self,
            text='Enter a value',
            command=self.ask
        )
        ask_button.pack(expand=True)

        close_button = ttk.Button(
            self,
            text='Quit Dialog',
            command=self.destroy
        )
        close_button.pack(expand=True)

        self.mainloop()
        # self.destroy()

    def ask(self):
        name = askstring(
            parent=self,
            title="test",
            prompt="Which name do you want to give to your simulation ?"
        )

        print("###########################################")
        print(name)
        print("###########################################")
        type(self).result = name


def run():
    """ Encapsulate GUI """
    main()


def main():
    AskStringDialog("Please, Enter a value")
    return(AskStringDialog.result)


if __name__ == "__main__":
    main()
