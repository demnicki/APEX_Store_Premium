﻿/*
List of all application PL/SQL processes by execution sequence.

Sequence one. Every time the page loads.
*/
DECLARE
	n NUMBER(1);
BEGIN
	SELECT count(session_number) INTO n FROM api_sessions WHERE session_number = apex_custom_auth.get_session_id;
	:TEXT_SHOP_CART := 'Value of your shopping cart: '||shop.cart_value(apex_custom_auth.get_session_id)||' EUR.';
	IF n = 0 THEN
		INSERT INTO api_sessions(session_number, ip, agent) VALUES (apex_custom_auth.get_session_id, owa_util.get_cgi_env('REMOTE_ADDR'), owa_util.get_cgi_env('HTTP_USER_AGENT'));
		COMMIT;
    	:NR_IF_LOGIN := 0;
		:NR_INBOX := 1;
		:TEXT_IF_LOGIN := 'You are not logged in. Log in / register now.';
    	:TEXT_INBOX := 'Unread messages in your inbox: '||:NR_INBOX;
        :LINK_PG_16 := apex_util.prepare_url(p_url => 'f?p='||:APP_ID||':16:'||:APP_SESSION||'::NO::');
        :LINK_PG_18 := apex_util.prepare_url(p_url => 'f?p='||:APP_ID||':18:'||:APP_SESSION||'::NO::');
	ELSIF n = 1 THEN
		IF :NR_IF_LOGIN = 1 THEN
    		:TEXT_IF_LOGIN := 'My user panel: '||lower(:LOGIN_EMAIL)||'.';
    	ELSIF :NR_IF_LOGIN = 0 THEN
    		:TEXT_IF_LOGIN := 'You are not logged in. Log in / register now.';
        END IF;
	END IF;
END;
/*
Sequence two. Sending the token by email.
*/
BEGIN
	NULL;
END;
/*
Sequence three. User login.
*/
DECLARE
	v_is_register     BOOLEAN := false;
	v_id_user         users.id_user%TYPE;
    v_unread_messages users.unread_messages%TYPE;
	v_first_name      users.first_name%TYPE;
	v_second_name     users.second_name%TYPE;
	v_surname         users.surname%TYPE;
BEGIN
	:LOGIN_EMAIL := lower(apex_application.g_x01);
	v_is_register := authentication.is_exist_user(:LOGIN_EMAIL);
	IF v_is_register THEN
		SELECT id_user, unread_messages, first_name, second_name, surname INTO v_id_user, v_unread_messages, v_first_name, v_second_name, v_surname FROM users WHERE login_email = :LOGIN_EMAIL;
        :NR_IF_LOGIN := 1;
		:NR_INBOX := v_unread_messages;
		:ID_USER := v_id_user;
		:NAME_USER := v_first_name||' '||v_second_name||' '||v_surname;
		:EUR := shop.available_eur(v_id_user);
	END IF;
	apex_json.open_object;
	apex_json.write('v_is_register', v_is_register);
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
		INSERT INTO users(login_email, gender_user, language_user, first_name, second_name, surname) VALUES (:LOGIN_EMAIL, lower(apex_application.g_x01), lower(apex_application.g_x02), apex_application.g_x03, apex_application.g_x04, apex_application.g_x05);
		COMMIT;
		SELECT id_user INTO v_id_user FROM users WHERE login_email = :LOGIN_EMAIL;
		INSERT INTO account_operations(id_user, id_type, amount, description) VALUES (v_id_user, 1, 1.50, 'A new account has been created with login '||:LOGIN_EMAIL||'.');
		COMMIT;
		if_successful := true;
		IF length(apex_application.g_x03) > 5 THEN
			INSERT INTO nrs_tel(nr_tel, id_user) VALUES (apex_application.g_x06, v_id_user);
			COMMIT;
		END IF;

	END IF;
	:NR_IF_LOGIN := 1;
	:EUR := 1.50;
	:ID_USER := v_id_user;
	:NAME_USER := apex_application.g_x03||' '||apex_application.g_x04||' '||apex_application.g_x05;
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
Sequence eight. Completely removing the product from the shopping cart.
*/
BEGIN
	DELETE FROM shopping_cart WHERE session_number = apex_custom_auth.get_session_id AND id_product = apex_application.g_x01;
    COMMIT;
    apex_json.open_object;
	apex_json.write('if_successful', true);
	apex_json.close_object;
END;
/*
Sequence nine. User placing an order.
*/
DECLARE
    is_logged BOOLEAN;
    n         NUMBER(1);
    CURSOR order_cust IS SELECT id_product FROM shopping_cart WHERE session_number = apex_custom_auth.get_session_id;
BEGIN
	SELECT count(id_user) INTO n FROM users WHERE id_user = :ID_USER;
    IF n = 1 THEN
       FOR product IN order_cust LOOP
            INSERT INTO customer_subscriptions(id_user, id_product, availability) VALUES (:ID_USER, product.id_product, 'n');
       END LOOP;
       COMMIT;
       is_logged := true;
    ELSE
       is_logged := false;
    END IF;
   	apex_json.open_object;
    apex_json.write('is_logged', is_logged);
	apex_json.close_object;
END;
/*
Sequence ten. The process of sending an individual message by the user to the designated sales representative.
*/
DECLARE
    mess_obj JSON_OBJECT_T;
BEGIN
    mess_obj := JSON_OBJECT_T();
    mess_obj.put('to_whom', apex_application.g_x01);
    mess_obj.put('content', apex_application.g_x02);
    mess_obj.put('file', apex_application.g_x03);
    :MESSAGE := mess_obj.stringify;
	INSERT INTO messages(id_user, id_emp, message_status, content_message, content_translation_pl)
		VALUES (:ID_USER, apex_application.g_x01, '4', apex_application.g_x02||' File: '||apex_application.g_x03, 'This message is not translated yet.');
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
/*
Sequence eleven. The process of topping up the user's account by one and a half euros for clicking on an individual permalink.
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