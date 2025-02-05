/*
*/
BEGIN
	INSERT INTO messages(id_user, id_emp, message_status, content_message, content_translation_pl)
		VALUES (:ID_USER, :P16_ID_EMP, '4', :P16_CONTENT||' File: '||:P16_FILE, 'This message is not translated yet.');
    COMMIT;
END;