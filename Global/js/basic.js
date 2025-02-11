var array_colors = [
    'white',
    'darkgoldenrod',
    'red',
    'grey',
    'yellow',
    'blue',
    'green',
    'azure',
    'goldenrod',
    'maroon',
    'orchid',
    'olive'];
var array_logo = [
    'A',
    'P',
    'E',
    'X',
    ' ',
    'S',
    't',
    'o',
    'r',
    'e',
    ' ',
    'P',
    'r',
    'e',
    'm',
    'i',
    'u',
    'm'];

function go_to_panel(nr_if_login) {
    var v_nr_if_login = parseInt(nr_if_login);
    if (v_nr_if_login == 1) {
        apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":2:" + apex.env.APP_SESSION);
    }else {
        apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":9999:" + apex.env.APP_SESSION);
    };
};

function social_med(nr) {
    if (nr == 1) {
        window.open('http://www.facebook.com/groups/1744045656082133', '_blank');
    } else if (nr == 2) {
        window.open('http://www.youtube.com/@demnicki', '_blank');
    } else if (nr == 3) {
        window.open('http://www.linkedin.com/in/adam-demnicki-b205211a7/', '_blank');
    } else if (nr == 4) {
        window.open('http://www.github.com/demnicki', '_blank');
    };

};

function up_eur(){
    var id_user;
    var content_html;
    if("id_user" in localStorage){
        id_user = localStorage.getItem("id_user");
        content_html = '<p>Your click has credited the account of the promoter with ID <b>' + id_user + '</b>, with the amount of <b>EUR 1.50</b>.</p>';
        if ("up_eur" in localStorage){
            content_html = '<p>This permalink has already been used.</p>'; 
        }else{
            localStorage.setItem('up_eur', true);
                apex.server.process('Up_eur',
                    {X01: id_user},
                    {success: function () {},
                    dataType: "text"},
                    {error: function () {
                        content_html = '<p>Something went wrong.</p>'; 
                    }
                    });
        };
    }else{
        content_html = '<p>Invalid user ID.</p>'; 

    };
    document.getElementById('center_content').innerHTML = document.getElementById('center_content').innerHTML + content_html;
};

function copy_link(link){
    navigator.clipboard.writeText('http://apex.oracle.com/pls/apex/premium/link/id/'+link);
    apex.message.alert('Link copied.');
};

function copy_swift(){
    navigator.clipboard.writeText('ALBPPLPW');
    apex.message.alert('SWIFT code copied.');
};

function copy_iban(){
    navigator.clipboard.writeText('PL76249000050000400005540768');
    apex.message.alert('IBAN bank account number copied.');
};

function logo_shop() {
    var random_n = 0;
    var text_input_logo = '';
    for (let i = 0; i < array_logo.length; i++) {
        random_n = Math.round(Math.random() * 12);
        text_input_logo = text_input_logo + '<font color="' + array_colors[random_n] + '">' + array_logo[i] + '</font>';
    };
    document.getElementById('logo_shop').innerHTML = text_input_logo;
};

function send_message() {
    apex.server.process(
        'Send_mess',
        {
            X01: apex.item('P2_LIST').getValue(),
            X02: apex.item('P2_MESSAG').getValue(),
            X03: apex.item('P2_FILE').getValue()
        },
        {
            success: function (Data) {
                apex.navigation.redirect(Data.link_pg_16);
            },
            dataType: "json"
        },
        {
            error: function () {}
        }
    );
};

function get_page(p_url) {
    document.getElementById('load_page').innerHTML = '<h1>Please wait...</h1>'; 
fetch(p_url).then(function (response) {
    return response.text();
    }).then(function (html) {
        document.getElementById('load_page').innerHTML = html;
    });
};