/*
Creating all the number sequences and tables and views in this project.

Creating number sequences.
*/

CREATE SEQUENCE seq_tokens
MINVALUE   1000
MAXVALUE   9999
START WITH 1000;

CREATE SEQUENCE seq_operat
MINVALUE   10000000
MAXVALUE   99999999
START WITH 10000000;

CREATE SEQUENCE seq_messages
MINVALUE   1000
MAXVALUE   9999
START WITH 1000;

/*
Creating tables.
*/

CREATE TABLE languages(
	id_lang   CHAR(2 CHAR) NOT NULL,
	name_lang CHAR(30 CHAR),
	CONSTRAINT c_id_lang PRIMARY KEY (id_lang)
);

CREATE TABLE tokens_url(
	login_email VARCHAR(100 CHAR) NOT NULL,
	id_user     NUMBER(4) DEFAULT ON NULL seq_tokens.NEXTVAL NOT NULL,
	token       CHAR(3 CHAR) NOT NULL,
	CONSTRAINT c_login_email PRIMARY KEY (login_email),
	CONSTRAINT c_id_user UNIQUE (id_user)
);


CREATE TABLE user_profiles(	
	id_user         NUMBER(4) NOT NULL,
	gender_user     CHAR(1 CHAR) NOT NULL,
	language_user   CHAR(2 CHAR) NOT NULL,
	unread_messages NUMBER(1) DEFAULT 0 NOT NULL,
	first_name      VARCHAR(100 CHAR),
	second_name     VARCHAR(100 CHAR),
	surname         VARCHAR(200 CHAR),
	date_created    DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT c_id_user_1 FOREIGN KEY (id_user) REFERENCES tokens_url(id_user),
	CONSTRAINT c_id_user_2 UNIQUE (id_user),
	CONSTRAINT c_gender_user CHECK ((gender_user) in ('m','f', 'n')),
	CONSTRAINT c_language_user FOREIGN KEY (language_user) REFERENCES languages(id_lang)
);

CREATE TABLE nrs_tel(
	nr_tel  CHAR(15 CHAR) NOT NULL,
	id_user NUMBER(4) NOT NULL,
	CONSTRAINT c_nr_tel PRIMARY KEY (nr_tel),
	CONSTRAINT c_id_user_3 FOREIGN KEY (id_user) REFERENCES tokens_url(id_user)
);

CREATE TABLE api_sessions(
	session_number  CHAR(16 CHAR) NOT NULL,
	ip              CHAR(60 CHAR),
	agent           VARCHAR(300 CHAR),
	start_session   DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT c_session_number PRIMARY KEY (session_number)
);

CREATE TABLE user_sessions(
	session_number  CHAR(16 CHAR) NOT NULL,
	id_user         NUMBER(4) NOT NULL,
	CONSTRAINT c_session_number_1 FOREIGN KEY (session_number) REFERENCES api_sessions(session_number),
	CONSTRAINT c_id_user_4 FOREIGN KEY (id_user) REFERENCES tokens_url(id_user)
);

CREATE TABLE transaction_type(
	id_type     NUMBER(1) NOT NULL,
	direction   CHAR(1 CHAR) NOT NULL,
	type_name   VARCHAR(30 CHAR),
	CONSTRAINT c_id_type PRIMARY KEY (id_type),
	CONSTRAINT c_direction CHECK ((direction) in ('i','o'))
);

CREATE TABLE account_operations(
	id_trans       NUMBER(9) DEFAULT ON NULL seq_operat.NEXTVAL NOT NULL,
	id_user        NUMBER(4) NOT NULL,
	id_type        NUMBER(1) NOT NULL,
	amount         NUMBER(8,2) NOT NULL,
	date_operation DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	description    VARCHAR(1000 CHAR),
	CONSTRAINT c_id_trans PRIMARY KEY (id_trans),
	CONSTRAINT c_id_user_5 FOREIGN KEY (id_user) REFERENCES tokens_url(id_user),
	CONSTRAINT c_id_type_1 FOREIGN KEY (id_type) REFERENCES transaction_type(id_type)
);

CREATE TABLE employees(
	id_emp      CHAR(2 CHAR) NOT NULL,
	id_user     NUMBER(4) NOT NULL,
	name_emp    VARCHAR(200 CHAR),
	nr_tel      CHAR(15 CHAR),
	CONSTRAINT c_id_emp PRIMARY KEY (id_emp),
	CONSTRAINT c_id_user_6 FOREIGN KEY (id_user) REFERENCES tokens_url(id_user)
);

CREATE TABLE product_type(
	id          CHAR(1 CHAR) NOT NULL,
	description VARCHAR(1000 CHAR),
	CONSTRAINT c_id_product_type PRIMARY KEY (id)
);

CREATE TABLE products(
	id           NUMBER(2) NOT NULL,
	name_product VARCHAR(1000 CHAR),
	product_type CHAR(1 CHAR) NOT NULL,
	price        NUMBER(6, 2) DEFAULT 0.01 NOT NULL,
	image        BLOB,
	CONSTRAINT c_id_product PRIMARY KEY (id),
	CONSTRAINT c_type_product_1 FOREIGN KEY (product_type) REFERENCES product_type(id)
);

CREATE TABLE shopping_cart(
	session_number CHAR(16 CHAR) NOT NULL,
	id_product     NUMBER(2) NOT NULL,
	quantity       NUMBER(3) DEFAULT 1 NOT NULL,
	CONSTRAINT c_session_number_2 FOREIGN KEY (session_number) REFERENCES api_sessions(session_number),
	CONSTRAINT c_id_product_1 FOREIGN KEY (id_product) REFERENCES products(id)
);

CREATE TABLE customer_subscriptions(
	id_user      NUMBER(4) NOT NULL,
	id_product   NUMBER(2) NOT NULL,
	availability CHAR(1 CHAR) DEFAULT 'n' NOT NULL,
	CONSTRAINT c_id_user_7 FOREIGN KEY (id_user) REFERENCES tokens_url(id_user),
	CONSTRAINT c_id_product_2 FOREIGN KEY (id_product) REFERENCES products(id),
	CONSTRAINT c_availability CHECK ((availability) in ('y','n'))
);

CREATE TABLE message_status(
	id          CHAR (1 CHAR) NOT NULL,
	description VARCHAR(500 CHAR) NOT NULL,
	CONSTRAINT c_message_status PRIMARY KEY (id)
);

CREATE TABLE messages(
	id_message             NUMBER(4) DEFAULT ON NULL seq_messages.NEXTVAL NOT NULL,
	date_created           DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	id_user                NUMBER(4) NOT NULL,
	id_emp                 CHAR(2 CHAR) NOT NULL,
	message_status         CHAR(1 CHAR) DEFAULT 'n' NOT NULL,
	content_message        CLOB,
	content_translation_pl CLOB,
	CONSTRAINT c_id_message PRIMARY KEY (id_message),
	CONSTRAINT c_id_user_8 FOREIGN KEY (id_user) REFERENCES tokens_url(id_user),
	CONSTRAINT c_id_emp_1 FOREIGN KEY (id_emp) REFERENCES employees(id_emp),
	CONSTRAINT c_message_status_1 FOREIGN KEY (message_status) REFERENCES message_status(id)
);

/*
Creating views.
*/
CREATE VIEW quant_products (id_prod, name_product, quantity, cost, minus_product, add_product) AS
SELECT p.id, p.name_product, s.quantity, '  '||(s.quantity * p.price), '', ''
FROM product_type t
INNER JOIN products p ON t.id = p.product_type
INNER JOIN shopping_cart s ON s.id_product = p.id
WHERE (s.session_number = apex_custom_auth.get_session_id) AND ((t.id = 'c') OR (t.id = 's'));

CREATE VIEW subs_products (id_prod, name_product, quantity, cost, delete_product) AS
SELECT p.id, p.name_product, s.quantity, '  '||(s.quantity * p.price), ''
FROM product_type t
INNER JOIN products p ON t.id = p.product_type
INNER JOIN shopping_cart s ON s.id_product = p.id
WHERE (s.session_number = apex_custom_auth.get_session_id) AND ((t.id = 'a') OR (t.id = 'e'));