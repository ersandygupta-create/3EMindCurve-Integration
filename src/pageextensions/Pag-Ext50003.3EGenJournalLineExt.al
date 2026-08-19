pageextension 50003 "3E HIS General Journal" extends "General Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("3E HIS Document Type"; Rec."3E HIS Document Type")
            {
                Caption = 'HIS Document Type';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HIS Document Type field.';
            }
            field("3E Receipt No."; Rec."3E Receipt No.")
            {
                Caption = 'Receipt No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receipt No. field.';
            }
            field("3E UHID"; Rec."3E UHID")
            {
                Caption = 'UHID';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the UHID field.';
            }
            field("3E Patient Name"; Rec."3E Patient Name")
            {
                Caption = 'Patient Name';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Patient Name field.';

            }
            field("3E UTR No."; Rec."3E UTR No.")
            {
                Caption = 'UTR No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the UTR No. field.';
            }
            field("3E Narration"; Rec."3E Narration")
            {
                Caption = 'Narration';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Narration field.';
            }
            field("3E Store Code"; Rec."3E Store Code")
            {
                Caption = 'Store Code';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Store Code field.';
            }
            field("3E Sub Group Code"; Rec."3E Sub Group Code")
            {
                Caption = 'Sub Group Code';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sub Group Code field.';
            }
            field("3E HIS Module"; Rec."3E HIS Module")
            {
                Caption = 'HIS Module';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HIS Module field.';
            }
            field("3E Validation Key"; Rec."3E Validation Key")
            {
                Caption = 'Validation Key';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Validation Key field.';

            }

        }
    }
}
