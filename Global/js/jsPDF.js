window.jsPDF = window.jspdf.jsPDF;

var table_user_info = [
    ['Your ID', '&ID_USER.'], ['Funds available in your account in Euro currency.', '€ &EUR.'], ['Your full name', '&NAME_USER.']
];

var array_shop_cart = [];

function pdf() {
    var doc = new jsPDF("p", "pt", "a4");
    doc.setFontSize(17);
    doc.text(220, 40, "Basic user data");
    doc.autoTable({
        startY: 60,
        body: table_user_info,
        theme: 'grid',
    });
    doc.text(100, 150, "Order Details: The contents of your shopping cart.");
    doc.autoTable({
        startY: 180,
        body: [['Nr', 'Name product', 'Quantity', 'Cost'], array_shop_cart, ['Total costs: ', '&.']],
        theme: 'grid',
    });
    doc.save('your_raport.pdf');
};

function gen_mess_pdf(){
    alert('Funkcja');
};