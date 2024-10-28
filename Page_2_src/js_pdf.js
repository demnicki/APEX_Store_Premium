﻿function pdf() {
    var doc = new jsPDF();
    doc.autoTable({
        theme: 'plain',
        headStyles: { fontSize: 20 },
        bodyStyles: { fontSize: 20, fontStyle: 'italic' },

        head: [['Position in the table.', 'Variable value']],
        body: [['You ID', '&ID_USER.'], ['You are logged in as:', '&APP_USER.'], ['Your current account balance in euro:', '&EUR.']],

    });

    doc.autoTable({
        theme: 'plain',
        headStyles: { fontSize: 10 },
        bodyStyles: { fontSize: 8, fontStyle: 'italic' },

        head: [['ID', 'Name', 'Country']],
        body: [['1', 'Simon', 'Swedenddd'], ['2', 'Karl', 'Norway']],

    });
    doc.save('Raport_your_profil.pdf');
};