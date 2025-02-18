/*
*/
DECLARE
    n NUMBER(1);
BEGIN
    SELECT count(id_product) INTO n FROM customer_subscriptions WHERE id_user = :ID_USER;
    :P2_OP_SYS := mirror.op_sys(owa_util.get_cgi_env('HTTP_USER_AGENT'));
    :P2_BROWSER := mirror.browser(owa_util.get_cgi_env('HTTP_USER_AGENT'));
    :P2_IP := owa_util.get_cgi_env('REMOTE_ADDR');
    SELECT sum(amount) INTO :P2_SUM_ASSETS FROM account_operations WHERE id_user = :ID_USER;
    SELECT sum(p.price) INTO :P2_SUM_LIABILITIES FROM customer_subscriptions s
        INNER JOIN products p ON s.id_product = p.id WHERE s.id_user = :ID_USER;
    :P2_MULTIPLIER := round(:P2_SUM_ASSETS/500, 0);
    :P2_PAYCHECK := :P2_MULTIPLIER * 500;
    :P2_SUM_ASSETS := '€ '||to_char(:P2_SUM_ASSETS, '999.99');
    IF n < 1 THEN
        :P2_SUM_LIABILITIES := '€ 0.00';
    ELSE
        :P2_SUM_LIABILITIES := '€ '||to_char(:P2_SUM_LIABILITIES, '999.99');
    END IF;
END;
/*
*/
SELECT direct, id_trans, date_operation, amount, description FROM trans_history WHERE id_user = :ID_USER;
/*
*/
SELECT id_product, (SELECT name_product FROM products WHERE id = id_product) AS name_product, '' AS availability, '' AS cancel_product FROM customer_subscriptions WHERE id_user = :ID_USER;