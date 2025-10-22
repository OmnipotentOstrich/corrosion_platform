#!/usr/bin/env python
"""
创建system应用的新增表
"""
import os
import sys

# 添加项目路径到sys.path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# 设置Django环境
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

import django
django.setup()

from django.db import connection

def create_system_tables():
    """创建system应用的新增表"""
    print("开始创建system应用的新增表...")
    
    with connection.cursor() as cursor:
        # 创建 system_security_logs 表
        print("\n创建 system_security_logs 表...")
        try:
            cursor.execute("""
                CREATE TABLE `system_security_logs` (
                    `id` bigint NOT NULL AUTO_INCREMENT,
                    `security_type` varchar(30) NOT NULL,
                    `ip_address` char(39) NOT NULL,
                    `user_agent` longtext NOT NULL,
                    `description` longtext NOT NULL,
                    `risk_level` varchar(10) NOT NULL,
                    `is_resolved` tinyint(1) NOT NULL,
                    `resolved_at` datetime(6) DEFAULT NULL,
                    `extra_data` json DEFAULT NULL,
                    `created_at` datetime(6) NOT NULL,
                    `resolved_by_id` bigint DEFAULT NULL,
                    `user_id` bigint DEFAULT NULL,
                    PRIMARY KEY (`id`),
                    KEY `system_security_logs_security_type_created_at` (`security_type`, `created_at`),
                    KEY `system_security_logs_risk_level_created_at` (`risk_level`, `created_at`),
                    KEY `system_security_logs_is_resolved_created_at` (`is_resolved`, `created_at`),
                    CONSTRAINT `system_security_logs_resolved_by_id_fk` FOREIGN KEY (`resolved_by_id`) REFERENCES `users` (`id`),
                    CONSTRAINT `system_security_logs_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
            print("✓ system_security_logs 表创建成功")
        except Exception as e:
            print(f"⚠ system_security_logs: {str(e)[:80]}")
        
        # 创建 system_page_configs 表
        print("\n创建 system_page_configs 表...")
        try:
            cursor.execute("""
                CREATE TABLE `system_page_configs` (
                    `id` bigint NOT NULL AUTO_INCREMENT,
                    `page_name` varchar(100) NOT NULL,
                    `page_type` varchar(20) NOT NULL,
                    `title` varchar(200) NOT NULL,
                    `description` longtext NOT NULL,
                    `keywords` varchar(500) NOT NULL,
                    `layout_config` json DEFAULT NULL,
                    `theme_config` json DEFAULT NULL,
                    `custom_css` longtext NOT NULL,
                    `custom_js` longtext NOT NULL,
                    `is_active` tinyint(1) NOT NULL,
                    `created_at` datetime(6) NOT NULL,
                    `updated_at` datetime(6) NOT NULL,
                    PRIMARY KEY (`id`),
                    UNIQUE KEY `page_name` (`page_name`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
            print("✓ system_page_configs 表创建成功")
        except Exception as e:
            print(f"⚠ system_page_configs: {str(e)[:80]}")
        
        # 创建 system_analytics 表
        print("\n创建 system_analytics 表...")
        try:
            cursor.execute("""
                CREATE TABLE `system_analytics` (
                    `id` bigint NOT NULL AUTO_INCREMENT,
                    `analytics_type` varchar(20) NOT NULL,
                    `metric_name` varchar(100) NOT NULL,
                    `metric_value` decimal(15,2) NOT NULL,
                    `dimension_data` json DEFAULT NULL,
                    `time_period` varchar(20) NOT NULL,
                    `analysis_date` date NOT NULL,
                    `extra_data` json DEFAULT NULL,
                    `created_at` datetime(6) NOT NULL,
                    PRIMARY KEY (`id`),
                    KEY `system_analytics_analytics_type_analysis_date` (`analytics_type`, `analysis_date`),
                    KEY `system_analytics_metric_name_analysis_date` (`metric_name`, `analysis_date`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
            print("✓ system_analytics 表创建成功")
        except Exception as e:
            print(f"⚠ system_analytics: {str(e)[:80]}")
        
        # 创建 system_maintenance 表
        print("\n创建 system_maintenance 表...")
        try:
            cursor.execute("""
                CREATE TABLE `system_maintenance` (
                    `id` bigint NOT NULL AUTO_INCREMENT,
                    `maintenance_type` varchar(20) NOT NULL,
                    `title` varchar(200) NOT NULL,
                    `description` longtext NOT NULL,
                    `status` varchar(20) NOT NULL,
                    `scheduled_start` datetime(6) NOT NULL,
                    `scheduled_end` datetime(6) NOT NULL,
                    `actual_start` datetime(6) DEFAULT NULL,
                    `actual_end` datetime(6) DEFAULT NULL,
                    `affected_services` json DEFAULT NULL,
                    `created_at` datetime(6) NOT NULL,
                    `updated_at` datetime(6) NOT NULL,
                    `created_by_id` bigint DEFAULT NULL,
                    PRIMARY KEY (`id`),
                    CONSTRAINT `system_maintenance_created_by_id_fk` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
            print("✓ system_maintenance 表创建成功")
        except Exception as e:
            print(f"⚠ system_maintenance: {str(e)[:80]}")
    
    print("\n所有system应用的表创建完成！")

if __name__ == '__main__':
    try:
        create_system_tables()
    except Exception as e:
        print(f"\n❌ 操作失败: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
