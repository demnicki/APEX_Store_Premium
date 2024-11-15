function add_product(id_prod) {
    apex.server.process(
        'Add_product',
        {
            x01: id_prod,
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

function decrease(nr_prod){
   apex.server.process(
        'Decrease_quantity',
        {
            X01: nr_prod
        },
        {
            success: function (Data) {
                if (Data.quantity > 0) {
                    apex.message.alert('Product quantity reduced. You currently have '+Data.v_quantity+' of this product in your shopping cart.');
                }
                else if (Data.quantity == 0){
                    apex.message.alert('This product has been removed from your shopping cart.');
                };
                
            },
            dataType: "json"
        },
        {
            error: function () {}
        }
    );

};

function increase(nr_prod){
    apex.server.process(
        'Increase_quantity',
        {
            X01: nr_prod
        },
        {
            success: function (Data) {
                apex.message.alert('Product quantity increased. You currently have '+Data.v_quantity+' of this product in your shopping cart.');
            },
            dataType: "json"
        },
        {
            error: function () {}
        }
    );
    
};