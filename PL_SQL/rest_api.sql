/*
Processes in REST Api triggers.

The controller processes the sending of the login token by email.
*/
BEGIN
    htp.p('<script>');
    htp.p('localStorage.setItem(''id_user'', '||:id||');');
    htp.p('</script>');
    htp.p('<meta http-equiv=refresh content="0; URL=http://apex.oracle.com/pls/apex/r/premium/intro/up_eur">');
END;
/*
Controller for handling individual promotional permalink.
*/
BEGIN
    htp.p('<script>');
    htp.p('localStorage.setItem(''token'', '||:token||');');
    htp.p('</script>');
    htp.p('<meta http-equiv=refresh content="0; URL=http://apex.oracle.com/pls/apex/r/premium/intro/token">');
END;
/*
Controller returning account history and order details of a specific user - according to "id_user".
*/
DECLARE
    CURSOR cs (a_id_user customer_subscriptions.id_user%TYPE) IS
        SELECT p.id AS id, p.price AS price, p.name_product AS name
        FROM customer_subscriptions c
        INNER JOIN products p ON c.id_product = p.id
        WHERE c.id_user = a_id_user;
    CURSOR ao (a_id_user account_operations.id_user%TYPE) IS SELECT id_trans, amount, date_operation, description FROM account_operations WHERE id_user = a_id_user;
    obj_json      JSON_OBJECT_T;
    json_cs       JSON_OBJECT_T;
    json_ao       JSON_OBJECT_T;
    arr_cs        JSON_ARRAY_T;
    arr_ao        JSON_ARRAY_T;
    v_id_user     tokens_url.id_user%TYPE;
    v_language    user_profiles.language_user%TYPE;
    v_first_name  user_profiles.first_name%TYPE;
    v_second_name user_profiles.second_name%TYPE;
    v_surname     user_profiles.surname%TYPE;
    v_sum_cs      NUMBER(6, 2);
    v_sum_ao      NUMBER(7, 2);
BEGIN
    obj_json := json_object_t();
    arr_cs := json_array_t();
    arr_ao := json_array_t();
    SELECT language_user, first_name, second_name, surname INTO v_language, v_first_name, v_second_name, v_surname FROM user_profiles WHERE id_user = :id_user;
    SELECT sum(p.price) INTO v_sum_cs
        FROM customer_subscriptions c
        INNER JOIN products p ON c.id_product = p.id WHERE c.id_user = :id_user;
    SELECT sum(amount) INTO v_sum_ao FROM account_operations WHERE id_user = :id_user;
    FOR i IN cs(:id_user) LOOP
        json_cs := json_object_t();
        json_cs.put('id_product', i.id);
        json_cs.put('price_eur', i.price);
        json_cs.put('name_product', i.name);
        arr_cs.append(json_cs);
    END LOOP;
    FOR i IN ao(:id_user) LOOP
        json_ao := json_object_t();
        json_ao.put('id_trans', i.id_trans);
        json_ao.put('date_operation', i.date_operation);
        json_ao.put('amount', i.amount);        
        json_ao.put('description', i.description);
        arr_ao.append(json_ao);
    END LOOP;
    obj_json.put('language_user', v_language);
    obj_json.put('first_name', v_first_name);
    obj_json.put('second_name', v_second_name);
    obj_json.put('surname', v_surname);
    obj_json.put('balance_liabilities', v_sum_cs);
    obj_json.put('balance_assets', v_sum_ao);
    obj_json.put('arr_cs', arr_cs);
    obj_json.put('arr_ao', arr_ao);
    owa_util.mime_header('application/json', true, 'UTF-8');
    htp.p(obj_json.stringify);
END;
/*
Controller, internal for handling incoming messages from Clients.
*/
DECLARE
    CURSOR up IS SELECT id_user, gender_user, language_user, first_name, second_name, surname FROM user_profiles;
    CURSOR ms IS SELECT id_user, date_created, content_message FROM messages;
    obj_json                JSON_OBJECT_T;
    json_up                 JSON_OBJECT_T;
    json_ms                 JSON_OBJECT_T;
    arr_up                  JSON_ARRAY_T;
    arr_ms                  JSON_ARRAY_T;
    sum_profiles_user       NUMBER(6);
    sum_subscriptions       NUMBER(9);
    sum_ac_operations       NUMBER(9);
    sum_cart_shopping       NUMBER(9);
    sum_indiv_ac_operations NUMBER(9);
    
BEGIN
    obj_json := json_object_t();
    arr_up := json_array_t();
    arr_ms := json_array_t();
    SELECT count(id_user) INTO sum_profiles_user FROM user_profiles;
    SELECT count(id_user) INTO sum_subscriptions FROM customer_subscriptions;
    SELECT sum(amount) INTO sum_ac_operations FROM account_operations;
    SELECT count(session_number) INTO sum_cart_shopping FROM shopping_cart;
    FOR i IN up LOOP
        SELECT sum(amount) INTO sum_indiv_ac_operations FROM account_operations WHERE id_user = i.id_user;
        json_up := json_object_t();
        json_up.put('sum_indiv_ac_operations', sum_indiv_ac_operations);
        json_up.put('gender_user', i.gender_user);
        json_up.put('language_user', i.language_user);
        json_up.put('first_name', i.first_name);
        json_up.put('second_name', i.second_name);        
        json_up.put('surname', i.surname);
        arr_up.append(json_up);
    END LOOP;
    FOR i IN ms LOOP
        json_ms := json_object_t();
        json_ms.put('id_user', i.id_user);
        json_ms.put('date_created', i.date_created);
        json_ms.put('content_message', i.content_message);
        arr_ms.append(json_ms);
    END LOOP;
    obj_json.put('sum_profiles_user', sum_profiles_user);
    obj_json.put('sum_subscriptions', sum_subscriptions);
    obj_json.put('sum_ac_operations', sum_ac_operations);
    obj_json.put('sum_cart_shopping', sum_cart_shopping);
    obj_json.put('arr_up', arr_up);
    obj_json.put('arr_ms', arr_ms);
    owa_util.mime_header('application/json', true, 'UTF-8');
    htp.p(obj_json.stringify);
END;