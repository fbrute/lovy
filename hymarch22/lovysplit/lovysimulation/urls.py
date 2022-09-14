from django.urls import path
from . import views

app_name = "simulations"
urlpatterns = [
    path("", views.index, name="index"),
    # path("<str:name>", views.greet, name="greet"),
    path("<int:simulation_id>/edit/", views.edit, name="edit"),
    path("<int:simulation_id>", views.simulation, name="view"),
    path("add", views.add, name="add")
    # path("kimia", views.kimia, name="kimia"),
]
