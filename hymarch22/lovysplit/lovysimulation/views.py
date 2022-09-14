from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django import forms
from django.urls import reverse
from .models import Simulation


class FirstNewSimulationForm(forms.Form):
    folder_name = forms.CharField(
        label="Name for the New Simulation",
        error_messages={'unique': u"This folder name is already used! Please change it."}
    )
    excel_file_path = forms.FileField(label="Excel file path for the Simulation")


class NewSimulationForm(forms.ModelForm):
    class Meta:
        model = Simulation
        fields = ['id', 'folder_name', 'excel_file_path']


def add(request):
    # Check if method is a POST
    if request.method == "POST":
        # Take in the data the user has submitted and save it as form
        form = NewSimulationForm(request.POST, request.FILES)

        # Check if form data is valid (server-side)
        if form.is_valid():

            # Isolate the task from the 'cleaned' version of form data
            folder_name = form.cleaned_data["folder_name"]
            excel_file_path = form.cleaned_data["excel_file_path"]

            # Add the new task to our list of tasks
            new_simulation = Simulation(
                folder_name=folder_name,
                excel_file_path=excel_file_path
            )
            new_simulation.save()

            # Redirect user to list of tasks
            return HttpResponseRedirect(reverse("simulations:index"))

        else:

            # If the form is invalid, re-render the page with existing information.
            return render(request, "lovysimulation/add.html", {
                "form": form
            })

    return render(request, "lovysimulation/add.html", {
        "form": NewSimulationForm()
    })


def edit(request, simulation_id=None):

    simulation = Simulation.objects.get(id=simulation_id)

    form = NewSimulationForm(request.POST or None, instance=simulation, files=request.FILES or None)

    if request.method == 'POST':

        if form.is_valid():
            form.save()
            return HttpResponseRedirect(reverse("simulations:index"))
        else:
            return render(request, "lovysimulation/edit.html", {
                "form": form
            })

    return render(
        request, "lovysimulation/edit.html",
        {"form": form, "simulation": simulation}
    )


# Create your views here.
def index(request):
    return render(
        request,
        "lovysimulation/index.html",
        {"simulations": Simulation.objects.all()}
    )


def simulation(request, simulation_id):
    simulation = Simulation.objects.get(id=simulation_id)
    return render(request, "lovysimulation/simulation.html", {"simulation": simulation})


def kimia(request):
    return HttpResponse("Hello, Kimia!")


def greet(request, name):
    return render(
        request,
        "lovysimulation/greet.html",
        {
            "name": name.capitalize()
        }
    )
