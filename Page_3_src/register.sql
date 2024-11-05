DECLARE
	if_successful BOOLEAN;

BEGIN
	authentication.create_customer(
		in_login_email    => :LOGIN_EMAIL,
		in_gender_user    => apex_application.g_x01,
		in_language_user  => apex_application.g_x02,
		in_nr_tel         => apex_application.g_x03,
		in_name_user      => apex_application.g_x04,
		out_if_successful => if_successful);
	apex_json.open_object;
	apex_json.write('if_successful', if_successful);
	apex_json.close_object;
END;