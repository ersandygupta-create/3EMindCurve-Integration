tableextension 50002 "3E HIS Bank Ledger Entry" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50000; "3E UTR No."; Code[35])
        {
            Caption = 'UTR No.';
            DataClassification = CustomerContent;
        }
        field(50001; "3E Narration"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Narration';
        }
        field(50002; "3E Cheque No."; Code[30])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
        }
        field(50003; "3E Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;
        }
        field(50004; "3E HIS Document Type"; Text[60])
        {
            Caption = 'HIS Document Type';
            DataClassification = ToBeClassified;
        }
    }
}
