/*
The login process when starting the User Panel.
*/
DECLARE
	v_login_email tokens_url.login_email%TYPE;
	v_name_user VARCHAR2(500 CHAR);

BEGIN
		
        :NR_IF_LOGIN := 1;
		:NR_INBOX := v_unread_messages;
		:ID_USER := v_id_user;
		:NAME_USER := v_first_name||' '||v_second_name||' '||v_surname;
		:EUR := shop.available_eur(v_id_user);
END;