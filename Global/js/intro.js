var nr_char_domain = 11;
var nr_char_logo = 0;
var color_domain = 'white';
var color_logo = 'white';
var array_domain = [
    'A',
    'P',
    'E',
    'X',
    '4',
    'b',
    'i',
    'z',
    '.',
    'c',
    'o',
    'm'];
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
function intro() {
    nr_char_domain--;
    nr_char_logo++;
    var text_input_logo = '';
    var text_input_domain = '';
    for (let i = 0; i < array_logo.length; i++) {
        if (i == nr_char_logo) {
            color_logo = 'goldenrod';
        } else {
            color_logo = 'white';
        };
        text_input_logo = text_input_logo + '<font color="' + color_logo + '">' + array_logo[i] + '</font>';
    };
    for (let i = 0; i < array_domain.length; i++) {
        if (i == nr_char_domain) {
            color_domain = 'goldenrod';
        } else {
            color_domain = 'white';
        };
        text_input_domain = text_input_domain + '<font color="' + color_domain + '">' + array_domain[i] + '</font>';
    };
    document.getElementById('domain').innerHTML = text_input_domain;
    document.getElementById('logo').innerHTML = text_input_logo;
};