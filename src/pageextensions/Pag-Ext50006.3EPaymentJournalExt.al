pageextension 50006 "3E Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        addafter(CommentField)
        {
            field("3E UTR No."; Rec."3E UTR No.")
            {
                Caption = 'UTR No.';
                ToolTip = 'Specify the UTR No. field.';
                ApplicationArea = All;
            }
            field("3E Narration"; Rec."3E Narration")
            {
                Caption = 'Narration';
                ToolTip = 'Specify the Narrtion field.';
                ApplicationArea = All;
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