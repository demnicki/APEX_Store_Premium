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
DECLARE
    v_eur users.balance_available_eur%TYPE;
BEGIN
    SELECT balance_available_eur INTO v_eur FROM users WHERE id_user = apex_application.g_x01;
    v_eur := v_eur + 1.50;
    UPDATE users SET balance_available_eur = v_eur WHERE id_user = apex_application.g_x01;
    COMMIT;
    apex_json.open_object;
	apex_json.write('if_successful', true);
	apex_json.close_object;
END;