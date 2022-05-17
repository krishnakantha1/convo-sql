create or replace procedure insert_new_message(
	r_message_id inout int,
	r_user_id inout varchar,
	r_user_name inout varchar,
	r_group_id inout varchar,
	r_message_text inout varchar,
	r_message_type inout varchar,
	r_message_created_on inout timestamp with time zone,
	r_replyed_message_id inout int,
	r_replyed_message_user_id inout varchar,
	r_replyed_message_username inout varchar,
	r_replyed_message_text inout varchar,
	
	p_msg inout varchar,
	p_err_buf inout varchar
)
language plpgsql
as $$
declare
	count_entry int := 0;

	temp1 int;
	temp2 varchar;
	temp3 varchar;
	temp4 varchar;
	temp5 varchar;
	temp6 varchar;
	temp7 timestamp with time zone;
	temp8 int;
	temp9 varchar;
	temp10 varchar;
	temp11 varchar;
begin
		--check to see if user is a member of the group hes messaging
		select count(*) into count_entry from cnvo_group_members where u_id = r_user_id and g_id = r_group_id;
		
		if count_entry=0 then
			raise exception using errcode = 'NMBER';
		end if;
		
		--insert user created message into table and get the message id.
		insert into  cnvo_group_message(u_id,g_id,gmsg_message,gmsg_type,gmsg_reply_gmsg_id) 
		values(r_user_id,r_group_id,r_message_text,upper(r_message_type),r_replyed_message_id) 
		returning gmsg_id into r_message_id;
		
		--select the complete [message] format through the message id that was created before.
		select
			complete_table.message_id, 
			complete_table.user_id,
			cu1.u_name,
			complete_table.group_id,
			complete_table.full_message,
			complete_table.message_type,
			complete_table.message_created_on,
			complete_table.replyed_message_id,
			complete_table.replyed_message_user_id,
			complete_table.replyed_message_username,
			complete_table.replyed_message_text
 			into
 				temp1,
				temp2,
				temp3,
				temp4,
				temp5,
				temp6,
				temp7,
				temp8,
				temp9,
				temp10,
				temp11
		from
			(select 
				partial_table.message_id, 
				partial_table.user_id,
				partial_table.group_id,
				partial_table.full_message,
				partial_table.message_type,
				partial_table.message_created_on,
				partial_table.replyed_message_id,
				partial_table.replyed_message_user_id,
				cu2.u_name replyed_message_username,
				partial_table.replyed_message_text
			from
				(select 
					cgm1.gmsg_id message_id,
					cgm1.u_id user_id,
					cgm1.g_id group_id,
					cgm1.gmsg_message full_message,
					cgm1.gmsg_type message_type,
					cgm1.gmsg_created_on message_created_on,
					cgm1.gmsg_reply_gmsg_id replyed_message_id,
					cgm2.u_id replyed_message_user_id,
					cgm2.gmsg_message replyed_message_text
					from cnvo_group_message cgm1 left join cnvo_group_message cgm2 on cgm1.gmsg_reply_gmsg_id = cgm2.gmsg_id
					where cgm1.gmsg_id=r_message_id) partial_table left join cnvo_users cu2 on partial_table.replyed_message_user_id = cu2.u_id) complete_table
				, cnvo_users cu1
		where complete_table.user_id = cu1.u_id;
		
		r_message_id := temp1;
		r_user_id := temp2;
		r_user_name := temp3;
		r_group_id := temp4;
		r_message_text := temp5;
		r_message_type := temp6;
		r_message_created_on := temp7;
		r_replyed_message_id := temp8;
		r_replyed_message_user_id := temp9;
		r_replyed_message_username := temp10;
		r_replyed_message_text := temp11;
		
		p_msg := 'successful';
exception
	when sqlstate 'NMBER' then
		p_err_buf := 'member not in group';
	when others then
		get stacked diagnostics 
			p_err_buf := MESSAGE_TEXT;
end;
$$

--'krishnakantha#BgFccgFjegjcH','gtemp1'




