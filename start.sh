#!/bin/bash

# 防腐保温智能数字平台启动脚本

echo "=========================================="
echo "防腐保温智能数字平台启动脚本"
echo "=========================================="

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "错误: Docker未安装，请先安装Docker"
    exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "错误: Docker Compose未安装，请先安装Docker Compose"
    exit 1
fi

# 创建必要的目录
echo "创建必要的目录..."
mkdir -p logs
mkdir -p backend/logs
mkdir -p backend/media
mkdir -p backend/staticfiles

# 设置权限
echo "设置文件权限..."
chmod +x start.sh
chmod +x stop.sh

# 构建并启动服务
echo "构建并启动服务..."
docker-compose up --build -d

# 等待数据库启动
echo "等待数据库启动..."
sleep 10

# 执行数据库迁移
echo "执行数据库迁移..."
docker-compose exec backend python manage.py migrate

# 创建超级用户
echo "创建超级用户..."
docker-compose exec backend python manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123456')
    print('超级用户创建成功: admin/admin123456')
else:
    print('超级用户已存在')
"

# 收集静态文件
echo "收集静态文件..."
docker-compose exec backend python manage.py collectstatic --noinput

echo "=========================================="
echo "启动完成！"
echo "=========================================="
echo "访问地址:"
echo "  前端: http://localhost:8080"
echo "  后端API: http://localhost:8080/api/"
echo "  管理后台: http://localhost:8080/admin/"
echo ""
echo "默认管理员账号:"
echo "  用户名: admin"
echo "  密码: admin123456"
echo ""
echo "查看日志: docker-compose logs -f"
echo "停止服务: ./stop.sh"
echo "=========================================="
