/*
The login process when starting the User Panel.
*/
BEGIN
    :P2_OP_SYS := mirror.op_sys(owa_util.get_cgi_env('HTTP_USER_AGENT'));
    :P2_BROWSER := mirror.browser(owa_util.get_cgi_env('HTTP_USER_AGENT'));
    :P2_IP := owa_util.get_cgi_env('REMOTE_ADDR');
END;