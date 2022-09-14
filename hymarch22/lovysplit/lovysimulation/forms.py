class NewSimulationForm(forms.ModelForm):
    class Meta:
        model = Simulation
        fields = ['id', 'folder_name', 'excel_file_path']
