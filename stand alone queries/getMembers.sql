
with all_users_of_group as (
		select distinct cgm.g_id, cgm.u_id
		from cnvo_group_members cgm
		where cgm.g_id = 'GROUP#shadow_clan#BgFcFjjjjcFDB' 
		group by cgm.g_id,cgm.u_id
	),
	all_online_users_of_group as(
		select distinct cgm.g_id, cgm.u_id
		from cnvo_group_members cgm, cnvo_user_connections cuc 
		where cgm.g_id = 'GROUP#shadow_clan#BgFcFjjjjcFDB' 
			and cgm.u_id = cuc.u_id 
			and cuc.uc_connection_end_on is null 
		group by cgm.g_id,cgm.u_id
	)
select all_users.g_id, 
		all_users.u_id, 
 		case 
 			when online_users.u_id is not null then
 				'online'
 			else
 				'offline'
		end status
from all_users_of_group all_users left join all_online_users_of_group online_users 
on all_users.u_id = online_users.u_id;
