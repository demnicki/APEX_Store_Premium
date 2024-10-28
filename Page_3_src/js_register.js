function register() {
    apex.server.process(
        'Register',
        {
            x01: apex.item("GENDER").getValue(),
            x02: apex.item("LANGUAGE").getValue(),
            x03: apex.item("NR_TEL").getValue(),
            x04: apex.item("FULL_NAME").getValue()
        },
        {
            success: function (Data) {
                var object = JSON.parse(Data);
                if (object.if_successful) {
                    apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":12:" + apex.env.APP_SESSION);
                } else {
                    apex.message.alert('Fatal error. Please try again or contact support. Comm: ' + Data);
                };
            },
            dataType: "text"
        },
        {
            error: function () { apex.message.alert('Fatal error. Please try again or contact support.'); }
        }
    );
};