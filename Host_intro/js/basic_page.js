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

function send_message() {
    apex.server.process(
        'Send_mess',
        {
            X01: 'To: '+apex.item('P15_LIST').getValue()+'. ',
            X02: apex.item('P15_MESSAG').getValue(),
            X03: apex.item('P15_FILE').getValue(),
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
function login() {
    apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":9999:" + apex.env.APP_SESSION);
};