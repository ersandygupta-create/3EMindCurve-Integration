pageextension 50002 "3E Vendor Led Entries Ext" extends "Vendor Ledger Entries"
{
    layout
    {
    }

    actions
    {
        addbefore("&Navigate")
        {
            action("3E Print Payment Advice")
            {
                ApplicationArea = All;
                Caption = 'Print Payment Advice';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Prepare to the print Payment Advice Document';

                trigger OnAction()
                begin
                    IF (Rec."Document Type" = Rec."Document Type"::Payment) OR (Rec."Document Type" = Rec."Document Type"::" ") THEN begin
                        VendorLedgerEntry.Reset();
                        VendorLedgerEntry.SetRange("Document No.", Rec."Document No.");
                        VendorLedgerEntry.SetRange("Vendor No.", Rec."Vendor No.");
                        if VendorLedgerEntry.FindFirst() then
                            Report.RunModal(Report::"3E Vendor - Payment Advice", true, false, VendorLedgerEntry);
                    end else
                        Error('Please Payment Advice Select only Payment Document !');
                end;
            }
        }

    }

    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
}