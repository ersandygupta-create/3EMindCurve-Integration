pageextension 50008 "3E User Setup Ext" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("3E Document Delete Approver"; Rec."3E Document Delete Approver")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Delete Approver field.';
            }
            field("3E Document Delete Processor"; rec."3E Document Delete Processor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Delete Processor field.';
            }
        }
    }
}
