pageextension 50004 "3E Bank Account Ledger Ext" extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("3E Cheque No."; Rec."3E Cheque No.")
            {
                Caption = 'Cheque No.';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specify the Cheque No field.';
            }
            field("3E Cheque Date"; Rec."3E Cheque Date")
            {
                Caption = 'Cheque Date';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specify the Cheque Date field.';
            }
            field("3E UTR No."; Rec."3E UTR No.")
            {
                Caption = 'UTR No.';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specify the UTR No. field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}