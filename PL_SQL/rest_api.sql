/*
Processes in REST Api triggers.

The controller processes the sending of the login token by email.
*/
BEGIN
    htp.p('<script>');
    htp.p('localStorage.setItem(''id_user'', '||:id||');');
    htp.p('</script>');
    htp.p('<meta http-equiv=refresh content="0; URL=http://apex.oracle.com/pls/apex/r/premium/intro/up_eur">');
END;
/*
Controller for handling individual promotional permalink.
*/
BEGIN
    htp.p('<script>');
    htp.p('localStorage.setItem(''token'', '||:token||');');
    htp.p('</script>');
    htp.p('<meta http-equiv=refresh content="0; URL=http://apex.oracle.com/pls/apex/r/premium/intro/token">');
END;