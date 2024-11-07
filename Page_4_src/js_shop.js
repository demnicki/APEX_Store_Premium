/*

*/

function logo_shop() {
    var random_n = 0;
    var text_input_logo = '';
    for (let i = 0; i < array_logo.length; i++) {
        random_n = Math.round(Math.random() * 12);
        text_input_logo = text_input_logo + '<font color="' + array_colors[random_n] + '">' + array_logo[i] + '</font>';
    };
    document.getElementById('logo_shop').innerHTML = text_input_logo;
};

function add_product(in_id_product) {
    apex.server.process(
        'Add_product',
        {
            x01: in_id_product,
        },
        {
            success: function (Data) {
                apex.message.alert('Product added to shopping cart.');
            },
            dataType: "text"
        },
        {
            error: function () { apex.message.alert('Fatal error. Please try again or contact support.'); }
        }
    );    
};