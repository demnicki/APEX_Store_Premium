/*
Processes.

Application processes - after authentication.
*/

DECLARE
	v_id_user         users.id_user%TYPE;
	v_permission_type users.permission_type%TYPE;
	v_name_user       users.name_user%TYPE;
	v_eur             users.balance_available_eur%TYPE;
BEGIN
	SELECT id_user,
		permission_type,
		name_user,
		balance_available_eur
		INTO
		v_id_user,
		v_permission_type,
		v_name_user,
		v_eur
	FROM users WHERE login_email = lower(apex_application.g_user);
	:EUR := v_eur;
	:ID_USER := v_id_user;
	:NAME_USER := v_name_user;
	:PERMISSION_TYPE := v_permission_type;
END;

/*
Processes for page 3.
*/
DECLARE
	if_successful BOOLEAN;

BEGIN
	authentication.create_customer(
		in_login_email    => apex_application.g_user,
		in_gender_user    => apex_application.g_x01,
		in_language_user  => apex_application.g_x02,
		in_nr_tel         => apex_application.g_x03,
		in_name_user      => apex_application.g_x04,
		out_if_successful => if_successful);
	apex_json.open_object;
	apex_json.write('if_successful', if_successful);
	apex_json.close_object;
END;