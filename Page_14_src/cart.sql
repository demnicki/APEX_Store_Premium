/*
*/
BEGIN
    :P14_SUM_CART := shop.cart_value(apex_custom_auth.get_session_id);
    :P14_SUM_SUBS := shop.cart_value(apex_custom_auth.get_session_id);
END;
/*
Processes for managing the shopping cart.
*/
SELECT
    id_product AS id_prod,
    (SELECT name_product FROM products WHERE id = id_product) AS name_product,
    quantity,
    quantity * (SELECT price FROM products WHERE id = id_product) AS cost,
    '' AS minus_product,
    '' AS add_product    
    FROM shopping_cart WHERE session_number = apex_custom_auth.get_session_id;

/*
*/
SELECT
    id_product AS id_prod,
    (SELECT name_product FROM products WHERE id = id_product) AS name_product,
    quantity * (SELECT price FROM products WHERE id = id_product) AS cost,
    '' AS delete_product
    FROM shopping_cart WHERE session_number = apex_custom_auth.get_session_id;