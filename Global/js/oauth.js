function register() {
    apex.server.process(
        'Register',
        {
            x01: apex.item("GENDER").getValue(),
            x02: apex.item("LANGUAGE").getValue(),
            x03: apex.item("NR_TEL").getValue(),
            x04: apex.item("FIRST_NAME").getValue() + ' ' + apex.item("SURNAME").getValue()
        },
        {
            success: function (Data) {
                if (Data.if_successful) {
                    apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":2:" + apex.env.APP_SESSION);
                } else {
                    apex.message.alert('Fatal error. Please try again or contact support. Comm: ' + Data);
                };
            },
            dataType: "json"
        },
        {
            error: function () { apex.message.alert('Fatal error. Please try again or contact support.'); }
        }
    );
};

function send_mail() {
    var address = apex.item('P9999_EMAIL').getValue();
    apex.message.alert('Receive your email with a link to log in to your account, in your inbox ' + address + '.');
};

function login_user(login_mail) {
    apex.server.process(
        'Login',
        {
            x01: login_mail,
        },
        {
            success: function (Data) {
                if (Data.v_is_register) {
                    apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":2:" + apex.env.APP_SESSION);
                } else {
                    apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":3:" + apex.env.APP_SESSION);
                };
            },
            dataType: "json"
        },
        {
            error: function () { apex.message.alert('Fatal error. Please try again or contact support.'); }
        }
    );

};