from operator import mod
from re import M
from django.db import models


# Create your models here.
class Simulation(models.Model):
    folder_name = models.CharField(
        max_length=64,
        unique=True,
        blank=False,

    )
    excel_file_path = models.FileField(upload_to='excel_file_path')

    def __str__(self):
        return f"{self.id}: folder_name: {self.folder_name}, excel_file_path: {self.excel_file_path}"

class BackTraj(models.Model):
    pass

class Scenario(models.Model):
    scenario_name = models.CharField(
        max_length=64,
        unique=True,
        blank=False
    )
