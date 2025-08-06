from django.db import models

# Create your models here.
class Student(models.Model): # student_student(테이블명 : 앱명_클래스명소문자)
    id=models.AutoField(primary_key=True)
    name=models.CharField(max_length=100, unique=True)
    major=models.CharField(max_length=100, null=True) # 기본이 null=False
    age=models.IntegerField(default=0)
    grade=models.IntegerField(default=0)

    def __str__(self):
        return f"{self.id} : {self.name} ({self.major}, {self.grade}학년 {self.age}살)"