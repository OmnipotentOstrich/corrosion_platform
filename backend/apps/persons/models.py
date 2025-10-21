from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone

User = get_user_model()


class Person(models.Model):
    """个人用户信息"""
    GENDER_CHOICES = [
        ('male', '男'),
        ('female', '女'),
        ('other', '其他'),
    ]
    
    EDUCATION_CHOICES = [
        ('high_school', '高中'),
        ('college', '大专'),
        ('bachelor', '本科'),
        ('master', '硕士'),
        ('doctor', '博士'),
        ('other', '其他'),
    ]
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='person', verbose_name='关联用户')
    real_name = models.CharField(max_length=50, verbose_name='真实姓名')
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, verbose_name='性别')
    birth_date = models.DateField(null=True, blank=True, verbose_name='出生日期')
    id_card = models.CharField(max_length=18, unique=True, verbose_name='身份证号')
    education = models.CharField(max_length=20, choices=EDUCATION_CHOICES, verbose_name='学历')
    profession = models.CharField(max_length=100, verbose_name='职业')
    work_experience = models.IntegerField(default=0, verbose_name='工作经验(年)')
    skills = models.TextField(blank=True, verbose_name='技能专长')
    address = models.CharField(max_length=500, verbose_name='居住地址')
    emergency_contact = models.CharField(max_length=50, verbose_name='紧急联系人')
    emergency_phone = models.CharField(max_length=20, verbose_name='紧急联系电话')
    bio = models.TextField(blank=True, verbose_name='个人简介')
    is_verified = models.BooleanField(default=False, verbose_name='是否认证')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'persons'
        verbose_name = '个人用户信息'
        verbose_name_plural = '个人用户信息'
    
    def __str__(self):
        return f"{self.real_name} ({self.user.username})"


class PersonProject(models.Model):
    """个人项目记录"""
    PROJECT_TYPE_CHOICES = [
        ('corrosion_protection', '防腐工程'),
        ('insulation', '保温工程'),
        ('maintenance', '维护保养'),
        ('inspection', '检测服务'),
        ('consulting', '咨询服务'),
        ('other', '其他'),
    ]
    
    PROJECT_STATUS_CHOICES = [
        ('planning', '规划中'),
        ('in_progress', '进行中'),
        ('completed', '已完成'),
        ('suspended', '已暂停'),
        ('cancelled', '已取消'),
    ]
    
    person = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='projects', verbose_name='个人用户')
    name = models.CharField(max_length=200, verbose_name='项目名称')
    project_type = models.CharField(max_length=30, choices=PROJECT_TYPE_CHOICES, verbose_name='项目类型')
    description = models.TextField(verbose_name='项目描述')
    client = models.CharField(max_length=200, verbose_name='客户')
    role = models.CharField(max_length=100, verbose_name='担任角色')
    start_date = models.DateField(verbose_name='开始日期')
    end_date = models.DateField(null=True, blank=True, verbose_name='结束日期')
    status = models.CharField(max_length=20, choices=PROJECT_STATUS_CHOICES, default='planning', verbose_name='项目状态')
    progress = models.IntegerField(default=0, verbose_name='进度百分比')
    location = models.CharField(max_length=500, blank=True, verbose_name='项目地点')
    income = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, verbose_name='项目收入')
    achievements = models.TextField(blank=True, verbose_name='项目成果')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'person_projects'
        verbose_name = '个人项目'
        verbose_name_plural = '个人项目'
    
    def __str__(self):
        return f"{self.person.real_name} - {self.name}"


class PersonTask(models.Model):
    """个人任务记录"""
    TASK_STATUS_CHOICES = [
        ('pending', '待处理'),
        ('in_progress', '进行中'),
        ('completed', '已完成'),
        ('cancelled', '已取消'),
    ]
    
    PRIORITY_CHOICES = [
        ('low', '低'),
        ('medium', '中'),
        ('high', '高'),
        ('urgent', '紧急'),
    ]
    
    person = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='tasks', verbose_name='个人用户')
    project = models.ForeignKey(PersonProject, on_delete=models.CASCADE, related_name='tasks', null=True, blank=True, verbose_name='关联项目')
    title = models.CharField(max_length=200, verbose_name='任务标题')
    description = models.TextField(verbose_name='任务描述')
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES, default='medium', verbose_name='优先级')
    status = models.CharField(max_length=20, choices=TASK_STATUS_CHOICES, default='pending', verbose_name='任务状态')
    due_date = models.DateTimeField(null=True, blank=True, verbose_name='截止时间')
    completed_at = models.DateTimeField(null=True, blank=True, verbose_name='完成时间')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'person_tasks'
        verbose_name = '个人任务'
        verbose_name_plural = '个人任务'
    
    def __str__(self):
        return f"{self.person.real_name} - {self.title}"


class PersonStatistics(models.Model):
    """个人统计数据"""
    person = models.OneToOneField(Person, on_delete=models.CASCADE, related_name='statistics', verbose_name='个人用户')
    total_projects = models.IntegerField(default=0, verbose_name='总项目数')
    completed_projects = models.IntegerField(default=0, verbose_name='已完成项目数')
    total_tasks = models.IntegerField(default=0, verbose_name='总任务数')
    completed_tasks = models.IntegerField(default=0, verbose_name='已完成任务数')
    total_income = models.DecimalField(max_digits=12, decimal_places=2, default=0, verbose_name='总收入')
    work_days = models.IntegerField(default=0, verbose_name='工作天数')
    last_updated = models.DateTimeField(auto_now=True, verbose_name='最后更新时间')
    
    class Meta:
        db_table = 'person_statistics'
        verbose_name = '个人统计'
        verbose_name_plural = '个人统计'
    
    def __str__(self):
        return f"{self.person.real_name} - 统计数据"


class PersonDocument(models.Model):
    """个人资质文件"""
    DOCUMENT_TYPE_CHOICES = [
        ('id_card', '身份证'),
        ('certificate', '职业资格证书'),
        ('diploma', '学历证书'),
        ('resume', '简历'),
        ('portfolio', '作品集'),
        ('other', '其他'),
    ]
    
    person = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='documents', verbose_name='个人用户')
    document_type = models.CharField(max_length=20, choices=DOCUMENT_TYPE_CHOICES, verbose_name='文件类型')
    title = models.CharField(max_length=200, verbose_name='文件标题')
    file = models.FileField(upload_to='person_documents/', verbose_name='文件')
    description = models.TextField(blank=True, verbose_name='文件描述')
    is_public = models.BooleanField(default=False, verbose_name='是否公开')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'person_documents'
        verbose_name = '个人资质文件'
        verbose_name_plural = '个人资质文件'
    
    def __str__(self):
        return f"{self.person.real_name} - {self.title}"
