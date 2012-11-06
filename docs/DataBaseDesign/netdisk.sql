-- 网络硬盘
DROP TABLE IF EXISTS BC_NETDISK_COMMENT;
DROP TABLE IF EXISTS BC_NETDISK_SHARE;
DROP TABLE IF EXISTS BC_NETDISK_VISIT;
DROP TABLE IF EXISTS BC_NETDISK_FILE;

-- 网络文件
CREATE TABLE BC_NETDISK_FILE(
	ID INT NOT NULL,
	PID INT,
	STATUS_ INT DEFAULT 0 NOT NULL,
	TYPE_ INT DEFAULT 0 NOT NULL,
	NAME VARCHAR(500) NOT NULL,
	SIZE_ INT DEFAULT 0 NOT NULL,
	EXT VARCHAR(10),
	ORDER_ VARCHAR(100),
	PATH VARCHAR(500),
	EDIT_ROLE INT DEFAULT 0 NOT NULL,
	BATCH_NO VARCHAR(500), 
	AUTHOR_ID INT NOT NULL,
	FILE_DATE TIMESTAMP NOT NULL,
	MODIFIER_ID INT,
	MODIFIED_DATE TIMESTAMP,
	CONSTRAINT BCPK_ND_FILE PRIMARY KEY (ID)
);
COMMENT ON TABLE BC_NETDISK_FILE IS '网络文件';
COMMENT ON COLUMN BC_NETDISK_FILE.ID IS 'ID';
COMMENT ON COLUMN BC_NETDISK_FILE.PID IS '所在文件夹ID';
COMMENT ON COLUMN BC_NETDISK_FILE.STATUS_ IS '状态 : 0-正常,1-已删除';
COMMENT ON COLUMN BC_NETDISK_FILE.TYPE_ IS '类型 : 0-文件夹,1-文件';
COMMENT ON COLUMN BC_NETDISK_FILE.NAME IS '名称 : (不带路径的部分)';
COMMENT ON COLUMN BC_NETDISK_FILE.SIZE_ IS '大小 : 字节单位,文件大小或文件夹的总大小';
COMMENT ON COLUMN BC_NETDISK_FILE.EXT IS '扩展名 : 仅适用于文件类型';
COMMENT ON COLUMN BC_NETDISK_FILE.ORDER_ IS '排序号';
COMMENT ON COLUMN BC_NETDISK_FILE.PATH IS '保存路径 : 相对于[NETDISK]目录下的子路径,开头不要带符号/,仅适用于文件类型';
COMMENT ON COLUMN BC_NETDISK_FILE.EDIT_ROLE IS '编辑权限 : 0-编辑者可修改,1-只有拥有者可修改';
COMMENT ON COLUMN BC_NETDISK_FILE.BATCH_NO IS '批号:标识是否是上传文件夹时到一批上传的文件';
COMMENT ON COLUMN BC_NETDISK_FILE.AUTHOR_ID IS '创建人ID';
COMMENT ON COLUMN BC_NETDISK_FILE.FILE_DATE IS '创建时间';
COMMENT ON COLUMN BC_NETDISK_FILE.MODIFIER_ID IS '最后修改人ID';
COMMENT ON COLUMN BC_NETDISK_FILE.MODIFIED_DATE IS '最后修改时间';
ALTER TABLE BC_NETDISK_FILE ADD CONSTRAINT BCFK_ND_FILE_PID FOREIGN KEY (PID)
	REFERENCES BC_NETDISK_FILE (ID) ON UPDATE NO ACTION ;
ALTER TABLE BC_NETDISK_FILE ADD CONSTRAINT BCFK_ND_FILE_AUTHOR FOREIGN KEY (AUTHOR_ID)
	REFERENCES BC_IDENTITY_ACTOR_HISTORY (ID);
ALTER TABLE BC_NETDISK_FILE ADD CONSTRAINT BCFK_ND_FILE_MODIFIER FOREIGN KEY (MODIFIER_ID)
	REFERENCES BC_IDENTITY_ACTOR_HISTORY (ID);

-- 网络文件访问权限
CREATE TABLE BC_NETDISK_SHARE(
	ID INT NOT NULL,
	PID INT DEFAULT 0 NOT NULL,
	ROLE_ VARCHAR(4) NOT NULL,
	AID INT NOT NULL,
	CONSTRAINT BCPK_ND_SHARE PRIMARY KEY (ID)
);
COMMENT ON TABLE BC_NETDISK_SHARE IS '网络文件访问权限';
COMMENT ON COLUMN BC_NETDISK_SHARE.ID IS 'ID';
COMMENT ON COLUMN BC_NETDISK_SHARE.PID IS '文件ID';
COMMENT ON COLUMN BC_NETDISK_SHARE.ROLE_ IS '访问权限 : 用4为数字表示(wrfd:w-编辑,r-查看,f-评论,d-下载),每位数的值为0或1,1代表拥有此权限';
COMMENT ON COLUMN BC_NETDISK_SHARE.AID IS '访问人ID';
ALTER TABLE BC_NETDISK_SHARE ADD CONSTRAINT BCFK_ND_FILE_SHARE FOREIGN KEY (PID)
	REFERENCES BC_NETDISK_FILE (ID) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE BC_NETDISK_SHARE ADD CONSTRAINT BCFK_ND_SHARE_AID FOREIGN KEY (AID)
	REFERENCES BC_IDENTITY_ACTOR (ID);

-- 网络文件评论
CREATE TABLE BC_NETDISK_COMMENT(
	ID INT NOT NULL,
	PID INT DEFAULT 0 NOT NULL,
	AID INT NOT NULL,
	FILE_DATE TIMESTAMP NOT NULL,
	DESC_ VARCHAR(4000) NOT NULL,
	CONSTRAINT BCPK_ND_COMMENT PRIMARY KEY (ID)
);
COMMENT ON TABLE BC_NETDISK_COMMENT IS '网络文件评论';
COMMENT ON COLUMN BC_NETDISK_COMMENT.ID IS 'ID';
COMMENT ON COLUMN BC_NETDISK_COMMENT.PID IS '文件ID';
COMMENT ON COLUMN BC_NETDISK_COMMENT.AID IS '评论人ID';
COMMENT ON COLUMN BC_NETDISK_COMMENT.FILE_DATE IS '评论时间';
COMMENT ON COLUMN BC_NETDISK_COMMENT.DESC_ IS '评论内容';
ALTER TABLE BC_NETDISK_COMMENT ADD CONSTRAINT BCFK_ND_FILE_COMMENT FOREIGN KEY (PID)
	REFERENCES BC_NETDISK_FILE (ID) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE BC_NETDISK_COMMENT ADD CONSTRAINT BCFK_ND_COMMENT_AID FOREIGN KEY (AID)
	REFERENCES BC_IDENTITY_ACTOR_HISTORY (ID);

-- 网络文件访问记录
CREATE TABLE BC_NETDISK_VISIT(
	ID INT NOT NULL,
	PID INT DEFAULT 0 NOT NULL,
	AID INT NOT NULL,
	TYPE_ INT DEFAULT 0 NOT NULL,
	DESC_ VARCHAR(4000) NOT NULL,
	CONSTRAINT BCPK_ND_VISIT PRIMARY KEY (ID)
);
COMMENT ON TABLE BC_NETDISK_VISIT IS '网络文件访问记录';
COMMENT ON COLUMN BC_NETDISK_VISIT.ID IS 'ID';
COMMENT ON COLUMN BC_NETDISK_VISIT.PID IS '文件ID';
COMMENT ON COLUMN BC_NETDISK_VISIT.AID IS '访问人ID';
COMMENT ON COLUMN BC_NETDISK_VISIT.TYPE_ IS '访问类型 : 0-查看,1-整理,2-更改权限';
COMMENT ON COLUMN BC_NETDISK_VISIT.DESC_ IS '说明';
ALTER TABLE BC_NETDISK_VISIT ADD CONSTRAINT BCFK_ND_FILE_VISIT FOREIGN KEY (PID)
	REFERENCES BC_NETDISK_FILE (ID) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE BC_NETDISK_VISIT ADD CONSTRAINT BCFK_ND_VISIT_AID FOREIGN KEY (AID)
	REFERENCES BC_IDENTITY_ACTOR_HISTORY (ID);
