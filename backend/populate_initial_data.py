#!/usr/bin/env python
"""
填充初始数据
为各个模块生成测试数据
"""
import os
import django
from datetime import datetime, timedelta
import random

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from django.utils import timezone
from apps.users.models import User, Role, UserRole
from apps.enterprises.models import Enterprise, EnterpriseProject
from apps.persons.models import Person, PersonProject, PersonTask
from apps.info_plaza.models import InfoPost, InfoCategory, InfoComment, InfoLike
from apps.resources.models import Resource, ResourceType
from apps.system.models import SystemLog


def create_enterprises():
    """创建企业数据"""
    print("\n" + "="*60)
    print("创建企业数据")
    print("="*60)
    
    # 获取企业角色
    enterprise_role = Role.objects.filter(code='enterprise_admin').first()
    
    enterprises_data = [
        {
            'name': '腾讯科技有限公司',
            'short_name': '腾讯',
            'enterprise_type': 'manufacturer',
            'unified_social_credit_code': '91440300279377467A',
            'legal_representative': '马化腾',
            'registered_capital': 50000000.00,
            'establishment_date': '1998-11-11',
            'business_scope': '互联网信息服务、软件开发',
            'contact_person': '张三',
            'contact_phone': '13800138001',
            'contact_email': 'zhangsan@tencent.com',
            'address': '深圳市南山区科技园',
            'description': '中国领先的互联网增值服务提供商',
            'status': 'approved',
        },
        {
            'name': '华为技术有限公司',
            'short_name': '华为',
            'enterprise_type': 'manufacturer',
            'unified_social_credit_code': '91440300618460327Q',
            'legal_representative': '任正非',
            'registered_capital': 40000000.00,
            'establishment_date': '1987-09-15',
            'business_scope': '通信设备制造、销售',
            'contact_person': '李四',
            'contact_phone': '13800138002',
            'contact_email': 'lisi@huawei.com',
            'address': '深圳市龙岗区坂田华为基地',
            'description': '全球领先的ICT（信息与通信）基础设施和智能终端提供商',
            'status': 'approved',
        },
        {
            'name': '阿里巴巴网络技术有限公司',
            'short_name': '阿里',
            'enterprise_type': 'service',
            'unified_social_credit_code': '913301007177990149',
            'legal_representative': '张勇',
            'registered_capital': 80000000.00,
            'establishment_date': '1999-06-28',
            'business_scope': '电子商务、云计算服务',
            'contact_person': '王五',
            'contact_phone': '13800138003',
            'contact_email': 'wangwu@alibaba.com',
            'address': '杭州市余杭区文一西路969号',
            'description': '中国最大的电子商务公司',
            'status': 'approved',
        },
    ]
    
    enterprises = []
    for i, data in enumerate(enterprises_data):
        # 为每个企业创建或获取用户
        username = f"enterprise_{i+1}"
        user, user_created = User.objects.get_or_create(
            username=username,
            defaults={
                'email': f"enterprise{i+1}@example.com",
                'phone': f"139100{i+1:05d}",  # 生成唯一手机号
                'first_name': data['contact_person'],
                'user_type': 'enterprise',
                'is_active': True,
                'is_verified': True,
            }
        )
        if user_created:
            user.set_password('enterprise123')
            user.save()
            # 分配企业角色
            if enterprise_role:
                UserRole.objects.get_or_create(user=user, role=enterprise_role)
            print(f"  → 创建企业用户: {username}")
        
        # 创建企业
        enterprise, created = Enterprise.objects.get_or_create(
            unified_social_credit_code=data['unified_social_credit_code'],
            defaults={**data, 'user': user}
        )
        if created:
            print(f"✓ 创建企业: {enterprise.name}")
        else:
            print(f"○ 企业已存在: {enterprise.name}")
        enterprises.append(enterprise)
    
    return enterprises


def create_enterprise_projects(enterprises):
    """创建企业项目"""
    print("\n" + "="*60)
    print("创建企业项目")
    print("="*60)
    
    if not enterprises:
        print("⚠️  没有企业数据，跳过")
        return []
    
    projects_data = [
        {
            'name': '智慧城市物联网平台',
            'description': '基于物联网技术的智慧城市综合管理平台，包含交通、环境、安防等多个子系统',
            'client': '某市政府',
            'contract_amount': 5000000.00,
            'start_date': timezone.now().date() - timedelta(days=180),
            'end_date': timezone.now().date() + timedelta(days=180),
            'status': 'in_progress',
            'progress': 65,
            'location': '深圳市南山区',
        },
        {
            'name': '企业数字化转型咨询',
            'description': '为传统企业提供全方位的数字化转型咨询服务',
            'client': '某制造企业',
            'contract_amount': 2000000.00,
            'start_date': timezone.now().date() - timedelta(days=90),
            'end_date': timezone.now().date() + timedelta(days=270),
            'status': 'in_progress',
            'progress': 35,
            'location': '深圳市龙岗区',
        },
        {
            'name': '5G通信基站建设',
            'description': '城市核心区域5G基站建设与优化项目',
            'client': '某运营商',
            'contract_amount': 8000000.00,
            'start_date': timezone.now().date() - timedelta(days=365),
            'end_date': timezone.now().date() - timedelta(days=30),
            'status': 'completed',
            'progress': 100,
            'location': '深圳市福田区',
        },
        {
            'name': '云计算数据中心',
            'description': '建设高标准的云计算数据中心',
            'client': '某科技公司',
            'contract_amount': 15000000.00,
            'start_date': timezone.now().date() + timedelta(days=30),
            'end_date': timezone.now().date() + timedelta(days=730),
            'status': 'planning',
            'progress': 0,
            'location': '杭州市余杭区',
        },
        {
            'name': '电商平台升级改造',
            'description': '对现有电商平台进行全面升级改造，提升用户体验',
            'client': '某电商企业',
            'contract_amount': 3000000.00,
            'start_date': timezone.now().date() - timedelta(days=60),
            'end_date': timezone.now().date() + timedelta(days=120),
            'status': 'in_progress',
            'progress': 45,
            'location': '杭州市滨江区',
        },
    ]
    
    projects = []
    for i, data in enumerate(projects_data):
        enterprise = enterprises[i % len(enterprises)]
        project, created = EnterpriseProject.objects.get_or_create(
            enterprise=enterprise,
            name=data['name'],
            defaults=data
        )
        if created:
            print(f"✓ 创建项目: {project.name} (所属: {enterprise.name})")
        else:
            print(f"○ 项目已存在: {project.name}")
        projects.append(project)
    
    return projects


def create_persons():
    """创建个人用户数据"""
    print("\n" + "="*60)
    print("创建个人用户数据")
    print("="*60)
    
    # 获取个人用户
    personal_user = User.objects.filter(username='user').first()
    if not personal_user:
        print("⚠️  个人用户不存在，跳过")
        return []
    
    persons_data = [
        {
            'real_name': '张伟',
            'gender': 'male',
            'birth_date': '1990-05-15',
            'id_card': '110101199005151234',
            'address': '北京市朝阳区',
            'education': 'bachelor',
            'profession': '软件工程师',
            'skills': 'Python, Django, Vue.js',
            'work_experience': 5,
            'emergency_contact': '张伟父亲',
            'emergency_phone': '13800138888',
            'bio': '5年软件开发经验，擅长Python后端开发和Vue.js前端开发',
        },
    ]
    
    persons = []
    for data in persons_data:
        person, created = Person.objects.get_or_create(
            user=personal_user,
            defaults=data
        )
        if created:
            print(f"✓ 创建个人资料: {person.real_name}")
        else:
            print(f"○ 个人资料已存在: {person.real_name}")
        persons.append(person)
    
    return persons


def create_person_projects(persons):
    """创建个人项目"""
    print("\n" + "="*60)
    print("创建个人项目")
    print("="*60)
    
    if not persons:
        print("⚠️  没有个人数据，跳过")
        return []
    
    person = persons[0]
    
    projects_data = [
        {
            'name': '个人博客系统开发',
            'description': '使用Django和Vue.js开发个人技术博客',
            'start_date': timezone.now().date() - timedelta(days=60),
            'end_date': timezone.now().date() + timedelta(days=30),
            'status': 'in_progress',
            'progress': 70,
            'role': 'manager',
        },
        {
            'name': '在线教育平台',
            'description': '参与开发在线教育平台的前端部分',
            'start_date': timezone.now().date() - timedelta(days=120),
            'end_date': timezone.now().date() - timedelta(days=30),
            'status': 'completed',
            'progress': 100,
            'role': 'developer',
        },
        {
            'name': '移动APP开发',
            'description': '开发一款健康管理类移动应用',
            'start_date': timezone.now().date() + timedelta(days=15),
            'end_date': timezone.now().date() + timedelta(days=180),
            'status': 'pending',
            'progress': 0,
            'role': 'manager',
        },
    ]
    
    projects = []
    for data in projects_data:
        project, created = PersonProject.objects.get_or_create(
            person=person,
            name=data['name'],
            defaults=data
        )
        if created:
            print(f"✓ 创建个人项目: {project.name}")
        else:
            print(f"○ 个人项目已存在: {project.name}")
        projects.append(project)
    
    return projects


def create_person_tasks(persons, projects):
    """创建个人任务"""
    print("\n" + "="*60)
    print("创建个人任务")
    print("="*60)
    
    if not persons or not projects:
        print("⚠️  缺少必要数据，跳过")
        return []
    
    person = persons[0]
    
    tasks_data = [
        {
            'title': '完成用户登录功能',
            'description': '实现用户登录、注册、找回密码等功能',
            'priority': 'high',
            'status': 'completed',
            'due_date': timezone.now().date() - timedelta(days=10),
        },
        {
            'title': '设计数据库表结构',
            'description': '设计博客系统的数据库表结构',
            'priority': 'high',
            'status': 'completed',
            'due_date': timezone.now().date() - timedelta(days=50),
        },
        {
            'title': '开发文章管理模块',
            'description': '实现文章的增删改查功能',
            'priority': 'high',
            'status': 'in_progress',
            'due_date': timezone.now().date() + timedelta(days=7),
        },
        {
            'title': '实现评论功能',
            'description': '为博客文章添加评论功能',
            'priority': 'medium',
            'status': 'pending',
            'due_date': timezone.now().date() + timedelta(days=20),
        },
        {
            'title': '优化页面加载速度',
            'description': '通过代码优化和缓存提升页面加载速度',
            'priority': 'medium',
            'status': 'pending',
            'due_date': timezone.now().date() + timedelta(days=30),
        },
        {
            'title': '编写API文档',
            'description': '使用Swagger编写完整的API文档',
            'priority': 'low',
            'status': 'pending',
            'due_date': timezone.now().date() + timedelta(days=25),
        },
        {
            'title': '进行单元测试',
            'description': '为核心功能编写单元测试',
            'priority': 'medium',
            'status': 'pending',
            'due_date': timezone.now().date() + timedelta(days=35),
        },
    ]
    
    tasks = []
    for i, data in enumerate(tasks_data):
        # 为前3个任务分配项目
        project = projects[0] if i < len(projects) else None
        
        task, created = PersonTask.objects.get_or_create(
            person=person,
            title=data['title'],
            defaults={**data, 'project': project}
        )
        if created:
            print(f"✓ 创建任务: {task.title} [{task.get_status_display()}]")
        else:
            print(f"○ 任务已存在: {task.title}")
        tasks.append(task)
    
    return tasks


def create_info_categories():
    """创建信息分类"""
    print("\n" + "="*60)
    print("创建信息分类")
    print("="*60)
    
    categories_data = [
        {'name': '技术分享', 'code': 'tech', 'description': '技术文章和经验分享'},
        {'name': '行业动态', 'code': 'industry', 'description': '行业新闻和动态'},
        {'name': '项目案例', 'code': 'case', 'description': '项目案例展示'},
        {'name': '招聘信息', 'code': 'job', 'description': '招聘和求职信息'},
        {'name': '活动通知', 'code': 'event', 'description': '各类活动通知'},
    ]
    
    categories = []
    for data in categories_data:
        try:
            category, created = InfoCategory.objects.get_or_create(
                code=data['code'],
                defaults=data
            )
            if created:
                print(f"✓ 创建分类: {category.name}")
            else:
                print(f"○ 分类已存在: {category.name}")
            categories.append(category)
        except Exception as e:
            print(f"⚠️  分类创建出错 ({data['name']}): {str(e)}")
            # 尝试通过name获取已存在的分类
            try:
                category = InfoCategory.objects.get(name=data['name'])
                categories.append(category)
                print(f"○ 使用已存在的分类: {category.name}")
            except:
                pass
    
    return categories


def create_info_posts(categories):
    """创建信息广场帖子"""
    print("\n" + "="*60)
    print("创建信息广场帖子")
    print("="*60)
    
    if not categories:
        print("⚠️  没有分类数据，跳过")
        return []
    
    admin_user = User.objects.filter(username='admin').first()
    
    posts_data = [
        {
            'title': 'Django REST Framework 最佳实践',
            'content': '''在使用Django REST Framework开发API时，有一些最佳实践值得注意：

1. **使用ViewSet和Router**：可以大大简化URL配置
2. **合理使用序列化器**：区分读取和写入序列化器
3. **权限控制**：使用permission_classes进行细粒度控制
4. **分页设置**：为列表接口添加分页功能
5. **过滤和搜索**：使用django-filter实现复杂查询

这些实践可以让你的API更加规范和易于维护。''',
            'category': categories[0],
            'status': 'published',
            'is_top': True,
            'view_count': 156,
        },
        {
            'title': '防腐保温行业2024年发展趋势',
            'content': '''2024年防腐保温行业呈现以下发展趋势：

1. **绿色环保材料**：环保型防腐保温材料需求增加
2. **智能化施工**：引入物联网和智能监控技术
3. **标准化管理**：行业标准不断完善
4. **数字化转型**：企业加速数字化转型步伐

行业整体向高质量发展转型。''',
            'category': categories[1],
            'status': 'published',
            'is_top': False,
            'view_count': 89,
        },
        {
            'title': '大型石化项目防腐保温案例分享',
            'content': '''某大型石化项目防腐保温工程案例：

**项目概况**：
- 项目规模：15万吨/年
- 施工周期：18个月
- 涉及管道：超过50公里

**技术亮点**：
1. 采用新型复合材料
2. 智能监测系统
3. 全过程质量管控

项目已顺利通过验收，各项指标优良。''',
            'category': categories[2],
            'status': 'published',
            'is_top': False,
            'view_count': 234,
        },
        {
            'title': '招聘：高级Python开发工程师',
            'content': '''我公司诚聘高级Python开发工程师：

**岗位要求**：
- 3年以上Python开发经验
- 熟悉Django/Flask框架
- 了解前端技术（Vue/React）
- 有良好的代码习惯

**待遇**：
- 薪资：15K-25K
- 五险一金
- 弹性工作制

有意者请发送简历至hr@example.com''',
            'category': categories[3],
            'status': 'published',
            'is_top': False,
            'view_count': 67,
        },
        {
            'title': '防腐保温技术交流会通知',
            'content': '''【活动通知】

时间：2024年11月15日 14:00
地点：市会展中心3号厅
主题：新型防腐保温材料应用与发展

**议程**：
1. 主题演讲
2. 案例分享
3. 技术交流
4. 展览展示

欢迎行业同仁参加！''',
            'category': categories[4],
            'status': 'published',
            'is_top': True,
            'view_count': 123,
        },
    ]
    
    posts = []
    for data in posts_data:
        post, created = InfoPost.objects.get_or_create(
            title=data['title'],
            defaults={
                **data,
                'author': admin_user,
            }
        )
        if created:
            print(f"✓ 创建帖子: {post.title}")
        else:
            print(f"○ 帖子已存在: {post.title}")
        posts.append(post)
    
    return posts


def create_resource_types():
    """创建资源类型"""
    print("\n" + "="*60)
    print("创建资源类型")
    print("="*60)
    
    types_data = [
        {'name': '技术文档', 'code': 'doc', 'description': '各类技术文档资料'},
        {'name': '设计图纸', 'code': 'design', 'description': '工程设计图纸'},
        {'name': '施工方案', 'code': 'plan', 'description': '施工方案和计划'},
        {'name': '规范标准', 'code': 'standard', 'description': '行业规范和标准'},
        {'name': '培训资料', 'code': 'training', 'description': '培训课件和资料'},
    ]
    
    types = []
    for data in types_data:
        resource_type, created = ResourceType.objects.get_or_create(
            code=data['code'],
            defaults=data
        )
        if created:
            print(f"✓ 创建资源类型: {resource_type.name}")
        else:
            print(f"○ 资源类型已存在: {resource_type.name}")
        types.append(resource_type)
    
    return types


def create_resources(resource_types):
    """创建资源"""
    print("\n" + "="*60)
    print("创建资源")
    print("="*60)
    
    if not resource_types:
        print("⚠️  没有资源类型，跳过")
        return []
    
    admin_user = User.objects.filter(username='admin').first()
    
    resources_data = [
        {
            'name': '挖掘机CAT320D',
            'description': '卡特彼勒320D型挖掘机，状态良好，可用于各类工程',
            'resource_type': resource_types[0],
            'manufacturer': '卡特彼勒',
            'model': 'CAT320D',
            'location': '北京市朝阳区设备仓库',
            'contact_person': '张三',
            'contact_phone': '13800138001',
            'contact_email': 'zhangsan@example.com',
            'quantity': 2,
            'unit_price': 1500000.00,
            'is_available_for_rent': True,
            'rental_price': 5000.00,
            'rental_unit': '天',
        },
        {
            'name': '塔吊QTZ80',
            'description': 'QTZ80型塔式起重机，最大起重量8吨',
            'resource_type': resource_types[1],
            'manufacturer': '中联重科',
            'model': 'QTZ80',
            'location': '上海市浦东新区工地',
            'contact_person': '李四',
            'contact_phone': '13800138002',
            'contact_email': 'lisi@example.com',
            'quantity': 1,
            'unit_price': 800000.00,
            'is_available_for_rent': True,
            'rental_price': 3000.00,
            'rental_unit': '天',
        },
        {
            'name': '混凝土搅拌站HZS120',
            'description': 'HZS120型混凝土搅拌站，每小时产量120立方米',
            'resource_type': resource_types[2],
            'manufacturer': '三一重工',
            'model': 'HZS120',
            'location': '广州市番禺区工业园',
            'contact_person': '王五',
            'contact_phone': '13800138003',
            'contact_email': 'wangwu@example.com',
            'quantity': 1,
            'unit_price': 2000000.00,
            'is_available_for_rent': False,
        },
    ]
    
    resources = []
    for data in resources_data:
        resource, created = Resource.objects.get_or_create(
            name=data['name'],
            defaults={
                **data,
                'owner': admin_user,
                'status': 'available',
            }
        )
        if created:
            print(f"✓ 创建资源: {resource.name}")
        else:
            print(f"○ 资源已存在: {resource.name}")
        resources.append(resource)
    
    return resources


def main():
    """主函数"""
    print("\n" + "="*60)
    print("开始填充初始数据")
    print("="*60)
    
    try:
        # 1. 创建企业相关数据
        enterprises = create_enterprises()
        enterprise_projects = create_enterprise_projects(enterprises)
        
        # 2. 创建个人相关数据
        persons = create_persons()
        person_projects = create_person_projects(persons)
        person_tasks = create_person_tasks(persons, person_projects)
        
        # 3. 创建信息广场数据
        info_categories = create_info_categories()
        info_posts = create_info_posts(info_categories)
        
        # 4. 创建资源数据
        resource_types = create_resource_types()
        resources = create_resources(resource_types)
        
        print("\n" + "="*60)
        print("数据填充完成！")
        print("="*60)
        print(f"\n统计信息：")
        print(f"  企业数量: {len(enterprises)}")
        print(f"  企业项目: {len(enterprise_projects)}")
        print(f"  个人资料: {len(persons)}")
        print(f"  个人项目: {len(person_projects)}")
        print(f"  个人任务: {len(person_tasks)}")
        print(f"  信息分类: {len(info_categories)}")
        print(f"  信息帖子: {len(info_posts)}")
        print(f"  资源类型: {len(resource_types)}")
        print(f"  资源数量: {len(resources)}")
        print("\n✅ 所有初始数据已成功填充！")
        
    except Exception as e:
        print(f"\n❌ 填充数据时出错: {str(e)}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    main()

