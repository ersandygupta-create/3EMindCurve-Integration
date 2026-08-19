pageextension 50007 "3E Dimension Value Ext" extends "Dimension Values"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                Caption = 'Name 2';
                ApplicationArea = All;
                ToolTip = 'Specify the name 2 field.';
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