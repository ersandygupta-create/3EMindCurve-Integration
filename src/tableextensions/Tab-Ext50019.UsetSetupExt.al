tableextension 50019 "3E Uset Setup Ext" extends "User Setup"
{
    fields
    {
        field(50000; "3E Document Delete Approver"; Boolean)
        {
            Caption = 'Document Delete Approver';
            DataClassification = CustomerContent;
        }
        field(50001; "3E Document Delete Processor"; Boolean)
        {
            Caption = 'Document Delete Processor';
            DataClassification = CustomerContent;
        }
    }
}
