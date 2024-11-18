/*
INSERT to tables.

INSERT to table „Languages”.
*/
INSERT INTO languages(id_lang, name_lang) VALUES ('pl', 'Polish');
INSERT INTO languages(id_lang, name_lang) VALUES ('en', 'English');
INSERT INTO languages(id_lang, name_lang) VALUES ('ar', 'Arabic');
INSERT INTO languages(id_lang, name_lang) VALUES ('ge', 'German');
INSERT INTO languages(id_lang, name_lang) VALUES ('ru', 'Russian');
/*
INSERT to table „Transaction_type”.
*/
INSERT INTO transaction_type(id_type, direction, type_name, description) VALUES (1, 'i', 'Opening', 'Opening an account.');
INSERT INTO transaction_type(id_type, direction, type_name, description) VALUES (2, 'i', 'Permalink', 'Credit to your bill for clicking on an individual permalink.');
INSERT INTO transaction_type(id_type, direction, type_name, description) VALUES (3, 'i', 'Paypal ', 'Top up your account via PayPal.');
INSERT INTO transaction_type(id_type, direction, type_name, description) VALUES (4, 'i', 'SWIFT', 'Top up your account via SWIFT bank transfer.');
INSERT INTO transaction_type(id_type, direction, type_name, description) VALUES (5, 'o', 'Products', 'Payment for products in your shopping cart.');
INSERT INTO transaction_type(id_type, direction, type_name, description) VALUES (6, 'o', 'Labor', 'Payment for application developer labor.');
/*
INSERT to table „Account_operations”.
*/

/*
INSERT to table „Message_status”.
*/