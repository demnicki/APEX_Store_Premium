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
/*
Creating packages of procedures and functions named "Shop".
*/
CREATE OR REPLACE PACKAGE shop
IS
	FUNCTION not_empty(a_session_nr api_sessions.session_number%TYPE) RETURN BOOLEAN;
	FUNCTION cart_value(a_session_nr api_sessions.session_number%TYPE) RETURN VARCHAR2;
	FUNCTION monthly_subs(a_session_nr api_sessions.session_number%TYPE) RETURN VARCHAR2;
	FUNCTION available_eur(a_id_user users.id_user%TYPE) RETURN VARCHAR2;
END shop;

CREATE OR REPLACE PACKAGE BODY shop
IS
	FUNCTION not_empty(a_session_nr api_sessions.session_number%TYPE) RETURN BOOLEAN
	IS
		n NUMBER(3);
	BEGIN
		SELECT count(session_number) INTO n FROM shopping_cart WHERE session_number = a_session_nr;
		IF n = 0 THEN
			RETURN false;
		ELSE
			RETURN true;
		END IF;
	END not_empty;

	FUNCTION cart_value(a_session_nr api_sessions.session_number%TYPE) RETURN VARCHAR2
	IS
		n        NUMBER(3);
		v_result NUMBER(6, 2);
	BEGIN
		SELECT count(session_number) INTO n FROM shopping_cart WHERE session_number = a_session_nr;
		IF n = 0 THEN
			RETURN '€ 0.00';
		ELSE
			SELECT sum(quantity * (SELECT price FROM products WHERE id = id_product)) INTO v_result FROM shopping_cart WHERE session_number = a_session_nr;
			RETURN '€ '||to_char(v_result, '999.99');
		END IF;		
	END cart_value;

	FUNCTION monthly_subs(a_session_nr api_sessions.session_number%TYPE) RETURN VARCHAR2
	IS
		n        NUMBER(3);
		v_result NUMBER(6, 2);
	BEGIN
		SELECT count(session_number) INTO n FROM shopping_cart WHERE session_number = a_session_nr AND
			id_product = (SELECT id FROM products WHERE product_type = 'c');
		IF n = 0 THEN
			RETURN 'No monthly subs.';
		ELSE
			SELECT sum(quantity * (SELECT price FROM products WHERE id = id_product)) INTO v_result FROM shopping_cart WHERE session_number = a_session_nr AND
				id_product = (SELECT id FROM products WHERE product_type = 'c');
			RETURN '€ '||to_char(v_result, '999.99');
		END IF;
	END monthly_subs;

	FUNCTION available_eur(a_id_user users.id_user%TYPE) RETURN VARCHAR2
	IS
		v_eur NUMBER(8,2) := 0;
	BEGIN
		SELECT sum(amount) INTO v_eur FROM account_operations WHERE id_user = a_id_user;
		RETURN '€ '||to_char(v_eur, '999.99');
	END available_eur;
END shop;
/*
Creating packages of procedures and functions named "Mirror".
*/
CREATE OR REPLACE PACKAGE mirror
IS
	FUNCTION op_sys(a_agent VARCHAR2) RETURN VARCHAR2;
	FUNCTION browser(a_agent VARCHAR2) RETURN VARCHAR2;
END mirror;

CREATE OR REPLACE PACKAGE BODY mirror
IS
	FUNCTION op_sys(a_agent VARCHAR2) RETURN VARCHAR2
	IS
		TYPE value_table IS TABLE OF VARCHAR2(100 CHAR) INDEX BY VARCHAR2(100 CHAR);
		v_systems_table value_table;
		v_index         VARCHAR2(100 CHAR);
		v_result        VARCHAR2(100 CHAR) := 'System unknown';
	BEGIN
		v_systems_table('windows NT 10.0') := 'Windows 10/11';
	    v_systems_table('macintosh')       := 'Mac OS X';
	    v_systems_table('mac_powerpc')     := 'Mac OS 9';
	    v_systems_table('linux')           := 'Linux';
	    v_systems_table('ubuntu')          := 'Ubuntu';
	    v_systems_table('iphone')          := 'iPhone';
	    v_systems_table('ipod')            := 'iPod';
	    v_systems_table('ipad')            := 'iPad';
	    v_systems_table('android')         := 'Android';
	    v_systems_table('webos')           := 'Mobile';
		v_index := v_systems_table.FIRST;
		WHILE (v_index IS NOT NULL) LOOP
			IF regexp_count(lower(a_agent), lower(v_index)) > 0 THEN
				    v_result := v_systems_table(v_index);
			    END IF;
			v_index := v_systems_table.NEXT(v_index);
		END LOOP;
		RETURN v_result;
	END op_sys;

	FUNCTION browser(a_agent VARCHAR2) RETURN VARCHAR2
	IS
		TYPE value_table IS TABLE OF VARCHAR2(100 CHAR) INDEX BY VARCHAR2(100 CHAR);
		v_browsers_table value_table;
		v_index          VARCHAR2(100 CHAR);
		v_result         VARCHAR2(100 CHAR) := 'Safari';
	BEGIN
		v_browsers_table('postmanruntime') := 'PostMan';
	    v_browsers_table('firefox')        := 'Firefox';
	    v_browsers_table('chrome')         := 'Chrome';
	    v_browsers_table('edge')           := 'Edge';
	    v_browsers_table('opera')          := 'Opera';
		v_index := v_browsers_table.FIRST;
		WHILE (v_index IS NOT NULL) LOOP
			IF regexp_count(lower(a_agent), lower(v_index)) > 0 THEN
				    v_result := v_browsers_table(v_index);
			    END IF;
			v_index := v_browsers_table.NEXT(v_index);
		END LOOP;
		RETURN v_result;
	END browser;
END mirror;