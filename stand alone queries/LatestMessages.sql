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
			where cgm1.u_id='krishnakantha#BgFccgFjegjcH' 
					and cgm1.g_id='gtemp1' 
					and cgm1.gmsg_created_on<=(select gm_user_last_seen_in_group from cnvo_group_members cgmber where cgmber.u_id='krishnakantha#BgFccgFjegjcH' and cgmber.g_id='gtemp1')
			order by cgm1.gmsg_id desc
			limit greatest(0,-1)) partial_table left join cnvo_users cu2 on partial_table.replyed_message_user_id = cu2.u_id) complete_table, cnvo_users cu1
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
			where cgm1.u_id='krishnakantha#BgFccgFjegjcH' 
					and cgm1.g_id='gtemp1' 
					and cgm1.gmsg_created_on>(select gm_user_last_seen_in_group from cnvo_group_members cgmber where cgmber.u_id='krishnakantha#BgFccgFjegjcH' and cgmber.g_id='gtemp1')
			order by cgm1.gmsg_id desc
			limit 20) partial_table left join cnvo_users cu2 on partial_table.replyed_message_user_id = cu2.u_id) complete_table, cnvo_users cu1
	where complete_table.user_id = cu1.u_id order by message_id
	)
select * from old_messages
union all
select -1,null,null,null,'New Messages','SYS',current_timestamp,null,null,null,null where 1=2
union all
select * from new_messages;




