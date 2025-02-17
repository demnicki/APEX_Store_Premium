function add_product(id_prod) {
    apex.server.process(
        'Add_product',
        {
            x01: id_prod,
        },
        {
            success: function (Data) {
                apex.navigation.dialog.close(true);
                apex.message.alert('Product added to shopping cart.');
                setTimeout(() => {apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":4:" + apex.env.APP_SESSION);}, 5000);
            },
            dataType: "text"
        },
        {
            error: function () { apex.message.alert('Fatal error. Please try again or contact support.'); }
        }
    );    
};

function decrease(id_prod){
   apex.server.process(
        'Decrease_quantity',
        {
            X01: id_prod
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

function increase(id_prod){
    apex.server.process(
        'Increase_quantity',
        {
            X01: id_prod
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

function delete_product(id_prod){
    apex.server.process(
        'Delete_product',
        {
            X01: id_prod
        },
        {
            success: function (Data) {
                apex.message.alert('The product has been removed.');
            },
            dataType: "json"
        },
        {
            error: function () {}
        }
    );
};

function place_order(){
    apex.server.process(
        'Place_order',
        {},
        {
            success: function (Data) {
                if (Data.is_logged){
                    apex.navigation.dialog.close(true);
                    apex.message.alert('Your order has been placed. Go to your user panel.');
                    setTimeout(() => {apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":2:" + apex.env.APP_SESSION);}, 2000);
                    
                }else{
                    apex.message.alert('To place an order, please log in or register first.');
                };                
            },
            dataType: "json"
        },
        {
            error: function () {}
        }
    );
};

function cancel_order(id_prod, id_user){
    apex.server.process(
        'Cancel_order',
        {
            X01: id_prod,
            X02: id_user
        },
        {
            success: function (Data) {
                apex.message.alert('This product has been removed from your wish list. Your order has been reduced.');
                setTimeout(() => {apex.navigation.redirect("f?p=" + apex.env.APP_ID + ":2:" + apex.env.APP_SESSION);}, 2000);
            },
            dataType: "json"
        },
        {
            error: function () {}
        }
    );
};

function download(){
  apex.message.alert('This service or product has not been paid for yet. Check your transaction history.');
};

function paycheck(){
    apex.message.showErrors([
        {
            type:       "error",
            location:   [ "page",],
            message:    "Your available funds have not reached the required amount for withdrawal.",
            unsafe:     false
        }]);
};