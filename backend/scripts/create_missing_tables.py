#!/usr/bin/env python
"""
手动创建新增的表
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

def create_missing_tables():
    """创建缺失的表"""
    print("开始创建缺失的表...")
    
    with connection.cursor() as cursor:
        # 创建 user_profiles 表
        print("\n创建 user_profiles 表...")
        try:
            cursor.execute("""
                CREATE TABLE `user_profiles` (
                    `id` bigint NOT NULL AUTO_INCREMENT,
                    `real_name` varchar(50) NOT NULL,
                    `id_card` varchar(18) NOT NULL,
                    `gender` varchar(10) NOT NULL,
                    `birthday` date DEFAULT NULL,
                    `address` longtext NOT NULL,
                    `company` varchar(200) NOT NULL,
                    `position` varchar(100) NOT NULL,
                    `bio` longtext NOT NULL,
                    `website` varchar(200) NOT NULL,
                    `social_media` json DEFAULT NULL,
                    `preferences` json DEFAULT NULL,
                    `created_at` datetime(6) NOT NULL,
                    `updated_at` datetime(6) NOT NULL,
                    `user_id` bigint NOT NULL,
                    PRIMARY KEY (`id`),
                    UNIQUE KEY `user_id` (`user_id`),
                    CONSTRAINT `user_profiles_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
            print("✓ user_profiles 表创建成功")
        except Exception as e:
            print(f"⚠ user_profiles: {str(e)[:80]}")
        
        # 创建 user_sessions 表
        print("\n创建 user_sessions 表...")
        try:
            cursor.execute("""
                CREATE TABLE `user_sessions` (
                    `id` bigint NOT NULL AUTO_INCREMENT,
                    `session_key` varchar(100) NOT NULL,
                    `ip_address` char(39) NOT NULL,
                    `user_agent` longtext NOT NULL,
                    `login_time` datetime(6) NOT NULL,
                    `last_activity` datetime(6) NOT NULL,
                    `is_active` tinyint(1) NOT NULL,
                    `expire_at` datetime(6) NOT NULL,
                    `user_id` bigint NOT NULL,
                    PRIMARY KEY (`id`),
                    UNIQUE KEY `session_key` (`session_key`),
                    KEY `user_sessions_user_id` (`user_id`),
                    CONSTRAINT `user_sessions_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
            print("✓ user_sessions 表创建成功")
        except Exception as e:
            print(f"⚠ user_sessions: {str(e)[:80]}")
        
        # 创建 user_activity_logs 表
        print("\n创建 user_activity_logs 表...")
        try:
            cursor.execute("""
                CREATE TABLE `user_activity_logs` (
                    `id` bigint NOT NULL AUTO_INCREMENT,
                    `action` varchar(50) NOT NULL,
                    `description` varchar(200) NOT NULL,
                    `ip_address` char(39) NOT NULL,
                    `user_agent` longtext NOT NULL,
                    `request_path` varchar(500) NOT NULL,
                    `extra_data` json DEFAULT NULL,
                    `created_at` datetime(6) NOT NULL,
                    `user_id` bigint NOT NULL,
                    PRIMARY KEY (`id`),
                    KEY `user_activity_logs_user_created_at` (`user_id`, `created_at`),
                    KEY `user_activity_logs_action_created_at` (`action`, `created_at`),
                    CONSTRAINT `user_activity_logs_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
            print("✓ user_activity_logs 表创建成功")
        except Exception as e:
            print(f"⚠ user_activity_logs: {str(e)[:80]}")
        
        # 创建 permission_groups 表
        print("\n创建 permission_groups 表...")
        try:
            cursor.execute("""
                CREATE TABLE `permission_groups` (
                    `id` bigint NOT NULL AUTO_INCREMENT,
                    `name` varchar(100) NOT NULL,
                    `code` varchar(100) NOT NULL,
                    `description` longtext NOT NULL,
                    `module` varchar(50) NOT NULL,
                    `sort_order` int NOT NULL,
                    `is_active` tinyint(1) NOT NULL,
                    `created_at` datetime(6) NOT NULL,
                    PRIMARY KEY (`id`),
                    UNIQUE KEY `name` (`name`),
                    UNIQUE KEY `code` (`code`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
            print("✓ permission_groups 表创建成功")
        except Exception as e:
            print(f"⚠ permission_groups: {str(e)[:80]}")
        
        # 创建 role_permission_audits 表
        print("\n创建 role_permission_audits 表...")
        try:
            cursor.execute("""
                CREATE TABLE `role_permission_audits` (
                    `id` bigint NOT NULL AUTO_INCREMENT,
                    `action` varchar(20) NOT NULL,
                    `description` longtext NOT NULL,
                    `ip_address` char(39) NOT NULL,
                    `user_agent` longtext NOT NULL,
                    `extra_data` json DEFAULT NULL,
                    `created_at` datetime(6) NOT NULL,
                    `permission_id` bigint DEFAULT NULL,
                    `role_id` bigint NOT NULL,
                    `user_id` bigint NOT NULL,
                    PRIMARY KEY (`id`),
                    KEY `role_permission_audits_role_created_at` (`role_id`, `created_at`),
                    KEY `role_permission_audits_user_created_at` (`user_id`, `created_at`),
                    KEY `role_permission_audits_action_created_at` (`action`, `created_at`),
                    CONSTRAINT `role_permission_audits_permission_id_fk` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
                    CONSTRAINT `role_permission_audits_role_id_fk` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
                    CONSTRAINT `role_permission_audits_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
            print("✓ role_permission_audits 表创建成功")
        except Exception as e:
            print(f"⚠ role_permission_audits: {str(e)[:80]}")
        
        # 创建 user_permission_overrides 表
        print("\n创建 user_permission_overrides 表...")
        try:
            cursor.execute("""
                CREATE TABLE `user_permission_overrides` (
                    `id` bigint NOT NULL AUTO_INCREMENT,
                    `is_granted` tinyint(1) NOT NULL,
                    `reason` longtext NOT NULL,
                    `expire_at` datetime(6) DEFAULT NULL,
                    `is_active` tinyint(1) NOT NULL,
                    `created_at` datetime(6) NOT NULL,
                    `granted_by_id` bigint DEFAULT NULL,
                    `permission_id` bigint NOT NULL,
                    `user_id` bigint NOT NULL,
                    PRIMARY KEY (`id`),
                    UNIQUE KEY `user_permission_unique` (`user_id`, `permission_id`),
                    CONSTRAINT `user_permission_overrides_granted_by_id_fk` FOREIGN KEY (`granted_by_id`) REFERENCES `users` (`id`),
                    CONSTRAINT `user_permission_overrides_permission_id_fk` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
                    CONSTRAINT `user_permission_overrides_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
            print("✓ user_permission_overrides 表创建成功")
        except Exception as e:
            print(f"⚠ user_permission_overrides: {str(e)[:80]}")
        
        # 更新 role_menus 表（添加新字段）
        print("\n更新 role_menus 表...")
        try:
            cursor.execute("ALTER TABLE `role_menus` ADD COLUMN `can_view` tinyint(1) NOT NULL DEFAULT 1")
            print("✓ 添加 can_view 字段")
        except Exception as e:
            print(f"⚠ can_view: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `role_menus` ADD COLUMN `can_create` tinyint(1) NOT NULL DEFAULT 0")
            print("✓ 添加 can_create 字段")
        except Exception as e:
            print(f"⚠ can_create: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `role_menus` ADD COLUMN `can_update` tinyint(1) NOT NULL DEFAULT 0")
            print("✓ 添加 can_update 字段")
        except Exception as e:
            print(f"⚠ can_update: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `role_menus` ADD COLUMN `can_delete` tinyint(1) NOT NULL DEFAULT 0")
            print("✓ 添加 can_delete 字段")
        except Exception as e:
            print(f"⚠ can_delete: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `role_menus` ADD COLUMN `can_export` tinyint(1) NOT NULL DEFAULT 0")
            print("✓ 添加 can_export 字段")
        except Exception as e:
            print(f"⚠ can_export: {str(e)[:80]}")
        
        # 更新 menus 表（添加新字段）
        print("\n更新 menus 表...")
        try:
            cursor.execute("ALTER TABLE `menus` ADD COLUMN `menu_type` varchar(20) NOT NULL DEFAULT 'page'")
            print("✓ 添加 menu_type 字段")
        except Exception as e:
            print(f"⚠ menu_type: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `menus` ADD COLUMN `is_visible` tinyint(1) NOT NULL DEFAULT 1")
            print("✓ 添加 is_visible 字段")
        except Exception as e:
            print(f"⚠ is_visible: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `menus` ADD COLUMN `requires_permission` tinyint(1) NOT NULL DEFAULT 1")
            print("✓ 添加 requires_permission 字段")
        except Exception as e:
            print(f"⚠ requires_permission: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `menus` ADD COLUMN `description` longtext NOT NULL DEFAULT ''")
            print("✓ 添加 description 字段")
        except Exception as e:
            print(f"⚠ description: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `menus` ADD COLUMN `component_path` varchar(200) NOT NULL DEFAULT ''")
            print("✓ 添加 component_path 字段")
        except Exception as e:
            print(f"⚠ component_path: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `menus` ADD COLUMN `meta_data` json DEFAULT NULL")
            print("✓ 添加 meta_data 字段")
        except Exception as e:
            print(f"⚠ meta_data: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `menus` ADD COLUMN `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)")
            print("✓ 添加 updated_at 字段")
        except Exception as e:
            print(f"⚠ updated_at: {str(e)[:80]}")
        
        # 更新 user_login_logs 表（添加新字段）
        print("\n更新 user_login_logs 表...")
        try:
            cursor.execute("ALTER TABLE `user_login_logs` ADD COLUMN `logout_time` datetime(6) DEFAULT NULL")
            print("✓ 添加 logout_time 字段")
        except Exception as e:
            print(f"⚠ logout_time: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `user_login_logs` ADD COLUMN `failure_reason` varchar(200) NOT NULL DEFAULT ''")
            print("✓ 添加 failure_reason 字段")
        except Exception as e:
            print(f"⚠ failure_reason: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `user_login_logs` ADD COLUMN `location` varchar(100) NOT NULL DEFAULT ''")
            print("✓ 添加 location 字段")
        except Exception as e:
            print(f"⚠ location: {str(e)[:80]}")
        
        try:
            cursor.execute("ALTER TABLE `user_login_logs` ADD COLUMN `device_type` varchar(50) NOT NULL DEFAULT ''")
            print("✓ 添加 device_type 字段")
        except Exception as e:
            print(f"⚠ device_type: {str(e)[:80]}")
    
    print("\n所有表创建/更新完成！")

if __name__ == '__main__':
    try:
        create_missing_tables()
    except Exception as e:
        print(f"\n❌ 操作失败: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
