/*
*/
BEGIN
	SELECT (SELECT name_emp FROM employees WHERE id_emp = id_emp), content_message INTO :P16_ID_EMP, :P16_CONTENT FROM messages WHERE id_user = :ID_USER ORDER BY date_created DESC FETCH FIRST 1 ROW ONLY;
    COMMIT;
END;