import tkinter as tk


class ScenarioView(tk.Tk):
    def __init__(self, list_to_choose_from):
        super().__init__()
        # create the root window
        self.geometry('200x100')
        self.resizable(False, False)
        self.title('Select a Scenario')
        self.columnconfigure(0, weight=1)
        self.rowconfigure(0, weight=1)

        # create a listbox
        self.scenarios_var = tk.StringVar(value=list_to_choose_from)

        self.listbox = tk.Listbox(
            self,
            listvariable=self.scenarios_var,
            height=6,
            selectmode='single'
        )

        self.listbox.grid(
            column=0,
            row=0,
            sticky='nwes'
        )

        self.listbox.bind('<<ListboxSelect>>', self.items_selected)
        # self.button = ttk.Button(self, "Quit", self.destroy)

        # the final result, selection to get returned

        self.mainloop()
        self.destroy()

    def items_selected(self,event):
        """ handle item selected event
        """
        # get selected indices
        selected_indices = self.listbox.curselection()
        # get selected items
        type(self).result = ",".join([self.listbox.get(i) for i in selected_indices])
        print(type(self).result)
        self.quit()


def main():
    ScenarioView(["first", "second", "third"])
    print(f"result={ScenarioView.result}")
    return(ScenarioView.result)


if __name__ == "__main__":
    main()