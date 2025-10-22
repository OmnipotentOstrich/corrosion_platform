# 工具脚本说明

本目录包含用于数据库维护和问题修复的工具脚本。

## 脚本列表

### 1. fix_migrations.py
**用途**: 修复迁移历史不一致问题  
**使用场景**: 当出现 "InconsistentMigrationHistory" 错误时  
**运行方式**:
```bash
cd backend
python scripts/fix_migrations.py
```

### 2. create_missing_tables.py
**用途**: 创建users应用的新增表  
**包含表**: user_profiles, user_sessions, user_activity_logs, permission_groups等  
**运行方式**:
```bash
cd backend
python scripts/create_missing_tables.py
```

### 3. create_system_tables.py
**用途**: 创建system应用的新增表  
**包含表**: system_security_logs, system_page_configs, system_analytics, system_maintenance  
**运行方式**:
```bash
cd backend
python scripts/create_system_tables.py
```

### 4. fix_menus_table.py
**用途**: 修复menus表的字段问题  
**运行方式**:
```bash
cd backend
python scripts/fix_menus_table.py
```

### 5. check_tables.py
**用途**: 检查数据库中的表  
**运行方式**:
```bash
cd backend
python scripts/check_tables.py
```

## 注意事项

1. 这些脚本仅在首次部署或出现问题时使用
2. 正常情况下应使用Django的migrate命令
3. 运行脚本前请备份数据库
4. 这些脚本已在v2.0部署时使用过，通常不需要再次运行

## 维护建议

如果需要重新部署或迁移数据库，请按以下顺序运行：

1. 运行迁移修复（如果需要）
   ```bash
   python scripts/fix_migrations.py
   ```

2. 创建缺失的表（如果需要）
   ```bash
   python scripts/create_missing_tables.py
   python scripts/create_system_tables.py
   ```

3. 修复特定问题（如果需要）
   ```bash
   python scripts/fix_menus_table.py
   ```

4. 验证结果
   ```bash
   python scripts/check_tables.py
   ```





