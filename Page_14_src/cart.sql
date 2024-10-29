/*
Processes for managing the shopping cart.
*/

SELECT
    (SELECT name_product FROM products WHERE id = id_product) AS name_product,
    quantity,
    '<button class="button_plus" onclick="shopping_cart()">+</button>' AS add_product,
    '<button class="button_minus"" onclick="shopping_cart()">-</button>' AS minus_product
    FROM shopping_cart WHERE session_number = apex_custom_auth.get_session_id;