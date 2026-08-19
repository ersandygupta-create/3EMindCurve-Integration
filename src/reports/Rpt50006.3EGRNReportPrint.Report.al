report 50006 "3E GRN Report Print"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Rpt50006.3EGRNReportPrint.rdl';
    Caption = 'GRN Report Print';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE("No." = FILTER(<> ''));
            RequestFilterFields = "No.";
            column(CompanyLogo; CompanyInformation.Picture)
            {
            }
            column(CompName; CompanyInformation.Name)//CompName)
            {
            }
            column(COMPHomePage; CompanyInformation."Home Page")
            {
            }
            column(CompanyVATNo; CompanyInformation."VAT Registration No.")
            {
            }
            column(ComanyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompAdd; CompanyInformation.Address + ' , ' + CompanyInformation."Address 2")
            {
            }
            column(TelNo; CompanyInformation."Phone No.")
            {
            }
            column(LocationName; LocationName)
            {
            }
            column(LocationAdd; LocationAdd)
            {
            }
            column(LocationGSTIN; LocationGSTIN)
            {
            }
            column(Dept; txtdescruption)
            {
            }
            column(Locationcode; "Purch. Rcpt. Header"."Location Code")
            {
            }
            column(GRNNo; "Purch. Rcpt. Header"."No.")
            {
            }
            column(VenPhone; "Purch. Rcpt. Header"."Pay-to Contact no.")
            {
            }
            column(VedrEmail; Vendor."E-Mail")
            {
            }
            column(VendorPANNo; VendorPANNo)
            {
            }
            column(City; City)
            {
            }
            column(PostCode; PostCode)
            {
            }
            column(GSRDate; Format("Purch. Rcpt. Header"."Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>'))
            {
            }
            column(PONo; "Purch. Rcpt. Header"."Order No.")
            {
            }
            column(PODate; Format("Purch. Rcpt. Header"."Order Date", 0, '<Day,2>-<Month Text,3>-<Year4>'))
            {
            }
            column(Createdby; userc."User Name")
            {
            }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(ItemNo; "Purch. Rcpt. Line"."No.")
                {
                }
                column(ItemName; "Purch. Rcpt. Line".Description)
                {
                }
                column(UOM; "Purch. Rcpt. Line"."Unit of Measure")
                {
                }
                column(ReceiptQTY; "Purch. Rcpt. Line".Quantity)
                {
                }
                column(QTYInvoiced; "Purch. Rcpt. Line"."Quantity Invoiced")
                {
                }
                column(VendorCode; VendorCode)
                {
                }
                column(VendorName; VendorName)
                {
                }
                column(VendorGSTIN; VendorGSTIN)
                {
                }
                column(VendorAddress; VendorAddress)
                {
                }
                column(Unitcost; "Purch. Rcpt. Line"."Unit Cost")
                {
                }
                column(GstbaseAmt; "Purch. Rcpt. Line"."VAT Base Amount")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Vendor.RESET;
                    Vendor.SETRANGE("No.", "Buy-from Vendor No.");
                    IF Vendor.FINDFIRST THEN BEGIN
                        VendorCode := Vendor."No.";
                        VendorName := Vendor.Name;
                        VendorGSTIN := Vendor."VAT Registration No.";
                        VendorEmail := Vendor."E-Mail";
                        VendorAddress := Vendor.Address + ' ' + Vendor."Address 2";
                        City := Vendor.City;
                        PostCode := Vendor."Post Code";

                        if userc.Get(SystemCreatedBy) then;
                        if userm.Get(SystemModifiedBy) then;

                    END;

                    // sandeep

                    txtdescruption := '';
                    DimensionValue.RESET;
                    DimensionValue.SETRANGE("Dimension Code", '%1', 'DEPARTMENT');
                    DimensionValue.SETRANGE(Code, "Shortcut Dimension 2 Code");
                    IF DimensionValue.FINDFIRST THEN BEGIN
                        txtdescruption := DimensionValue.Name;
                    END;

                    LocationAdd := '';
                    LocationEmail := '';
                    LocationPhoneNo := '';
                    LocationGSTIN := '';
                    LocationName := '';
                    IF "Purch. Rcpt. Header"."Location Code" <> '' THEN BEGIN
                        Location.RESET;
                        Location.SETRANGE(Code, "Purch. Rcpt. Header"."Location Code");
                        IF Location.FINDFIRST THEN BEGIN
                            LocationName := Location.Name;
                            LocationAdd := Location.Address + ', ' + Location."Address 2" + ', ' + Location.City + ', ' + FORMAT(Location."Post Code");
                            LocationEmail := Location."E-Mail";
                            LocationPhoneNo := Location."Phone No.";
                        END;
                    end;

                end;

            }
        }

    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.RESET;
        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);
        CompName := CompanyInformation.Name;
    end;

    var
        CompanyInformation: Record 79;
        CompName: Text;
        Vendor: Record 23;
        VendorCode: Code[20];
        VendorName: Text;
        COMPANNo: Code[10];
        VendorPANNo: Code[10];
        VendorGSTIN: Code[15];
        VendorAddress: Text;
        City: Text[50];
        PostCode: Code[10];
        VendorEmail: Text;
        PurchaseHeader: Record 38;
        AmttoVendr: Decimal;
        DimensionValue: Record 349;
        txtdescruption: Text;
        userc: Record User;
        userm: Record User;
        Location: Record Location;
        LocationName: Text[100];
        LocationEmail: Code[100];
        LocationPhoneNo: Code[50];
        LocationGSTIN: Code[15];
        LocationWebsite: Text[200];
        LocationAdd: Code[200];

}

