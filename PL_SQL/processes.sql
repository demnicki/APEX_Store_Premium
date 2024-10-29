/*
Processes.

The process of generating a user's login status.
*/

BEGIN
	IF authentication.is_exist_user(lower(:LOGIN_EMAIL)) THEN
        :CHECK_LOGIN := 'Logged in as: '||lower(:LOGIN_EMAIL)||'.';
	ELSE
        :CHECK_LOGIN := 'You are not logged in. Log in / register now.';
    END IF;
END;

/*
The process of refreshing the value of the entire shopping cart.
*/

BEGIN
	:SHOP_CART_STATUS := 'Value of your shopping cart: '||shop.cart_value(apex_custom_auth.get_session_id)||' EUR.';
END;

/*
Application processes - Authorization scheme - checking if the user is registered.
*/
BEGIN
	IF authentication.is_exist_user(lower(:LOGIN_EMAIL)) THEN
		RETURN true;
	ELSE
		apex_util.redirect_url (p_url => './register');
	END IF;
END;

/*
Processes for page 3.
*/
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

/*
SQL queries for managing the shopping cart.
*/

