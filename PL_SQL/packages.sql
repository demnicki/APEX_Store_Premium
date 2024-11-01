/*
Creating packages of PL/SQL procedures and functions for the entire project.

Creating packages of procedures and functions named "Authentication".
*/

CREATE OR REPLACE PACKAGE authentication
IS
	FUNCTION is_exist_user(a_login_email VARCHAR2) RETURN BOOLEAN;

	FUNCTION have_pay_subsc(a_login_email VARCHAR2) RETURN BOOLEAN;

	PROCEDURE create_customer(
		in_login_email    IN users.login_email%TYPE,
		in_gender_user    IN users.gender_user%TYPE,
		in_language_user  IN users.language_user%TYPE,
		in_nr_tel         IN nrs_tel.nr_tel%TYPE,
		in_name_user      IN users.name_user%TYPE,
		out_if_successful OUT BOOLEAN);

END authentication;

CREATE OR REPLACE PACKAGE BODY authentication
IS
	FUNCTION is_exist_user(a_login_email VARCHAR2) RETURN BOOLEAN IS
		n NUMBER(1);
	BEGIN
		SELECT count(login_email) INTO n FROM users WHERE login_email = a_login_email;
		IF n = 1 THEN
			RETURN true;
		ELSE
			RETURN false;
		END IF;
	END is_exist_user;

	FUNCTION have_pay_subsc(a_login_email VARCHAR2) RETURN BOOLEAN IS
		v_balance_available_eur users.balance_available_eur%TYPE := 0;
	BEGIN
		SELECT balance_available_eur INTO v_balance_available_eur FROM users WHERE login_email = a_login_email;
		IF v_balance_available_eur > 4.99 THEN
			RETURN true;
		ELSE
			RETURN false;
		END IF;
	END have_pay_subsc;

	PROCEDURE create_customer(
		in_login_email    IN users.login_email%TYPE,
		in_gender_user    IN users.gender_user%TYPE,
		in_language_user  IN users.language_user%TYPE,
		in_nr_tel         IN nrs_tel.nr_tel%TYPE,
		in_name_user      IN users.name_user%TYPE,
		out_if_successful OUT BOOLEAN)
	IS
		n NUMBER(1);
		v_login_email users.login_email%TYPE;
	BEGIN
		v_login_email := lower(in_login_email);
		SELECT count(login_email) INTO n FROM users WHERE login_email = v_login_email;
		IF n = 0 THEN
			INSERT INTO users(login_email, gender_user, permission_type, language_user, name_user) VALUES (v_login_email, lower(in_gender_user), 'c', in_language_user, in_name_user);
			COMMIT;
			out_if_successful := true;
			IF length(in_nr_tel) > 5 THEN
				INSERT INTO nrs_tel(nr_tel, login_email) VALUES (in_nr_tel, v_login_email);
				COMMIT;
			END IF;
		ELSE
			out_if_successful := false;
		END IF;
	EXCEPTION
		WHEN others THEN
			ROLLBACK;
			out_if_successful := false;
	END create_customer;
END authentication;

CREATE OR REPLACE PACKAGE shop
IS
	FUNCTION cart_value(a_session_nr shopping_cart.session_number%TYPE) RETURN VARCHAR2;

END shop;

CREATE OR REPLACE PACKAGE BODY shop
IS
	FUNCTION cart_value(a_session_nr shopping_cart.session_number%TYPE) RETURN VARCHAR2
	IS
		n        NUMBER(3);
		v_result NUMBER(6, 2);
	BEGIN
		SELECT count(session_number) INTO n FROM shopping_cart WHERE session_number = a_session_nr;
		IF n = 0 THEN
			RETURN '0.00';
		ELSE
			SELECT sum(quantity * (SELECT price FROM products WHERE id = id_product)) INTO v_result FROM shopping_cart WHERE session_number = a_session_nr;
			RETURN to_char(v_result, '999.99');
		END IF;		
	END cart_value;
END shop;