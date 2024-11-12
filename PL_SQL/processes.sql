/*
List of all application PL/SQL processes by execution sequence.

Sequence one. Every time the page loads.
*/
BEGIN
    :TEXT_SHOP_CART := 'Value of your shopping cart: '||shop.cart_value(apex_custom_auth.get_session_id)||' EUR.';
    IF :NR_IF_LOGIN IS NULL THEN
    	:NR_IF_LOGIN := 0;
		:NR_ANIM := 1;
		:NR_INBOX := 1;
		:TEXT_IF_LOGIN := 'You are not logged in. Log in / register now.';
    	:TEXT_INBOX := 'Unread messages in your inbox: '||:NR_INBOX;
    ELSE
        IF :NR_IF_LOGIN = 1 THEN
    		:TEXT_IF_LOGIN := 'Logged in as: '||lower(:LOGIN_EMAIL)||'.';
    	ELSIF :NR_IF_LOGIN = 0 THEN
    		:TEXT_IF_LOGIN := 'You are not logged in. Log in / register now.';
        END IF;
    END IF;

	IF :NR_ANIM = 1 THEN
		:TEXT_ANIM := 'Turn off movie animation.';
	ELSIF :NR_ANIM = 0 THEN
		:TEXT_ANIM := 'Turn on movie animation.';
	END IF;
END;
/*
Sequence two. Setting the animation mode.
*/
BEGIN
    :NR_ANIM := apex_application.g_x01;
END;
/*
Sequence three. User login.
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
		:NR_IF_LOGIN := 1;
		:NR_ANIM := 1;
		:NR_INBOX := 1;
		:EUR := v_eur;
		:ID_USER := v_id_user;
		:NAME_USER := v_name_user;
		IF authentication.have_pay_subsc(lower(apex_application.g_x01)) THEN
			v_have_pay_subsc := true;
		END IF;
	END IF;
	apex_json.open_object;
	apex_json.write('v_is_register', v_is_register);
	apex_json.write('v_have_pay_subsc', v_have_pay_subsc);
	apex_json.close_object;
END;
/*
Sequence four. New user registration.
*/
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
/*
Sequence five. Reducing the quantity of a specific product in the shopping cart.
*/
BEGIN
	NULL;
END;
/*
Sequence six. Increasing the quantity of a specific product in the shopping cart.
*/
BEGIN
	NULL;
END;
/*
Sequence seven. Placing an order.
*/
BEGIN
	NULL;
END;
/*
Sequence eight. Sending a message to our sales representative.
*/
BEGIN
    :CONTENT_MESS := apex_application.g_x01||apex_application.g_x02;
	:FILE_MESS := apex_application.g_x03;
END;
