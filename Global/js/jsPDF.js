function pdf() {

};

function generate_arr_message(text) {
    var arr = [];
    var start_nr = 0;
    var end_nr = 70;
    var for_nr = Math.floor(text.length/80) + 1;
    for (let i=0; i<for_nr; i++) {
        arr.push(text.substring(start_nr, end_nr));
        start_nr += 70;
        end_nr += 70;
};
    return arr;
};

function gen_mess_pdf(){    
    var height_nr = 40;
    var doc = new jsPDF('p', 'mm', 'a4');
    var arr = generate_arr_message(apex.item("P16_CONTENT").getValue());
    doc.text(60, 10, "Your sales representative's name:");
    doc.text(70, 20, apex.item("P16_ID_EMP").getValue());
    doc.text(40, 30, 'Content of your sent message and attachments:');
    for (let i = 0; i < arr.length; i++) {
        doc.text(10, height_nr, arr[i]);
        height_nr += 10;
        };
    doc.text(40, 290, 'Greetings from the "APEX Store Premium" team.');
    doc.save('your_message.pdf');
};