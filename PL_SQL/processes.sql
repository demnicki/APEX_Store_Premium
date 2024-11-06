/*
Processes.

The process of generating a user's login status.
*/
DECLARE
	v_id_user         users.id_user%TYPE;
	v_name_user       users.name_user%TYPE;
	v_eur             users.balance_available_eur%TYPE;
BEGIN
	:SHOP_CART_STATUS := 'Value of your shopping cart: '||shop.cart_value(apex_custom_auth.get_session_id)||' EUR.';
	IF authentication.is_exist_user(lower(:LOGIN_EMAIL)) THEN
        :CHECK_LOGIN := 'Logged in as: '||lower(:LOGIN_EMAIL)||'.';
		SELECT id_user,
			name_user,
			balance_available_eur
			INTO
			v_id_user,
			v_name_user,
			v_eur
		FROM users WHERE login_email = lower(:LOGIN_EMAIL);
		:EUR := v_eur;
		:ID_USER := v_id_user;
		:NAME_USER := v_name_user;
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
