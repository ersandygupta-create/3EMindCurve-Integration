pageextension 50005 "3E HIS Cust. Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("3E HIS Module"; Rec."3E HIS Module")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("3E HIS Document Type"; Rec."3E HIS Document Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("3E Receipt No."; Rec."3E Receipt No.")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("3E UHID"; Rec."3E UHID")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("3E Patient Name"; Rec."3E Patient Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("3E Encounter No."; Rec."3E Encounter No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("3E Doctor Name"; Rec."3E Doctor Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("3E Speciality"; Rec."3E Speciality")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("3E Sponsor Code"; Rec."3E Sponsor Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("3E Sponsor Name"; Rec."3E Sponsor Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("3E Payer Code"; Rec."3E Payer Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("3E Payer Name"; Rec."3E Payer Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
