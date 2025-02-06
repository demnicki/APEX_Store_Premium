function pdf() {

};

function gen_mess_pdf(){
    var doc = new jsPDF('p', 'mm', 'a4');
    pdf.setFontSize(20);
    pdf.setFont("times");
    pdf.setFontType("bold");
    pdf.setTextColor(255, 0, 0);
    pdf.text(10, 10, apex.item("P16_ID_EMP").getValue());
    pdf.text(10, 10, apex.item("P16_CONTENT").getValue());
    doc.save('your_message.pdf');
};