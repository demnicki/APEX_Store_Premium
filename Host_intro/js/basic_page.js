var all_local_storage;

function url_fb() {
    window.open('http://www.facebook.com/groups/1744045656082133', '_blank');
};

function url_yt() {
    window.open('http://www.youtube.com/@demnicki', '_blank');
};

function message_box() {
    apex.message.alert('This service is not ready yet.');
};

function shopping_cart() {
    apex.message.alert('This service is not ready yet.');
};

function login() {
    apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":9999:" + apex.env.APP_SESSION);
};

function overwrite_local_storage() {
    all_local_storage = JSON.parse(localStorage.getItem('general'));
    all_local_storage.login_email = apex.env.APP_USER;
    localStorage.setItem('general', JSON.stringify(all_local_storage));
};

function pdf() {
    var doc = new jsPDF();
    doc.autoTable({
        theme: 'plain',
        headStyles: { fontSize: 20 },
        bodyStyles: { fontSize: 20, fontStyle: 'italic' },

        head: [['Position in the table.', 'Variable value']],
        body: [['You ID', '&ID_USER.'], ['You are logged in as:', '&APP_USER.'], ['Your current account balance in euro:', '&EUR.']],

    });

    doc.autoTable({
        theme: 'plain',
        headStyles: { fontSize: 10 },
        bodyStyles: { fontSize: 8, fontStyle: 'italic' },

        head: [['ID', 'Name', 'Country']],
        body: [['1', 'Simon', 'Swedenddd'], ['2', 'Karl', 'Norway']],

    });
    doc.save('Raport_your_profil.pdf');
};

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