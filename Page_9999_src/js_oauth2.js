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
                apex.navigation.redirect('f?p=&APP_ID.:1:&APP_SESSION.');
            },
            dataType: "text"
        },
        {
            error: function () { apex.message.alert('Fatal error. Please try again or contact support.'); }
        }
    );
    
};