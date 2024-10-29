/*

*/
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