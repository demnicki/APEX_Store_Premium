BEGIN
    SELECT description INTO :P10_DESC FROM account_operations WHERE id_trans = :P10_ID_TRANS;
END;