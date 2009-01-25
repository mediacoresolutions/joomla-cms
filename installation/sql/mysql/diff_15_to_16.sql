# $Id$

# 1.5 to 1.6

-- 2008-08-25

ALTER TABLE `jos_core_acl_groups_aro_map`
 ADD INDEX aro_id_group_id_group_aro_map USING BTREE(`aro_id`, `group_id`);

--

ALTER TABLE `jos_weblinks`
 CHANGE `published` `state` TINYINT( 1 ) NOT NULL DEFAULT '0';

-- 2008-10-10

DROP TABLE `jos_groups`;

--
-- Table structure for table `jos_core_acl_acl`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_acl` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `section_value` varchar(100) NOT NULL default 'system',
  `allow` int(1) unsigned NOT NULL default '0',
  `enabled` int(1) unsigned NOT NULL default '0',
  `return_value` varchar(250) default NULL,
  `note` varchar(250) default NULL,
  `updated_date` int(10) unsigned NOT NULL default '0',
  `acl_type` int(1) unsigned NOT NULL default '1' COMMENT 'Defines to what level AXOs apply to the rule',
  `name` varchar(100) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `core_acl_enabled_acl` (`enabled`),
  KEY `core_acl_section_value_acl` (`section_value`),
  KEY `core_acl_updated_date_acl` (`updated_date`),
  KEY `core_acl_type` USING BTREE (`acl_type`),
  KEY `core_acl_name` USING BTREE (`name`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

-- --------------------------------------------------------

--
-- Table structure for table `jos_core_acl_acl_sections`
--


CREATE TABLE IF NOT EXISTS `jos_core_acl_acl_sections` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `value` varchar(100) NOT NULL default '',
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(230) NOT NULL default '',
  `hidden` int(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `core_acl_value_acl_sections` (`value`),
  KEY `core_acl_hidden_acl_sections` (`hidden`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

INSERT IGNORE INTO `jos_core_acl_acl_sections` VALUES (1, 'system', 1, 'System', 0);
INSERT IGNORE INTO `jos_core_acl_acl_sections` VALUES (2, 'user', 2, 'User', 0);

-- --------------------------------------------------------


--
-- Table structure for table `jos_core_acl_aco`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_aco` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `section_value` varchar(100) NOT NULL default '0',
  `value` varchar(100) NOT NULL default '',
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `hidden` int(1) unsigned NOT NULL default '0',
  `acl_type` int(1) unsigned NOT NULL default '1' COMMENT 'Defines to what level AXOs apply',
  `note` mediumtext,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `core_acl_section_value_aco` (`section_value`,`value`),
  KEY `core_acl_hidden_aco` (`hidden`),
  KEY `core_acl_type_section` USING BTREE (`acl_type`,`section_value`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

-- --------------------------------------------------------

--
-- Table structure for table `jos_core_acl_aco_map`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_aco_map` (
  `acl_id` int(10) unsigned NOT NULL default '0',
  `section_value` varchar(100) NOT NULL default '0',
  `value` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`acl_id`,`section_value`,`value`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

-- --------------------------------------------------------

--
-- Table structure for table `jos_core_acl_aco_sections`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_aco_sections` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `value` varchar(100) NOT NULL default '',
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(230) NOT NULL default '',
  `hidden` int(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `core_acl_value_aco_sections` (`value`),
  KEY `core_acl_hidden_aco_sections` (`hidden`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

-- --------------------------------------------------------

--
-- Table structure for table `jos_core_acl_aro_map`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_aro_map` (
  `acl_id` int(10) unsigned NOT NULL default '0',
  `section_value` varchar(100) NOT NULL default '0',
  `value` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`acl_id`,`section_value`,`value`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

CREATE TABLE IF NOT EXISTS  `jos_core_acl_aro_groups_map` (
  `acl_id` int(11) NOT NULL default '0',
  `group_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`acl_id`,`group_id`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

-- --------------------------------------------------------

--
-- Table structure for table `jos_core_acl_axo`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_axo` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `section_value` varchar(100) NOT NULL default '0',
  `value` int(10) NOT NULL,
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `hidden` int(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `core_acl_hidden_axo` USING BTREE (`hidden`),
  KEY `core_acl_section_value_value_axo` USING BTREE (`section_value`,`value`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

-- --------------------------------------------------------

--
-- Table structure for table `jos_core_acl_axo_groups`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_axo_groups` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `parent_id` int(10) unsigned NOT NULL default '0',
  `lft` int(10) unsigned NOT NULL default '0',
  `rgt` int(10) unsigned NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `value` int(10) NOT NULL,
  `section_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`,`value`),
  KEY `core_acl_parent_id_axo_groups` USING BTREE (`parent_id`),
  KEY `core_acl_lft_rgt_axo_groups` USING BTREE (`lft`,`rgt`),
  KEY `core_acl_section_value` USING BTREE (`section_id`),
  KEY `core_acl_value_axo_groups` USING BTREE (`value`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

INSERT IGNORE INTO `jos_core_acl_axo_groups` VALUES (1, 0, 1, 8, 'ROOT', -1, 0);
INSERT IGNORE INTO `jos_core_acl_axo_groups` VALUES (2, 1, 2, 3, 'Public', '0', 0);
INSERT IGNORE INTO `jos_core_acl_axo_groups` VALUES (3, 1, 4, 5, 'Registered', '1', 0);
INSERT IGNORE INTO `jos_core_acl_axo_groups` VALUES (4, 1, 6, 7, 'Special', '2', 0);

-- --------------------------------------------------------

--
-- Table structure for table `jos_core_acl_axo_groups_map`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_axo_groups_map` (
  `acl_id` int(10) unsigned NOT NULL default '0',
  `group_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`acl_id`,`group_id`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

-- --------------------------------------------------------

--
-- Table structure for table `jos_core_acl_axo_map`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_axo_map` (
  `acl_id` int(10) unsigned NOT NULL default '0',
  `section_value` varchar(100) NOT NULL default '0',
  `value` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`acl_id`,`section_value`,`value`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

-- --------------------------------------------------------

--
-- Table structure for table `jos_core_acl_axo_sections`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_axo_sections` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `value` varchar(100) NOT NULL default '',
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(230) NOT NULL default '',
  `hidden` int(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `core_acl_value_axo_sections` (`value`),
  KEY `core_acl_hidden_axo_sections` (`hidden`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

-- --------------------------------------------------------

--
-- Table structure for table `jos_core_acl_groups_axo_map`
--

CREATE TABLE IF NOT EXISTS `jos_core_acl_groups_axo_map` (
  `group_id` int(10) unsigned NOT NULL default '0',
  `axo_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`group_id`,`axo_id`),
  KEY `jos_core_acl_axo_id` (`axo_id`),
  INDEX `group_id_axo_id_groups_axo_map` USING BTREE(`axo_id`, `group_id`),
  INDEX `aro_id_group_id_groups_axo_map` USING BTREE(`group_id`, `axo_id`)
) ENGINE=MyISAM CHARACTER SET `utf8`;

INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'core', -1, 'Core', 0);

INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_banners', 0, 'Banners', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_categories', 0, 'Categories', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_contact', 0, 'Contact', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_content', 0, 'Content', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_mailto', 0, 'Mail To', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_massmail', 0, 'Massmail', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_media', 0, 'Media Manager', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_messages', 0, 'Messages', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_newsfeeds', 0, 'Newsfeeds', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_poll', 0, 'Polls', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_search', 0, 'Search', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_sections', 0, 'Sections', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_trash', 0, 'Trash', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_user', 0, 'User Frontend', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_users', 0, 'Users Backend', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_weblinks', 0, 'Weblinks', 0);
INSERT INTO `jos_core_acl_acl_sections` VALUES (0, 'com_wrapper', 0, 'Wrapper', 0);

INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'core', -1, 'Core', 0);

INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_banners', 0, 'Banners', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_categories', 0, 'Categories', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_contact', 0, 'Contact', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_content', 0, 'Content', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_mailto', 0, 'Mail To', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_massmail', 0, 'Massmail', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_media', 0, 'Media Manager', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_messages', 0, 'Messages', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_newsfeeds', 0, 'Newsfeeds', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_poll', 0, 'Polls', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_search', 0, 'Search', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_sections', 0, 'Sections', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_trash', 0, 'Trash', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_user', 0, 'User Frontend', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_users', 0, 'Users Backend', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_weblinks', 0, 'Weblinks', 0);
INSERT INTO `jos_core_acl_aco_sections` VALUES (0, 'com_wrapper', 0, 'Wrapper', 0);

INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_banners', 0, 'Banners', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_categories', 0, 'Categories', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_contact', 0, 'Contact', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_content', 0, 'Content', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_massmail', 0, 'Massmail', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_media', 0, 'Media Manager', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_messages', 0, 'Messages', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_newsfeeds', 0, 'Newsfeeds', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_poll', 0, 'Polls', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_user', 0, 'User Frontend', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_users', 0, 'Users Backend', 0);
INSERT INTO `jos_core_acl_axo_sections` VALUES (0, 'com_weblinks', 0, 'Weblinks', 0);

-- Type 1 Permissions

INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'login', 0, 'Login', 0, 1, 'ACO System Login Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'event.email', 0, 'Email Event', 0, 1, 'ACO System Email Event Desc');

INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'acl.manage', 0, 'Manage Global Access Control', 0, 1, 'ACO ACL Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'checkin.manage', 0, 'Manage Global Checkins', 0, 1, 'ACO Checkin Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'cache.manage', 0, 'Manage Global Cache', 0, 1, 'ACO Cache Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'config.manage', 0, 'Manage Global Configuration', 0, 1, 'ACO Config Manage Desc');

INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'component.install', 0, 'Install Components', 0, 1, 'ACO Component Install Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'language.install', 0, 'Install Langauges', 0, 1, 'ACO Language Install Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'module.install', 0, 'Install Modules', 0, 1, 'ACO Module Install Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'plugin.install', 0, 'Install Plugins', 0, 1, 'ACO Plugin Install Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'template.install', 0, 'Install Templates', 0, 1, 'ACO Template Install Desc');

INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'language.manage', 0, 'Manage Langauges', 0, 1, 'ACO Language Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'module.manage', 0, 'Manage Modules', 0, 1, 'ACO Module Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'plugin.manage', 0, 'Manage Plugins', 0, 1, 'ACO Plugin Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'template.manage', 0, 'Manage Templates', 0, 1, 'ACO Template Manage Desc');

INSERT INTO `jos_core_acl_aco` VALUES (0, 'core', 'menu.manage', 0, 'Manage Menus', 0, 1, 'ACO Menus Manage Desc');

INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_banners', 'manage', 0, 'Manage', 0, 1, 'ACO Banners Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_categories', 'manage', 0, 'Manage', 0, 1, 'ACO Categories Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_contact', 'manage', 0, 'Manage', 0, 1, 'ACO Contacts Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_content', 'articles.manage', 0, 'Manage Article', 0, 1, 'ACO Content Manage Article Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_content', 'frontpage.manage', 0, 'Manage Frontpage', 0, 1, 'ACO Content Manage Frontpage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_massmail', 'manage', 0, 'Manage', 0, 1, 'ACO Massmail Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_media', 'manage', 0, 'Manage', 0, 1, 'ACO Media Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_menus', 'type.manage', 0, 'Manage Menu Types', 0, 1, 'ACO Menus Manage Types Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_menus', 'menus.manage', 0, 'Manage Menu Items', 0, 1, 'ACO Menus Manage Items Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_modules', 'manage', 0, 'Manage', 0, 1, 'ACO Modules Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_newsfeeds', 'manage', 0, 'Manage', 0, 1, 'ACO Newsfeeds Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_poll', 'manage', 0, 'Manage', 0, 1, 'ACO Poll Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_sections', 'manage', 0, 'Manage', 0, 1, 'ACO Sections Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_trash', 'manage', 0, 'Manage', 0, 1, 'ACO Trash Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_user', 'profile.edit', 0, 'Edit Profile', 0, 1, 'ACO User Edit Profile Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_users', 'manage', 0, 'Manage', 0, 1, 'ACO Users Manage Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_users', 'user.block', 0, 'Block User', 0, 1, 'ACO Users Block User Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_users', 'event.email', 0, 'Email Event', 0, 1, 'ACO Users Email Event Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_weblinks', 'manage', 0, 'Manage', 0, 1, 'ACO Weblinks Manage Desc');

-- Type 2 Permissions

INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_content', 'article.add', 0, 'Add Article', 0, 2, 'ACO Content Add Article Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_content', 'article.edit', 0, 'Edit Article', 0, 2, 'ACO Content Edit Article Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_content', 'article.publish', 0, 'Publish Article', 0, 2, 'ACO Content Publish Article Desc');

-- Type 3 Permissions

INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_content', 'article.view', 0, 'View Articles', 0, 3, 'ACO Content View Articles Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_categories', 'category.view', 0, 'View Categories', 0, 3, 'ACO Categories View Categories Desc');
INSERT INTO `jos_core_acl_aco` VALUES (0, 'com_sections', 'section.view', 0, 'View Sections', 0, 3, 'ACO Sections View Sections Desc');


# Update Sites
CREATE TABLE  `jos_updates` (
  `update_id` int(11) NOT NULL auto_increment,
  `update_site_id` int(11) default '0',
  `extension_id` int(11) default '0',
  `categoryid` int(11) default '0',
  `name` varchar(100) default '',
  `description` text,
  `element` varchar(100) default '',
  `type` varchar(20) default '',
  `folder` varchar(20) default '',
  `client_id` tinyint(3) default '0',
  `version` varchar(10) default '',
  `data` text,
  `detailsurl` text,
  PRIMARY KEY  (`update_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Available Updates';

CREATE TABLE  `jos_update_sites` (
  `update_site_id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default '',
  `type` varchar(20) default '',
  `location` text,
  `enabled` int(11) default '0',
  PRIMARY KEY  (`update_site_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Update Sites';

CREATE TABLE `jos_update_sites_extensions` (
  `update_site_id` INT DEFAULT 0,
  `extension_id` INT DEFAULT 0,
  INDEX `newindex`(`update_site_id`, `extension_id`)
) ENGINE = MYISAM CHARACTER SET utf8 COMMENT = 'Links extensions to update sites';

CREATE TABLE  `jos_update_categories` (
  `categoryid` int(11) NOT NULL auto_increment,
  `name` varchar(20) default '',
  `description` text,
  `parent` int(11) default '0',
  `updatesite` int(11) default '0',
  PRIMARY KEY  (`categoryid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Update Categories';


CREATE TABLE  `jos_tasks` (
  `taskid` int(10) unsigned NOT NULL auto_increment,
  `tasksetid` int(10) unsigned NOT NULL default '0',
  `data` text,
  `offset` int(11) default '0',
  `total` int(11) default '0',
  PRIMARY KEY  (`taskid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Individual tasks';

CREATE TABLE  `jos_tasksets` (
  `tasksetid` int(10) unsigned NOT NULL auto_increment,
  `taskname` varchar(100) default '',
  `extensionid` int(10) unsigned default '0',
  `executionpage` text,
  `landingpage` text,
  PRIMARY KEY  (`tasksetid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Task Sets';


--
-- 25 Jan 2009
--
-- Note: this will supercede traditional GACL tables above

--
-- Table structure for table `#__access_actions`
--

CREATE TABLE IF NOT EXISTS `#__access_actions` (
  `id` int(10) unsigned NOT NULL auto_increment COMMENT 'Primary Key',
  `section_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_sections.id',
  `name` varchar(100) NOT NULL default '',
  `title` varchar(100) NOT NULL default '',
  `description` text,
  `access_type` int(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `idx_action_name_lookup` (`section_id`,`name`),
  KEY `idx_acl_manager_lookup` (`access_type`,`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__access_action_rule_map`
--

CREATE TABLE IF NOT EXISTS `#__access_action_rule_map` (
  `action_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_actions.id',
  `rule_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_rules.id',
  PRIMARY KEY  (`action_id`,`rule_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__access_assetgroups`
--

CREATE TABLE IF NOT EXISTS `#__access_assetgroups` (
  `id` int(10) unsigned NOT NULL auto_increment COMMENT 'Primary Key',
  `parent_id` int(10) unsigned NOT NULL default '0' COMMENT 'Adjacency List Reference Id',
  `left_id` int(10) unsigned NOT NULL default '0' COMMENT 'Nested Set Reference Id',
  `right_id` int(10) unsigned NOT NULL default '0' COMMENT 'Nested Set Reference Id',
  `title` varchar(100) NOT NULL default '',
  `section_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_sections.id',
  `section` varchar(100) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `idx_assetgroup_title_lookup` (`section`,`title`),
  KEY `idx_assetgroup_adjacency_lookup` (`parent_id`),
  KEY `idx_assetgroup_nested_set_lookup` USING BTREE (`left_id`,`right_id`, `section_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__access_assetgroup_rule_map`
--

CREATE TABLE IF NOT EXISTS `#__access_assetgroup_rule_map` (
  `group_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_assetgroups.id',
  `rule_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_rules.id',
  PRIMARY KEY  (`group_id`,`rule_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__access_assets`
--

CREATE TABLE IF NOT EXISTS `#__access_assets` (
  `id` int(10) unsigned NOT NULL auto_increment COMMENT 'Primary Key',
  `section_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_sections.id',
  `section` varchar(100) NOT NULL default '0',
  `name` varchar(100) NOT NULL default '',
  `title` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `idx_asset_name_lookup` (`section_id`,`name`),
  KEY `idx_asset_section_lookup` (`section`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__access_asset_assetgroup_map`
--

CREATE TABLE IF NOT EXISTS `#__access_asset_assetgroup_map` (
  `asset_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_assets.id',
  `group_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_assetgroups.id',
  PRIMARY KEY  (`asset_id`,`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__access_asset_rule_map`
--

CREATE TABLE IF NOT EXISTS `#__access_asset_rule_map` (
  `asset_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_assets.id',
  `rule_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_rules.id',
  PRIMARY KEY  (`asset_id`,`rule_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__access_rules`
--

CREATE TABLE IF NOT EXISTS `#__access_rules` (
  `id` int(10) unsigned NOT NULL auto_increment COMMENT 'Primary Key',
  `section_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_sections.id',
  `section` varchar(100) NOT NULL default '0',
  `name` varchar(100) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `description` varchar(255) default NULL,
  `ordering` int(11) NOT NULL default '0',
  `allow` int(1) unsigned NOT NULL default '0',
  `enabled` int(1) unsigned NOT NULL default '0',
  `access_type` int(1) unsigned NOT NULL default '0',
  `updated_date` int(10) unsigned NOT NULL default '0',
  `return` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `idx_rule_name_lookup` (`section_id`,`name`),
  KEY `idx_access_check` (`enabled`, `allow`),
  KEY `idx_updated_lookup` (`updated_date`),
  KEY `idx_action_section_lookup` (`section`),
  KEY `idx_acl_manager_lookup` (`access_type`,`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__access_sections`
--

CREATE TABLE IF NOT EXISTS `#__access_sections` (
  `id` int(10) unsigned NOT NULL auto_increment COMMENT 'Primary Key',
  `name` varchar(100) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `ordering` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `idx_section_name_lookup` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__usergroups`
--

CREATE TABLE IF NOT EXISTS `#__usergroups` (
  `id` int(10) unsigned NOT NULL auto_increment COMMENT 'Primary Key',
  `parent_id` int(10) unsigned NOT NULL default '0' COMMENT 'Adjacency List Reference Id',
  `left_id` int(10) unsigned NOT NULL default '0' COMMENT 'Nested Set Reference Id',
  `right_id` int(10) unsigned NOT NULL default '0' COMMENT 'Nested Set Reference Id',
  `title` varchar(100) NOT NULL default '',
  `section_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_sections.id',
  `section` varchar(100) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `idx_usergroup_title_lookup` (`section`,`title`),
  KEY `idx_usergroup_adjacency_lookup` (`parent_id`),
  KEY `idx_usergroup_nested_set_lookup` USING BTREE (`left_id`,`right_id`, `section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__usergroup_rule_map`
--

CREATE TABLE IF NOT EXISTS `#__usergroup_rule_map` (
  `group_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__usergroups.id',
  `rule_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_rules.id',
  PRIMARY KEY  (`group_id`,`rule_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__user_rule_map`
--

CREATE TABLE IF NOT EXISTS `#__user_rule_map` (
  `user_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__users.id',
  `rule_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__access_rules.id',
  PRIMARY KEY  (`user_id`,`rule_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__user_usergroup_map`
--

CREATE TABLE IF NOT EXISTS `#__user_usergroup_map` (
  `user_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__users.id',
  `group_id` int(10) unsigned NOT NULL default '0' COMMENT 'Foreign Key to #__usergroups.id',
  PRIMARY KEY  (`user_id`,`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
