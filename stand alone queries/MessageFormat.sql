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
			where cgm1.gmsg_id=7) partial_table left join cnvo_users cu2 on partial_table.replyed_message_user_id = cu2.u_id) complete_table, cnvo_users cu1
where complete_table.user_id = cu1.u_id;	
