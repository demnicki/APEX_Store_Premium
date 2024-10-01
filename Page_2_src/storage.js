var all_local_storage;
function overwrite_local_storage() {
    all_local_storage = JSON.parse(localStorage.getItem('general'));
    all_local_storage.login_email = apex.env.APP_USER;
    localStorage.setItem('general', JSON.stringify(all_local_storage));
};

function tester() {
    localStorage.setItem('general', '{"color":10,"login_email":"adamd@wp.pl","id_user":"1001","order_nr":"12345678","content_message":"Your message","add_app_1":false,"add_app_2":false,"add_app_3":false,"add_app_4":false,"nr_pieces_cloud":0,"nr_pieces_windows":0,"nr_pieces_h_consult":0,"nr_pieces_h_programming":0}');
};