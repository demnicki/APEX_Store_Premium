var all_local_storage;
var login_mail = 'adam@wp.pl';
var id_user = '1001';
var order_nr = '12345678';
var content_message = 'Your message';
var add_app_1 = false;
var add_app_2 = false;
var add_app_3 = false;
var add_app_4 = false;
var nr_pieces_cloud = 0;
var nr_pieces_windows = 0;
var nr_pieces_h_consult = 0;
var nr_pieces_h_programming = 0;

function true_or_false(volumen) {
    if (volumen)
    { return 'true' }
    else
    { return 'false' };
};
function overwrite_local_storage() {
    all_local_storage = '{ "login_mail": "' + login_mail + '", "order_nr": "' + order_nr + '", "content_message": "' + content_message + '", "add_app_1": ' + true_or_false(add_app_1) + ', "add_app_2": ' + true_or_false(add_app_2) + ', "add_app_3": ' + true_or_false(add_app_3) + ', "add_app_4": ' + true_or_false(add_app_4) + ', "nr_pieces_cloud": ' + nr_pieces_cloud + ', "nr_pieces_windows": ' + nr_pieces_windows + ', "nr_pieces_h_consult": ' + nr_pieces_h_consult + ', "nr_pieces_h_programming": ' + nr_pieces_h_programming +' }';
    localStorage.setItem('general', all_local_storage);
};