var id_user;
var content_html;

function init_page() {
    var all_coockie = document.cookie;
    var array_cookie = all_coockie.split('id_user=');
    array_cookie = array_cookie[1].split(';');
    id_user = array_cookie[0];
    if (localStorage.hasOwnProperty('general')) {
        content_html = '<p>This permalink has already been used.</p>';
    }
    else {
        content_html = '<p>Your click has credited the account of the promoter with ID <b>' + id_user + '</b>, with the amount of <b>EUR 1.50</b>.</p></br ><p>You will be redirected to the main page of the website in a moment.</p>';
        localStorage.setItem('general', '{}');
        up_eur();
    };
    document.getElementById('center_content').innerHTML = document.getElementById('center_content').innerHTML + content_html;
};

function up_eur() {

};