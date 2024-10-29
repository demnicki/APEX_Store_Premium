/*
Processes for managing the shopping cart.
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