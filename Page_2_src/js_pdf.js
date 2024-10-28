function pdf() {
    var doc = new jsPDF();
    doc.autoTable({
        theme: 'plain',
        headStyles: { fontSize: 20 },
        bodyStyles: { fontSize: 20, fontStyle: 'italic' },

        head: [['Position in the table.', 'Variable value']],
        body: [['You ID', '&ID_USER.'], ['You are logged in as:', '&LOGIN_EMAIL.'], ['Your current account balance in euro:', '&EUR.']],

    });
    doc.save('Raport_your_profil.pdf');
};