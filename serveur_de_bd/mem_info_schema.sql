create table info_sch_fk (
	nom_tab_fk varchar(30),
	nom_col_fk varchar(30),
	nom_col_fk_pk varchar(30),
	nom_tab_pk varchar(30),
	nom_col_pk varchar(30)
) engine=innodb;
create unique index i_info_sch_bas_1 on info_sch_fk(nom_tab_fk,nom_col_fk);
insert into info_sch_fk
		select RC.TABLE_NAME,KCU.COLUMN_NAME,kcu3.column_name,rc.referenced_table_name,KCU2.COLUMN_NAME
		FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS RC
		inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK on FK.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA and FK.CONSTRAINT_NAME = RC.CONSTRAINT_NAME and FK.CONSTRAINT_TYPE = 'FOREIGN KEY'
		inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU on KCU.CONSTRAINT_NAME=RC.CONSTRAINT_NAME
		inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU2 on KCU2.TABLE_NAME=RC.referenced_TABLE_NAME and kcu2.constraint_name='PRIMARY'
		inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU3 on KCU3.TABLE_NAME=RC.TABLE_NAME and kcu3.constraint_name='PRIMARY'
		where rc.constraint_name like 'fk%' and rc.constraint_schema='gestion_pm2';

