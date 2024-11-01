/*

*/
DECLARE
	v_is_register     BOOLEAN := false;
	v_have_pay_subsc  BOOLEAN := false;
	v_id_user         users.id_user%TYPE;
	v_name_user       users.name_user%TYPE;
	v_eur             users.balance_available_eur%TYPE;
BEGIN
	:LOGIN_EMAIL := apex_application.g_x01;
	IF authentication.is_exist_user(lower(apex_application.g_x01)) THEN
		v_is_register := true;	
		SELECT id_user,
			name_user,
			balance_available_eur
			INTO
			v_id_user,
			v_name_user,
			v_eur
		FROM users WHERE login_email = lower(apex_application.g_x01);
		:EUR := v_eur;
		:ID_USER := v_id_user;
		:NAME_USER := v_name_user;
		IF authentication.have_pay_subsc(lower(apex_application.g_x01)) THEN
			v_have_pay_subsc := true;
		END IF;
	ELSE
		:EUR := 0.00;
	END IF;
	apex_json.open_object;
	apex_json.write('v_is_register', v_is_register);
	apex_json.write('v_have_pay_subsc', v_have_pay_subsc);
	apex_json.close_object;
END;