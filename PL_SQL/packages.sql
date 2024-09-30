/*
Creating packages of PL/SQL procedures and functions for the entire project.

Creating packages of procedures and functions named "Authentication".
*/

CREATE OR REPLACE PACKAGE authentication
IS
	FUNCTION is_exist_user(a_login_email VARCHAR2) RETURN BOOLEAN;

	PROCEDURE create_customer(
		in_login_email    IN users.login_email%TYPE,
		in_gender_user    IN users.gender_user%TYPE,
		in_language_user  IN users.gender_user%TYPE,
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

	PROCEDURE create_customer(
		in_login_email    IN users.login_email%TYPE,
		in_gender_user    IN users.gender_user%TYPE,
		in_language_user  IN users.gender_user%TYPE,
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
			SAVEPOINT;
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