/*
List of all application PL/SQL processes by execution sequence.

Sequence one. Every time the page loads.
*/
DECLARE
	n NUMBER(1);
	v_anim_type       api_sessions.anim_type%TYPE;
	v_unread_messages api_sessions.unread_messages%TYPE;
BEGIN
	SELECT count(session_number) INTO n FROM api_sessions WHERE session_number = apex_custom_auth.get_session_id;
	:TEXT_SHOP_CART := 'Value of your shopping cart: '||shop.cart_value(apex_custom_auth.get_session_id)||' EUR.';
	IF n = 0 THEN
		INSERT INTO api_sessions(session_number, ip, agent) VALUES (apex_custom_auth.get_session_id, owa_util.get_cgi_env('REMOTE_ADDR'), owa_util.get_cgi_env('HTTP_USER_AGENT'));
		COMMIT;
    	:NR_IF_LOGIN := 0;
		:NR_ANIM := 1;
		:NR_INBOX := 1;
		:TEXT_IF_LOGIN := 'You are not logged in. Log in / register now.';
    	:TEXT_INBOX := 'Unread messages in your inbox: '||:NR_INBOX;
	ELSIF n = 1 THEN
		SELECT anim_type, unread_messages INTO v_anim_type, v_unread_messages FROM api_sessions WHERE session_number = apex_custom_auth.get_session_id;
		:NR_ANIM := v_anim_type;
		:NR_INBOX := v_unread_messages;
    	:TEXT_INBOX := 'Unread messages in your inbox: '||:NR_INBOX;
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
BEGIN
	:LOGIN_EMAIL := lower(apex_application.g_x01);
	v_is_register := authentication.is_exist_user(:LOGIN_EMAIL);
	IF v_is_register THEN
		SELECT id_user, name_user INTO v_id_user, v_name_user FROM users WHERE login_email = :LOGIN_EMAIL;
		v_have_pay_subsc := authentication.have_pay_subsc(v_id_user);
		:ID_USER := v_id_user;
		:NAME_USER := v_name_user;
		:EUR := shop.available_eur(v_id_user);
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
	if_successful BOOLEAN;
	n             NUMBER(1);
	v_id_user     users.id_user%TYPE;
BEGIN
	if_successful := false;
	SELECT count(login_email) INTO n FROM users WHERE login_email = :LOGIN_EMAIL;
	IF n = 0 THEN
		INSERT INTO users(login_email, gender_user, language_user, name_user) VALUES (:LOGIN_EMAIL, lower(apex_application.g_x01), lower(apex_application.g_x02), apex_application.g_x04);
		COMMIT;
		SELECT id_user INTO v_id_user FROM users WHERE login_email = :LOGIN_EMAIL;
		INSERT INTO account_operations(id_user, id_type, amount, description) VALUES (v_id_user, 1, 1.50, 'A new account has been created with login '||:LOGIN_EMAIL||'.');
		COMMIT;
		if_successful := true;
		IF length(apex_application.g_x03) > 5 THEN
			INSERT INTO nrs_tel(nr_tel, id_user) VALUES (apex_application.g_x03, v_id_user);
			COMMIT;
		END IF;

	END IF;
	:NR_IF_LOGIN := 1;
	:EUR := 1.50;
	:ID_USER := v_id_user;
	:NAME_USER := apex_application.g_x04;
	apex_json.open_object;
	apex_json.write('if_successful', if_successful);
	apex_json.close_object;
EXCEPTION
	WHEN others THEN
		ROLLBACK;
		apex_json.open_object;
		apex_json.write('if_successful', false);
		apex_json.close_object;
END;
/*
Sequence five. Adding another product to the shopping cart.
*/
DECLARE
	n NUMBER(3);
BEGIN
	SELECT count(*) INTO n FROM shopping_cart WHERE session_number = apex_custom_auth.get_session_id AND id_product = apex_application.g_x01;
	IF n = 0 THEN
		INSERT INTO shopping_cart(session_number, id_product) VALUES (apex_custom_auth.get_session_id, apex_application.g_x01);
	ELSIF n = 1 THEN
		UPDATE shopping_cart SET quantity = (quantity + 1) WHERE session_number = apex_custom_auth.get_session_id AND id_product = apex_application.g_x01;
	END IF;
END;
/*
Sequence six. Reducing the quantity of a specific product in the shopping cart.
*/
DECLARE
    v_quantity shopping_cart.quantity%TYPE;
BEGIN
	SELECT quantity INTO v_quantity FROM shopping_cart WHERE session_number = apex_custom_auth.get_session_id AND id_product = apex_application.g_x01;
    IF v_quantity = 1 THEN
        DELETE FROM shopping_cart WHERE session_number = apex_custom_auth.get_session_id AND id_product = apex_application.g_x01;
    ELSIF v_quantity > 1 THEN
        UPDATE shopping_cart SET quantity = (v_quantity - 1) WHERE session_number = apex_custom_auth.get_session_id AND id_product = apex_application.g_x01;
    ELSE
        DELETE FROM shopping_cart WHERE session_number = apex_custom_auth.get_session_id;
    END IF;
    COMMIT;
    apex_json.open_object;
	apex_json.write('v_quantity', v_quantity);
	apex_json.close_object;
END;
/*
Sequence seven. Increasing the quantity of a specific product in the shopping cart.
*/
DECLARE
    v_quantity shopping_cart.quantity%TYPE;
BEGIN
	SELECT quantity INTO v_quantity FROM shopping_cart WHERE session_number = apex_custom_auth.get_session_id AND id_product = apex_application.g_x01;
    v_quantity := v_quantity + 1;
    UPDATE shopping_cart SET quantity = v_quantity WHERE session_number = apex_custom_auth.get_session_id AND id_product = apex_application.g_x01;
    COMMIT;
    apex_json.open_object;
	apex_json.write('v_quantity', v_quantity);
	apex_json.close_object;
END;
/*
Sequence eight. Placing an order.
*/
BEGIN
	NULL;
END;
/*
Sequence nine. Sending a message to our sales representative.
*/
BEGIN
    :CONTENT_MESS := apex_application.g_x01||apex_application.g_x02;
	:FILE_MESS := apex_application.g_x03;
END;
/*
Sequence ten. Top-up of the user's account with the amount of one and a half euros.
*/
BEGIN
    INSERT INTO account_operations(id_user, id_type, amount, description) VALUES (apex_application.g_x01, 2, 1.50, 'The guest with IP address '||owa_util.get_cgi_env('REMOTE_ADDR')||' has credited your account with the amount of one and a half euros.');
    COMMIT;
    apex_json.open_object;
	apex_json.write('if_successful', true);
	apex_json.close_object;
EXCEPTION
	WHEN others THEN
		ROLLBACK;
		apex_json.open_object;
		apex_json.write('if_successful', false);
		apex_json.close_object;
END;