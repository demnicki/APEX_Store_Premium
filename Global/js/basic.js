var v_login_mail = '@';

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

function init_anim(nr_anim) {
    var v_nr_anim = parseInt(nr_anim);
    if (v_nr_anim == 1) {
        document.getElementById('background_movie').style.display = 'block';
    } else if (v_nr_anim == 0) {
        document.getElementById('background_movie').style.display = 'none';
    };
    apex.server.process(
        'Turn_anim',
        {
            x01: v_nr_anim
        },
        {
            success: function (Data) {},
            dataType: "text"
        },
        {
            error: function () {}
        }
    );
};

function turn_anim(nr_anim) {
    var v_nr_anim = parseInt(nr_anim);
    if (v_nr_anim == 1) {
        init_anim(0);
    }
    else if (v_nr_anim == 0) {
        init_anim(1);
    };
};

function to_login_page() {
    apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":9999:" + apex.env.APP_SESSION);
};

function go_to_panel(nr_if_login, eur) {
    var v_nr_if_login = parseInt(nr_if_login);
    var v_eur = parseFloat(eur);
    if (v_nr_if_login == 1 && v_eur > 5) {
        apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":2:" + apex.env.APP_SESSION);
    }
    else if (v_nr_if_login == 1 && v_eur < 5) {
        apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":12:" + apex.env.APP_SESSION);
    } else {
        apex.message.alert('You are not logged in.');
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
            X01: 'To: '+apex.item('P15_LIST').getValue()+'. ',
            X02: apex.item('P15_MESSAG').getValue(),
            X03: apex.item('P15_FILE').getValue()
        },
        {
            success: function (Data) {},
            dataType: "text"
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