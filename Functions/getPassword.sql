create or replace function get_password(p_email varchar)
returns table(
	d_id cnvo_users.u_id%type,
	d_name cnvo_users.u_name%type,
	d_email cnvo_users.u_email%type,
	d_password cnvo_users.u_password%type
)
language plpgsql
as $$
begin
	return query select u_id as d_id,u_name as d_name,u_email as d_email,u_password as d_password from cnvo_users where u_email = p_email;
end;
$$


select * from get_password('1111@1111.com');