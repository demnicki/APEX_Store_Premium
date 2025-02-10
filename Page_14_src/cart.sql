/*
*/
BEGIN
    :P14_SUM_CART := shop.cart_value(apex_custom_auth.get_session_id);
    :P14_SUM_SUBS := shop.monthly_subs(apex_custom_auth.get_session_id);
END;