create or replace procedure create_user_with_details(
	p_id varchar,
	p_name varchar,
	p_email varchar,
	p_password varchar,
	p_msg inout varchar,
	p_err_buf inout varchar
)
language plpgsql
as $$
declare
	stack_var varchar;
begin
	if char_length(p_id)=0 OR char_length(p_name)=0 OR char_length(p_email)=0 OR char_length(p_password)=0 then
		raise exception using 
			errcode='NOPAR';
	end if;
	
	insert into cnvo_users(u_id,u_name,u_email,u_password) values(p_id,p_name,p_email,p_password);
	
	p_msg := 'user created successfully';
	
exception
	when unique_violation then
		get stacked diagnostics 
			stack_var := CONSTRAINT_NAME;
		
		if stack_var = 'u_email_unique' then
			p_err_buf := 'user email already exists.';
		end if;
	when sqlstate 'NOPAR' then
		p_err_buf := 'parameter/s missing';
	when others then
		get stacked diagnostics 
			p_err_buf := MESSAGE_TEXT;
end;
$$