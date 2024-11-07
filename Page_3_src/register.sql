DECLARE
	if_successful     BOOLEAN;
	v_id_user         users.id_user%TYPE;
	v_eur             users.balance_available_eur%TYPE;

BEGIN
	authentication.create_customer(
		in_login_email    => :LOGIN_EMAIL,
		in_gender_user    => apex_application.g_x01,
		in_language_user  => apex_application.g_x02,
		in_nr_tel         => apex_application.g_x03,
		in_name_user      => apex_application.g_x04,
		out_if_successful => if_successful);
	IF if_successful THEN
		SELECT id_user,
			balance_available_eur
		INTO
			v_id_user,
			v_eur
		FROM users WHERE login_email = lower(:LOGIN_EMAIL);
		:NR_IF_LOGIN := 1;
		:EUR := v_eur;
		:ID_USER := v_id_user;
		:NAME_USER := apex_application.g_x04;
	END IF;
	apex_json.open_object;
	apex_json.write('if_successful', if_successful);
	apex_json.close_object;
END;