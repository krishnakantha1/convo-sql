create or replace function get_latest_message(
	p_uid varchar,
	p_gid varchar
	)
returns table(
			r_message_id 					cnvo_group_message.gmsg_id%type, 
			r_user_id 					cnvo_users.u_id%type,
			r_user_name 					cnvo_users.u_name%type,
			r_group_id 					cnvo_group_message.g_id%type,
			r_message_text 				cnvo_group_message.gmsg_message%type,
			r_message_type 				cnvo_group_message.gmsg_type%type,
			r_message_created_on 			cnvo_group_message.gmsg_created_on%type,
			r_replyed_message_id 			cnvo_group_message.gmsg_id%type,
			r_replyed_message_user_id 	cnvo_users.u_id%type,
			r_replyed_message_username 	cnvo_users.u_name%type,
			r_replyed_message_text 		cnvo_group_message.gmsg_message%type
		)
language plpgsql
as $$
declare
	v_last_seen timestamp with time zone;
	v_new_message_count int;
begin
	-- get the last seen time for a user in a group.
	select gm_user_last_seen_in_group into v_last_seen
	from cnvo_group_members cgmber 
	where u_id=p_uid and g_id=p_gid;
	
	-- get the count of the number of unread message for the user in a group.
	select count(gmsg_id) into v_new_message_count from cnvo_group_message 
	where g_id = p_gid
		and gmsg_created_on > v_last_seen;
	
	-- return the latest messages in a clean format.
	return query
	with old_messages as
		(select
			message_id, 
			user_id,
			cu1.u_name user_name,
			group_id,
			message_text,
			message_type,
			message_created_on,
			replyed_message_id,
			replyed_message_user_id,
			replyed_message_username,
			replyed_message_text
		from
			(select 
				message_id, 
				user_id,
				group_id,
				message_text,
				message_type,
				message_created_on,
				replyed_message_id,
				replyed_message_user_id,
				cu2.u_name replyed_message_username,
				replyed_message_text
			from
				(select 
					cgm1.gmsg_id message_id,
					cgm1.u_id user_id,
					cgm1.g_id group_id,
					cgm1.gmsg_message message_text,
					cgm1.gmsg_type message_type,
					cgm1.gmsg_created_on message_created_on,
					cgm1.gmsg_reply_gmsg_id replyed_message_id,
					cgm2.u_id replyed_message_user_id,
					cgm2.gmsg_message replyed_message_text
				from cnvo_group_message cgm1 left join cnvo_group_message cgm2 on cgm1.gmsg_reply_gmsg_id=cgm2.gmsg_id
				where cgm1.g_id = p_gid
						and cgm1.gmsg_created_on <= v_last_seen
				order by cgm1.gmsg_id desc
				limit greatest(0,20-v_new_message_count)) partial_table left join cnvo_users cu2 on partial_table.replyed_message_user_id = cu2.u_id) complete_table, cnvo_users cu1
		where complete_table.user_id = cu1.u_id order by message_id
		),
		new_messages as
		(select
			message_id, 
			user_id,
			cu1.u_name user_name,
			group_id,
			message_text,
			message_type,
			message_created_on,
			replyed_message_id,
			replyed_message_user_id,
			replyed_message_username,
			replyed_message_text
		from
			(select 
				message_id, 
				user_id,
				group_id,
				message_text,
				message_type,
				message_created_on,
				replyed_message_id,
				replyed_message_user_id,
				cu2.u_name replyed_message_username,
				replyed_message_text
			from
				(select 
					cgm1.gmsg_id message_id,
					cgm1.u_id user_id,
					cgm1.g_id group_id,
					cgm1.gmsg_message message_text,
					cgm1.gmsg_type message_type,
					cgm1.gmsg_created_on message_created_on,
					cgm1.gmsg_reply_gmsg_id replyed_message_id,
					cgm2.u_id replyed_message_user_id,
					cgm2.gmsg_message replyed_message_text
				from cnvo_group_message cgm1 left join cnvo_group_message cgm2 on cgm1.gmsg_reply_gmsg_id=cgm2.gmsg_id
				where cgm1.g_id = p_gid
						and cgm1.gmsg_created_on > v_last_seen
				) partial_table left join cnvo_users cu2 on partial_table.replyed_message_user_id = cu2.u_id) complete_table, cnvo_users cu1
		where complete_table.user_id = cu1.u_id order by message_id
		)
	select 
		message_id, 
		user_id,
		user_name,
		group_id,
		message_text,
		message_type,
		message_created_on,
		replyed_message_id,
		replyed_message_user_id,
		replyed_message_username,
		replyed_message_text
	from old_messages
	
	union all
	
	select -1,null,null,null,'New Messages','SYS',current_timestamp,null,null,null,null where v_new_message_count>0
	
	union all
	
	select 
		message_id, 
		user_id,
		user_name,
		group_id,
		message_text,
		message_type,
		message_created_on,
		replyed_message_id,
		replyed_message_user_id,
		replyed_message_username,
		replyed_message_text 
	from new_messages;
	
end;
$$


select * from get_latest_message('krishnakantha#BgFccgFjegjcH', 'gtemp1')



