/*

*/
var v_login_mail = 'adamdemnicki@gmail.com';

function post_login_mail(login_mail) {
    apex.server.process(
        'Login',
        {
            x01: login_mail,
        },
        {
            success: function (Data) {
                var obj_json = JSON.parse(Data);
                if (obj_json.v_is_register) {
                    if (obj_json.v_have_pay_subsc) {
                        apex.navigation.redirect('f?p=&APP_ID.:2:&APP_SESSION.');
                    } else {
                        apex.navigation.redirect('f?p=&APP_ID.:12:&APP_SESSION.');
                    };
                }
                else {
                    apex.navigation.redirect('f?p=&APP_ID.:3:&APP_SESSION.');
                };
            },
            dataType: "text"
        },
        {
            error: function () { apex.message.alert('Fatal error. Please try again or contact support.'); }
        }
    );
    
};