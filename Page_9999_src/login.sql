/*

*/
BEGIN
    apex_authentication.login( 
        p_username            => apex_application.g_x01, 
        p_password            => '', 
        p_uppercase_username  => FALSE,
        p_set_persistent_auth => TRUE);
END;