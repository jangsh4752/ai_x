from django.db import models
from django.contrib.auth.models import AbstractUser

class CustomUser(AbstractUser):
    gender = models.CharField(max_length=10, choices=[('M', '남성'), ('F', '여성')])
    birth_date = models.DateField()
    license_date = models.DateField()
    car_model_code = models.CharField(max_length=50, blank=True, null=True)

class Clause(models.Model):
    insurer = models.CharField(max_length=50)
    title = models.CharField(max_length=100)
    clause_number = models.CharField(max_length=20)
    page = models.IntegerField()
    text = models.TextField()
    pdf_link = models.URLField()

class InsuranceQuote(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    insurer_name = models.CharField(max_length=50)
    premium = models.IntegerField()
    coverage_summary = models.TextField()
    special_terms = models.TextField()
    score = models.FloatField()
    created_at = models.DateTimeField(auto_now_add=True)
    conditions = models.JSONField(default=dict)

