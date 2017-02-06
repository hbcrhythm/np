DROP DATABASE IF EXISTS np;
CREATE DATABASE np DEFAULT CHARACTER SET utf8;
USE np;
DROP TABLE IF EXISTS account;
CREATE TABLE account(
	account char(100) NOT NULL,
	create_time	 int(11) NOT NULL default '0' COMMENT '账号创建时间',
	platform_id  smallint(6) NOT NULL DEFAULT '0' COMMENT '平台id',
	device_no    char(30) NOT NULL DEFAULT '' COMMENT '设备号', 
	channel_id	 smallint(6) NOT NULL default '0' COMMENT '渠道id',
	PRIMARY KEY (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='账号表';

DROP TABLE IF EXISTS role;
CREATE TABLE role(
	id bigint(20) unsigned NOT NULL,
	account char(100) NOT NULL,
	name char(30) NOT NULL COMMENT '名字',
	create_time int(11) NOT NULL DEFAULT '0' COMMENT '角色创建时间',
	login_time int(11) NOT NULL DEFAULT '0' COMMENT '登录时间',
	logout_time int(11) NOT NULL DEFAULT '0' COMMENT '登出时间', 
	level int(4) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
	sex	tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '性别', 	
	career 	tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '职业',
	forbid_talk int(11) NOT NULL DEFAULT '0' COMMENT '禁言结束时间',
	PRIMARY KEY (`id`),
	UNIQUE KEY `name` (`name`),
	KEY `account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';

DROP TABLE IF EXISTS role_assets;
CREATE TABLE role_assets (
	id bigint(20) unsigned NOT NULL,
	exp bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '经验值',
	coin int(11) NOT NULL DEFAULT '0' COMMENT '铜钱',
	gold int(11) NOT NULL DEFAULT '0' COMMENT '元宝',
	gold_acc int(11) NOT NULL DEFAULT '0' COMMENT '累计充值元宝',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS role_mods;
CREATE TABLE role_mods(
	id bigint(20) unsigned NOT NULL,
	pos varchar(255) NOT NULL DEFAULT '' COMMENT '位置',
	bag text NOT NULL DEFAULT '' COMMENT '背包',
    fuben text NOT NULL DEFAULT '' COMMENT '副本信息',
    task text NOT NULL DEFAULT '' COMMENT '任务信息',
    hang text NOT NULL DEFAULT '' COMMENT '挂机信息',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='角色数据';

DROP TABLE IF EXISTS forbid;
CREATE TABLE forbid(
	id bigint(20) unsigned NOT NULL COMMENT '角色id',
	name char(30) NOT NULL COMMENT '角色名',
	admin_name char(30) NOT NULL COMMENT '管理员名字',
	start_time int(11) NOT NULL DEFAULT '0' COMMENT '封禁开始时间',
	end_time int(11) NOT NULL DEFAULT '0' COMMENT '封禁结束时间',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='禁言表';

DROP CREATE IF EXISTS sys_env;
CREATE TABLE sys_env(
	id tinyint(1) unsigned NOT NULL auto_increment,
	ids text NOT NULL DEFAULT '' COMMENT '服務器的ids列表',
	PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统环境表';

