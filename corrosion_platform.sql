/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80404 (8.4.4)
 Source Host           : localhost:3306
 Source Schema         : corrosion_platform

 Target Server Type    : MySQL
 Target Server Version : 80404 (8.4.4)
 File Encoding         : 65001

 Date: 22/10/2025 22:56:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id` ASC, `codename` ASC) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 217 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO `auth_permission` VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO `auth_permission` VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO `auth_permission` VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO `auth_permission` VALUES (21, 'Can add 用户', 6, 'add_user');
INSERT INTO `auth_permission` VALUES (22, 'Can change 用户', 6, 'change_user');
INSERT INTO `auth_permission` VALUES (23, 'Can delete 用户', 6, 'delete_user');
INSERT INTO `auth_permission` VALUES (24, 'Can view 用户', 6, 'view_user');
INSERT INTO `auth_permission` VALUES (25, 'Can add 角色', 7, 'add_role');
INSERT INTO `auth_permission` VALUES (26, 'Can change 角色', 7, 'change_role');
INSERT INTO `auth_permission` VALUES (27, 'Can delete 角色', 7, 'delete_role');
INSERT INTO `auth_permission` VALUES (28, 'Can view 角色', 7, 'view_role');
INSERT INTO `auth_permission` VALUES (29, 'Can add 权限', 8, 'add_permission');
INSERT INTO `auth_permission` VALUES (30, 'Can change 权限', 8, 'change_permission');
INSERT INTO `auth_permission` VALUES (31, 'Can delete 权限', 8, 'delete_permission');
INSERT INTO `auth_permission` VALUES (32, 'Can view 权限', 8, 'view_permission');
INSERT INTO `auth_permission` VALUES (33, 'Can add 菜单', 9, 'add_menu');
INSERT INTO `auth_permission` VALUES (34, 'Can change 菜单', 9, 'change_menu');
INSERT INTO `auth_permission` VALUES (35, 'Can delete 菜单', 9, 'delete_menu');
INSERT INTO `auth_permission` VALUES (36, 'Can view 菜单', 9, 'view_menu');
INSERT INTO `auth_permission` VALUES (37, 'Can add 用户角色', 10, 'add_userrole');
INSERT INTO `auth_permission` VALUES (38, 'Can change 用户角色', 10, 'change_userrole');
INSERT INTO `auth_permission` VALUES (39, 'Can delete 用户角色', 10, 'delete_userrole');
INSERT INTO `auth_permission` VALUES (40, 'Can view 用户角色', 10, 'view_userrole');
INSERT INTO `auth_permission` VALUES (41, 'Can add 角色权限', 11, 'add_rolepermission');
INSERT INTO `auth_permission` VALUES (42, 'Can change 角色权限', 11, 'change_rolepermission');
INSERT INTO `auth_permission` VALUES (43, 'Can delete 角色权限', 11, 'delete_rolepermission');
INSERT INTO `auth_permission` VALUES (44, 'Can view 角色权限', 11, 'view_rolepermission');
INSERT INTO `auth_permission` VALUES (45, 'Can add 角色菜单', 12, 'add_rolemenu');
INSERT INTO `auth_permission` VALUES (46, 'Can change 角色菜单', 12, 'change_rolemenu');
INSERT INTO `auth_permission` VALUES (47, 'Can delete 角色菜单', 12, 'delete_rolemenu');
INSERT INTO `auth_permission` VALUES (48, 'Can view 角色菜单', 12, 'view_rolemenu');
INSERT INTO `auth_permission` VALUES (49, 'Can add 用户登录日志', 13, 'add_userloginlog');
INSERT INTO `auth_permission` VALUES (50, 'Can change 用户登录日志', 13, 'change_userloginlog');
INSERT INTO `auth_permission` VALUES (51, 'Can delete 用户登录日志', 13, 'delete_userloginlog');
INSERT INTO `auth_permission` VALUES (52, 'Can view 用户登录日志', 13, 'view_userloginlog');
INSERT INTO `auth_permission` VALUES (53, 'Can add 企业信息', 14, 'add_enterprise');
INSERT INTO `auth_permission` VALUES (54, 'Can change 企业信息', 14, 'change_enterprise');
INSERT INTO `auth_permission` VALUES (55, 'Can delete 企业信息', 14, 'delete_enterprise');
INSERT INTO `auth_permission` VALUES (56, 'Can view 企业信息', 14, 'view_enterprise');
INSERT INTO `auth_permission` VALUES (57, 'Can add 企业资质文件', 15, 'add_enterprisedocument');
INSERT INTO `auth_permission` VALUES (58, 'Can change 企业资质文件', 15, 'change_enterprisedocument');
INSERT INTO `auth_permission` VALUES (59, 'Can delete 企业资质文件', 15, 'delete_enterprisedocument');
INSERT INTO `auth_permission` VALUES (60, 'Can view 企业资质文件', 15, 'view_enterprisedocument');
INSERT INTO `auth_permission` VALUES (61, 'Can add 企业员工', 16, 'add_employee');
INSERT INTO `auth_permission` VALUES (62, 'Can change 企业员工', 16, 'change_employee');
INSERT INTO `auth_permission` VALUES (63, 'Can delete 企业员工', 16, 'delete_employee');
INSERT INTO `auth_permission` VALUES (64, 'Can view 企业员工', 16, 'view_employee');
INSERT INTO `auth_permission` VALUES (65, 'Can add 企业项目', 17, 'add_enterpriseproject');
INSERT INTO `auth_permission` VALUES (66, 'Can change 企业项目', 17, 'change_enterpriseproject');
INSERT INTO `auth_permission` VALUES (67, 'Can delete 企业项目', 17, 'delete_enterpriseproject');
INSERT INTO `auth_permission` VALUES (68, 'Can view 企业项目', 17, 'view_enterpriseproject');
INSERT INTO `auth_permission` VALUES (69, 'Can add 企业统计', 18, 'add_enterprisestatistics');
INSERT INTO `auth_permission` VALUES (70, 'Can change 企业统计', 18, 'change_enterprisestatistics');
INSERT INTO `auth_permission` VALUES (71, 'Can delete 企业统计', 18, 'delete_enterprisestatistics');
INSERT INTO `auth_permission` VALUES (72, 'Can view 企业统计', 18, 'view_enterprisestatistics');
INSERT INTO `auth_permission` VALUES (73, 'Can add 个人用户信息', 19, 'add_person');
INSERT INTO `auth_permission` VALUES (74, 'Can change 个人用户信息', 19, 'change_person');
INSERT INTO `auth_permission` VALUES (75, 'Can delete 个人用户信息', 19, 'delete_person');
INSERT INTO `auth_permission` VALUES (76, 'Can view 个人用户信息', 19, 'view_person');
INSERT INTO `auth_permission` VALUES (77, 'Can add 个人项目', 20, 'add_personproject');
INSERT INTO `auth_permission` VALUES (78, 'Can change 个人项目', 20, 'change_personproject');
INSERT INTO `auth_permission` VALUES (79, 'Can delete 个人项目', 20, 'delete_personproject');
INSERT INTO `auth_permission` VALUES (80, 'Can view 个人项目', 20, 'view_personproject');
INSERT INTO `auth_permission` VALUES (81, 'Can add 个人任务', 21, 'add_persontask');
INSERT INTO `auth_permission` VALUES (82, 'Can change 个人任务', 21, 'change_persontask');
INSERT INTO `auth_permission` VALUES (83, 'Can delete 个人任务', 21, 'delete_persontask');
INSERT INTO `auth_permission` VALUES (84, 'Can view 个人任务', 21, 'view_persontask');
INSERT INTO `auth_permission` VALUES (85, 'Can add 个人统计', 22, 'add_personstatistics');
INSERT INTO `auth_permission` VALUES (86, 'Can change 个人统计', 22, 'change_personstatistics');
INSERT INTO `auth_permission` VALUES (87, 'Can delete 个人统计', 22, 'delete_personstatistics');
INSERT INTO `auth_permission` VALUES (88, 'Can view 个人统计', 22, 'view_personstatistics');
INSERT INTO `auth_permission` VALUES (89, 'Can add 个人资质文件', 23, 'add_persondocument');
INSERT INTO `auth_permission` VALUES (90, 'Can change 个人资质文件', 23, 'change_persondocument');
INSERT INTO `auth_permission` VALUES (91, 'Can delete 个人资质文件', 23, 'delete_persondocument');
INSERT INTO `auth_permission` VALUES (92, 'Can view 个人资质文件', 23, 'view_persondocument');
INSERT INTO `auth_permission` VALUES (93, 'Can add 信息分类', 24, 'add_infocategory');
INSERT INTO `auth_permission` VALUES (94, 'Can change 信息分类', 24, 'change_infocategory');
INSERT INTO `auth_permission` VALUES (95, 'Can delete 信息分类', 24, 'delete_infocategory');
INSERT INTO `auth_permission` VALUES (96, 'Can view 信息分类', 24, 'view_infocategory');
INSERT INTO `auth_permission` VALUES (97, 'Can add 信息发布', 25, 'add_infopost');
INSERT INTO `auth_permission` VALUES (98, 'Can change 信息发布', 25, 'change_infopost');
INSERT INTO `auth_permission` VALUES (99, 'Can delete 信息发布', 25, 'delete_infopost');
INSERT INTO `auth_permission` VALUES (100, 'Can view 信息发布', 25, 'view_infopost');
INSERT INTO `auth_permission` VALUES (101, 'Can add 信息发布图片', 26, 'add_infopostimage');
INSERT INTO `auth_permission` VALUES (102, 'Can change 信息发布图片', 26, 'change_infopostimage');
INSERT INTO `auth_permission` VALUES (103, 'Can delete 信息发布图片', 26, 'delete_infopostimage');
INSERT INTO `auth_permission` VALUES (104, 'Can view 信息发布图片', 26, 'view_infopostimage');
INSERT INTO `auth_permission` VALUES (105, 'Can add 信息评论', 27, 'add_infocomment');
INSERT INTO `auth_permission` VALUES (106, 'Can change 信息评论', 27, 'change_infocomment');
INSERT INTO `auth_permission` VALUES (107, 'Can delete 信息评论', 27, 'delete_infocomment');
INSERT INTO `auth_permission` VALUES (108, 'Can view 信息评论', 27, 'view_infocomment');
INSERT INTO `auth_permission` VALUES (109, 'Can add 信息点赞', 28, 'add_infolike');
INSERT INTO `auth_permission` VALUES (110, 'Can change 信息点赞', 28, 'change_infolike');
INSERT INTO `auth_permission` VALUES (111, 'Can delete 信息点赞', 28, 'delete_infolike');
INSERT INTO `auth_permission` VALUES (112, 'Can view 信息点赞', 28, 'view_infolike');
INSERT INTO `auth_permission` VALUES (113, 'Can add 信息收藏', 29, 'add_infofavorite');
INSERT INTO `auth_permission` VALUES (114, 'Can change 信息收藏', 29, 'change_infofavorite');
INSERT INTO `auth_permission` VALUES (115, 'Can delete 信息收藏', 29, 'delete_infofavorite');
INSERT INTO `auth_permission` VALUES (116, 'Can view 信息收藏', 29, 'view_infofavorite');
INSERT INTO `auth_permission` VALUES (117, 'Can add 信息浏览日志', 30, 'add_infoviewlog');
INSERT INTO `auth_permission` VALUES (118, 'Can change 信息浏览日志', 30, 'change_infoviewlog');
INSERT INTO `auth_permission` VALUES (119, 'Can delete 信息浏览日志', 30, 'delete_infoviewlog');
INSERT INTO `auth_permission` VALUES (120, 'Can view 信息浏览日志', 30, 'view_infoviewlog');
INSERT INTO `auth_permission` VALUES (121, 'Can add 信息标签', 31, 'add_infotag');
INSERT INTO `auth_permission` VALUES (122, 'Can change 信息标签', 31, 'change_infotag');
INSERT INTO `auth_permission` VALUES (123, 'Can delete 信息标签', 31, 'delete_infotag');
INSERT INTO `auth_permission` VALUES (124, 'Can view 信息标签', 31, 'view_infotag');
INSERT INTO `auth_permission` VALUES (125, 'Can add 资源类型', 32, 'add_resourcetype');
INSERT INTO `auth_permission` VALUES (126, 'Can change 资源类型', 32, 'change_resourcetype');
INSERT INTO `auth_permission` VALUES (127, 'Can delete 资源类型', 32, 'delete_resourcetype');
INSERT INTO `auth_permission` VALUES (128, 'Can view 资源类型', 32, 'view_resourcetype');
INSERT INTO `auth_permission` VALUES (129, 'Can add 资源信息', 33, 'add_resource');
INSERT INTO `auth_permission` VALUES (130, 'Can change 资源信息', 33, 'change_resource');
INSERT INTO `auth_permission` VALUES (131, 'Can delete 资源信息', 33, 'delete_resource');
INSERT INTO `auth_permission` VALUES (132, 'Can view 资源信息', 33, 'view_resource');
INSERT INTO `auth_permission` VALUES (133, 'Can add 资源图片', 34, 'add_resourceimage');
INSERT INTO `auth_permission` VALUES (134, 'Can change 资源图片', 34, 'change_resourceimage');
INSERT INTO `auth_permission` VALUES (135, 'Can delete 资源图片', 34, 'delete_resourceimage');
INSERT INTO `auth_permission` VALUES (136, 'Can view 资源图片', 34, 'view_resourceimage');
INSERT INTO `auth_permission` VALUES (137, 'Can add 资源使用日志', 35, 'add_resourceusagelog');
INSERT INTO `auth_permission` VALUES (138, 'Can change 资源使用日志', 35, 'change_resourceusagelog');
INSERT INTO `auth_permission` VALUES (139, 'Can delete 资源使用日志', 35, 'delete_resourceusagelog');
INSERT INTO `auth_permission` VALUES (140, 'Can view 资源使用日志', 35, 'view_resourceusagelog');
INSERT INTO `auth_permission` VALUES (141, 'Can add 资源维护记录', 36, 'add_resourcemaintenance');
INSERT INTO `auth_permission` VALUES (142, 'Can change 资源维护记录', 36, 'change_resourcemaintenance');
INSERT INTO `auth_permission` VALUES (143, 'Can delete 资源维护记录', 36, 'delete_resourcemaintenance');
INSERT INTO `auth_permission` VALUES (144, 'Can view 资源维护记录', 36, 'view_resourcemaintenance');
INSERT INTO `auth_permission` VALUES (145, 'Can add 资源申请', 37, 'add_resourcerequest');
INSERT INTO `auth_permission` VALUES (146, 'Can change 资源申请', 37, 'change_resourcerequest');
INSERT INTO `auth_permission` VALUES (147, 'Can delete 资源申请', 37, 'delete_resourcerequest');
INSERT INTO `auth_permission` VALUES (148, 'Can view 资源申请', 37, 'view_resourcerequest');
INSERT INTO `auth_permission` VALUES (149, 'Can add 资源统计', 38, 'add_resourcestatistics');
INSERT INTO `auth_permission` VALUES (150, 'Can change 资源统计', 38, 'change_resourcestatistics');
INSERT INTO `auth_permission` VALUES (151, 'Can delete 资源统计', 38, 'delete_resourcestatistics');
INSERT INTO `auth_permission` VALUES (152, 'Can view 资源统计', 38, 'view_resourcestatistics');
INSERT INTO `auth_permission` VALUES (153, 'Can add 系统配置', 39, 'add_systemconfig');
INSERT INTO `auth_permission` VALUES (154, 'Can change 系统配置', 39, 'change_systemconfig');
INSERT INTO `auth_permission` VALUES (155, 'Can delete 系统配置', 39, 'delete_systemconfig');
INSERT INTO `auth_permission` VALUES (156, 'Can view 系统配置', 39, 'view_systemconfig');
INSERT INTO `auth_permission` VALUES (157, 'Can add 系统日志', 40, 'add_systemlog');
INSERT INTO `auth_permission` VALUES (158, 'Can change 系统日志', 40, 'change_systemlog');
INSERT INTO `auth_permission` VALUES (159, 'Can delete 系统日志', 40, 'delete_systemlog');
INSERT INTO `auth_permission` VALUES (160, 'Can view 系统日志', 40, 'view_systemlog');
INSERT INTO `auth_permission` VALUES (161, 'Can add 系统统计', 41, 'add_systemstatistics');
INSERT INTO `auth_permission` VALUES (162, 'Can change 系统统计', 41, 'change_systemstatistics');
INSERT INTO `auth_permission` VALUES (163, 'Can delete 系统统计', 41, 'delete_systemstatistics');
INSERT INTO `auth_permission` VALUES (164, 'Can view 系统统计', 41, 'view_systemstatistics');
INSERT INTO `auth_permission` VALUES (165, 'Can add 系统通知', 42, 'add_systemnotification');
INSERT INTO `auth_permission` VALUES (166, 'Can change 系统通知', 42, 'change_systemnotification');
INSERT INTO `auth_permission` VALUES (167, 'Can delete 系统通知', 42, 'delete_systemnotification');
INSERT INTO `auth_permission` VALUES (168, 'Can view 系统通知', 42, 'view_systemnotification');
INSERT INTO `auth_permission` VALUES (169, 'Can add 系统备份', 43, 'add_systembackup');
INSERT INTO `auth_permission` VALUES (170, 'Can change 系统备份', 43, 'change_systembackup');
INSERT INTO `auth_permission` VALUES (171, 'Can delete 系统备份', 43, 'delete_systembackup');
INSERT INTO `auth_permission` VALUES (172, 'Can view 系统备份', 43, 'view_systembackup');
INSERT INTO `auth_permission` VALUES (173, 'Can add 系统监控', 44, 'add_systemmonitor');
INSERT INTO `auth_permission` VALUES (174, 'Can change 系统监控', 44, 'change_systemmonitor');
INSERT INTO `auth_permission` VALUES (175, 'Can delete 系统监控', 44, 'delete_systemmonitor');
INSERT INTO `auth_permission` VALUES (176, 'Can view 系统监控', 44, 'view_systemmonitor');
INSERT INTO `auth_permission` VALUES (177, 'Can add 权限组', 45, 'add_permissiongroup');
INSERT INTO `auth_permission` VALUES (178, 'Can change 权限组', 45, 'change_permissiongroup');
INSERT INTO `auth_permission` VALUES (179, 'Can delete 权限组', 45, 'delete_permissiongroup');
INSERT INTO `auth_permission` VALUES (180, 'Can view 权限组', 45, 'view_permissiongroup');
INSERT INTO `auth_permission` VALUES (181, 'Can add 用户会话', 46, 'add_usersession');
INSERT INTO `auth_permission` VALUES (182, 'Can change 用户会话', 46, 'change_usersession');
INSERT INTO `auth_permission` VALUES (183, 'Can delete 用户会话', 46, 'delete_usersession');
INSERT INTO `auth_permission` VALUES (184, 'Can view 用户会话', 46, 'view_usersession');
INSERT INTO `auth_permission` VALUES (185, 'Can add 用户资料', 47, 'add_userprofile');
INSERT INTO `auth_permission` VALUES (186, 'Can change 用户资料', 47, 'change_userprofile');
INSERT INTO `auth_permission` VALUES (187, 'Can delete 用户资料', 47, 'delete_userprofile');
INSERT INTO `auth_permission` VALUES (188, 'Can view 用户资料', 47, 'view_userprofile');
INSERT INTO `auth_permission` VALUES (189, 'Can add 用户权限覆盖', 48, 'add_userpermissionoverride');
INSERT INTO `auth_permission` VALUES (190, 'Can change 用户权限覆盖', 48, 'change_userpermissionoverride');
INSERT INTO `auth_permission` VALUES (191, 'Can delete 用户权限覆盖', 48, 'delete_userpermissionoverride');
INSERT INTO `auth_permission` VALUES (192, 'Can view 用户权限覆盖', 48, 'view_userpermissionoverride');
INSERT INTO `auth_permission` VALUES (193, 'Can add 用户活动日志', 49, 'add_useractivitylog');
INSERT INTO `auth_permission` VALUES (194, 'Can change 用户活动日志', 49, 'change_useractivitylog');
INSERT INTO `auth_permission` VALUES (195, 'Can delete 用户活动日志', 49, 'delete_useractivitylog');
INSERT INTO `auth_permission` VALUES (196, 'Can view 用户活动日志', 49, 'view_useractivitylog');
INSERT INTO `auth_permission` VALUES (197, 'Can add 角色权限审计', 50, 'add_rolepermissionaudit');
INSERT INTO `auth_permission` VALUES (198, 'Can change 角色权限审计', 50, 'change_rolepermissionaudit');
INSERT INTO `auth_permission` VALUES (199, 'Can delete 角色权限审计', 50, 'delete_rolepermissionaudit');
INSERT INTO `auth_permission` VALUES (200, 'Can view 角色权限审计', 50, 'view_rolepermissionaudit');
INSERT INTO `auth_permission` VALUES (201, 'Can add 系统页面配置', 51, 'add_systempageconfig');
INSERT INTO `auth_permission` VALUES (202, 'Can change 系统页面配置', 51, 'change_systempageconfig');
INSERT INTO `auth_permission` VALUES (203, 'Can delete 系统页面配置', 51, 'delete_systempageconfig');
INSERT INTO `auth_permission` VALUES (204, 'Can view 系统页面配置', 51, 'view_systempageconfig');
INSERT INTO `auth_permission` VALUES (205, 'Can add 系统维护', 52, 'add_systemmaintenance');
INSERT INTO `auth_permission` VALUES (206, 'Can change 系统维护', 52, 'change_systemmaintenance');
INSERT INTO `auth_permission` VALUES (207, 'Can delete 系统维护', 52, 'delete_systemmaintenance');
INSERT INTO `auth_permission` VALUES (208, 'Can view 系统维护', 52, 'view_systemmaintenance');
INSERT INTO `auth_permission` VALUES (209, 'Can add 系统数据分析', 53, 'add_systemanalytics');
INSERT INTO `auth_permission` VALUES (210, 'Can change 系统数据分析', 53, 'change_systemanalytics');
INSERT INTO `auth_permission` VALUES (211, 'Can delete 系统数据分析', 53, 'delete_systemanalytics');
INSERT INTO `auth_permission` VALUES (212, 'Can view 系统数据分析', 53, 'view_systemanalytics');
INSERT INTO `auth_permission` VALUES (213, 'Can add 系统安全日志', 54, 'add_systemsecuritylog');
INSERT INTO `auth_permission` VALUES (214, 'Can change 系统安全日志', 54, 'change_systemsecuritylog');
INSERT INTO `auth_permission` VALUES (215, 'Can delete 系统安全日志', 54, 'delete_systemsecuritylog');
INSERT INTO `auth_permission` VALUES (216, 'Can view 系统安全日志', 54, 'view_systemsecuritylog');

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NULL DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id` ASC) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_users_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_chk_1` CHECK (`action_flag` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label` ASC, `model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (16, 'enterprises', 'employee');
INSERT INTO `django_content_type` VALUES (14, 'enterprises', 'enterprise');
INSERT INTO `django_content_type` VALUES (15, 'enterprises', 'enterprisedocument');
INSERT INTO `django_content_type` VALUES (17, 'enterprises', 'enterpriseproject');
INSERT INTO `django_content_type` VALUES (18, 'enterprises', 'enterprisestatistics');
INSERT INTO `django_content_type` VALUES (24, 'info_plaza', 'infocategory');
INSERT INTO `django_content_type` VALUES (27, 'info_plaza', 'infocomment');
INSERT INTO `django_content_type` VALUES (29, 'info_plaza', 'infofavorite');
INSERT INTO `django_content_type` VALUES (28, 'info_plaza', 'infolike');
INSERT INTO `django_content_type` VALUES (25, 'info_plaza', 'infopost');
INSERT INTO `django_content_type` VALUES (26, 'info_plaza', 'infopostimage');
INSERT INTO `django_content_type` VALUES (31, 'info_plaza', 'infotag');
INSERT INTO `django_content_type` VALUES (30, 'info_plaza', 'infoviewlog');
INSERT INTO `django_content_type` VALUES (19, 'persons', 'person');
INSERT INTO `django_content_type` VALUES (23, 'persons', 'persondocument');
INSERT INTO `django_content_type` VALUES (20, 'persons', 'personproject');
INSERT INTO `django_content_type` VALUES (22, 'persons', 'personstatistics');
INSERT INTO `django_content_type` VALUES (21, 'persons', 'persontask');
INSERT INTO `django_content_type` VALUES (33, 'resources', 'resource');
INSERT INTO `django_content_type` VALUES (34, 'resources', 'resourceimage');
INSERT INTO `django_content_type` VALUES (36, 'resources', 'resourcemaintenance');
INSERT INTO `django_content_type` VALUES (37, 'resources', 'resourcerequest');
INSERT INTO `django_content_type` VALUES (38, 'resources', 'resourcestatistics');
INSERT INTO `django_content_type` VALUES (32, 'resources', 'resourcetype');
INSERT INTO `django_content_type` VALUES (35, 'resources', 'resourceusagelog');
INSERT INTO `django_content_type` VALUES (5, 'sessions', 'session');
INSERT INTO `django_content_type` VALUES (53, 'system', 'systemanalytics');
INSERT INTO `django_content_type` VALUES (43, 'system', 'systembackup');
INSERT INTO `django_content_type` VALUES (39, 'system', 'systemconfig');
INSERT INTO `django_content_type` VALUES (40, 'system', 'systemlog');
INSERT INTO `django_content_type` VALUES (52, 'system', 'systemmaintenance');
INSERT INTO `django_content_type` VALUES (44, 'system', 'systemmonitor');
INSERT INTO `django_content_type` VALUES (42, 'system', 'systemnotification');
INSERT INTO `django_content_type` VALUES (51, 'system', 'systempageconfig');
INSERT INTO `django_content_type` VALUES (54, 'system', 'systemsecuritylog');
INSERT INTO `django_content_type` VALUES (41, 'system', 'systemstatistics');
INSERT INTO `django_content_type` VALUES (9, 'users', 'menu');
INSERT INTO `django_content_type` VALUES (8, 'users', 'permission');
INSERT INTO `django_content_type` VALUES (45, 'users', 'permissiongroup');
INSERT INTO `django_content_type` VALUES (7, 'users', 'role');
INSERT INTO `django_content_type` VALUES (12, 'users', 'rolemenu');
INSERT INTO `django_content_type` VALUES (11, 'users', 'rolepermission');
INSERT INTO `django_content_type` VALUES (50, 'users', 'rolepermissionaudit');
INSERT INTO `django_content_type` VALUES (6, 'users', 'user');
INSERT INTO `django_content_type` VALUES (49, 'users', 'useractivitylog');
INSERT INTO `django_content_type` VALUES (13, 'users', 'userloginlog');
INSERT INTO `django_content_type` VALUES (48, 'users', 'userpermissionoverride');
INSERT INTO `django_content_type` VALUES (47, 'users', 'userprofile');
INSERT INTO `django_content_type` VALUES (10, 'users', 'userrole');
INSERT INTO `django_content_type` VALUES (46, 'users', 'usersession');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2025-10-15 00:26:28.759506');
INSERT INTO `django_migrations` VALUES (2, 'admin', '0001_initial', '2025-10-15 00:26:28.893979');
INSERT INTO `django_migrations` VALUES (3, 'admin', '0002_logentry_remove_auto_add', '2025-10-15 00:26:28.904469');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0003_logentry_add_action_flag_choices', '2025-10-15 00:26:28.911829');
INSERT INTO `django_migrations` VALUES (5, 'contenttypes', '0002_remove_content_type_name', '2025-10-15 00:26:29.039281');
INSERT INTO `django_migrations` VALUES (6, 'auth', '0001_initial', '2025-10-15 00:26:29.280268');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0002_alter_permission_name_max_length', '2025-10-15 00:26:29.337750');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0003_alter_user_email_max_length', '2025-10-15 00:26:29.348272');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0004_alter_user_username_opts', '2025-10-15 00:26:29.357252');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0005_alter_user_last_login_null', '2025-10-15 00:26:29.366926');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0006_require_contenttypes_0002', '2025-10-15 00:26:29.371308');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0007_alter_validators_add_error_messages', '2025-10-15 00:26:29.380323');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0008_alter_user_username_max_length', '2025-10-15 00:26:29.391312');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0009_alter_user_last_name_max_length', '2025-10-15 00:26:29.400347');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0010_alter_group_name_max_length', '2025-10-15 00:26:29.423405');
INSERT INTO `django_migrations` VALUES (16, 'auth', '0011_update_proxy_permissions', '2025-10-15 00:26:29.477945');
INSERT INTO `django_migrations` VALUES (17, 'auth', '0012_alter_user_first_name_max_length', '2025-10-15 00:26:29.487956');
INSERT INTO `django_migrations` VALUES (18, 'sessions', '0001_initial', '2025-10-15 00:26:29.521595');
INSERT INTO `django_migrations` VALUES (19, 'info_plaza', '0001_initial', '2025-10-21 16:10:07.126997');
INSERT INTO `django_migrations` VALUES (21, 'system', '0001_initial', '2025-10-22 11:59:10.001728');
INSERT INTO `django_migrations` VALUES (22, 'users', '0001_initial', '2025-10-22 12:01:43.490024');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------

-- ----------------------------
-- Table structure for employees
-- ----------------------------
DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `employee_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '工号',
  `position` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '职位',
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '部门',
  `hire_date` date NOT NULL COMMENT '入职日期',
  `salary` decimal(10, 2) NULL DEFAULT NULL COMMENT '薪资',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否在职',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  UNIQUE INDEX `employees_enterprise_id_employee_id`(`enterprise_id` ASC, `employee_id` ASC) USING BTREE,
  INDEX `idx_position`(`position` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE,
  CONSTRAINT `employees_enterprise_id` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `employees_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业员工表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of employees
-- ----------------------------
INSERT INTO `employees` VALUES (1, 4, 19, 'EMP906323', 'other', '待分配', '2025-10-21', NULL, 1, '2025-10-21 01:58:26.686194', '2025-10-21 01:58:26.686194');
INSERT INTO `employees` VALUES (2, 1, 21, 'EMP106616', 'other', '待分配', '2025-10-21', NULL, 1, '2025-10-21 19:31:46.861854', '2025-10-21 19:31:46.861854');
INSERT INTO `employees` VALUES (3, 1, 22, 'EMP109451', 'other', '待分配', '2025-10-21', NULL, 1, '2025-10-21 19:31:49.702410', '2025-10-21 19:31:49.702410');
INSERT INTO `employees` VALUES (4, 1, 23, 'EMP285702', 'manager', 'test', '2025-10-21', 10000.00, 1, '2025-10-21 19:35:09.137211', '2025-10-21 19:35:09.137211');

-- ----------------------------
-- Table structure for enterprise_documents
-- ----------------------------
DROP TABLE IF EXISTS `enterprise_documents`;
CREATE TABLE `enterprise_documents`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `document_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件类型',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件标题',
  `file` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '文件描述',
  `is_verified` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已验证',
  `verified_at` datetime(6) NULL DEFAULT NULL COMMENT '验证时间',
  `verified_by_id` bigint NULL DEFAULT NULL COMMENT '验证人ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `enterprise_documents_enterprise_id`(`enterprise_id` ASC) USING BTREE,
  INDEX `enterprise_documents_verified_by_id`(`verified_by_id` ASC) USING BTREE,
  INDEX `idx_document_type`(`document_type` ASC) USING BTREE,
  INDEX `idx_is_verified`(`is_verified` ASC) USING BTREE,
  CONSTRAINT `enterprise_documents_enterprise_id` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `enterprise_documents_verified_by_id` FOREIGN KEY (`verified_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业资质文件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of enterprise_documents
-- ----------------------------

-- ----------------------------
-- Table structure for enterprise_projects
-- ----------------------------
DROP TABLE IF EXISTS `enterprise_projects`;
CREATE TABLE `enterprise_projects`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目名称',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目描述',
  `client` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户',
  `contract_amount` decimal(15, 2) NULL DEFAULT NULL COMMENT '合同金额',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '结束日期',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planning' COMMENT '项目状态',
  `progress` int NOT NULL DEFAULT 0 COMMENT '进度百分比',
  `location` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '项目地点',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `enterprise_projects_enterprise_id`(`enterprise_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_start_date`(`start_date` ASC) USING BTREE,
  CONSTRAINT `enterprise_projects_enterprise_id` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of enterprise_projects
-- ----------------------------
INSERT INTO `enterprise_projects` VALUES (1, 1, '智慧城市物联网平台', '基于物联网技术的智慧城市综合管理平台，包含交通、环境、安防等多个子系统', '某市政府', 5000000.00, '2025-04-24', '2026-04-19', 'in_progress', 65, '深圳市南山区', '2025-10-21 01:39:45.035225', '2025-10-21 01:39:45.035225');
INSERT INTO `enterprise_projects` VALUES (2, 3, '企业数字化转型咨询', '为传统企业提供全方位的数字化转型咨询服务', '某制造企业', 2000000.00, '2025-07-23', '2026-07-18', 'in_progress', 35, '深圳市龙岗区', '2025-10-21 01:39:45.041888', '2025-10-21 01:39:45.041888');
INSERT INTO `enterprise_projects` VALUES (3, 4, '5G通信基站建设', '城市核心区域5G基站建设与优化项目', '某运营商', 8000000.00, '2024-10-21', '2025-09-21', 'completed', 100, '深圳市福田区', '2025-10-21 01:39:45.047884', '2025-10-21 01:39:45.047884');
INSERT INTO `enterprise_projects` VALUES (4, 1, '云计算数据中心', '建设高标准的云计算数据中心', '某科技公司', 15000000.00, '2025-11-20', '2027-10-21', 'planning', 0, '杭州市余杭区', '2025-10-21 01:39:45.053886', '2025-10-21 01:39:45.053886');
INSERT INTO `enterprise_projects` VALUES (5, 3, '电商平台升级改造', '对现有电商平台进行全面升级改造，提升用户体验', '某电商企业', 3000000.00, '2025-08-22', '2026-02-18', 'in_progress', 45, '杭州市滨江区', '2025-10-21 01:39:45.059419', '2025-10-21 01:39:45.059419');

-- ----------------------------
-- Table structure for enterprise_statistics
-- ----------------------------
DROP TABLE IF EXISTS `enterprise_statistics`;
CREATE TABLE `enterprise_statistics`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `enterprise_id` bigint NOT NULL COMMENT '企业ID',
  `total_projects` int NOT NULL DEFAULT 0 COMMENT '总项目数',
  `completed_projects` int NOT NULL DEFAULT 0 COMMENT '已完成项目数',
  `total_employees` int NOT NULL DEFAULT 0 COMMENT '总员工数',
  `total_revenue` decimal(15, 2) NOT NULL DEFAULT 0.00 COMMENT '总收入',
  `total_contracts` int NOT NULL DEFAULT 0 COMMENT '总合同数',
  `last_updated` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '最后更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `enterprise_id`(`enterprise_id` ASC) USING BTREE,
  CONSTRAINT `enterprise_statistics_enterprise_id` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of enterprise_statistics
-- ----------------------------
INSERT INTO `enterprise_statistics` VALUES (1, 1, 2, 0, 0, 0.00, 0, '2025-10-21 11:35:54.494508');

-- ----------------------------
-- Table structure for enterprises
-- ----------------------------
DROP TABLE IF EXISTS `enterprises`;
CREATE TABLE `enterprises`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '关联用户ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '企业名称',
  `short_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '企业简称',
  `enterprise_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '企业类型',
  `unified_social_credit_code` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '统一社会信用代码',
  `legal_representative` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '法定代表人',
  `registered_capital` decimal(15, 2) NULL DEFAULT NULL COMMENT '注册资本',
  `establishment_date` date NULL DEFAULT NULL COMMENT '成立日期',
  `business_scope` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '经营范围',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '企业地址',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系电话',
  `contact_email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系邮箱',
  `website` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '企业网站',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '企业简介',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '认证状态',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  UNIQUE INDEX `unified_social_credit_code`(`unified_social_credit_code` ASC) USING BTREE,
  INDEX `idx_enterprise_type`(`enterprise_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE,
  INDEX `idx_enterprises_name`(`name` ASC) USING BTREE,
  INDEX `idx_enterprises_contact_email`(`contact_email` ASC) USING BTREE,
  CONSTRAINT `enterprises_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '企业信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of enterprises
-- ----------------------------
INSERT INTO `enterprises` VALUES (1, 12, '腾讯科技有限公司', '腾讯', 'manufacturer', '91440300279377467A', '马化腾', 50000000.00, '1998-11-11', '互联网信息服务、软件开发', '深圳市南山区科技园', '张三', '13800138001', 'zhangsan@tencent.com', '', '中国领先的互联网增值服务提供商', 'approved', 1, '2025-10-21 01:39:00.622924', '2025-10-21 01:39:00.622924');
INSERT INTO `enterprises` VALUES (3, 17, '华为技术有限公司', '华为', 'manufacturer', '91440300618460327Q', '任正非', 40000000.00, '1987-09-15', '通信设备制造、销售', '深圳市龙岗区坂田华为基地', '李四', '13800138002', 'lisi@huawei.com', '', '全球领先的ICT（信息与通信）基础设施和智能终端提供商', 'approved', 1, '2025-10-21 01:39:44.514629', '2025-10-21 01:39:44.514629');
INSERT INTO `enterprises` VALUES (4, 18, '阿里巴巴网络技术有限公司', '阿里', 'service', '913301007177990149', '张勇', 80000000.00, '1999-06-28', '电子商务、云计算服务', '杭州市余杭区文一西路969号', '王五', '13800138003', 'wangwu@alibaba.com', '', '中国最大的电子商务公司', 'approved', 1, '2025-10-21 01:39:45.024045', '2025-10-21 01:39:45.024045');

-- ----------------------------
-- Table structure for info_categories
-- ----------------------------
DROP TABLE IF EXISTS `info_categories`;
CREATE TABLE `info_categories`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类代码',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '分类描述',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分类图标',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE,
  INDEX `idx_sort_order`(`sort_order` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '信息分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of info_categories
-- ----------------------------
INSERT INTO `info_categories` VALUES (1, '供应信息', 'supply', '产品供应、服务提供等信息', 'ShoppingCart', 1, 1, '2025-10-14 09:44:09.000000');
INSERT INTO `info_categories` VALUES (2, '需求信息', 'demand', '产品需求、服务需求等信息', 'ShoppingBag', 2, 1, '2025-10-14 09:44:09.000000');
INSERT INTO `info_categories` VALUES (3, '招聘信息', 'recruitment', '人才招聘、岗位需求等信息', 'User', 3, 1, '2025-10-14 09:44:09.000000');
INSERT INTO `info_categories` VALUES (4, '招标信息', 'tender', '项目招标、采购招标等信息', 'Document', 4, 1, '2025-10-14 09:44:09.000000');
INSERT INTO `info_categories` VALUES (5, '技术文章', 'technology', '技术分享、经验交流等文章', 'Reading', 5, 1, '2025-10-14 09:44:09.000000');
INSERT INTO `info_categories` VALUES (6, '行业资讯', 'news', '行业动态、政策资讯等信息', 'Bell', 6, 1, '2025-10-14 09:44:09.000000');
INSERT INTO `info_categories` VALUES (21, '技术分享', 'tech', '技术文章和经验分享', '', 0, 1, '2025-10-21 01:40:04.842465');
INSERT INTO `info_categories` VALUES (22, '行业动态', 'industry', '行业新闻和动态', '', 0, 1, '2025-10-21 01:40:04.849449');
INSERT INTO `info_categories` VALUES (23, '项目案例', 'case', '项目案例展示', '', 0, 1, '2025-10-21 01:40:04.855451');
INSERT INTO `info_categories` VALUES (26, '活动通知', 'event', '各类活动通知', '', 0, 1, '2025-10-21 01:40:20.693304');

-- ----------------------------
-- Table structure for info_comments
-- ----------------------------
DROP TABLE IF EXISTS `info_comments`;
CREATE TABLE `info_comments`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `author_id` bigint NOT NULL COMMENT '评论者ID',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父评论ID',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论内容',
  `like_count` int NOT NULL DEFAULT 0 COMMENT '点赞数',
  `is_approved` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否审核通过',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `info_comments_post_id`(`post_id` ASC) USING BTREE,
  INDEX `info_comments_author_id`(`author_id` ASC) USING BTREE,
  INDEX `info_comments_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_is_approved`(`is_approved` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  CONSTRAINT `info_comments_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `info_comments_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `info_comments` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `info_comments_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '信息评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of info_comments
-- ----------------------------
INSERT INTO `info_comments` VALUES (1, 9, 1, NULL, 'test', 0, 1, '2025-10-21 19:07:11.993781', '2025-10-21 19:07:11.993781');

-- ----------------------------
-- Table structure for info_favorites
-- ----------------------------
DROP TABLE IF EXISTS `info_favorites`;
CREATE TABLE `info_favorites`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `info_favorites_post_id_user_id`(`post_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `info_favorites_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `info_favorites_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `info_favorites_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '信息收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of info_favorites
-- ----------------------------

-- ----------------------------
-- Table structure for info_likes
-- ----------------------------
DROP TABLE IF EXISTS `info_likes`;
CREATE TABLE `info_likes`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `info_likes_post_id_user_id`(`post_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `info_likes_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `info_likes_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `info_likes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '信息点赞表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of info_likes
-- ----------------------------
INSERT INTO `info_likes` VALUES (2, 3, 5, '2025-10-15 16:39:21.536019');

-- ----------------------------
-- Table structure for info_post_images
-- ----------------------------
DROP TABLE IF EXISTS `info_post_images`;
CREATE TABLE `info_post_images`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片路径',
  `caption` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片说明',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `info_post_images_post_id`(`post_id` ASC) USING BTREE,
  INDEX `idx_sort_order`(`sort_order` ASC) USING BTREE,
  CONSTRAINT `info_post_images_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '信息发布图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of info_post_images
-- ----------------------------

-- ----------------------------
-- Table structure for info_posts
-- ----------------------------
DROP TABLE IF EXISTS `info_posts`;
CREATE TABLE `info_posts`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `author_id` bigint NOT NULL COMMENT '发布者ID',
  `category_id` bigint NULL DEFAULT NULL,
  `post_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '信息类型',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容',
  `summary` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '摘要',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标签',
  `priority` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT '优先级',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft' COMMENT '状态',
  `is_top` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否置顶',
  `is_recommended` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否推荐',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '浏览次数',
  `like_count` int NOT NULL DEFAULT 0 COMMENT '点赞数',
  `comment_count` int NOT NULL DEFAULT 0 COMMENT '评论数',
  `share_count` int NOT NULL DEFAULT 0 COMMENT '分享数',
  `contact_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '联系信息',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '地点',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `valid_until` datetime(6) NULL DEFAULT NULL COMMENT '有效期至',
  `published_at` datetime(6) NULL DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `info_posts_author_id`(`author_id` ASC) USING BTREE,
  INDEX `info_posts_category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_post_type`(`post_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_published_at`(`published_at` ASC) USING BTREE,
  INDEX `idx_is_top`(`is_top` ASC) USING BTREE,
  INDEX `idx_is_recommended`(`is_recommended` ASC) USING BTREE,
  INDEX `idx_info_posts_title`(`title` ASC) USING BTREE,
  INDEX `idx_info_posts_view_count`(`view_count` ASC) USING BTREE,
  INDEX `idx_info_posts_like_count`(`like_count` ASC) USING BTREE,
  CONSTRAINT `info_posts_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `info_posts_category_id` FOREIGN KEY (`category_id`) REFERENCES `info_categories` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '信息发布表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of info_posts
-- ----------------------------
INSERT INTO `info_posts` VALUES (1, 2, 5, 'technology', '防腐保温材料新技术应用', '介绍最新的防腐保温材料技术及其在工业领域的应用。包括聚氨酯保温材料、纳米防腐涂料等新型材料。', '最新防腐保温材料技术介绍', '', 'normal', 'published', 0, 0, 0, 0, 0, 0, '', '', NULL, NULL, '2025-10-15 16:39:15.286959', '2025-10-15 16:39:15.288968', '2025-10-16 01:17:29.198766');
INSERT INTO `info_posts` VALUES (2, 2, 5, 'news', '2024年防腐行业发展趋势', '分析2024年防腐保温行业的发展趋势和机遇，包括市场规模、技术创新、政策支持等方面。', '2024年行业发展趋势分析', '', 'normal', 'published', 0, 0, 0, 0, 0, 0, '', '', NULL, NULL, '2025-10-15 16:39:15.296971', '2025-10-15 16:39:15.298487', '2025-10-16 01:17:27.975378');
INSERT INTO `info_posts` VALUES (3, 2, 5, 'technology', '大型管道防腐项目经验分享', '分享大型管道防腐项目的实施经验和注意事项，包括材料选择、施工工艺、质量控制等。', '大型项目实施经验总结', '', 'normal', 'published', 0, 0, 7, 1, 0, 0, '', '', NULL, NULL, '2025-10-15 16:39:15.302497', '2025-10-15 16:39:15.304495', '2025-10-22 20:45:22.276301');
INSERT INTO `info_posts` VALUES (4, 1, 21, '', 'Django REST Framework 最佳实践', '在使用Django REST Framework开发API时，有一些最佳实践值得注意：\n\n1. **使用ViewSet和Router**：可以大大简化URL配置\n2. **合理使用序列化器**：区分读取和写入序列化器\n3. **权限控制**：使用permission_classes进行细粒度控制\n4. **分页设置**：为列表接口添加分页功能\n5. **过滤和搜索**：使用django-filter实现复杂查询\n\n这些实践可以让你的API更加规范和易于维护。', '', '', 'normal', 'published', 1, 0, 156, 0, 0, 0, '', '', NULL, NULL, NULL, '2025-10-21 01:40:34.931385', '2025-10-21 01:40:34.931385');
INSERT INTO `info_posts` VALUES (5, 1, 22, '', '防腐保温行业2024年发展趋势', '2024年防腐保温行业呈现以下发展趋势：\n\n1. **绿色环保材料**：环保型防腐保温材料需求增加\n2. **智能化施工**：引入物联网和智能监控技术\n3. **标准化管理**：行业标准不断完善\n4. **数字化转型**：企业加速数字化转型步伐\n\n行业整体向高质量发展转型。', '', '', 'normal', 'published', 0, 0, 89, 0, 0, 0, '', '', NULL, NULL, NULL, '2025-10-21 01:40:34.940400', '2025-10-21 01:40:34.940400');
INSERT INTO `info_posts` VALUES (6, 1, 23, '', '大型石化项目防腐保温案例分享', '某大型石化项目防腐保温工程案例：\n\n**项目概况**：\n- 项目规模：15万吨/年\n- 施工周期：18个月\n- 涉及管道：超过50公里\n\n**技术亮点**：\n1. 采用新型复合材料\n2. 智能监测系统\n3. 全过程质量管控\n\n项目已顺利通过验收，各项指标优良。', '', '', 'normal', 'published', 0, 0, 234, 0, 0, 0, '', '', NULL, NULL, NULL, '2025-10-21 01:40:34.946403', '2025-10-21 01:40:34.946403');
INSERT INTO `info_posts` VALUES (7, 1, 3, '', '招聘：高级Python开发工程师', '我公司诚聘高级Python开发工程师：\n\n**岗位要求**：\n- 3年以上Python开发经验\n- 熟悉Django/Flask框架\n- 了解前端技术（Vue/React）\n- 有良好的代码习惯\n\n**待遇**：\n- 薪资：15K-25K\n- 五险一金\n- 弹性工作制\n\n有意者请发送简历至hr@example.com', '', '', 'normal', 'published', 0, 0, 68, 0, 0, 0, '', '', NULL, NULL, NULL, '2025-10-21 01:40:34.952395', '2025-10-22 03:07:23.433801');
INSERT INTO `info_posts` VALUES (8, 1, 26, '', '防腐保温技术交流会通知', '【活动通知】\n\n时间：2024年11月15日 14:00\n地点：市会展中心3号厅\n主题：新型防腐保温材料应用与发展\n\n**议程**：\n1. 主题演讲\n2. 案例分享\n3. 技术交流\n4. 展览展示\n\n欢迎行业同仁参加！', '', '', 'normal', 'published', 1, 0, 123, 0, 0, 0, '', '', NULL, NULL, NULL, '2025-10-21 01:40:34.958401', '2025-10-21 01:40:34.958401');
INSERT INTO `info_posts` VALUES (9, 1, 23, 'supply', 'test', 'test', 'test', 'test', 'normal', 'draft', 0, 0, 1, 0, 0, 0, '', '', NULL, NULL, NULL, '2025-10-21 19:07:02.063929', '2025-10-22 03:07:20.681401');

-- ----------------------------
-- Table structure for info_tags
-- ----------------------------
DROP TABLE IF EXISTS `info_tags`;
CREATE TABLE `info_tags`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '标签描述',
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#1890ff' COMMENT '标签颜色',
  `use_count` int NOT NULL DEFAULT 0 COMMENT '使用次数',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  INDEX `idx_use_count`(`use_count` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '信息标签表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of info_tags
-- ----------------------------

-- ----------------------------
-- Table structure for info_view_logs
-- ----------------------------
DROP TABLE IF EXISTS `info_view_logs`;
CREATE TABLE `info_view_logs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '信息发布ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `ip_address` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IP地址',
  `user_agent` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户代理',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `info_view_logs_post_id`(`post_id` ASC) USING BTREE,
  INDEX `info_view_logs_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_ip_address`(`ip_address` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  CONSTRAINT `info_view_logs_post_id` FOREIGN KEY (`post_id`) REFERENCES `info_posts` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `info_view_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '信息浏览日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of info_view_logs
-- ----------------------------
INSERT INTO `info_view_logs` VALUES (1, 3, 5, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 16:39:21.450272');
INSERT INTO `info_view_logs` VALUES (2, 3, 5, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 16:39:21.507417');
INSERT INTO `info_view_logs` VALUES (3, 3, 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 17:17:29.992615');
INSERT INTO `info_view_logs` VALUES (4, 3, 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 17:17:34.449319');
INSERT INTO `info_view_logs` VALUES (5, 3, 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 00:35:15.411223');
INSERT INTO `info_view_logs` VALUES (6, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:58:40.739108');
INSERT INTO `info_view_logs` VALUES (7, 9, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 19:07:08.434096');
INSERT INTO `info_view_logs` VALUES (8, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 19:07:23.430436');
INSERT INTO `info_view_logs` VALUES (9, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:45:22.270125');

-- ----------------------------
-- Table structure for menus
-- ----------------------------
DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单代码',
  `url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '菜单URL',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '菜单图标',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父菜单ID',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `menu_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'page',
  `is_visible` tinyint(1) NOT NULL DEFAULT 1,
  `requires_permission` tinyint(1) NOT NULL DEFAULT 1,
  `component_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `meta_data` json NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_sort_order`(`sort_order` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE,
  CONSTRAINT `menus_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of menus
-- ----------------------------
INSERT INTO `menus` VALUES (1, '仪表板', 'dashboard', '/dashboard', 'Odometer', NULL, 1, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (2, '企业中心', 'enterprise', '/dashboard/enterprise', 'OfficeBuilding', NULL, 2, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (3, '个人中心', 'personal', '/dashboard/personal', 'User', NULL, 3, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (4, '信息广场', 'info_plaza', '/dashboard/info-plaza', 'ChatDotSquare', NULL, 4, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (5, '资源管理', 'resources', '/dashboard/resources', 'Box', NULL, 5, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (6, '系统管理', 'system', '/dashboard/system', 'Setting', NULL, 6, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (7, '企业信息', 'enterprise_info', '/dashboard/enterprise', 'OfficeBuilding', 2, 1, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (8, '项目管理', 'enterprise_projects', '/dashboard/enterprise/projects', 'Folder', 2, 2, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (9, '员工管理', 'enterprise_employees', '/dashboard/enterprise/employees', 'UserFilled', 2, 3, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (10, '个人信息', 'personal_info', '/dashboard/personal', 'User', 3, 1, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (11, '我的项目', 'personal_projects', '/dashboard/personal/projects', 'Folder', 3, 2, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (12, '我的任务', 'personal_tasks', '/dashboard/personal/tasks', 'List', 3, 3, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (13, '信息浏览', 'info_browse', '/dashboard/info-plaza', 'ChatDotSquare', 4, 1, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (14, '发布信息', 'info_publish', '/dashboard/info-plaza/publish', 'Edit', 4, 2, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (15, '资源浏览', 'resource_browse', '/dashboard/resources', 'Box', 5, 1, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (16, '添加资源', 'resource_add', '/dashboard/resources/add', 'Plus', 5, 2, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (17, '用户管理', 'system_users', '/dashboard/system/users', 'User', 6, 1, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (18, '角色管理', 'system_roles', '/dashboard/system/roles', 'UserFilled', 6, 2, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (19, '系统日志', 'system_logs', '/dashboard/system/logs', 'Document', 6, 3, 1, '2025-10-14 09:44:09.000000', 'page', 1, 1, '', NULL, '2025-10-22 20:10:10.452497', NULL);
INSERT INTO `menus` VALUES (60, '系统管理', 'system_management', '/system', 'system', NULL, 1, 1, '2025-10-22 12:11:33.763296', 'module', 1, 1, '', NULL, '2025-10-22 12:11:33.764295', '系统管理模块');
INSERT INTO `menus` VALUES (61, '用户管理', 'user_management', '/system/users', 'user', 60, 1, 1, '2025-10-22 12:11:33.767295', 'page', 1, 1, '', NULL, '2025-10-22 12:11:33.767295', '用户管理页面');

-- ----------------------------
-- Table structure for permission_groups
-- ----------------------------
DROP TABLE IF EXISTS `permission_groups`;
CREATE TABLE `permission_groups`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort_order` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permission_groups
-- ----------------------------
INSERT INTO `permission_groups` VALUES (1, '用户管理权限组', 'user_management_group', '用户管理相关权限', 'users', 1, 1, '2025-10-22 12:10:56.767739');

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限名称',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限代码',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '权限描述',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属模块',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE,
  INDEX `idx_module`(`module` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 97 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES (1, '用户查看', 'user_view', '查看用户信息', 'users', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (2, '用户创建', 'user_create', '创建用户', 'users', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (3, '用户编辑', 'user_edit', '编辑用户信息', 'users', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (4, '用户删除', 'user_delete', '删除用户', 'users', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (5, '角色查看', 'role_view', '查看角色信息', 'users', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (6, '角色创建', 'role_create', '创建角色', 'users', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (7, '角色编辑', 'role_edit', '编辑角色信息', 'users', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (8, '角色删除', 'role_delete', '删除角色', 'users', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (9, '企业查看', 'enterprise_view', '查看企业信息', 'enterprises', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (10, '企业创建', 'enterprise_create', '创建企业', 'enterprises', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (11, '企业编辑', 'enterprise_edit', '编辑企业信息', 'enterprises', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (12, '企业管理', 'enterprise_manage', '管理企业', 'enterprises', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (13, '信息查看', 'info_view', '查看信息', 'info_plaza', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (14, '信息发布', 'info_publish', '发布信息', 'info_plaza', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (15, '信息编辑', 'info_edit', '编辑信息', 'info_plaza', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (16, '信息删除', 'info_delete', '删除信息', 'info_plaza', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (17, '资源查看', 'resource_view', '查看资源', 'resources', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (18, '资源创建', 'resource_create', '创建资源', 'resources', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (19, '资源编辑', 'resource_edit', '编辑资源', 'resources', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (20, '资源删除', 'resource_delete', '删除资源', 'resources', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (21, '系统配置', 'system_config', '系统配置管理', 'system', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (22, '系统日志', 'system_log', '查看系统日志', 'system', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (23, '系统统计', 'system_statistics', '查看系统统计', 'system', 1, '2025-10-14 09:44:09.000000');
INSERT INTO `permissions` VALUES (72, '用户管理', 'user_manage', '管理用户', 'users', 1, '2025-10-22 00:46:00.754955');
INSERT INTO `permissions` VALUES (73, '角色管理', 'role_manage', '管理角色', 'users', 1, '2025-10-22 00:46:00.767939');
INSERT INTO `permissions` VALUES (74, '权限查看', 'permission_view', '查看权限信息', 'users', 1, '2025-10-22 00:46:00.774182');
INSERT INTO `permissions` VALUES (75, '权限创建', 'permission_create', '创建权限', 'users', 1, '2025-10-22 00:46:00.779210');
INSERT INTO `permissions` VALUES (76, '权限编辑', 'permission_edit', '编辑权限信息', 'users', 1, '2025-10-22 00:46:00.784212');
INSERT INTO `permissions` VALUES (77, '权限删除', 'permission_delete', '删除权限', 'users', 1, '2025-10-22 00:46:00.789198');
INSERT INTO `permissions` VALUES (78, '权限管理', 'permission_manage', '管理权限', 'users', 1, '2025-10-22 00:46:00.794194');
INSERT INTO `permissions` VALUES (79, '企业删除', 'enterprise_delete', '删除企业', 'enterprises', 1, '2025-10-22 00:46:00.803207');
INSERT INTO `permissions` VALUES (80, '员工查看', 'employee_view', '查看员工信息', 'enterprises', 1, '2025-10-22 00:46:00.809208');
INSERT INTO `permissions` VALUES (81, '员工创建', 'employee_create', '创建员工', 'enterprises', 1, '2025-10-22 00:46:00.815207');
INSERT INTO `permissions` VALUES (82, '员工编辑', 'employee_edit', '编辑员工信息', 'enterprises', 1, '2025-10-22 00:46:00.819214');
INSERT INTO `permissions` VALUES (83, '员工删除', 'employee_delete', '删除员工', 'enterprises', 1, '2025-10-22 00:46:00.825198');
INSERT INTO `permissions` VALUES (84, '员工管理', 'employee_manage', '管理员工', 'enterprises', 1, '2025-10-22 00:46:00.830211');
INSERT INTO `permissions` VALUES (85, '项目查看', 'project_view', '查看项目信息', 'projects', 1, '2025-10-22 00:46:00.835193');
INSERT INTO `permissions` VALUES (86, '项目创建', 'project_create', '创建项目', 'projects', 1, '2025-10-22 00:46:00.840207');
INSERT INTO `permissions` VALUES (87, '项目编辑', 'project_edit', '编辑项目信息', 'projects', 1, '2025-10-22 00:46:00.845199');
INSERT INTO `permissions` VALUES (88, '项目删除', 'project_delete', '删除项目', 'projects', 1, '2025-10-22 00:46:00.850872');
INSERT INTO `permissions` VALUES (89, '项目管理', 'project_manage', '管理项目', 'projects', 1, '2025-10-22 00:46:00.854881');
INSERT INTO `permissions` VALUES (90, '信息管理', 'info_manage', '管理信息', 'info_plaza', 1, '2025-10-22 00:46:00.864872');
INSERT INTO `permissions` VALUES (91, '资源管理', 'resource_manage', '管理资源', 'resources', 1, '2025-10-22 00:46:00.874881');
INSERT INTO `permissions` VALUES (92, '系统查看', 'system_view', '查看系统信息', 'system', 1, '2025-10-22 00:46:00.880871');
INSERT INTO `permissions` VALUES (93, '系统管理', 'system_manage', '管理系统', 'system', 1, '2025-10-22 00:46:00.888898');
INSERT INTO `permissions` VALUES (94, '仪表板查看', 'dashboard_view', '查看仪表板', 'dashboard', 1, '2025-10-22 00:46:00.894371');
INSERT INTO `permissions` VALUES (95, '仪表板管理', 'dashboard_manage', '管理仪表板', 'dashboard', 1, '2025-10-22 00:46:00.899380');
INSERT INTO `permissions` VALUES (96, '查看用户资料', 'users.view_userprofile', '查看用户详细资料', 'users', 1, '2025-10-22 12:10:56.772802');

-- ----------------------------
-- Table structure for person_documents
-- ----------------------------
DROP TABLE IF EXISTS `person_documents`;
CREATE TABLE `person_documents`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `document_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件类型',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件标题',
  `file` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '文件描述',
  `is_public` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否公开',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `person_documents_person_id`(`person_id` ASC) USING BTREE,
  INDEX `idx_document_type`(`document_type` ASC) USING BTREE,
  INDEX `idx_is_public`(`is_public` ASC) USING BTREE,
  CONSTRAINT `person_documents_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '个人资质文件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of person_documents
-- ----------------------------

-- ----------------------------
-- Table structure for person_projects
-- ----------------------------
DROP TABLE IF EXISTS `person_projects`;
CREATE TABLE `person_projects`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目名称',
  `project_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目类型',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目描述',
  `client` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户',
  `role` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '担任角色',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '结束日期',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planning' COMMENT '项目状态',
  `progress` int NOT NULL DEFAULT 0 COMMENT '进度百分比',
  `location` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '项目地点',
  `income` decimal(10, 2) NULL DEFAULT NULL COMMENT '项目收入',
  `achievements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '项目成果',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `person_projects_person_id`(`person_id` ASC) USING BTREE,
  INDEX `idx_project_type`(`project_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_start_date`(`start_date` ASC) USING BTREE,
  CONSTRAINT `person_projects_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '个人项目记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of person_projects
-- ----------------------------
INSERT INTO `person_projects` VALUES (1, 1, '个人博客系统开发', '', '使用Django和Vue.js开发个人技术博客', '', 'manager', '2025-08-22', '2025-11-20', 'in_progress', 70, '', NULL, '', '2025-10-21 01:40:04.760924', '2025-10-21 01:40:04.760924');
INSERT INTO `person_projects` VALUES (2, 1, '在线教育平台', '', '参与开发在线教育平台的前端部分', '', 'developer', '2025-06-23', '2025-09-21', 'completed', 100, '', NULL, '', '2025-10-21 01:40:04.767918', '2025-10-21 01:40:04.767918');
INSERT INTO `person_projects` VALUES (3, 1, '移动APP开发', '', '开发一款健康管理类移动应用', '', 'manager', '2025-11-05', '2026-04-19', 'pending', 0, '', NULL, '', '2025-10-21 01:40:04.774930', '2025-10-21 01:40:04.774930');

-- ----------------------------
-- Table structure for person_statistics
-- ----------------------------
DROP TABLE IF EXISTS `person_statistics`;
CREATE TABLE `person_statistics`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `total_projects` int NOT NULL DEFAULT 0 COMMENT '总项目数',
  `completed_projects` int NOT NULL DEFAULT 0 COMMENT '已完成项目数',
  `total_tasks` int NOT NULL DEFAULT 0 COMMENT '总任务数',
  `completed_tasks` int NOT NULL DEFAULT 0 COMMENT '已完成任务数',
  `total_income` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '总收入',
  `work_days` int NOT NULL DEFAULT 0 COMMENT '工作天数',
  `last_updated` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '最后更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `person_id`(`person_id` ASC) USING BTREE,
  CONSTRAINT `person_statistics_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '个人统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of person_statistics
-- ----------------------------
INSERT INTO `person_statistics` VALUES (1, 1, 3, 1, 7, 2, 0.00, 1, '2025-10-22 09:34:21.000000');

-- ----------------------------
-- Table structure for person_tasks
-- ----------------------------
DROP TABLE IF EXISTS `person_tasks`;
CREATE TABLE `person_tasks`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `person_id` bigint NOT NULL COMMENT '个人用户ID',
  `project_id` bigint NULL DEFAULT NULL COMMENT '关联项目ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务标题',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务描述',
  `priority` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium' COMMENT '优先级',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '任务状态',
  `due_date` datetime(6) NULL DEFAULT NULL COMMENT '截止时间',
  `completed_at` datetime(6) NULL DEFAULT NULL COMMENT '完成时间',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `person_tasks_person_id`(`person_id` ASC) USING BTREE,
  INDEX `person_tasks_project_id`(`project_id` ASC) USING BTREE,
  INDEX `idx_priority`(`priority` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_due_date`(`due_date` ASC) USING BTREE,
  CONSTRAINT `person_tasks_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `person_tasks_project_id` FOREIGN KEY (`project_id`) REFERENCES `person_projects` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '个人任务记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of person_tasks
-- ----------------------------
INSERT INTO `person_tasks` VALUES (1, 1, 1, '完成用户登录功能', '实现用户登录、注册、找回密码等功能', 'high', 'completed', '2025-10-10 16:00:00.000000', NULL, '2025-10-21 01:40:04.795284', '2025-10-21 01:40:04.795284');
INSERT INTO `person_tasks` VALUES (2, 1, 1, '设计数据库表结构', '设计博客系统的数据库表结构', 'high', 'completed', '2025-08-31 16:00:00.000000', NULL, '2025-10-21 01:40:04.804287', '2025-10-21 01:40:04.804287');
INSERT INTO `person_tasks` VALUES (3, 1, 1, '开发文章管理模块', '实现文章的增删改查功能', 'high', 'in_progress', '2025-10-27 16:00:00.000000', NULL, '2025-10-21 01:40:04.811449', '2025-10-21 01:40:04.811449');
INSERT INTO `person_tasks` VALUES (4, 1, NULL, '实现评论功能', '为博客文章添加评论功能', 'medium', 'pending', '2025-11-09 16:00:00.000000', NULL, '2025-10-21 01:40:04.817449', '2025-10-21 01:40:04.817449');
INSERT INTO `person_tasks` VALUES (5, 1, NULL, '优化页面加载速度', '通过代码优化和缓存提升页面加载速度', 'medium', 'pending', '2025-11-19 16:00:00.000000', NULL, '2025-10-21 01:40:04.823451', '2025-10-21 01:40:04.823451');
INSERT INTO `person_tasks` VALUES (6, 1, NULL, '编写API文档', '使用Swagger编写完整的API文档', 'low', 'in_progress', '2025-11-14 16:00:00.000000', NULL, '2025-10-21 01:40:04.829450', '2025-10-22 01:34:21.880960');
INSERT INTO `person_tasks` VALUES (7, 1, NULL, '进行单元测试', '为核心功能编写单元测试', 'medium', 'pending', '2025-11-24 16:00:00.000000', NULL, '2025-10-21 01:40:04.835449', '2025-10-21 01:40:04.835449');

-- ----------------------------
-- Table structure for persons
-- ----------------------------
DROP TABLE IF EXISTS `persons`;
CREATE TABLE `persons`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '关联用户ID',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '真实姓名',
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '性别',
  `birth_date` date NULL DEFAULT NULL COMMENT '出生日期',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '身份证号',
  `education` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学历',
  `profession` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '职业',
  `work_experience` int NOT NULL DEFAULT 0 COMMENT '工作经验(年)',
  `skills` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '技能专长',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '居住地址',
  `emergency_contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '紧急联系人',
  `emergency_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '紧急联系电话',
  `bio` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '个人简介',
  `is_verified` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否认证',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  UNIQUE INDEX `id_card`(`id_card` ASC) USING BTREE,
  INDEX `idx_gender`(`gender` ASC) USING BTREE,
  INDEX `idx_education`(`education` ASC) USING BTREE,
  INDEX `idx_profession`(`profession` ASC) USING BTREE,
  INDEX `idx_is_verified`(`is_verified` ASC) USING BTREE,
  CONSTRAINT `persons_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '个人用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of persons
-- ----------------------------
INSERT INTO `persons` VALUES (1, 13, '张伟', 'male', '1990-05-15', '110101199005151234', 'bachelor', '软件工程师', 5, 'Python, Django, Vue.js', '北京市朝阳区', '张伟父亲', '13800138888', '5年软件开发经验，擅长Python后端开发和Vue.js前端开发', 0, '2025-10-21 01:40:04.720716', '2025-10-21 01:40:04.720716');

-- ----------------------------
-- Table structure for resource_images
-- ----------------------------
DROP TABLE IF EXISTS `resource_images`;
CREATE TABLE `resource_images`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片路径',
  `caption` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片说明',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `resource_images_resource_id`(`resource_id` ASC) USING BTREE,
  INDEX `idx_sort_order`(`sort_order` ASC) USING BTREE,
  CONSTRAINT `resource_images_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资源图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of resource_images
-- ----------------------------

-- ----------------------------
-- Table structure for resource_maintenances
-- ----------------------------
DROP TABLE IF EXISTS `resource_maintenances`;
CREATE TABLE `resource_maintenances`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `maintenance_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '维护类型',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '维护标题',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '维护描述',
  `start_date` datetime(6) NOT NULL COMMENT '开始时间',
  `end_date` datetime(6) NULL DEFAULT NULL COMMENT '结束时间',
  `cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '维护费用',
  `technician` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '维护人员',
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '维护备注',
  `created_by_id` bigint NOT NULL COMMENT '创建人ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `resource_maintenances_resource_id`(`resource_id` ASC) USING BTREE,
  INDEX `resource_maintenances_created_by_id`(`created_by_id` ASC) USING BTREE,
  INDEX `idx_maintenance_type`(`maintenance_type` ASC) USING BTREE,
  INDEX `idx_start_date`(`start_date` ASC) USING BTREE,
  CONSTRAINT `resource_maintenances_created_by_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `resource_maintenances_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资源维护记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of resource_maintenances
-- ----------------------------

-- ----------------------------
-- Table structure for resource_requests
-- ----------------------------
DROP TABLE IF EXISTS `resource_requests`;
CREATE TABLE `resource_requests`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `requester_id` bigint NOT NULL COMMENT '申请人ID',
  `request_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申请类型',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申请标题',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申请描述',
  `start_date` datetime(6) NOT NULL COMMENT '开始时间',
  `end_date` datetime(6) NOT NULL COMMENT '结束时间',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '申请数量',
  `purpose` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用目的',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '申请状态',
  `approved_by_id` bigint NULL DEFAULT NULL COMMENT '审批人ID',
  `approved_at` datetime(6) NULL DEFAULT NULL COMMENT '审批时间',
  `approval_notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '审批备注',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `resource_requests_resource_id`(`resource_id` ASC) USING BTREE,
  INDEX `resource_requests_requester_id`(`requester_id` ASC) USING BTREE,
  INDEX `resource_requests_approved_by_id`(`approved_by_id` ASC) USING BTREE,
  INDEX `idx_request_type`(`request_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_start_date`(`start_date` ASC) USING BTREE,
  CONSTRAINT `resource_requests_approved_by_id` FOREIGN KEY (`approved_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `resource_requests_requester_id` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `resource_requests_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资源申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of resource_requests
-- ----------------------------

-- ----------------------------
-- Table structure for resource_statistics
-- ----------------------------
DROP TABLE IF EXISTS `resource_statistics`;
CREATE TABLE `resource_statistics`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_type_id` bigint NOT NULL COMMENT '资源类型ID',
  `total_count` int NOT NULL DEFAULT 0 COMMENT '总数量',
  `available_count` int NOT NULL DEFAULT 0 COMMENT '可用数量',
  `in_use_count` int NOT NULL DEFAULT 0 COMMENT '使用中数量',
  `maintenance_count` int NOT NULL DEFAULT 0 COMMENT '维护中数量',
  `total_value` decimal(15, 2) NOT NULL DEFAULT 0.00 COMMENT '总价值',
  `utilization_rate` decimal(5, 2) NOT NULL DEFAULT 0.00 COMMENT '利用率',
  `last_updated` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '最后更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `resource_type_id`(`resource_type_id` ASC) USING BTREE,
  CONSTRAINT `resource_statistics_resource_type_id` FOREIGN KEY (`resource_type_id`) REFERENCES `resource_types` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资源统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of resource_statistics
-- ----------------------------

-- ----------------------------
-- Table structure for resource_types
-- ----------------------------
DROP TABLE IF EXISTS `resource_types`;
CREATE TABLE `resource_types`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型代码',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '类型描述',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '类型图标',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE,
  INDEX `idx_sort_order`(`sort_order` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资源类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of resource_types
-- ----------------------------
INSERT INTO `resource_types` VALUES (1, '设备', 'equipment', '各种防腐保温设备', 'Tools', 1, 1, '2025-10-14 09:44:09.000000');
INSERT INTO `resource_types` VALUES (2, '材料', 'material', '防腐保温材料', 'Box', 2, 1, '2025-10-14 09:44:09.000000');
INSERT INTO `resource_types` VALUES (3, '人才', 'talent', '专业技术人才', 'User', 3, 1, '2025-10-14 09:44:09.000000');
INSERT INTO `resource_types` VALUES (4, '技术', 'technology', '技术服务和解决方案', 'Setting', 4, 1, '2025-10-14 09:44:09.000000');
INSERT INTO `resource_types` VALUES (15, '技术文档', 'doc', '各类技术文档资料', '', 0, 1, '2025-10-21 01:40:34.972403');
INSERT INTO `resource_types` VALUES (16, '设计图纸', 'design', '工程设计图纸', '', 0, 1, '2025-10-21 01:40:34.979384');
INSERT INTO `resource_types` VALUES (17, '施工方案', 'plan', '施工方案和计划', '', 0, 1, '2025-10-21 01:40:34.984387');
INSERT INTO `resource_types` VALUES (18, '规范标准', 'standard', '行业规范和标准', '', 0, 1, '2025-10-21 01:40:34.990392');
INSERT INTO `resource_types` VALUES (19, '培训资料', 'training', '培训课件和资料', '', 0, 1, '2025-10-21 01:40:34.995392');

-- ----------------------------
-- Table structure for resource_usage_logs
-- ----------------------------
DROP TABLE IF EXISTS `resource_usage_logs`;
CREATE TABLE `resource_usage_logs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resource_id` bigint NOT NULL COMMENT '资源ID',
  `user_id` bigint NOT NULL COMMENT '使用者ID',
  `usage_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用类型',
  `start_date` datetime(6) NOT NULL COMMENT '开始时间',
  `end_date` datetime(6) NULL DEFAULT NULL COMMENT '结束时间',
  `purpose` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用目的',
  `location` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '使用地点',
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `resource_usage_logs_resource_id`(`resource_id` ASC) USING BTREE,
  INDEX `resource_usage_logs_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_usage_type`(`usage_type` ASC) USING BTREE,
  INDEX `idx_start_date`(`start_date` ASC) USING BTREE,
  CONSTRAINT `resource_usage_logs_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `resource_usage_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资源使用日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of resource_usage_logs
-- ----------------------------

-- ----------------------------
-- Table structure for resources
-- ----------------------------
DROP TABLE IF EXISTS `resources`;
CREATE TABLE `resources`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源名称',
  `resource_type_id` bigint NOT NULL COMMENT '资源类型ID',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源描述',
  `specifications` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '技术规格',
  `manufacturer` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '制造商',
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '型号',
  `serial_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '序列号',
  `purchase_date` date NULL DEFAULT NULL COMMENT '采购日期',
  `warranty_expiry` date NULL DEFAULT NULL COMMENT '保修到期',
  `location` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '存放位置',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'available' COMMENT '状态',
  `quality` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'good' COMMENT '质量等级',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '数量',
  `unit_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '单价',
  `total_value` decimal(15, 2) NULL DEFAULT NULL COMMENT '总价值',
  `owner_id` bigint NOT NULL COMMENT '所有者ID',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系电话',
  `contact_email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '联系邮箱',
  `is_public` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否公开',
  `is_available_for_rent` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否可租赁',
  `rental_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '租赁价格',
  `rental_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '租赁单位',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `resources_resource_type_id`(`resource_type_id` ASC) USING BTREE,
  INDEX `resources_owner_id`(`owner_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_quality`(`quality` ASC) USING BTREE,
  INDEX `idx_is_public`(`is_public` ASC) USING BTREE,
  INDEX `idx_is_available_for_rent`(`is_available_for_rent` ASC) USING BTREE,
  INDEX `idx_resources_name`(`name` ASC) USING BTREE,
  INDEX `idx_resources_manufacturer`(`manufacturer` ASC) USING BTREE,
  INDEX `idx_resources_location`(`location` ASC) USING BTREE,
  CONSTRAINT `resources_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `resources_resource_type_id` FOREIGN KEY (`resource_type_id`) REFERENCES `resource_types` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资源信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of resources
-- ----------------------------
INSERT INTO `resources` VALUES (1, '挖掘机CAT320D', 15, '卡特彼勒320D型挖掘机，状态良好，可用于各类工程', '', '卡特彼勒', 'CAT320D', '', NULL, NULL, '北京市朝阳区设备仓库', 'available', 'good', 2, 1500000.00, NULL, 1, '张三', '13800138001', 'zhangsan@example.com', 1, 1, 5000.00, '天', '2025-10-21 01:41:23.797422', '2025-10-21 01:41:23.797422');
INSERT INTO `resources` VALUES (2, '塔吊QTZ80', 16, 'QTZ80型塔式起重机，最大起重量8吨', '', '中联重科', 'QTZ80', '', NULL, NULL, '上海市浦东新区工地', 'available', 'good', 1, 800000.00, NULL, 1, '李四', '13800138002', 'lisi@example.com', 1, 1, 3000.00, '天', '2025-10-21 01:41:23.806423', '2025-10-21 01:41:23.806423');
INSERT INTO `resources` VALUES (3, '混凝土搅拌站HZS120', 17, 'HZS120型混凝土搅拌站，每小时产量120立方米', '', '三一重工', 'HZS120', '', NULL, NULL, '广州市番禺区工业园', 'available', 'good', 1, 2000000.00, NULL, 1, '王五', '13800138003', 'wangwu@example.com', 1, 0, NULL, '', '2025-10-21 01:41:23.811590', '2025-10-21 01:41:23.811590');

-- ----------------------------
-- Table structure for role_menus
-- ----------------------------
DROP TABLE IF EXISTS `role_menus`;
CREATE TABLE `role_menus`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `can_view` tinyint(1) NOT NULL DEFAULT 1,
  `can_create` tinyint(1) NOT NULL DEFAULT 0,
  `can_update` tinyint(1) NOT NULL DEFAULT 0,
  `can_delete` tinyint(1) NOT NULL DEFAULT 0,
  `can_export` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_menus_role_id_menu_id`(`role_id` ASC, `menu_id` ASC) USING BTREE,
  INDEX `role_menus_menu_id`(`menu_id` ASC) USING BTREE,
  CONSTRAINT `role_menus_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `role_menus_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 239 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_menus
-- ----------------------------
INSERT INTO `role_menus` VALUES (95, 1, 1, '2025-10-21 00:53:13.693645', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (96, 1, 2, '2025-10-21 00:53:13.698650', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (97, 1, 7, '2025-10-21 00:53:13.702661', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (98, 1, 8, '2025-10-21 00:53:13.706466', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (99, 1, 9, '2025-10-21 00:53:13.711466', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (100, 1, 3, '2025-10-21 00:53:13.715470', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (101, 1, 10, '2025-10-21 00:53:13.719678', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (102, 1, 11, '2025-10-21 00:53:13.722692', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (103, 1, 12, '2025-10-21 00:53:13.726693', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (104, 1, 4, '2025-10-21 00:53:13.731692', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (105, 1, 13, '2025-10-21 00:53:13.735692', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (106, 1, 14, '2025-10-21 00:53:13.738692', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (107, 1, 5, '2025-10-21 00:53:13.742677', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (108, 1, 15, '2025-10-21 00:53:13.746692', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (109, 1, 16, '2025-10-21 00:53:13.750701', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (110, 1, 6, '2025-10-21 00:53:13.754513', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (111, 1, 17, '2025-10-21 00:53:13.758498', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (112, 1, 18, '2025-10-21 00:53:13.762502', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (113, 1, 19, '2025-10-21 00:53:13.766254', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (114, 2, 1, '2025-10-21 00:53:13.777264', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (115, 2, 2, '2025-10-21 00:53:13.781265', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (116, 2, 7, '2025-10-21 00:53:13.786292', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (117, 2, 8, '2025-10-21 00:53:13.790799', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (118, 2, 9, '2025-10-21 00:53:13.795813', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (119, 2, 4, '2025-10-21 00:53:13.798809', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (120, 2, 13, '2025-10-21 00:53:13.803810', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (121, 2, 14, '2025-10-21 00:53:13.808326', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (122, 2, 5, '2025-10-21 00:53:13.812324', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (123, 2, 15, '2025-10-21 00:53:13.816326', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (124, 2, 16, '2025-10-21 00:53:13.820937', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (125, 3, 1, '2025-10-21 00:53:13.830938', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (126, 3, 2, '2025-10-21 00:53:13.834937', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (127, 3, 7, '2025-10-21 00:53:13.838937', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (128, 3, 8, '2025-10-21 00:53:13.842948', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (129, 3, 4, '2025-10-21 00:53:13.858939', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (130, 3, 13, '2025-10-21 00:53:13.862910', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (131, 3, 5, '2025-10-21 00:53:13.866913', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (132, 3, 15, '2025-10-21 00:53:13.871910', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (133, 4, 1, '2025-10-21 00:53:13.882613', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (134, 4, 3, '2025-10-21 00:53:13.886147', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (135, 4, 10, '2025-10-21 00:53:13.890669', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (136, 4, 11, '2025-10-21 00:53:13.894881', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (137, 4, 12, '2025-10-21 00:53:13.898904', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (138, 4, 4, '2025-10-21 00:53:13.902159', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (139, 4, 13, '2025-10-21 00:53:13.906159', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (140, 4, 5, '2025-10-21 00:53:13.910157', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (141, 4, 15, '2025-10-21 00:53:13.913866', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (142, 16, 1, '2025-10-22 00:38:52.016224', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (143, 16, 3, '2025-10-22 00:38:52.020221', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (144, 16, 10, '2025-10-22 00:38:52.025221', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (145, 16, 11, '2025-10-22 00:38:52.030290', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (146, 16, 12, '2025-10-22 00:38:52.034142', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (147, 16, 4, '2025-10-22 00:38:52.038598', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (148, 16, 13, '2025-10-22 00:38:52.043245', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (149, 16, 5, '2025-10-22 00:38:52.047245', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (150, 16, 15, '2025-10-22 00:38:52.051244', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (151, 17, 1, '2025-10-22 00:38:52.060243', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (152, 17, 3, '2025-10-22 00:38:52.064247', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (153, 17, 10, '2025-10-22 00:38:52.069260', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (154, 17, 11, '2025-10-22 00:38:52.073247', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (155, 17, 12, '2025-10-22 00:38:52.077858', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (156, 17, 4, '2025-10-22 00:38:52.082855', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (157, 17, 13, '2025-10-22 00:38:52.086855', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (158, 17, 14, '2025-10-22 00:38:52.091858', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (159, 17, 5, '2025-10-22 00:38:52.096856', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (160, 17, 15, '2025-10-22 00:38:52.101855', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (161, 17, 16, '2025-10-22 00:38:52.105867', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (162, 18, 1, '2025-10-22 00:38:52.113856', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (163, 18, 3, '2025-10-22 00:38:52.117856', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (164, 18, 10, '2025-10-22 00:38:52.121856', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (165, 18, 11, '2025-10-22 00:38:52.125857', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (166, 18, 12, '2025-10-22 00:38:52.130852', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (167, 18, 4, '2025-10-22 00:38:52.134858', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (168, 18, 13, '2025-10-22 00:38:52.138861', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (169, 18, 5, '2025-10-22 00:38:52.143853', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (170, 18, 15, '2025-10-22 00:38:52.147856', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (171, 19, 1, '2025-10-22 00:38:52.156859', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (172, 19, 3, '2025-10-22 00:38:52.160854', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (173, 19, 10, '2025-10-22 00:38:52.165859', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (174, 19, 12, '2025-10-22 00:38:52.169856', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (175, 19, 4, '2025-10-22 00:38:52.173875', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (176, 19, 13, '2025-10-22 00:38:52.177855', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (177, 19, 5, '2025-10-22 00:38:52.181854', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (178, 19, 15, '2025-10-22 00:38:52.186869', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (179, 20, 1, '2025-10-22 00:38:52.194873', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (180, 20, 3, '2025-10-22 00:38:52.199869', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (181, 20, 10, '2025-10-22 00:38:52.203886', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (182, 20, 11, '2025-10-22 00:38:52.207870', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (183, 20, 12, '2025-10-22 00:38:52.212010', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (184, 20, 4, '2025-10-22 00:38:52.216666', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (185, 20, 13, '2025-10-22 00:38:52.220666', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (186, 20, 14, '2025-10-22 00:38:52.225683', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (187, 20, 5, '2025-10-22 00:38:52.229662', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (188, 20, 15, '2025-10-22 00:38:52.234665', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (189, 20, 16, '2025-10-22 00:38:52.238661', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (190, 21, 1, '2025-10-22 00:38:52.248684', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (191, 21, 3, '2025-10-22 00:38:52.252662', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (192, 21, 10, '2025-10-22 00:38:52.256661', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (193, 21, 11, '2025-10-22 00:38:52.261667', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (194, 21, 12, '2025-10-22 00:38:52.265666', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (195, 21, 4, '2025-10-22 00:38:52.269667', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (196, 21, 13, '2025-10-22 00:38:52.273664', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (197, 21, 14, '2025-10-22 00:38:52.277678', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (198, 21, 5, '2025-10-22 00:38:52.282677', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (199, 21, 15, '2025-10-22 00:38:52.286668', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (200, 21, 16, '2025-10-22 00:38:52.291664', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (201, 22, 1, '2025-10-22 00:38:52.299671', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (202, 22, 3, '2025-10-22 00:38:52.303671', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (203, 22, 10, '2025-10-22 00:38:52.307684', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (204, 22, 11, '2025-10-22 00:38:52.311884', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (205, 22, 12, '2025-10-22 00:38:52.316889', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (206, 22, 4, '2025-10-22 00:38:52.321884', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (207, 22, 13, '2025-10-22 00:38:52.325884', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (208, 22, 14, '2025-10-22 00:38:52.330885', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (209, 22, 5, '2025-10-22 00:38:52.335885', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (210, 22, 15, '2025-10-22 00:38:52.339884', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (211, 22, 16, '2025-10-22 00:38:52.343882', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (212, 23, 1, '2025-10-22 00:38:52.352887', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (213, 23, 3, '2025-10-22 00:38:52.356880', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (214, 23, 10, '2025-10-22 00:38:52.360882', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (215, 23, 11, '2025-10-22 00:38:52.365884', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (216, 23, 12, '2025-10-22 00:38:52.369891', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (217, 23, 4, '2025-10-22 00:38:52.374883', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (218, 23, 13, '2025-10-22 00:38:52.378894', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (219, 23, 5, '2025-10-22 00:38:52.382894', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (220, 23, 15, '2025-10-22 00:38:52.387891', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (221, 24, 1, '2025-10-22 00:38:52.396064', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (222, 24, 3, '2025-10-22 00:38:52.400049', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (223, 24, 10, '2025-10-22 00:38:52.404052', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (224, 24, 11, '2025-10-22 00:38:52.409055', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (225, 24, 12, '2025-10-22 00:38:52.417052', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (226, 24, 4, '2025-10-22 00:38:52.425052', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (227, 24, 13, '2025-10-22 00:38:52.431050', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (228, 24, 5, '2025-10-22 00:38:52.437052', 1, 0, 0, 0, 0);
INSERT INTO `role_menus` VALUES (229, 24, 15, '2025-10-22 00:38:52.443049', 1, 0, 0, 0, 0);

-- ----------------------------
-- Table structure for role_permission_audits
-- ----------------------------
DROP TABLE IF EXISTS `role_permission_audits`;
CREATE TABLE `role_permission_audits`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `action` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ip_address` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_agent` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `extra_data` json NULL,
  `created_at` datetime(6) NOT NULL,
  `permission_id` bigint NULL DEFAULT NULL,
  `role_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `role_permission_audits_role_created_at`(`role_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `role_permission_audits_user_created_at`(`user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `role_permission_audits_action_created_at`(`action` ASC, `created_at` ASC) USING BTREE,
  INDEX `role_permission_audits_permission_id_fk`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `role_permission_audits_permission_id_fk` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `role_permission_audits_role_id_fk` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `role_permission_audits_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_permission_audits
-- ----------------------------
INSERT INTO `role_permission_audits` VALUES (1, 'grant', '授予权限', '127.0.0.1', 'Test Browser', NULL, '2025-10-22 12:10:56.784957', 96, 26, 1);
INSERT INTO `role_permission_audits` VALUES (2, 'grant', '授予权限', '127.0.0.1', 'Test Browser', NULL, '2025-10-22 12:11:33.759780', 96, 26, 1);
INSERT INTO `role_permission_audits` VALUES (3, 'grant', '授予权限', '127.0.0.1', 'Test Browser', NULL, '2025-10-22 12:26:58.750414', 96, 26, 1);

-- ----------------------------
-- Table structure for role_permissions
-- ----------------------------
DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE `role_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_permissions_role_id_permission_id`(`role_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `role_permissions_permission_id`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `role_permissions_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `role_permissions_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 214 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色权限关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_permissions
-- ----------------------------
INSERT INTO `role_permissions` VALUES (24, 1, 1, '2025-10-22 00:46:00.913357');
INSERT INTO `role_permissions` VALUES (25, 1, 2, '2025-10-22 00:46:00.917356');
INSERT INTO `role_permissions` VALUES (26, 1, 3, '2025-10-22 00:46:00.921357');
INSERT INTO `role_permissions` VALUES (27, 1, 4, '2025-10-22 00:46:00.925373');
INSERT INTO `role_permissions` VALUES (28, 1, 72, '2025-10-22 00:46:00.929358');
INSERT INTO `role_permissions` VALUES (29, 1, 5, '2025-10-22 00:46:00.934360');
INSERT INTO `role_permissions` VALUES (30, 1, 6, '2025-10-22 00:46:00.944360');
INSERT INTO `role_permissions` VALUES (31, 1, 7, '2025-10-22 00:46:00.949358');
INSERT INTO `role_permissions` VALUES (32, 1, 8, '2025-10-22 00:46:00.954357');
INSERT INTO `role_permissions` VALUES (33, 1, 73, '2025-10-22 00:46:00.959359');
INSERT INTO `role_permissions` VALUES (34, 1, 74, '2025-10-22 00:46:00.965358');
INSERT INTO `role_permissions` VALUES (35, 1, 75, '2025-10-22 00:46:00.971357');
INSERT INTO `role_permissions` VALUES (36, 1, 76, '2025-10-22 00:46:00.975368');
INSERT INTO `role_permissions` VALUES (37, 1, 77, '2025-10-22 00:46:00.980370');
INSERT INTO `role_permissions` VALUES (38, 1, 78, '2025-10-22 00:46:00.985368');
INSERT INTO `role_permissions` VALUES (39, 1, 9, '2025-10-22 00:46:00.995889');
INSERT INTO `role_permissions` VALUES (40, 1, 10, '2025-10-22 00:46:01.005899');
INSERT INTO `role_permissions` VALUES (41, 1, 11, '2025-10-22 00:46:01.011896');
INSERT INTO `role_permissions` VALUES (42, 1, 79, '2025-10-22 00:46:01.018896');
INSERT INTO `role_permissions` VALUES (43, 1, 12, '2025-10-22 00:46:01.024899');
INSERT INTO `role_permissions` VALUES (44, 1, 80, '2025-10-22 00:46:01.029898');
INSERT INTO `role_permissions` VALUES (45, 1, 81, '2025-10-22 00:46:01.034898');
INSERT INTO `role_permissions` VALUES (46, 1, 82, '2025-10-22 00:46:01.040896');
INSERT INTO `role_permissions` VALUES (47, 1, 83, '2025-10-22 00:46:01.047896');
INSERT INTO `role_permissions` VALUES (48, 1, 84, '2025-10-22 00:46:01.060898');
INSERT INTO `role_permissions` VALUES (49, 1, 85, '2025-10-22 00:46:01.069898');
INSERT INTO `role_permissions` VALUES (50, 1, 86, '2025-10-22 00:46:01.073897');
INSERT INTO `role_permissions` VALUES (51, 1, 87, '2025-10-22 00:46:01.078907');
INSERT INTO `role_permissions` VALUES (52, 1, 88, '2025-10-22 00:46:01.083907');
INSERT INTO `role_permissions` VALUES (53, 1, 89, '2025-10-22 00:46:01.088906');
INSERT INTO `role_permissions` VALUES (54, 1, 13, '2025-10-22 00:46:01.093991');
INSERT INTO `role_permissions` VALUES (55, 1, 14, '2025-10-22 00:46:01.098993');
INSERT INTO `role_permissions` VALUES (56, 1, 15, '2025-10-22 00:46:01.103994');
INSERT INTO `role_permissions` VALUES (57, 1, 16, '2025-10-22 00:46:01.107992');
INSERT INTO `role_permissions` VALUES (58, 1, 90, '2025-10-22 00:46:01.111992');
INSERT INTO `role_permissions` VALUES (59, 1, 17, '2025-10-22 00:46:01.116992');
INSERT INTO `role_permissions` VALUES (60, 1, 18, '2025-10-22 00:46:01.120996');
INSERT INTO `role_permissions` VALUES (61, 1, 19, '2025-10-22 00:46:01.125994');
INSERT INTO `role_permissions` VALUES (62, 1, 20, '2025-10-22 00:46:01.129993');
INSERT INTO `role_permissions` VALUES (63, 1, 91, '2025-10-22 00:46:01.134993');
INSERT INTO `role_permissions` VALUES (64, 1, 92, '2025-10-22 00:46:01.139990');
INSERT INTO `role_permissions` VALUES (65, 1, 21, '2025-10-22 00:46:01.144992');
INSERT INTO `role_permissions` VALUES (66, 1, 22, '2025-10-22 00:46:01.149993');
INSERT INTO `role_permissions` VALUES (67, 1, 93, '2025-10-22 00:46:01.153992');
INSERT INTO `role_permissions` VALUES (68, 1, 94, '2025-10-22 00:46:01.158993');
INSERT INTO `role_permissions` VALUES (69, 1, 95, '2025-10-22 00:46:01.162997');
INSERT INTO `role_permissions` VALUES (70, 2, 1, '2025-10-22 00:46:01.171992');
INSERT INTO `role_permissions` VALUES (71, 2, 2, '2025-10-22 00:46:01.175995');
INSERT INTO `role_permissions` VALUES (72, 2, 3, '2025-10-22 00:46:01.179993');
INSERT INTO `role_permissions` VALUES (73, 2, 9, '2025-10-22 00:46:01.184996');
INSERT INTO `role_permissions` VALUES (74, 2, 11, '2025-10-22 00:46:01.187992');
INSERT INTO `role_permissions` VALUES (75, 2, 12, '2025-10-22 00:46:01.192993');
INSERT INTO `role_permissions` VALUES (76, 2, 80, '2025-10-22 00:46:01.197993');
INSERT INTO `role_permissions` VALUES (77, 2, 81, '2025-10-22 00:46:01.202992');
INSERT INTO `role_permissions` VALUES (78, 2, 82, '2025-10-22 00:46:01.206994');
INSERT INTO `role_permissions` VALUES (79, 2, 83, '2025-10-22 00:46:01.211998');
INSERT INTO `role_permissions` VALUES (80, 2, 84, '2025-10-22 00:46:01.216994');
INSERT INTO `role_permissions` VALUES (81, 2, 85, '2025-10-22 00:46:01.220995');
INSERT INTO `role_permissions` VALUES (82, 2, 86, '2025-10-22 00:46:01.225993');
INSERT INTO `role_permissions` VALUES (83, 2, 87, '2025-10-22 00:46:01.229998');
INSERT INTO `role_permissions` VALUES (84, 2, 88, '2025-10-22 00:46:01.233991');
INSERT INTO `role_permissions` VALUES (85, 2, 89, '2025-10-22 00:46:01.239992');
INSERT INTO `role_permissions` VALUES (86, 2, 13, '2025-10-22 00:46:01.243991');
INSERT INTO `role_permissions` VALUES (87, 2, 14, '2025-10-22 00:46:01.248992');
INSERT INTO `role_permissions` VALUES (88, 2, 15, '2025-10-22 00:46:01.253994');
INSERT INTO `role_permissions` VALUES (89, 2, 16, '2025-10-22 00:46:01.257991');
INSERT INTO `role_permissions` VALUES (90, 2, 90, '2025-10-22 00:46:01.261994');
INSERT INTO `role_permissions` VALUES (91, 2, 17, '2025-10-22 00:46:01.266990');
INSERT INTO `role_permissions` VALUES (92, 2, 18, '2025-10-22 00:46:01.270993');
INSERT INTO `role_permissions` VALUES (93, 2, 19, '2025-10-22 00:46:01.276001');
INSERT INTO `role_permissions` VALUES (94, 2, 20, '2025-10-22 00:46:01.280004');
INSERT INTO `role_permissions` VALUES (95, 2, 91, '2025-10-22 00:46:01.284001');
INSERT INTO `role_permissions` VALUES (96, 2, 94, '2025-10-22 00:46:01.288003');
INSERT INTO `role_permissions` VALUES (97, 3, 1, '2025-10-22 00:46:01.295540');
INSERT INTO `role_permissions` VALUES (98, 3, 9, '2025-10-22 00:46:01.301523');
INSERT INTO `role_permissions` VALUES (99, 3, 80, '2025-10-22 00:46:01.307524');
INSERT INTO `role_permissions` VALUES (100, 3, 85, '2025-10-22 00:46:01.316768');
INSERT INTO `role_permissions` VALUES (101, 3, 13, '2025-10-22 00:46:01.329853');
INSERT INTO `role_permissions` VALUES (102, 3, 14, '2025-10-22 00:46:01.334981');
INSERT INTO `role_permissions` VALUES (103, 3, 17, '2025-10-22 00:46:01.339542');
INSERT INTO `role_permissions` VALUES (104, 3, 94, '2025-10-22 00:46:01.345543');
INSERT INTO `role_permissions` VALUES (105, 4, 1, '2025-10-22 00:46:01.354540');
INSERT INTO `role_permissions` VALUES (106, 4, 85, '2025-10-22 00:46:01.360539');
INSERT INTO `role_permissions` VALUES (107, 4, 13, '2025-10-22 00:46:01.364541');
INSERT INTO `role_permissions` VALUES (108, 4, 17, '2025-10-22 00:46:01.368540');
INSERT INTO `role_permissions` VALUES (109, 4, 94, '2025-10-22 00:46:01.372537');
INSERT INTO `role_permissions` VALUES (110, 16, 1, '2025-10-22 00:46:01.380542');
INSERT INTO `role_permissions` VALUES (111, 16, 85, '2025-10-22 00:46:01.384549');
INSERT INTO `role_permissions` VALUES (112, 16, 13, '2025-10-22 00:46:01.388541');
INSERT INTO `role_permissions` VALUES (113, 16, 14, '2025-10-22 00:46:01.393542');
INSERT INTO `role_permissions` VALUES (114, 16, 17, '2025-10-22 00:46:01.397545');
INSERT INTO `role_permissions` VALUES (115, 16, 94, '2025-10-22 00:46:01.401547');
INSERT INTO `role_permissions` VALUES (116, 17, 1, '2025-10-22 00:46:01.409538');
INSERT INTO `role_permissions` VALUES (117, 17, 85, '2025-10-22 00:46:01.413543');
INSERT INTO `role_permissions` VALUES (118, 17, 86, '2025-10-22 00:46:01.418541');
INSERT INTO `role_permissions` VALUES (119, 17, 87, '2025-10-22 00:46:01.422542');
INSERT INTO `role_permissions` VALUES (120, 17, 13, '2025-10-22 00:46:01.426539');
INSERT INTO `role_permissions` VALUES (121, 17, 14, '2025-10-22 00:46:01.431541');
INSERT INTO `role_permissions` VALUES (122, 17, 15, '2025-10-22 00:46:01.435542');
INSERT INTO `role_permissions` VALUES (123, 17, 17, '2025-10-22 00:46:01.439545');
INSERT INTO `role_permissions` VALUES (124, 17, 18, '2025-10-22 00:46:01.444542');
INSERT INTO `role_permissions` VALUES (125, 17, 19, '2025-10-22 00:46:01.449542');
INSERT INTO `role_permissions` VALUES (126, 17, 94, '2025-10-22 00:46:01.453543');
INSERT INTO `role_permissions` VALUES (127, 18, 1, '2025-10-22 00:46:01.464084');
INSERT INTO `role_permissions` VALUES (128, 18, 85, '2025-10-22 00:46:01.469086');
INSERT INTO `role_permissions` VALUES (129, 18, 13, '2025-10-22 00:46:01.473082');
INSERT INTO `role_permissions` VALUES (130, 18, 17, '2025-10-22 00:46:01.478086');
INSERT INTO `role_permissions` VALUES (131, 18, 94, '2025-10-22 00:46:01.482081');
INSERT INTO `role_permissions` VALUES (132, 19, 1, '2025-10-22 00:46:01.491082');
INSERT INTO `role_permissions` VALUES (133, 19, 13, '2025-10-22 00:46:01.496081');
INSERT INTO `role_permissions` VALUES (134, 19, 17, '2025-10-22 00:46:01.500082');
INSERT INTO `role_permissions` VALUES (135, 19, 94, '2025-10-22 00:46:01.506080');
INSERT INTO `role_permissions` VALUES (136, 20, 1, '2025-10-22 00:46:01.515082');
INSERT INTO `role_permissions` VALUES (137, 20, 85, '2025-10-22 00:46:01.520084');
INSERT INTO `role_permissions` VALUES (138, 20, 86, '2025-10-22 00:46:01.524082');
INSERT INTO `role_permissions` VALUES (139, 20, 87, '2025-10-22 00:46:01.529081');
INSERT INTO `role_permissions` VALUES (140, 20, 13, '2025-10-22 00:46:01.534083');
INSERT INTO `role_permissions` VALUES (141, 20, 14, '2025-10-22 00:46:01.538080');
INSERT INTO `role_permissions` VALUES (142, 20, 15, '2025-10-22 00:46:01.542081');
INSERT INTO `role_permissions` VALUES (143, 20, 17, '2025-10-22 00:46:01.547083');
INSERT INTO `role_permissions` VALUES (144, 20, 18, '2025-10-22 00:46:01.552081');
INSERT INTO `role_permissions` VALUES (145, 20, 19, '2025-10-22 00:46:01.558082');
INSERT INTO `role_permissions` VALUES (146, 20, 94, '2025-10-22 00:46:01.568082');
INSERT INTO `role_permissions` VALUES (158, 22, 1, '2025-10-22 00:46:01.647385');
INSERT INTO `role_permissions` VALUES (159, 22, 85, '2025-10-22 00:46:01.651387');
INSERT INTO `role_permissions` VALUES (160, 22, 86, '2025-10-22 00:46:01.654386');
INSERT INTO `role_permissions` VALUES (161, 22, 87, '2025-10-22 00:46:01.658387');
INSERT INTO `role_permissions` VALUES (162, 22, 89, '2025-10-22 00:46:01.662046');
INSERT INTO `role_permissions` VALUES (163, 22, 13, '2025-10-22 00:46:01.666048');
INSERT INTO `role_permissions` VALUES (164, 22, 14, '2025-10-22 00:46:01.670046');
INSERT INTO `role_permissions` VALUES (165, 22, 15, '2025-10-22 00:46:01.673047');
INSERT INTO `role_permissions` VALUES (166, 22, 17, '2025-10-22 00:46:01.678054');
INSERT INTO `role_permissions` VALUES (167, 22, 18, '2025-10-22 00:46:01.681047');
INSERT INTO `role_permissions` VALUES (168, 22, 19, '2025-10-22 00:46:01.685063');
INSERT INTO `role_permissions` VALUES (169, 22, 94, '2025-10-22 00:46:01.690052');
INSERT INTO `role_permissions` VALUES (170, 23, 1, '2025-10-22 00:46:01.698063');
INSERT INTO `role_permissions` VALUES (171, 23, 85, '2025-10-22 00:46:01.702049');
INSERT INTO `role_permissions` VALUES (172, 23, 87, '2025-10-22 00:46:01.707046');
INSERT INTO `role_permissions` VALUES (173, 23, 13, '2025-10-22 00:46:01.712047');
INSERT INTO `role_permissions` VALUES (174, 23, 14, '2025-10-22 00:46:01.716047');
INSERT INTO `role_permissions` VALUES (175, 23, 17, '2025-10-22 00:46:01.719061');
INSERT INTO `role_permissions` VALUES (176, 23, 94, '2025-10-22 00:46:01.723060');
INSERT INTO `role_permissions` VALUES (177, 24, 1, '2025-10-22 00:46:01.731061');
INSERT INTO `role_permissions` VALUES (178, 24, 85, '2025-10-22 00:46:01.735064');
INSERT INTO `role_permissions` VALUES (179, 24, 87, '2025-10-22 00:46:01.739050');
INSERT INTO `role_permissions` VALUES (180, 24, 13, '2025-10-22 00:46:01.743062');
INSERT INTO `role_permissions` VALUES (181, 24, 14, '2025-10-22 00:46:01.748062');
INSERT INTO `role_permissions` VALUES (182, 24, 17, '2025-10-22 00:46:01.752051');
INSERT INTO `role_permissions` VALUES (183, 24, 94, '2025-10-22 00:46:01.756050');
INSERT INTO `role_permissions` VALUES (206, 21, 1, '2025-10-22 01:28:27.286058');
INSERT INTO `role_permissions` VALUES (207, 21, 17, '2025-10-22 01:28:27.290056');
INSERT INTO `role_permissions` VALUES (208, 21, 18, '2025-10-22 01:28:27.295078');
INSERT INTO `role_permissions` VALUES (209, 21, 19, '2025-10-22 01:28:27.299075');
INSERT INTO `role_permissions` VALUES (210, 21, 94, '2025-10-22 01:28:27.303073');
INSERT INTO `role_permissions` VALUES (212, 26, 96, '2025-10-22 12:45:53.528883');
INSERT INTO `role_permissions` VALUES (213, 26, 94, '2025-10-22 12:45:53.531892');

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色代码',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '角色描述',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES (1, '系统管理员', 'admin', '系统管理员，拥有所有权限', 1, '2025-10-14 09:44:09.000000', '2025-10-22 00:48:42.014773');
INSERT INTO `roles` VALUES (2, '企业管理员', 'enterprise_admin', '企业管理员，管理企业相关功能', 1, '2025-10-14 09:44:09.000000', '2025-10-14 09:44:09.000000');
INSERT INTO `roles` VALUES (3, '企业员工', 'enterprise_employee', '企业员工，使用企业功能', 1, '2025-10-14 09:44:09.000000', '2025-10-14 09:44:09.000000');
INSERT INTO `roles` VALUES (4, '个人用户', 'personal_user', '个人用户，使用个人功能', 1, '2025-10-14 09:44:09.000000', '2025-10-14 09:44:09.000000');
INSERT INTO `roles` VALUES (16, '技术人员', 'technician', '从事技术工作的专业人员，负责技术实施和操作', 1, '2025-10-22 00:38:51.947000', '2025-10-22 00:38:51.947000');
INSERT INTO `roles` VALUES (17, '工程师', 'engineer', '具有工程专业背景的技术人员，负责工程设计和技术管理', 1, '2025-10-22 00:38:51.953001', '2025-10-22 00:44:43.824622');
INSERT INTO `roles` VALUES (18, '施工人员', 'construction_worker', '从事现场施工工作的人员，负责具体施工操作', 1, '2025-10-22 00:38:51.959000', '2025-10-22 00:38:51.959998');
INSERT INTO `roles` VALUES (19, '劳务人员', 'labor_worker', '从事基础劳务工作的人员，负责辅助性工作', 1, '2025-10-22 00:38:51.969208', '2025-10-22 00:38:51.969208');
INSERT INTO `roles` VALUES (20, '行业顾问', 'industry_consultant', '具有丰富行业经验的专业顾问，提供专业咨询和建议', 1, '2025-10-22 00:38:51.976220', '2025-10-22 01:12:00.110263');
INSERT INTO `roles` VALUES (21, '行业专家', 'industry_expert', '在特定领域具有权威地位的专业专家，提供高端咨询服务', 1, '2025-10-22 00:38:51.981219', '2025-10-22 01:28:27.238486');
INSERT INTO `roles` VALUES (22, '项目经理', 'project_manager', '负责项目整体管理和协调的项目管理人员', 1, '2025-10-22 00:38:51.986221', '2025-10-22 00:38:51.986221');
INSERT INTO `roles` VALUES (23, '质量监督员', 'quality_supervisor', '负责质量控制和监督工作的专业人员', 1, '2025-10-22 00:38:51.992219', '2025-10-22 00:38:51.992219');
INSERT INTO `roles` VALUES (24, '安全管理员', 'safety_manager', '负责安全管理和监督工作的专业人员', 1, '2025-10-22 00:38:51.998218', '2025-10-22 00:38:51.998218');
INSERT INTO `roles` VALUES (26, '测试角色', 'test_role', '用于测试的角色', 1, '2025-10-22 12:10:56.776794', '2025-10-22 12:45:53.523803');

-- ----------------------------
-- Table structure for system_analytics
-- ----------------------------
DROP TABLE IF EXISTS `system_analytics`;
CREATE TABLE `system_analytics`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `analytics_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `metric_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `metric_value` decimal(15, 2) NOT NULL,
  `dimension_data` json NULL,
  `time_period` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `analysis_date` date NOT NULL,
  `extra_data` json NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `system_analytics_analytics_type_analysis_date`(`analytics_type` ASC, `analysis_date` ASC) USING BTREE,
  INDEX `system_analytics_metric_name_analysis_date`(`metric_name` ASC, `analysis_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_analytics
-- ----------------------------
INSERT INTO `system_analytics` VALUES (1, 'user_behavior', 'page_views', 1500.00, '{\"page\": \"dashboard\", \"user_type\": \"enterprise\"}', 'daily', '2025-10-22', NULL, '2025-10-22 12:11:33.791337');
INSERT INTO `system_analytics` VALUES (2, 'user_behavior', 'page_views', 1500.00, '{\"page\": \"dashboard\", \"user_type\": \"enterprise\"}', 'daily', '2025-10-22', NULL, '2025-10-22 12:26:58.764801');

-- ----------------------------
-- Table structure for system_backups
-- ----------------------------
DROP TABLE IF EXISTS `system_backups`;
CREATE TABLE `system_backups`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `backup_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '备份类型',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '备份名称',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备份描述',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '文件路径',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小(字节)',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '状态',
  `start_time` datetime(6) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime(6) NULL DEFAULT NULL COMMENT '结束时间',
  `error_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '错误信息',
  `created_by_id` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `system_backups_created_by_id`(`created_by_id` ASC) USING BTREE,
  INDEX `idx_backup_type`(`backup_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `system_backups_created_by_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统备份表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_backups
-- ----------------------------
INSERT INTO `system_backups` VALUES (1, 'database', 'test_backup_20241201', '测试数据库备份', '/backups/test_backup_20241201.sql', 1048576, 'completed', '2025-10-22 11:11:33.799434', '2025-10-22 11:41:33.799434', '', 1, '2025-10-22 12:11:33.800435');
INSERT INTO `system_backups` VALUES (2, 'database', 'test_backup_20241201', '测试数据库备份', '/backups/test_backup_20241201.sql', 1048576, 'completed', '2025-10-22 11:26:58.770882', '2025-10-22 11:56:58.770882', '', 1, '2025-10-22 12:26:58.771883');

-- ----------------------------
-- Table structure for system_configs
-- ----------------------------
DROP TABLE IF EXISTS `system_configs`;
CREATE TABLE `system_configs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置值',
  `config_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置类型',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置描述',
  `is_encrypted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否加密',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `key`(`key` ASC) USING BTREE,
  INDEX `idx_config_type`(`config_type` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_configs
-- ----------------------------
INSERT INTO `system_configs` VALUES (1, 'site_name', '防腐保温智能数字平台', 'basic', '网站名称', 0, 1, '2025-10-14 09:44:09.000000', '2025-10-14 09:44:09.000000');
INSERT INTO `system_configs` VALUES (2, 'site_description', '专业的防腐保温行业数字化平台', 'basic', '网站描述', 0, 1, '2025-10-14 09:44:09.000000', '2025-10-14 09:44:09.000000');
INSERT INTO `system_configs` VALUES (3, 'site_keywords', '防腐,保温,数字化,平台', 'basic', '网站关键词', 0, 1, '2025-10-14 09:44:09.000000', '2025-10-14 09:44:09.000000');
INSERT INTO `system_configs` VALUES (4, 'contact_email', 'admin@corrosion-platform.com', 'basic', '联系邮箱', 0, 1, '2025-10-14 09:44:09.000000', '2025-10-14 09:44:09.000000');
INSERT INTO `system_configs` VALUES (5, 'contact_phone', '400-123-4567', 'basic', '联系电话', 0, 1, '2025-10-14 09:44:09.000000', '2025-10-14 09:44:09.000000');
INSERT INTO `system_configs` VALUES (6, 'max_file_size', '10485760', 'basic', '最大文件上传大小(字节)', 0, 1, '2025-10-14 09:44:09.000000', '2025-10-14 09:44:09.000000');
INSERT INTO `system_configs` VALUES (7, 'allowed_file_types', 'jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx', 'basic', '允许上传的文件类型', 0, 1, '2025-10-14 09:44:09.000000', '2025-10-14 09:44:09.000000');
INSERT INTO `system_configs` VALUES (9, 'system_name', '腐蚀平台管理系统', 'basic', '系统名称', 0, 1, '2025-10-22 12:11:33.772814', '2025-10-22 12:11:33.772814');

-- ----------------------------
-- Table structure for system_logs
-- ----------------------------
DROP TABLE IF EXISTS `system_logs`;
CREATE TABLE `system_logs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日志级别',
  `log_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日志类型',
  `module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模块',
  `message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日志消息',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `ip_address` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户代理',
  `request_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求路径',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求方法',
  `response_status` int NULL DEFAULT NULL COMMENT '响应状态',
  `execution_time` double NULL DEFAULT NULL COMMENT '执行时间(秒)',
  `extra_data` json NULL COMMENT '额外数据',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `system_logs_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_level_created_at`(`level` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_log_type_created_at`(`log_type` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_user_created_at`(`user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_module_created_at`(`module` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_system_logs_ip_address`(`ip_address` ASC) USING BTREE,
  INDEX `idx_system_logs_request_method`(`request_method` ASC) USING BTREE,
  CONSTRAINT `system_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_logs
-- ----------------------------

-- ----------------------------
-- Table structure for system_maintenance
-- ----------------------------
DROP TABLE IF EXISTS `system_maintenance`;
CREATE TABLE `system_maintenance`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `maintenance_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `scheduled_start` datetime(6) NOT NULL,
  `scheduled_end` datetime(6) NOT NULL,
  `actual_start` datetime(6) NULL DEFAULT NULL,
  `actual_end` datetime(6) NULL DEFAULT NULL,
  `affected_services` json NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `system_maintenance_created_by_id_fk`(`created_by_id` ASC) USING BTREE,
  CONSTRAINT `system_maintenance_created_by_id_fk` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_maintenance
-- ----------------------------
INSERT INTO `system_maintenance` VALUES (1, 'scheduled', '数据库优化维护', '定期数据库优化和清理', 'planned', '2025-10-23 12:11:33.795429', '2025-10-23 14:11:33.795429', NULL, NULL, NULL, '2025-10-22 12:11:33.796432', '2025-10-22 12:11:33.796432', 1);
INSERT INTO `system_maintenance` VALUES (2, 'scheduled', '数据库优化维护', '定期数据库优化和清理', 'planned', '2025-10-23 12:26:58.766881', '2025-10-23 14:26:58.766881', NULL, NULL, NULL, '2025-10-22 12:26:58.767884', '2025-10-22 12:26:58.767884', 1);

-- ----------------------------
-- Table structure for system_monitors
-- ----------------------------
DROP TABLE IF EXISTS `system_monitors`;
CREATE TABLE `system_monitors`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `monitor_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '监控类型',
  `metric_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '指标名称',
  `metric_value` double NOT NULL COMMENT '指标值',
  `threshold_warning` double NULL DEFAULT NULL COMMENT '警告阈值',
  `threshold_critical` double NULL DEFAULT NULL COMMENT '严重阈值',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT '状态',
  `extra_data` json NULL COMMENT '额外数据',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_monitor_type_created_at`(`monitor_type` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_status_created_at`(`status` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统监控表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_monitors
-- ----------------------------
INSERT INTO `system_monitors` VALUES (1, 'cpu', 'cpu_usage', 75.5, 80, 90, 'normal', NULL, '2025-10-22 12:11:33.786337');
INSERT INTO `system_monitors` VALUES (2, 'cpu', 'cpu_usage', 75.5, 80, 90, 'normal', NULL, '2025-10-22 12:26:58.761797');

-- ----------------------------
-- Table structure for system_notifications
-- ----------------------------
DROP TABLE IF EXISTS `system_notifications`;
CREATE TABLE `system_notifications`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知内容',
  `notification_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知类型',
  `priority` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium' COMMENT '优先级',
  `is_global` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否全局通知',
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已读',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `expire_at` datetime(6) NULL DEFAULT NULL COMMENT '过期时间',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_notification_type`(`notification_type` ASC) USING BTREE,
  INDEX `idx_priority`(`priority` ASC) USING BTREE,
  INDEX `idx_is_global`(`is_global` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE,
  INDEX `idx_expire_at`(`expire_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_notifications
-- ----------------------------

-- ----------------------------
-- Table structure for system_notifications_target_users
-- ----------------------------
DROP TABLE IF EXISTS `system_notifications_target_users`;
CREATE TABLE `system_notifications_target_users`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `systemnotification_id` bigint NOT NULL COMMENT '系统通知ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `system_notifications_target_users_systemnotification_id_user_id`(`systemnotification_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `system_notifications_target_users_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `system_notifications_target_users_systemnotification_id` FOREIGN KEY (`systemnotification_id`) REFERENCES `system_notifications` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `system_notifications_target_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统通知用户关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_notifications_target_users
-- ----------------------------

-- ----------------------------
-- Table structure for system_page_configs
-- ----------------------------
DROP TABLE IF EXISTS `system_page_configs`;
CREATE TABLE `system_page_configs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `page_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `page_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `keywords` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `layout_config` json NULL,
  `theme_config` json NULL,
  `custom_css` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `custom_js` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `page_name`(`page_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_page_configs
-- ----------------------------
INSERT INTO `system_page_configs` VALUES (1, 'dashboard', 'dashboard', '仪表板', '系统仪表板页面', 'dashboard,仪表板,统计', NULL, NULL, '', '', 1, '2025-10-22 12:11:33.778814', '2025-10-22 12:11:33.778814');

-- ----------------------------
-- Table structure for system_security_logs
-- ----------------------------
DROP TABLE IF EXISTS `system_security_logs`;
CREATE TABLE `system_security_logs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `security_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ip_address` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_agent` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `risk_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_resolved` tinyint(1) NOT NULL,
  `resolved_at` datetime(6) NULL DEFAULT NULL,
  `extra_data` json NULL,
  `created_at` datetime(6) NOT NULL,
  `resolved_by_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `system_security_logs_security_type_created_at`(`security_type` ASC, `created_at` ASC) USING BTREE,
  INDEX `system_security_logs_risk_level_created_at`(`risk_level` ASC, `created_at` ASC) USING BTREE,
  INDEX `system_security_logs_is_resolved_created_at`(`is_resolved` ASC, `created_at` ASC) USING BTREE,
  INDEX `system_security_logs_resolved_by_id_fk`(`resolved_by_id` ASC) USING BTREE,
  INDEX `system_security_logs_user_id_fk`(`user_id` ASC) USING BTREE,
  CONSTRAINT `system_security_logs_resolved_by_id_fk` FOREIGN KEY (`resolved_by_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `system_security_logs_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_security_logs
-- ----------------------------
INSERT INTO `system_security_logs` VALUES (1, 'login_failure', '192.168.1.100', 'Suspicious Browser', '多次登录失败', 'high', 0, NULL, NULL, '2025-10-22 12:11:33.782337', NULL, 1);
INSERT INTO `system_security_logs` VALUES (2, 'login_failure', '192.168.1.100', 'Suspicious Browser', '多次登录失败', 'high', 0, NULL, NULL, '2025-10-22 12:26:58.758798', NULL, 1);

-- ----------------------------
-- Table structure for system_statistics
-- ----------------------------
DROP TABLE IF EXISTS `system_statistics`;
CREATE TABLE `system_statistics`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `stat_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '统计类型',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `stat_hour` int NULL DEFAULT NULL COMMENT '统计小时',
  `metric_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '指标名称',
  `metric_value` decimal(15, 2) NOT NULL COMMENT '指标值',
  `extra_data` json NULL COMMENT '额外数据',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `system_statistics_stat_type_stat_date_stat_hour_metric_name`(`stat_type` ASC, `stat_date` ASC, `stat_hour` ASC, `metric_name` ASC) USING BTREE,
  INDEX `idx_stat_type_stat_date`(`stat_type` ASC, `stat_date` ASC) USING BTREE,
  INDEX `idx_metric_name_stat_date`(`metric_name` ASC, `stat_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_statistics
-- ----------------------------

-- ----------------------------
-- Table structure for user_activity_logs
-- ----------------------------
DROP TABLE IF EXISTS `user_activity_logs`;
CREATE TABLE `user_activity_logs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ip_address` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_agent` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `request_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `extra_data` json NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_activity_logs_user_created_at`(`user_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `user_activity_logs_action_created_at`(`action` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `user_activity_logs_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_activity_logs
-- ----------------------------
INSERT INTO `user_activity_logs` VALUES (1, 'login', '用户登录', '127.0.0.1', 'Test Browser', '/api/auth/login/', NULL, '2025-10-22 12:10:56.761737', 29);
INSERT INTO `user_activity_logs` VALUES (2, 'login', '用户登录', '127.0.0.1', 'Test Browser', '/api/auth/login/', NULL, '2025-10-22 12:11:33.751774', 29);
INSERT INTO `user_activity_logs` VALUES (3, 'login', '用户登录', '127.0.0.1', 'Test Browser', '/api/auth/login/', NULL, '2025-10-22 12:26:58.740895', 29);

-- ----------------------------
-- Table structure for user_login_logs
-- ----------------------------
DROP TABLE IF EXISTS `user_login_logs`;
CREATE TABLE `user_login_logs`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `ip_address` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IP地址',
  `user_agent` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户代理',
  `login_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '登录时间',
  `is_success` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否成功',
  `logout_time` datetime(6) NULL DEFAULT NULL,
  `failure_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `device_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_login_logs_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_login_time`(`login_time` ASC) USING BTREE,
  INDEX `idx_ip_address`(`ip_address` ASC) USING BTREE,
  CONSTRAINT `user_login_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 85 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户登录日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_login_logs
-- ----------------------------
INSERT INTO `user_login_logs` VALUES (1, 2, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 01:57:59.920442', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (2, 3, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 02:01:50.626371', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (3, 4, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 02:02:40.428319', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (4, 5, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 16:01:20.505579', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (5, 5, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 16:01:20.888824', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (6, 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:11:11.871810', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (7, 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:11:27.588464', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (8, 7, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 16:14:48.703860', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (9, 7, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 16:14:49.081179', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (10, 8, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 16:14:49.604600', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (11, 8, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 16:14:49.947890', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (12, 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:32:48.146278', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (13, 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:33:00.141050', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (14, 5, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 16:38:55.560010', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (15, 5, '127.0.0.1', 'python-requests/2.32.3', '2025-10-15 16:39:21.327271', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (16, 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 17:17:17.292351', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (17, 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 00:34:01.437373', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (18, 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 01:48:27.913059', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (19, 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 01:48:35.242484', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (20, 11, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 00:37:24.662459', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (21, 11, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 00:37:46.819116', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (22, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 00:53:45.934753', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (23, 12, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 00:54:02.349699', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (24, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:09:23.623412', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (25, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:10:48.067439', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (26, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:17:21.159364', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (27, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:28:02.382307', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (28, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:28:54.197062', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (29, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:29:17.997627', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (30, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:29:55.145956', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (31, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:34:32.776102', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (32, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:35:40.462938', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (33, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:35:57.609571', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (34, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:41:36.534534', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (35, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:42:47.270649', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (36, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:45:35.814495', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (37, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:49:27.921975', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (38, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:52:28.525857', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (39, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 01:58:16.372434', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (40, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:38:09.379331', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (41, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:48:07.365105', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (42, 12, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 11:35:54.345655', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (43, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 11:54:06.933971', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (44, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 11:54:18.621706', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (45, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 11:54:38.402119', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (46, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 12:23:37.633157', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (47, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 13:20:59.914125', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (48, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 13:22:03.994045', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (49, 12, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 13:22:39.695785', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (50, 13, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 13:22:58.079373', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (51, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 13:23:26.185101', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (52, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 14:08:31.490131', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (53, 20, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 14:32:50.316115', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (54, 20, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 14:33:30.441556', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (55, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:02:16.314328', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (56, 12, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 19:31:40.643524', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (57, 13, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 19:35:34.781967', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (58, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 00:23:26.174344', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (59, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 00:44:18.815755', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (60, 1, '127.0.0.1', 'python-requests/2.32.3', '2025-10-22 00:47:47.138298', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (61, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 00:51:10.248175', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (62, 13, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 00:51:17.824419', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (63, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 00:53:53.632136', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (64, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 00:59:22.912616', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (65, 1, '127.0.0.1', 'python-requests/2.32.3', '2025-10-22 01:02:51.263559', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (66, 1, '127.0.0.1', 'python-requests/2.32.3', '2025-10-22 01:03:59.753366', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (67, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 01:12:16.216359', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (68, 1, '127.0.0.1', 'python-requests/2.32.3', '2025-10-22 01:18:52.313947', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (69, 1, '127.0.0.1', 'python-requests/2.32.3', '2025-10-22 01:19:26.471833', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (70, 1, '127.0.0.1', 'python-requests/2.32.3', '2025-10-22 01:19:38.396272', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (71, 24, '127.0.0.1', 'python-requests/2.32.3', '2025-10-22 01:23:06.305020', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (72, 25, '127.0.0.1', 'python-requests/2.32.3', '2025-10-22 01:23:43.448226', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (73, 26, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 01:23:57.569839', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (74, 26, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 01:24:12.798998', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (75, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 01:24:27.697439', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (76, 1, '127.0.0.1', 'python-requests/2.32.3', '2025-10-22 01:27:34.441286', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (77, 26, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 01:30:01.520849', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (78, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 01:30:29.497509', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (79, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:21:21.882474', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (80, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:45:03.248153', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (81, 12, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 13:00:38.889355', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (82, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:40:34.841669', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (83, 30, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:41:34.239448', 1, NULL, '', '', '');
INSERT INTO `user_login_logs` VALUES (84, 30, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:41:44.068727', 1, NULL, '', '', '');

-- ----------------------------
-- Table structure for user_permission_overrides
-- ----------------------------
DROP TABLE IF EXISTS `user_permission_overrides`;
CREATE TABLE `user_permission_overrides`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_granted` tinyint(1) NOT NULL,
  `reason` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expire_at` datetime(6) NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `granted_by_id` bigint NULL DEFAULT NULL,
  `permission_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_permission_unique`(`user_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `user_permission_overrides_granted_by_id_fk`(`granted_by_id` ASC) USING BTREE,
  INDEX `user_permission_overrides_permission_id_fk`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `user_permission_overrides_granted_by_id_fk` FOREIGN KEY (`granted_by_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `user_permission_overrides_permission_id_fk` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `user_permission_overrides_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_permission_overrides
-- ----------------------------

-- ----------------------------
-- Table structure for user_profiles
-- ----------------------------
DROP TABLE IF EXISTS `user_profiles`;
CREATE TABLE `user_profiles`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `birthday` date NULL DEFAULT NULL,
  `address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `company` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `bio` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `website` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `social_media` json NULL,
  `preferences` json NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `user_profiles_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_profiles
-- ----------------------------
INSERT INTO `user_profiles` VALUES (1, '测试用户', '', 'male', NULL, '', '测试公司', '测试职位', '这是一个测试用户', '', NULL, NULL, '2025-10-22 12:10:56.754215', '2025-10-22 12:10:56.755218', 29);

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_roles_user_id_role_id`(`user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `user_roles_role_id`(`role_id` ASC) USING BTREE,
  CONSTRAINT `user_roles_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_roles_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_roles
-- ----------------------------
INSERT INTO `user_roles` VALUES (2, 2, 4, '2025-10-15 16:14:16.164107');
INSERT INTO `user_roles` VALUES (3, 3, 4, '2025-10-15 16:14:16.206743');
INSERT INTO `user_roles` VALUES (4, 4, 4, '2025-10-15 16:14:16.211743');
INSERT INTO `user_roles` VALUES (5, 5, 4, '2025-10-15 16:14:16.215791');
INSERT INTO `user_roles` VALUES (6, 6, 4, '2025-10-15 16:14:16.220805');
INSERT INTO `user_roles` VALUES (7, 7, 4, '2025-10-15 16:14:48.701862');
INSERT INTO `user_roles` VALUES (8, 8, 2, '2025-10-15 16:14:49.602598');
INSERT INTO `user_roles` VALUES (9, 9, 4, '2025-10-15 16:32:48.143279');
INSERT INTO `user_roles` VALUES (10, 10, 4, '2025-10-16 01:48:27.910052');
INSERT INTO `user_roles` VALUES (11, 11, 4, '2025-10-21 00:37:24.658459');
INSERT INTO `user_roles` VALUES (16, 1, 1, '2025-10-21 00:53:15.696054');
INSERT INTO `user_roles` VALUES (17, 12, 2, '2025-10-21 00:53:16.227920');
INSERT INTO `user_roles` VALUES (18, 13, 4, '2025-10-21 00:53:16.684049');
INSERT INTO `user_roles` VALUES (19, 14, 2, '2025-10-21 01:39:20.239854');
INSERT INTO `user_roles` VALUES (20, 17, 2, '2025-10-21 01:39:44.509245');
INSERT INTO `user_roles` VALUES (21, 18, 2, '2025-10-21 01:39:45.018020');
INSERT INTO `user_roles` VALUES (22, 20, 2, '2025-10-21 14:32:50.313114');
INSERT INTO `user_roles` VALUES (23, 24, 1, '2025-10-22 01:23:06.302490');
INSERT INTO `user_roles` VALUES (24, 25, 4, '2025-10-22 01:23:43.444500');
INSERT INTO `user_roles` VALUES (25, 26, 21, '2025-10-22 01:23:57.566855');
INSERT INTO `user_roles` VALUES (26, 30, 22, '2025-10-22 14:41:34.237409');

-- ----------------------------
-- Table structure for user_sessions
-- ----------------------------
DROP TABLE IF EXISTS `user_sessions`;
CREATE TABLE `user_sessions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `session_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ip_address` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_agent` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `login_time` datetime(6) NOT NULL,
  `last_activity` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `expire_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `session_key`(`session_key` ASC) USING BTREE,
  INDEX `user_sessions_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `user_sessions_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_sessions
-- ----------------------------
INSERT INTO `user_sessions` VALUES (1, 'test_session_key', '127.0.0.1', 'Test Browser', '2025-10-22 12:10:56.759217', '2025-10-22 12:10:56.759217', 1, '2025-10-23 12:10:56.757217', 29);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `user_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'personal' COMMENT '用户类型: enterprise-企业用户, personal-个人用户',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `is_verified` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否认证',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  INDEX `idx_user_type`(`user_type` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  INDEX `idx_users_email`(`email` ASC) USING BTREE,
  INDEX `idx_users_date_joined`(`date_joined` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'pbkdf2_sha256$600000$z0CNgwblJbm5akZwRShDt9$fcnTwye18bN1Um/pAhOqSKIts8/jZ5VGCab+cPOdxmg=', NULL, 1, 'admin', '系统', '管理员', 'admin@corrosion-platform.com', 1, 1, '2025-10-14 09:44:09.000000', 'personal', '13900000001', '', 1, '2025-10-14 09:44:09.000000', '2025-10-21 00:53:15.633917');
INSERT INTO `users` VALUES (2, 'pbkdf2_sha256$600000$wHxv50FxP2Q5uEWOL5Xul8$Ijo8nky46LON/cNvr2TI0H+N7V0ype0BG2OJtOlH8+E=', NULL, 0, 'testuser2', '', '', 'test2@example.com', 0, 1, '2025-10-15 01:57:59.586986', 'personal', '13800138002', '', 0, '2025-10-15 01:57:59.587987', '2025-10-15 01:57:59.880475');
INSERT INTO `users` VALUES (3, 'pbkdf2_sha256$600000$a63isT50WZtUwIoWT9K9l8$5RSA2bpYdrVeXQ4WDypFTbANuDG/a0RoY/T95wGhC4E=', NULL, 0, 'testuser3', '', '', 'test3@example.com', 0, 1, '2025-10-15 02:01:50.255715', 'personal', '13800138003', '', 0, '2025-10-15 02:01:50.256730', '2025-10-15 02:01:50.586132');
INSERT INTO `users` VALUES (4, 'pbkdf2_sha256$600000$UkyJHYlgFtNLNFbwthcXvW$7S6IpHNumUQnAmT8AMvS/iC9ksxjDADZH1+YKbuImcQ=', NULL, 0, 'testuser4', '测试', '', 'test4@example.com', 0, 1, '2025-10-15 02:02:40.066191', 'personal', '13800138004', '', 0, '2025-10-15 02:02:40.066191', '2025-10-15 02:02:40.423314');
INSERT INTO `users` VALUES (5, 'pbkdf2_sha256$600000$z8IkZgfLDj83KAKWbmZZc6$E8MM+w3a4Qu+UiXoS6syUPEtJJRKdygIGyNXn4Kc3wY=', NULL, 0, 'testuser_20251016000120', '测试用户', '', 'test_20251016000120@example.com', 0, 1, '2025-10-15 16:01:20.210382', 'personal', '13816000120', '', 0, '2025-10-15 16:01:20.481212', '2025-10-15 16:01:20.481212');
INSERT INTO `users` VALUES (6, 'pbkdf2_sha256$600000$ojRqhdn347AEBm9eY7674a$nP4UnoLwdAyGlZuikEz4tZOYVtNOeXoFuwEUxq5Sego=', NULL, 0, 'user001', 'liuhang', '', 'liuhang@qq.com', 0, 1, '2025-10-15 16:11:11.445243', 'personal', '18883838888', '', 0, '2025-10-15 16:11:11.818605', '2025-10-15 16:11:11.818605');
INSERT INTO `users` VALUES (7, 'pbkdf2_sha256$600000$CElszZSQZrX9mglIfgoEfy$hT3sjpKTCwakgoU9uXOyUbrey2QRrGBVaPsK3RahVEY=', NULL, 0, 'personal_20251016001448', '个人测试', '', 'personal_20251016001448@example.com', 0, 1, '2025-10-15 16:14:48.322129', 'personal', '13916001448', '', 0, '2025-10-15 16:14:48.659931', '2025-10-15 16:14:48.659931');
INSERT INTO `users` VALUES (8, 'pbkdf2_sha256$600000$CJM0aXXnjiVo0lEGaW11vo$OrHrH8l38Q8yR9tm052ZWnfF7hsoPguxZosAGzOj1aU=', NULL, 0, 'enterprise_20251016001448', '企业测试', '', 'enterprise_20251016001448@example.com', 0, 1, '2025-10-15 16:14:49.226841', 'enterprise', '13816001448', '', 0, '2025-10-15 16:14:49.561598', '2025-10-15 16:14:49.561598');
INSERT INTO `users` VALUES (9, 'pbkdf2_sha256$600000$UhnFQnFBPapZmkttOdLY2x$oUMA7zx/T5NJy2ZHOZ5JaI+BnLUxSq7Cd1QAYskjouk=', NULL, 0, 'test999', 'test999', '', 'test999@test.com', 0, 1, '2025-10-15 16:32:47.773155', 'personal', '13838383333', '', 0, '2025-10-15 16:32:48.103069', '2025-10-15 16:32:48.103069');
INSERT INTO `users` VALUES (10, 'pbkdf2_sha256$600000$TT6RhzG8CjTlWokwb9THxz$HN49vm61jVw2EDEoz/y8T2uQSp4WXV+wbBtYja8uNgY=', NULL, 0, 'test', 'test', '', 'test@test.com', 0, 1, '2025-10-16 01:48:27.561416', 'personal', '13332323222', '', 0, '2025-10-16 01:48:27.864925', '2025-10-16 01:48:27.864925');
INSERT INTO `users` VALUES (11, 'pbkdf2_sha256$600000$ytSSN3p3f4qnZMFQS7T7ki$MMwB5eXtPlmjOeu0dWndLASPaja0ra168suNosUAxiw=', NULL, 0, 'test123', 'liuhang', '', 'test123@test.com', 0, 1, '2025-10-21 00:37:24.271358', 'personal', '18688883333', '', 0, '2025-10-21 00:37:24.608954', '2025-10-21 00:37:24.608954');
INSERT INTO `users` VALUES (12, 'pbkdf2_sha256$600000$6FmegzR0OCQEwWPevotxWe$b3YPDDRfjlhCMQBpoVrBidXpdfwx244E2aSUJe8A0VU=', NULL, 0, 'enterprise', '企业', '用户', 'enterprise@example.com', 0, 1, '2025-10-21 00:53:14.242216', 'enterprise', '13900000002', '', 1, '2025-10-21 00:53:14.574476', '2025-10-21 00:53:16.162127');
INSERT INTO `users` VALUES (13, 'pbkdf2_sha256$600000$oUGDoBK1NeK4Cyo0erMVQh$i3lYbfqOytmCgp29SPxnDBuULZ0oUJA46WO5/h3K0o8=', NULL, 0, 'user', '个人', '用户', 'user@example.com', 0, 1, '2025-10-21 00:53:14.588497', 'personal', '13900000003', '', 1, '2025-10-21 00:53:14.898779', '2025-10-21 00:53:16.675026');
INSERT INTO `users` VALUES (14, 'pbkdf2_sha256$600000$QQoDmNYFe1Cs2Akx2QYlga$hSQDfufiXThMYMej+ieUXhZymbnqOWswBFX5KjSBC1k=', NULL, 0, 'enterprise_1', '张三', '', 'zhangsan@tencent.com', 0, 1, '2025-10-21 01:39:19.629764', 'enterprise', '13800138001', '', 1, '2025-10-21 01:39:19.629764', '2025-10-22 01:00:02.857226');
INSERT INTO `users` VALUES (17, 'pbkdf2_sha256$600000$kNsJ4vu3cv73k7Pfe7C92x$Tys1XPyJJT9ahKJJd5U/+vs1aFxInyjgiN5KkqQ4tHE=', NULL, 0, 'enterprise_2', '李四', '', 'enterprise2@example.com', 0, 1, '2025-10-21 01:39:44.007903', 'enterprise', '13910000002', '', 1, '2025-10-21 01:39:44.007903', '2025-10-21 01:39:44.489222');
INSERT INTO `users` VALUES (18, 'pbkdf2_sha256$600000$YrMNKa1mdu7XGRmJsE0b9s$bAQ+LWbuh8ntc65YJNayuWb8zK7tYrJSe2xuP89x7sY=', NULL, 0, 'enterprise_3', '王五', '', 'enterprise3@example.com', 0, 1, '2025-10-21 01:39:44.521611', 'enterprise', '13910000003', '', 1, '2025-10-21 01:39:44.521611', '2025-10-21 01:39:44.977569');
INSERT INTO `users` VALUES (19, 'pbkdf2_sha256$600000$atCydEmmmkaSatmfj3uniu$HO+o7mAfu0wF5THbNoXE4Qq4Ldi+azGacC3vbEtaEJQ=', NULL, 0, 'emp_906323', '新员工', '', 'emp_906323@company.com', 0, 1, '2025-10-21 01:58:26.341381', 'enterprise', '138906323', '', 0, '2025-10-21 01:58:26.669089', '2025-10-21 01:58:26.669089');
INSERT INTO `users` VALUES (20, 'pbkdf2_sha256$600000$9oFynMPDu5OF0db7IipFxF$ugujak4lxK81R1zev5/CAOjJbO/KXo2aEs4CC2HqWk8=', NULL, 0, 'test002', 'lh', '', 'test002@test.com', 0, 1, '2025-10-21 14:32:50.125982', 'enterprise', '18080808888', '', 0, '2025-10-21 14:32:50.308600', '2025-10-21 14:32:50.308600');
INSERT INTO `users` VALUES (21, 'pbkdf2_sha256$600000$W4zNSkp9HQdVSgxpeui6U3$AG18slF9/H+BggRBE7/srtZ5ScVSvHqdB5APJuSVy8k=', NULL, 0, 'emp_106616', '新员工', '', 'emp_106616@company.com', 0, 1, '2025-10-21 19:31:46.626154', 'enterprise', '138106616', '', 0, '2025-10-21 19:31:46.858854', '2025-10-21 19:31:46.858854');
INSERT INTO `users` VALUES (22, 'pbkdf2_sha256$600000$Uk2e4NsmDXXgIyQy4PPpDH$ugPInzWFyeP34KksOfX0B9cSw5JJWv3dKwydokiiINI=', NULL, 0, 'emp_109451', '新员工', '', 'emp_109451@company.com', 0, 1, '2025-10-21 19:31:49.461301', 'enterprise', '138109451', '', 0, '2025-10-21 19:31:49.699412', '2025-10-22 00:55:38.461356');
INSERT INTO `users` VALUES (23, 'pbkdf2_sha256$600000$HXZ7lkvCTzVhkKfzG121E2$8EzQGS40lkWwMV8LKoWuyzku7JOQ0vmTkFFU7DVr6V8=', NULL, 0, 'emp_285702', 'ddd', '', 'emp285702@company.com', 0, 1, '2025-10-21 19:35:08.904489', 'enterprise', '13828570212', '', 0, '2025-10-21 19:35:09.135210', '2025-10-22 01:17:19.099131');
INSERT INTO `users` VALUES (24, 'pbkdf2_sha256$600000$dDLExPbrG6YOKwrxI7wDtM$xIOcO6fR43hcyfgxoLp1XwqiPixamMQHl48O3R2SI/o=', NULL, 0, 'test_user_123', '测试', '用户', 'test@example.com', 0, 1, '2025-10-22 01:23:05.920461', 'personal', '13800138000', '', 0, '2025-10-22 01:23:06.260767', '2025-10-22 01:23:06.260767');
INSERT INTO `users` VALUES (25, 'pbkdf2_sha256$600000$VW6GRfn8PswJE9ePvlhYIg$fnajqvNhJAy7xEoIRMqSiYErBsZz7Fr5zTn8YTAatEc=', NULL, 0, 'test_user_789', '测试', '用户', 'test789@example.com', 0, 1, '2025-10-22 01:23:43.064490', 'personal', '13800138999', '', 0, '2025-10-22 01:23:43.403848', '2025-10-22 01:32:31.040634');
INSERT INTO `users` VALUES (26, 'pbkdf2_sha256$600000$NMV7Pq93d6pXQkkywoG695$QecUk3AYcusBAWKjzroMUhwdJPf2Kb58qd8kArfE8mw=', NULL, 0, 'test005', 'test005', '', 'test005@test.com', 0, 1, '2025-10-22 01:23:57.203465', 'personal', '19090909999', '', 0, '2025-10-22 01:23:57.526233', '2025-10-22 01:23:57.526233');
INSERT INTO `users` VALUES (29, 'pbkdf2_sha256$600000$uD6TqLAhRvWboJD0HEvqpN$S0r+RKyI27PbKuEUhuUNHZQ9eXNZWdIDPfSOXLKDOm0=', NULL, 0, 'test_user', '', '', 'test@example.com', 0, 1, '2025-10-22 12:00:31.648133', 'personal', '13900139000', '', 0, '2025-10-22 12:00:31.890898', '2025-10-22 12:00:31.890898');
INSERT INTO `users` VALUES (30, 'pbkdf2_sha256$600000$QNOxAUYojNpb2guiJCeT26$ddcBL8tAY5Aosv32uAyCd8dPOI8VukOGxngt4sZhBQ4=', NULL, 0, 'test008', 'test008', '', 'test008@test.com', 0, 1, '2025-10-22 14:41:34.048026', 'enterprise', '19899998888', '', 0, '2025-10-22 14:41:34.233409', '2025-10-22 14:41:34.233409');

-- ----------------------------
-- View structure for v_enterprise_statistics
-- ----------------------------
DROP VIEW IF EXISTS `v_enterprise_statistics`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_enterprise_statistics` AS select `e`.`enterprise_type` AS `enterprise_type`,count(0) AS `total_enterprises`,count((case when (`e`.`status` = 'approved') then 1 end)) AS `approved_enterprises`,count((case when (`e`.`status` = 'pending') then 1 end)) AS `pending_enterprises`,avg(`es`.`total_projects`) AS `avg_projects_per_enterprise`,sum(`es`.`total_revenue`) AS `total_revenue` from (`enterprises` `e` left join `enterprise_statistics` `es` on((`e`.`id` = `es`.`enterprise_id`))) group by `e`.`enterprise_type`;

-- ----------------------------
-- View structure for v_info_post_statistics
-- ----------------------------
DROP VIEW IF EXISTS `v_info_post_statistics`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_info_post_statistics` AS select `ic`.`name` AS `category_name`,`ip`.`post_type` AS `post_type`,count(0) AS `total_posts`,count((case when (`ip`.`status` = 'published') then 1 end)) AS `published_posts`,avg(`ip`.`view_count`) AS `avg_view_count`,avg(`ip`.`like_count`) AS `avg_like_count` from (`info_posts` `ip` join `info_categories` `ic` on((`ip`.`category_id` = `ic`.`id`))) group by `ic`.`name`,`ip`.`post_type`;

-- ----------------------------
-- View structure for v_resource_statistics
-- ----------------------------
DROP VIEW IF EXISTS `v_resource_statistics`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_resource_statistics` AS select `rt`.`name` AS `resource_type_name`,count(0) AS `total_resources`,count((case when (`r`.`status` = 'available') then 1 end)) AS `available_resources`,count((case when (`r`.`status` = 'in_use') then 1 end)) AS `in_use_resources`,sum(`r`.`total_value`) AS `total_value`,avg(`r`.`unit_price`) AS `avg_unit_price` from (`resources` `r` join `resource_types` `rt` on((`r`.`resource_type_id` = `rt`.`id`))) group by `rt`.`name`;

-- ----------------------------
-- View structure for v_user_statistics
-- ----------------------------
DROP VIEW IF EXISTS `v_user_statistics`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_user_statistics` AS select `u`.`user_type` AS `user_type`,count(0) AS `total_users`,count((case when (`u`.`is_active` = 1) then 1 end)) AS `active_users`,count((case when (`u`.`is_verified` = 1) then 1 end)) AS `verified_users`,count((case when (`u`.`date_joined` >= (now() - interval 30 day)) then 1 end)) AS `new_users_30d` from `users` `u` group by `u`.`user_type`;

-- ----------------------------
-- Procedure structure for UpdateEnterpriseStatistics
-- ----------------------------
DROP PROCEDURE IF EXISTS `UpdateEnterpriseStatistics`;
delimiter ;;
CREATE PROCEDURE `UpdateEnterpriseStatistics`(IN enterprise_id BIGINT)
BEGIN
    DECLARE total_projects_count INT DEFAULT 0;
    DECLARE completed_projects_count INT DEFAULT 0;
    DECLARE total_employees_count INT DEFAULT 0;
    DECLARE total_revenue_sum DECIMAL(15,2) DEFAULT 0;
    DECLARE total_contracts_count INT DEFAULT 0;
    
    -- 计算项目统计
    SELECT COUNT(*), COUNT(CASE WHEN status = 'completed' THEN 1 END)
    INTO total_projects_count, completed_projects_count
    FROM enterprise_projects 
    WHERE enterprise_id = enterprise_id;
    
    -- 计算员工统计
    SELECT COUNT(*)
    INTO total_employees_count
    FROM employees 
    WHERE enterprise_id = enterprise_id AND is_active = 1;
    
    -- 计算收入统计
    SELECT COALESCE(SUM(contract_amount), 0)
    INTO total_revenue_sum
    FROM enterprise_projects 
    WHERE enterprise_id = enterprise_id AND status = 'completed';
    
    -- 计算合同统计
    SELECT COUNT(*)
    INTO total_contracts_count
    FROM enterprise_projects 
    WHERE enterprise_id = enterprise_id;
    
    -- 更新或插入统计数据
    INSERT INTO enterprise_statistics (
        enterprise_id, total_projects, completed_projects, 
        total_employees, total_revenue, total_contracts, last_updated
    ) VALUES (
        enterprise_id, total_projects_count, completed_projects_count,
        total_employees_count, total_revenue_sum, total_contracts_count, NOW()
    ) ON DUPLICATE KEY UPDATE
        total_projects = total_projects_count,
        completed_projects = completed_projects_count,
        total_employees = total_employees_count,
        total_revenue = total_revenue_sum,
        total_contracts = total_contracts_count,
        last_updated = NOW();
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for UpdatePersonStatistics
-- ----------------------------
DROP PROCEDURE IF EXISTS `UpdatePersonStatistics`;
delimiter ;;
CREATE PROCEDURE `UpdatePersonStatistics`(IN person_id BIGINT)
BEGIN
    DECLARE total_projects_count INT DEFAULT 0;
    DECLARE completed_projects_count INT DEFAULT 0;
    DECLARE total_tasks_count INT DEFAULT 0;
    DECLARE completed_tasks_count INT DEFAULT 0;
    DECLARE total_income_sum DECIMAL(12,2) DEFAULT 0;
    DECLARE work_days_count INT DEFAULT 0;
    
    -- 计算项目统计
    SELECT COUNT(*), COUNT(CASE WHEN status = 'completed' THEN 1 END)
    INTO total_projects_count, completed_projects_count
    FROM person_projects 
    WHERE person_id = person_id;
    
    -- 计算任务统计
    SELECT COUNT(*), COUNT(CASE WHEN status = 'completed' THEN 1 END)
    INTO total_tasks_count, completed_tasks_count
    FROM person_tasks 
    WHERE person_id = person_id;
    
    -- 计算收入统计
    SELECT COALESCE(SUM(income), 0)
    INTO total_income_sum
    FROM person_projects 
    WHERE person_id = person_id AND status = 'completed';
    
    -- 计算工作天数
    SELECT COUNT(DISTINCT DATE(created_at))
    INTO work_days_count
    FROM person_tasks 
    WHERE person_id = person_id AND status = 'completed';
    
    -- 更新或插入统计数据
    INSERT INTO person_statistics (
        person_id, total_projects, completed_projects, 
        total_tasks, completed_tasks, total_income, work_days, last_updated
    ) VALUES (
        person_id, total_projects_count, completed_projects_count,
        total_tasks_count, completed_tasks_count, total_income_sum, work_days_count, NOW()
    ) ON DUPLICATE KEY UPDATE
        total_projects = total_projects_count,
        completed_projects = completed_projects_count,
        total_tasks = total_tasks_count,
        completed_tasks = completed_tasks_count,
        total_income = total_income_sum,
        work_days = work_days_count,
        last_updated = NOW();
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for UpdateResourceStatistics
-- ----------------------------
DROP PROCEDURE IF EXISTS `UpdateResourceStatistics`;
delimiter ;;
CREATE PROCEDURE `UpdateResourceStatistics`(IN resource_type_id BIGINT)
BEGIN
    DECLARE total_count_val INT DEFAULT 0;
    DECLARE available_count_val INT DEFAULT 0;
    DECLARE in_use_count_val INT DEFAULT 0;
    DECLARE maintenance_count_val INT DEFAULT 0;
    DECLARE total_value_sum DECIMAL(15,2) DEFAULT 0;
    DECLARE utilization_rate_val DECIMAL(5,2) DEFAULT 0;
    
    -- 计算各种状态的资源数量
    SELECT 
        COUNT(*),
        COUNT(CASE WHEN status = 'available' THEN 1 END),
        COUNT(CASE WHEN status = 'in_use' THEN 1 END),
        COUNT(CASE WHEN status = 'maintenance' THEN 1 END),
        COALESCE(SUM(total_value), 0)
    INTO 
        total_count_val, available_count_val, in_use_count_val, 
        maintenance_count_val, total_value_sum
    FROM resources 
    WHERE resource_type_id = resource_type_id;
    
    -- 计算利用率
    IF total_count_val > 0 THEN
        SET utilization_rate_val = (in_use_count_val / total_count_val) * 100;
    END IF;
    
    -- 更新或插入统计数据
    INSERT INTO resource_statistics (
        resource_type_id, total_count, available_count, in_use_count,
        maintenance_count, total_value, utilization_rate, last_updated
    ) VALUES (
        resource_type_id, total_count_val, available_count_val, in_use_count_val,
        maintenance_count_val, total_value_sum, utilization_rate_val, NOW()
    ) ON DUPLICATE KEY UPDATE
        total_count = total_count_val,
        available_count = available_count_val,
        in_use_count = in_use_count_val,
        maintenance_count = maintenance_count_val,
        total_value = total_value_sum,
        utilization_rate = utilization_rate_val,
        last_updated = NOW();
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table employees
-- ----------------------------
DROP TRIGGER IF EXISTS `tr_employee_update`;
delimiter ;;
CREATE TRIGGER `tr_employee_update` AFTER UPDATE ON `employees` FOR EACH ROW BEGIN
    IF OLD.is_active != NEW.is_active THEN
        CALL UpdateEnterpriseStatistics(NEW.enterprise_id);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table enterprise_projects
-- ----------------------------
DROP TRIGGER IF EXISTS `tr_enterprise_project_update`;
delimiter ;;
CREATE TRIGGER `tr_enterprise_project_update` AFTER UPDATE ON `enterprise_projects` FOR EACH ROW BEGIN
    IF OLD.status != NEW.status THEN
        CALL UpdateEnterpriseStatistics(NEW.enterprise_id);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table person_projects
-- ----------------------------
DROP TRIGGER IF EXISTS `tr_person_project_update`;
delimiter ;;
CREATE TRIGGER `tr_person_project_update` AFTER UPDATE ON `person_projects` FOR EACH ROW BEGIN
    IF OLD.status != NEW.status THEN
        CALL UpdatePersonStatistics(NEW.person_id);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table person_tasks
-- ----------------------------
DROP TRIGGER IF EXISTS `tr_person_task_update`;
delimiter ;;
CREATE TRIGGER `tr_person_task_update` AFTER UPDATE ON `person_tasks` FOR EACH ROW BEGIN
    IF OLD.status != NEW.status THEN
        CALL UpdatePersonStatistics(NEW.person_id);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table resources
-- ----------------------------
DROP TRIGGER IF EXISTS `tr_resource_update`;
delimiter ;;
CREATE TRIGGER `tr_resource_update` AFTER UPDATE ON `resources` FOR EACH ROW BEGIN
    IF OLD.status != NEW.status OR OLD.resource_type_id != NEW.resource_type_id THEN
        CALL UpdateResourceStatistics(NEW.resource_type_id);
        IF OLD.resource_type_id != NEW.resource_type_id THEN
            CALL UpdateResourceStatistics(OLD.resource_type_id);
        END IF;
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
