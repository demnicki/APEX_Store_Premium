/*
Creating all the number sequences and tables in this project.

Creating number sequences.
*/

CREATE SEQUENCE seq_users
MINVALUE   1000
MAXVALUE   9999
START WITH 1000;

CREATE SEQUENCE seq_orders
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

CREATE TABLE permission_type(
	id_type   CHAR(1 CHAR) NOT NULL,
	name_type CHAR(30 CHAR),
	c_comment VARCHAR(300 CHAR),
	CONSTRAINT c_id_type PRIMARY KEY (id_type)
);

CREATE TABLE users(
	login_email           VARCHAR(100 CHAR) NOT NULL,
	id_user               NUMBER(4) DEFAULT ON NULL seq_users.NEXTVAL NOT NULL,
	gender_user           CHAR(1 CHAR) NOT NULL,
	permission_type       CHAR(1 CHAR) NOT NULL,
	language_user         CHAR(2 CHAR) NOT NULL,
	name_user             VARCHAR(300 CHAR),
	balance_available_eur NUMBER(6, 2) DEFAULT 4.99 NOT NULL,
	date_created          DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT c_login_email PRIMARY KEY (login_email),
	CONSTRAINT c_id_user UNIQUE (id_user),
	CONSTRAINT c_gender_user CHECK ((gender_user) in ('m','f', 'n')),
	CONSTRAINT c_permission_type FOREIGN KEY (permission_type) REFERENCES permission_type(id_type),
	CONSTRAINT c_language_user FOREIGN KEY (language_user) REFERENCES languages(id_lang)
);

CREATE TABLE nrs_tel(
	nr_tel      CHAR(15 CHAR) NOT NULL,
	login_email VARCHAR(100 CHAR) NOT NULL,
	CONSTRAINT c_nr_tel PRIMARY KEY (nr_tel),
	CONSTRAINT c_login_tel FOREIGN KEY (login_email) REFERENCES users(login_email)
);

CREATE TABLE employees(
	id_emp      CHAR(2 CHAR) NOT NULL,
	login_email VARCHAR(100 CHAR) NOT NULL,
	name_emp    VARCHAR(200 CHAR),
	nr_tel      CHAR(15 CHAR),
	CONSTRAINT c_id_emp PRIMARY KEY (id_emp),
	CONSTRAINT c_login_emp FOREIGN KEY (login_email) REFERENCES users(login_email)
);

CREATE TABLE order_records(
	id_order                NUMBER(8) DEFAULT ON NULL seq_orders.NEXTVAL NOT NULL,
	date_created            DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	login_email             VARCHAR(100 CHAR) NOT NULL,
	id_emp                  CHAR(2 CHAR) NOT NULL,
	add_app_1               NUMBER(1) DEFAULT 0 NOT NULL,
	add_app_2               NUMBER(1) DEFAULT 0 NOT NULL,
	add_app_3               NUMBER(1) DEFAULT 0 NOT NULL,
	add_app_4               NUMBER(1) DEFAULT 0 NOT NULL,
	nr_pieces_cloud         NUMBER(3) DEFAULT 0 NOT NULL,
	nr_pieces_windows       NUMBER(3) DEFAULT 0 NOT NULL,
	nr_pieces_h_consult     NUMBER(3) DEFAULT 0 NOT NULL,
	nr_pieces_h_programming NUMBER(3) DEFAULT 0 NOT NULL,
	CONSTRAINT c_id_order PRIMARY KEY (id_order),
	CONSTRAINT c_login_order FOREIGN KEY (login_email) REFERENCES users(login_email),
	CONSTRAINT c_id_emp_order FOREIGN KEY (id_emp) REFERENCES employees(id_emp)
);

CREATE TABLE messages(
	id_message      NUMBER(4) DEFAULT ON NULL seq_messages.NEXTVAL NOT NULL,
	date_created    DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	login_email     VARCHAR(100 CHAR) NOT NULL,
	id_emp          CHAR(2 CHAR) NOT NULL,
	content_message CLOB,
	CONSTRAINT c_id_message PRIMARY KEY (id_message),
	CONSTRAINT c_login_mess FOREIGN KEY (login_email) REFERENCES users(login_email),
	CONSTRAINT c_id_emp_mess FOREIGN KEY (id_emp) REFERENCES employees(id_emp)
);