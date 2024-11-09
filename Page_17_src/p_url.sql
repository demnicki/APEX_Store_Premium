/*

*/
BEGIN
    :P17_OPEN_P18 := apex_util.prepare_url(p_url => 'f?p='||:APP_ID||':18:'||:APP_SESSION||'::NO::');
END;