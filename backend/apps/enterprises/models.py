from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone

User = get_user_model()


class Enterprise(models.Model):
    """企业信息模型"""
    ENTERPRISE_TYPE_CHOICES = [
        ('manufacturer', '制造商'),
        ('contractor', '承包商'),
        ('supplier', '供应商'),
        ('service', '服务商'),
        ('other', '其他'),
    ]
    
    STATUS_CHOICES = [
        ('pending', '待审核'),
        ('approved', '已认证'),
        ('rejected', '已拒绝'),
        ('suspended', '已暂停'),
    ]
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='enterprise', verbose_name='关联用户')
    name = models.CharField(max_length=200, verbose_name='企业名称')
    short_name = models.CharField(max_length=100, blank=True, verbose_name='企业简称')
    enterprise_type = models.CharField(max_length=20, choices=ENTERPRISE_TYPE_CHOICES, verbose_name='企业类型')
    unified_social_credit_code = models.CharField(max_length=18, unique=True, verbose_name='统一社会信用代码')
    legal_representative = models.CharField(max_length=50, verbose_name='法定代表人')
    registered_capital = models.DecimalField(max_digits=15, decimal_places=2, null=True, blank=True, verbose_name='注册资本')
    establishment_date = models.DateField(null=True, blank=True, verbose_name='成立日期')
    business_scope = models.TextField(blank=True, verbose_name='经营范围')
    address = models.CharField(max_length=500, verbose_name='企业地址')
    contact_person = models.CharField(max_length=50, verbose_name='联系人')
    contact_phone = models.CharField(max_length=20, verbose_name='联系电话')
    contact_email = models.EmailField(verbose_name='联系邮箱')
    website = models.URLField(blank=True, verbose_name='企业网站')
    description = models.TextField(blank=True, verbose_name='企业简介')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending', verbose_name='认证状态')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'enterprises'
        verbose_name = '企业信息'
        verbose_name_plural = '企业信息'
    
    def __str__(self):
        return self.name


class EnterpriseDocument(models.Model):
    """企业资质文件"""
    DOCUMENT_TYPE_CHOICES = [
        ('business_license', '营业执照'),
        ('tax_certificate', '税务登记证'),
        ('organization_code', '组织机构代码证'),
        ('qualification_certificate', '资质证书'),
        ('safety_certificate', '安全许可证'),
        ('other', '其他'),
    ]
    
    enterprise = models.ForeignKey(Enterprise, on_delete=models.CASCADE, related_name='documents', verbose_name='企业')
    document_type = models.CharField(max_length=30, choices=DOCUMENT_TYPE_CHOICES, verbose_name='文件类型')
    title = models.CharField(max_length=200, verbose_name='文件标题')
    file = models.FileField(upload_to='enterprise_documents/', verbose_name='文件')
    description = models.TextField(blank=True, verbose_name='文件描述')
    is_verified = models.BooleanField(default=False, verbose_name='是否已验证')
    verified_at = models.DateTimeField(null=True, blank=True, verbose_name='验证时间')
    verified_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, verbose_name='验证人')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        db_table = 'enterprise_documents'
        verbose_name = '企业资质文件'
        verbose_name_plural = '企业资质文件'
    
    def __str__(self):
        return f"{self.enterprise.name} - {self.title}"


class Employee(models.Model):
    """企业员工"""
    POSITION_CHOICES = [
        ('admin', '管理员'),
        ('manager', '经理'),
        ('engineer', '工程师'),
        ('technician', '技术员'),
        ('sales', '销售'),
        ('other', '其他'),
    ]
    
    enterprise = models.ForeignKey(Enterprise, on_delete=models.CASCADE, related_name='employees', verbose_name='企业')
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='employee', verbose_name='用户')
    employee_id = models.CharField(max_length=50, verbose_name='工号')
    position = models.CharField(max_length=20, choices=POSITION_CHOICES, verbose_name='职位')
    department = models.CharField(max_length=100, blank=True, verbose_name='部门')
    hire_date = models.DateField(verbose_name='入职日期')
    salary = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, verbose_name='薪资')
    is_active = models.BooleanField(default=True, verbose_name='是否在职')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'employees'
        verbose_name = '企业员工'
        verbose_name_plural = '企业员工'
        unique_together = ['enterprise', 'employee_id']
    
    def __str__(self):
        return f"{self.enterprise.name} - {self.user.username}"


class EnterpriseProject(models.Model):
    """企业项目"""
    PROJECT_STATUS_CHOICES = [
        ('pending', '待开始'),
        ('active', '进行中'),
        ('completed', '已完成'),
        ('paused', '暂停'),
        ('cancelled', '已取消'),
    ]
    
    PROJECT_TYPE_CHOICES = [
        ('corrosion', '防腐工程'),
        ('insulation', '保温工程'),
        ('comprehensive', '综合工程'),
        ('maintenance', '维护工程'),
        ('other', '其他'),
    ]
    
    enterprise = models.ForeignKey(Enterprise, on_delete=models.CASCADE, related_name='projects', verbose_name='企业')
    name = models.CharField(max_length=200, verbose_name='项目名称')
    project_code = models.CharField(max_length=50, blank=True, verbose_name='项目编号')
    description = models.TextField(blank=True, verbose_name='项目描述')
    project_type = models.CharField(max_length=20, choices=PROJECT_TYPE_CHOICES, default='other', verbose_name='项目类型')
    client = models.CharField(max_length=200, blank=True, verbose_name='客户')
    manager = models.CharField(max_length=100, blank=True, verbose_name='项目负责人')
    budget = models.DecimalField(max_digits=15, decimal_places=2, null=True, blank=True, verbose_name='项目预算')
    contract_amount = models.DecimalField(max_digits=15, decimal_places=2, null=True, blank=True, verbose_name='合同金额')
    start_date = models.DateField(verbose_name='开始日期')
    end_date = models.DateField(null=True, blank=True, verbose_name='结束日期')
    status = models.CharField(max_length=20, choices=PROJECT_STATUS_CHOICES, default='pending', verbose_name='项目状态')
    progress = models.IntegerField(default=0, verbose_name='进度百分比')
    location = models.CharField(max_length=500, blank=True, verbose_name='项目地点')
    contact_phone = models.CharField(max_length=20, blank=True, verbose_name='联系电话')
    notes = models.TextField(blank=True, verbose_name='备注')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        db_table = 'enterprise_projects'
        verbose_name = '企业项目'
        verbose_name_plural = '企业项目'
    
    def __str__(self):
        return f"{self.enterprise.name} - {self.name}"


class EnterpriseStatistics(models.Model):
    """企业统计数据"""
    enterprise = models.OneToOneField(Enterprise, on_delete=models.CASCADE, related_name='statistics', verbose_name='企业')
    total_projects = models.IntegerField(default=0, verbose_name='总项目数')
    completed_projects = models.IntegerField(default=0, verbose_name='已完成项目数')
    total_employees = models.IntegerField(default=0, verbose_name='总员工数')
    total_revenue = models.DecimalField(max_digits=15, decimal_places=2, default=0, verbose_name='总收入')
    total_contracts = models.IntegerField(default=0, verbose_name='总合同数')
    last_updated = models.DateTimeField(auto_now=True, verbose_name='最后更新时间')
    
    class Meta:
        db_table = 'enterprise_statistics'
        verbose_name = '企业统计'
        verbose_name_plural = '企业统计'
    
    def __str__(self):
        return f"{self.enterprise.name} - 统计数据"
