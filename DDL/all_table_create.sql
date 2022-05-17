-----------------------------------------------------------------------------------------------------------------
-- main user table. contains the user objects data.
-----------------------------------------------------------------------------------------------------------------
create table cnvo_users(
	u_id varchar PRIMARY KEY,
	u_name varchar not NULL,
	u_email varchar not NULL constraint u_email_unique UNIQUE,
	u_password varchar not NULL,
	u_acc_created_on timestamp with time zone default current_timestamp,
	constraint u_password_min_length check(char_length(u_password)>=10),
	constraint u_name_length_limits check(char_length(u_name)>=5 AND char_length(u_name)<=20)
);

insert into cnvo_users(u_id,u_name,u_email,u_password) values('SYSTEM','SYSTEM','SYSTEM@SYSTEM.com','zyjXah6eAzKcB2ThwMD9zmBp722vLkbv5FYt-gj9DgGCu5L6hwlxTVVsrQvi0YGyZ1vVpZ6li7cOflB8sIquyV4_LJnOT22v19yG0_maf8fPwlCN7xfCA9yOi5dEUKWyWa_wb5TWerFO4kubnjXDIP6IIJmWQCghhAi4x0Y6Epk');


truncate table cnvo_users cascade;

-- drop table cnvo_users cascade;

insert into cnvo_users(u_id,u_name,u_email,u_password) values('utemp2','temp1temp1','temp1temp1@gmail.com','1234567891');

select * from cnvo_users;

-----------------------------------------------------------------------------------------------------------------
-- main groups table. contains the group objects data.
-----------------------------------------------------------------------------------------------------------------
create table cnvo_groups(
	g_id varchar primary key,
	g_name varchar constraint g_name_unique unique,
	g_grp_created_on timestamp with time zone default current_timestamp,
	g_grp_about varchar,
	constraint g_name_length_limit check(char_length(g_name)>=5 AND char_length(g_name)<=20),
	constraint g_grp_about_limit check(char_length(g_grp_about)<=200)
);

--truncate table cnvo_groups cascade;

-- drop table cnvo_groups cascade;

insert into cnvo_groups(g_id,g_name) values('gtemp1','shadowclan');

select * from cnvo_groups;

delete from cnvo_groups where g_id = 'GROUP#first_group#BgFceciggajii';

-----------------------------------------------------------------------------------------------------------------
-- table to relate user to their groups that they have joined.
-----------------------------------------------------------------------------------------------------------------
create table cnvo_group_members(
	gm_id serial PRIMARY KEY,
	u_id varchar,
	g_id varchar,
	gm_grp_joined_on timestamp with time zone default current_timestamp,
	gm_user_last_seen_in_group timestamp with time zone not null default current_timestamp,
	constraint gm_u_id_fk foreign key (u_id) references cnvo_users(u_id) on delete cascade,
	constraint gm_g_id_fk foreign key (g_id) references cnvo_groups(g_id) on delete cascade,
	constraint gm_u_g_unique unique(u_id,g_id)
);

--truncate table cnvo_group_members cascade;

-- drop table cnvo_group_members;

insert into cnvo_group_members(u_id,g_id) values('kirita#BgFccgDcigiBe','gtemp1');

select * from cnvo_group_members;

-- GROUP#shadowclan#BgFceDegjgDDF    GROUP#new_group#BgFceDFHgBigD

delete from cnvo_group_members where u_id='kirita#BgFceDHcBFgaa';

update cnvo_group_members set gm_user_last_seen_in_group = current_timestamp where u_id='kirita#BgFceDHcBFgaa';

-----------------------------------------------------------------------------------------------------------------
-- table to store message from a user to a perticular group.
-- IMP: while gmsg_u_id_fk and gmsg_g_id_fk references their respective group, there is no garentiee that the user
-- that sent the message belongs to the group. there fore it is taken care in the procedure that inserts the 
-- message into the table.
-----------------------------------------------------------------------------------------------------------------
create table cnvo_group_message(
	gmsg_id serial PRIMARY KEY,
	u_id varchar,
	g_id varchar,
	gmsg_message varchar,
	gmsg_type varchar,
	gmsg_created_on timestamp with time zone default current_timestamp,
	gmsg_reply_gmsg_id int,
	
	constraint gmsg_u_id_fk foreign key (u_id) references cnvo_users(u_id),
	constraint gmsg_g_id_fk foreign key (g_id) references cnvo_groups(g_id),
	constraint gmsg_message_limit check(char_length(gmsg_message)>0 AND char_length(gmsg_message)<=1000),
	constraint gmsg_type_choice check(gmsg_type in ('MSG','SYS','RPLY')),
	constraint gmsg_reply_gmsg_id_fk foreign key (gmsg_reply_gmsg_id) references cnvo_group_message(gmsg_id)
);

truncate table cnvo_group_message cascade;

-- drop table cnvo_group_message;

insert into cnvo_group_message(u_id,g_id,gmsg_message,gmsg_type,gmsg_reply_gmsg_id) 
values('kirita#BgFccgDcigiBe','gtemp1','im kirita','MSG',null);

insert into cnvo_group_message(u_id,g_id,gmsg_message,gmsg_type,gmsg_reply_gmsg_id) 
values('kirita#BgFccgDcigiBe','gtemp1','im kirita','RPLY',15);


select * from cnvo_group_message;

delete from cnvo_group_message where gmsg_id in(75,67) or gmsg_reply_gmsg_id in(75,67);

-----------------------------------------------------------------------------------------------------------------
-- table to maintian conection details of users
-----------------------------------------------------------------------------------------------------------------
create table cnvo_user_connections(
	uc_id serial PRIMARY KEY,
	uc_connection_string varchar not null,
	u_id varchar not null,
	uc_connection_created_on timestamp with time zone default current_timestamp,
	uc_connection_end_on timestamp with time zone,
	
	constraint uc_u_id foreign key (u_id) references cnvo_users(u_id)
)

--truncate table cnvo_user_connections cascade;

-- drop table cnvo_user_connections;

insert into cnvo_user_connections(uc_connection_string,u_id) values('abcd','kirita#BgFccgDcigiBe');

--delete from cnvo_user_connections;

select * from cnvo_user_connections;


