pageextension 50001 "3E GL Entry Ext" extends "General Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("GL Account Name"; Rec."G/L Account Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the G/L Account Name field.';
            }
            field("3E HIS Document Type"; Rec."3E HIS Document Type")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the HIS Document Type field.';
            }
            field("3E Receipt No."; Rec."3E Receipt No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Receipt No. field.';
            }

            field("3E UHID"; Rec."3E UHID")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the UHID field.';
            }
            field("3E Patient Name"; Rec."3E Patient Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Patient Name field.';
            }
            field("3E Validation Key"; Rec."3E Validation Key")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Validation Key field.';
            }
            field("3E Encounter No."; Rec."3E Encounter No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Encounter No. field.';
            }
            field("3E Doctor Name"; Rec."3E Doctor Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Doctor Name field.';
            }
            field("3E Speciality"; Rec."3E Speciality")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Speciality field.';
            }
            field("3E Sponsor Code"; Rec."3E Sponsor Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Sponsor Code field.';
            }
            field("3E Sponsor Name"; Rec."3E Sponsor Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Sponsor Name field.';
            }
            field("3E Payer Code"; Rec."3E Payer Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Payer Code field.';
            }
            field("3E Payer Name"; Rec."3E Payer Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Payer Name field.';
            }
            field("3E Narration"; Rec."3E Narration")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Narration field.';
            }
            field("3E UTR No."; Rec."3E UTR No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the UTR No. field.';
            }

            field("3E Store Code"; Rec."3E Store Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Store Code field.';
            }
            field("3E Sub Group Code"; Rec."3E Sub Group Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Sub Group Code field.';
            }
            field("3E HIS Module"; Rec."3E HIS Module")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the HIS Module field.';
            }

        }
    }

    actions
    {
        addbefore("&Navigate")
        {
            action("Print Voucher Dimension")
            {
                ApplicationArea = All;
                Caption = 'Print Voucher Dimension';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Print;
                ToolTip = 'Executes the Print Voucher Dimension action.';
                trigger OnAction()
                begin
                    GLEntry.RESET;
                    GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                    GLEntry.SETRANGE("Document No.", Rec."Document No.");
                    GLEntry.SETRANGE("Posting Date", Rec."Posting Date");
                    if GLEntry.FindFirst() then
                        REPORT.RUNMODAL(REPORT::"3E Voucher - Post Voucher", TRUE, TRUE, GLEntry);

                end;
            }
        }
    }

    var
        GLEntry: Record "G/L Entry";
}