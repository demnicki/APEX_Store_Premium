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
DECLARE
    n1 NUMBER(1);
    n2 NUMBER(1);
BEGIN
    SELECT count(id_user) INTO n1 FROM tokens_url WHERE id_user = :id;
    SELECT count(id_user) INTO n2 FROM user_profiles WHERE id_user = :id;
    htp.p('<script>');
    htp.p('localStorage.setItem(''id_user'', '||:id||');');
    htp.p('localStorage.setItem(''token'', '||:token||');');
    htp.p('</script>');
    IF n1 = 1 THEN 
        IF n2 = 1 THEN
            htp.p('<meta http-equiv=refresh content="0; URL=http://apex.oracle.com/pls/apex/r/premium/intro/panel">');
        ELSE
            htp.p('<meta http-equiv=refresh content="0; URL=http://apex.oracle.com/pls/apex/r/premium/intro/register">');
        END IF;
    ELSE
        htp.p('<meta http-equiv=refresh content="0; URL=http://apex.oracle.com/pls/apex/r/premium/intro/er_token">');
    END IF;
END;