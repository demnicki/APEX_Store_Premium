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
INSERT to table „employees”.
*/
INSERT INTO employees(id_emp, id_user, name_emp, nr_tel) VALUES ('ad', [?], 'Adam J. Demnicki', '+48511656830');
INSERT INTO employees(id_emp, id_user, name_emp, nr_tel) VALUES ('ms', [?], 'Mateusz Szymański', '');
INSERT INTO employees(id_emp, id_user, name_emp, nr_tel) VALUES ('aa', [?], 'Aleksandra Al-Hiyari', '');
/*
INSERT to table „Transaction_type”.
*/
INSERT INTO transaction_type(id_type, direction, type_name) VALUES (1, 'i', 'Opening');
INSERT INTO transaction_type(id_type, direction, type_name) VALUES (2, 'i', 'Permalink');
INSERT INTO transaction_type(id_type, direction, type_name) VALUES (3, 'i', 'Paypal ');
INSERT INTO transaction_type(id_type, direction, type_name) VALUES (4, 'i', 'SWIFT');
INSERT INTO transaction_type(id_type, direction, type_name) VALUES (5, 'o', 'Products');
INSERT INTO transaction_type(id_type, direction, type_name) VALUES (6, 'o', 'Labor');
/*
INSERT to table „product_type”.
*/
INSERT INTO product_type(id, description) VALUES ('c', 'Customer monthly subscriptions.');
INSERT INTO product_type(id, description) VALUES ('s', 'Services of our team.');
INSERT INTO product_type(id, description) VALUES ('a', 'Ready-made applications for the APEX platform.');
INSERT INTO product_type(id, description) VALUES ('e', 'Video educational courses.');

/*
INSERT to table „Message_status”.
*/
INSERT INTO message_status(id, description) VALUES ('4', 'New message, not read yet.');
INSERT INTO message_status(id, description) VALUES ('3', 'Message read but not yet translated.');
INSERT INTO message_status(id, description) VALUES ('2', 'Message read and translated, but not yet delivered to the client.');
INSERT INTO message_status(id, description) VALUES ('1', 'This message is fully supported.');