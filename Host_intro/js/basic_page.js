﻿var v_login_mail = '@';

function go_to_panel(nr_if_login, eur) {
    var v_nr_if_login = parseInt(nr_if_login);
    var v_eur = parseFloat(eur);
    if (v_nr_if_login = 1 && v_eur > 5) {
        apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":2:" + apex.env.APP_SESSION);
    }
    else if (v_nr_if_login = 1 && v_eur < 5) {
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
function message_box() {
    apex.message.alert('This service is not ready yet.');
};

function shopping_cart() {
    apex.message.alert('This service is not ready yet.');
};

function login() {
    apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":9999:" + apex.env.APP_SESSION);
};