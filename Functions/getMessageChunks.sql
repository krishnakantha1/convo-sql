create or replace function get_message_chunks(
	p_uid varchar,
	p_gid varchar,
	p_last_message_id int
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
	v_msg_chunk_size int := 20;
begin
	return query
		select
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
					from cnvo_group_message cgm1 left join cnvo_group_message cgm2 on cgm1.gmsg_reply_gmsg_id = cgm2.gmsg_id
					where cgm1.gmsg_id<p_last_message_id
							and cgm1.g_id = p_gid
					order by cgm1.gmsg_id desc
					limit v_msg_chunk_size) partial_table left join cnvo_users cu2 on partial_table.replyed_message_user_id = cu2.u_id) complete_table, cnvo_users cu1
		where complete_table.user_id = cu1.u_id
		order by message_id;	

end;
$$



select * from get_message_chunks('krishnakantha#BgFccgFjegjcH','gtemp1',9);


