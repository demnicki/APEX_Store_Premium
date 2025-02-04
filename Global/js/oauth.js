function register() {
    apex.server.process(
        'Register',
        {
            x01: apex.item("GENDER").getValue(),
            x02: apex.item("LANGUAGE").getValue(),
            x03: apex.item("FIRST_NAME").getValue(),
            X04: apex.item("SECOND_NAME").getValue(),
            X05: apex.item("SURNAME").getValue(),
            X06: apex.item("NR_TEL").getValue()
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

function createRandomString(length) {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    let result = "";
    for (let i = 0; i < length; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
};

function send_token() {
    var address = apex.item('P9999_EMAIL').getValue();
    var token = createRandomString(3);
    apex.server.process(
        'Get_token',
        {
            x01: address,
            x02: token
        },
        {
            success: function (Data) {apex.message.alert('Receive your email with a link to log in to your account, in your inbox ' + address + '.');},
            dataType: "json"
        },
        {
            error: function () { apex.message.alert('Fatal error. Please try again or contact support.'); }
        }
    );
};

function login_user() {
    apex.server.process(
        'Login',
        {
            x01: localStorage.getItem("token"),
        },
        {
            success: function (Data) {
                if (Data.v_is_exist) {
                    if (Data.v_is_register) {
                        apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":2:" + apex.env.APP_SESSION);
                    } else {
                        apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":3:" + apex.env.APP_SESSION);
                    };
                }
                else {/* */};
                
            },
            dataType: "json"
        },
        {
            error: function () { apex.message.alert('Fatal error. Please try again or contact support.'); }
        }
    );
};