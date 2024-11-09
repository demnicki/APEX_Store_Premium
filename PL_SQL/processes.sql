/*
Processes.

The process of generating a user's login status.
*/
BEGIN
	:TEXT_SHOP_CART := 'Value of your shopping cart: '||shop.cart_value(apex_custom_auth.get_session_id)||' EUR.';
	:TEXT_INBOX := 'Unread messages in your inbox: '||:NR_INBOX;
	IF :NR_IF_LOGIN = 1 THEN
		:TEXT_IF_LOGIN := 'Logged in as: '||lower(:LOGIN_EMAIL)||'.';
	ELSIF :NR_IF_LOGIN = 0 THEN
		:TEXT_IF_LOGIN := 'You are not logged in. Log in / register now.';
	ELSE
		:NR_IF_LOGIN := 0;
		:NR_ANIM := 1;
		:NR_INBOX := 1;
		:TEXT_IF_LOGIN := 'You are not logged in. Log in / register now.';
	END IF;

	IF :NR_ANIM = 1 THEN
		:TEXT_ANIM := 'Turn off movie animation.';
	ELSIF :NR_ANIM = 0 THEN
		:TEXT_ANIM := 'Turn on movie animation.';

	END IF;
END;

/*

*/
BEGIN
    :NR_ANIM := apex_application.g_x01;
END;

/*

*/
DECLARE
	string_url VARCHAR2(3000 CHAR);
BEGIN
	string_url := apex_util.prepare_url(p_url => 'f?p='||:APP_ID||':'||apex_application.g_x01||':'||:APP_SESSION||'::NO::');
	apex_json.open_object;
	apex_json.write('string_url', string_url);
	apex_json.close_object;
END;