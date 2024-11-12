var sec = 6;
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
var text_motto = '&#8222;They do not exist the limits of possibility, and the passing of time it is just an illusion.&#8221;';

function logo() {
    sec = sec - 1;
    var random_n = 0;
    var text_input_logo = '';
    var text_input_motto = '';
    for (let i = 0; i < array_logo.length; i++) {
        random_n = Math.round(Math.random() * 12);
        text_input_logo = text_input_logo + '<font color="' + array_colors[random_n] + '">' + array_logo[i] + '</font>';
    };
    document.getElementById('motto').innerHTML = '<font color="' + array_colors[random_n] + '">' + text_motto + '</font>';
    document.getElementById('logo').innerHTML = text_input_logo;
    document.getElementById('second_hand').innerHTML = sec;
};