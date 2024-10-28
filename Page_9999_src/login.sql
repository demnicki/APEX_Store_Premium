/*

*/
DECLARE
	v_id_user         users.id_user%TYPE;
	v_permission_type users.permission_type%TYPE;
	v_name_user       users.name_user%TYPE;
	v_eur             users.balance_available_eur%TYPE;
BEGIN
	:LOGIN_EMAIL := apex_application.g_x01;
	IF authentication.is_exist_user(lower(apex_application.g_x01)) THEN
		SELECT id_user,
			permission_type,
			name_user,
			balance_available_eur
			INTO
			v_id_user,
			v_permission_type,
			v_name_user,
			v_eur
		FROM users WHERE login_email = lower(apex_application.g_x01);
		:EUR := v_eur;
		:ID_USER := v_id_user;
		:NAME_USER := v_name_user;
		:PERMISSION_TYPE := v_permission_type;
	END IF;
END;