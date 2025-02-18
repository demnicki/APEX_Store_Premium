/*
*/
BEGIN
    :P14_SUM_CART := shop.cart_value(apex_custom_auth.get_session_id);
    :P14_SUM_SUBS := shop.monthly_subs(apex_custom_auth.get_session_id);
END;
/*
*/
SELECT id_prod, name_product, quantity, cost, minus_product, add_product FROM quant_products;
/*
*/
SELECT id_prod, name_product, cost, delete_product FROM subs_products;
/*
*/