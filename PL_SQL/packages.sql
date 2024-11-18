/*
Creating packages of PL/SQL procedures and functions for the entire project.

Creating packages of procedures and functions named "Authentication".
*/

CREATE OR REPLACE PACKAGE authentication
IS
	FUNCTION is_exist_user(a_login_email users.login_email%TYPE) RETURN BOOLEAN;
	FUNCTION have_pay_subsc(a_id_user users.id_user%TYPE) RETURN BOOLEAN;
END authentication;

CREATE OR REPLACE PACKAGE BODY authentication
IS
	FUNCTION is_exist_user(a_login_email users.login_email%TYPE) RETURN BOOLEAN IS
		n NUMBER(1);
	BEGIN
		SELECT count(login_email) INTO n FROM users WHERE login_email = a_login_email;
		IF n = 1 THEN
			RETURN true;
		ELSE
			RETURN false;
		END IF;
	END is_exist_user;

	FUNCTION have_pay_subsc(a_id_user users.id_user%TYPE) RETURN BOOLEAN
	IS
		v_eur NUMBER(8,2) := 0;
	BEGIN
		SELECT sum(amount) INTO v_eur FROM account_operations WHERE id_user = a_id_user;
		IF v_eur > 4.99 THEN
			RETURN true;
		ELSE
			RETURN false;
		END IF;
	END have_pay_subsc;
END authentication;

CREATE OR REPLACE PACKAGE shop
IS
	FUNCTION cart_value(a_session_nr api_sessions.session_number%TYPE) RETURN VARCHAR2;
	FUNCTION available_eur(a_id_user users.id_user%TYPE) RETURN VARCHAR2;
END shop;

CREATE OR REPLACE PACKAGE BODY shop
IS
	FUNCTION cart_value(a_session_nr api_sessions.session_number%TYPE) RETURN VARCHAR2
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

	FUNCTION available_eur(a_id_user users.id_user%TYPE) RETURN VARCHAR2
	IS
		v_eur NUMBER(8,2) := 0;
	BEGIN
		SELECT sum(amount) INTO v_eur FROM account_operations WHERE id_user = a_id_user;
		RETURN to_char(v_eur, '999.99');
	END available_eur;
END shop;