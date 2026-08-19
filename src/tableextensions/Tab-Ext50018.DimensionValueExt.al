tableextension 50018 "3E Dimension Value Ext" extends "Dimension Value"
{
    fields
    {
        field(50000; "Name 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}