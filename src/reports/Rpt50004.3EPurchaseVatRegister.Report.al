report 50004 "3E Purchase VAT Register"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Purchase VAT Register';

    dataset
    {
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Quantity = FILTER(<> 0), "No." = FILTER(<> ''));

            trigger OnAfterGetRecord()
            begin
                if DocumentType <> DocumentType::" " then begin
                    if (DocumentType = DocumentType::"CREDIT NOTE") then
                        CurrReport.Skip;
                end;

                if blnExportToExcel then
                    MakeExcelDataBody
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", StartDate, EndDate);

                Counter := 1;

                if VarLocCode <> '' then
                    LocationCode := LocationCode;

                if LocationCode <> '' then
                    SetFilter("Location Code", LocationCode);


                if DivisionCode <> '' then
                    SetFilter("Shortcut Dimension 1 Code", DivisionCode);

                if BranchCode <> '' then
                    SetFilter("Shortcut Dimension 2 Code", BranchCode);

                if ItemCode <> '' then
                    SetFilter("No.", ItemCode);

                if VendorCode <> '' then
                    SetFilter("Buy-from Vendor No.", VendorCode);

                if GLAccountNo <> '' then
                    SetFilter("No.", GLAccountNo);
            end;
        }
        dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") WHERE("No." = FILTER(<> ''), Quantity = FILTER(<> 0));

            trigger OnAfterGetRecord()
            begin
                if DocumentType <> DocumentType::" " then begin
                    if (DocumentType = DocumentType::INVOICE) then
                        CurrReport.Skip;
                end;


                if blnExportToExcel then
                    MakeExcelDataBody_Cr;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", StartDate, EndDate);

                Counter := 1;
                // if GSTINNo <> '' then begin
                //     LocationRec.Reset;
                //     LocationRec.SetFilter(LocationRec."GST Registration No.", GSTINNo);
                //     if LocationRec.FindFirst then
                //         repeat
                //             if Counter = 1 then
                //                 VarLocCode := LocationRec.Code
                //             else
                //                 VarLocCode += '|' + LocationRec.Code;
                //             Counter += 1;
                //         until LocationRec.Next = 0;
                // end;

                if VarLocCode <> '' then
                    LocationCode := LocationCode;

                if LocationCode <> '' then
                    SetFilter("Location Code", LocationCode);


                if DivisionCode <> '' then
                    SetFilter("Shortcut Dimension 1 Code", DivisionCode);

                if BranchCode <> '' then
                    SetFilter("Shortcut Dimension 2 Code", BranchCode);

                if ItemCode <> '' then
                    SetFilter("No.", ItemCode);

                if VendorCode <> '' then
                    SetFilter("Buy-from Vendor No.", VendorCode);

                if GLAccountNo <> '' then
                    SetFilter("No.", GLAccountNo);
            end;
        }

    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("From Date"; StartDate)
                {
                    ApplicationArea = All;
                }
                field("To Date"; EndDate)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; LocationCode)
                {
                    ApplicationArea = All;
                    TableRelation = Location;

                }
                field("Unit Code"; DivisionCode)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

                }
                field("Department Code"; BranchCode)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
                }
                field(Item; ItemCode)
                {
                    ApplicationArea = All;
                    TableRelation = Item;

                }
                field("Vendor Code"; VendorCode)
                {
                    ApplicationArea = All;
                    TableRelation = Vendor;

                }
                field("Document Type"; DocumentType)
                {
                    ApplicationArea = All;
                }
                field("Export to Excel"; blnExportToExcel)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            blnExportToExcel := true;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if blnExportToExcel then
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        if (StartDate = 0D) and (EndDate = 0D) then
            Error('Please check Date Filter');


        Month := Date2DMY(EndDate, 2);
        case Month of
            1 .. 3:
                txtQuarter := 'Q4';
            4 .. 6:
                txtQuarter := 'Q1';
            7 .. 9:
                txtQuarter := 'Q2';
            else
                txtQuarter := 'Q3';
        end;

        if blnExportToExcel then
            MakeExcelInfo;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        CompanyInformation: Record "Company Information";
        ExcelBuf: Record "Excel Buffer" temporary;
        blnExportToExcel: Boolean;
        CessAmount: Decimal;
        CessRate: Decimal;
        Text001: Label 'Purchase VAT Register';
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        GenPostingSetup: Record "General Posting Setup";
        Location: Record Location;
        ShiptoAddress: Record "Ship-to Address";
        Vendor: Record Vendor;
        FiscalYearStartDate: Date;
        FiscalYearEndDate: Date;
        LastYearStartDate: Date;
        LastYearEndDate: Date;
        Month: Integer;
        txtQuarter: Text;
        PurchInvHeader: Record "Purch. Inv. Header";
        txtLedgerDescription: Text[200];
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        LocationCode: Text;
        Counter: Integer;
        LocationRec: Record Location;
        VarLocCode: Text;
        DivisionCode: Text;
        BranchCode: Text;
        DimensionValue: Record "Dimension Value";
        DimensionValuesPage: Page "Dimension Values";
        OrigianlDocDate: Date;
        OrigianlDocNo: Code[30];
        ChrItemNo: Code[20];
        cdVendorReferenceNo: Text;
        HisPurchSalesHeader: Record "3E HIS Purchase Header";
        cdVendorInvoiceNo: Text;
        cdVendorInvoiceDate: Date;
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        dtDocumentDate: Date;
        ItemCode: Text;
        VendorCode: Text;
        DocumentType: Option " ",INVOICE,"CREDIT NOTE";
        GLAccountNo: Text;
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        DeptName: Text[100];
        UnitName: Text[100];


    procedure MakeExcelInfo()
    begin

        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Company Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Company Name
        ExcelBuf.AddColumn('Document No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Document No. 
        ExcelBuf.AddColumn('Posting Date', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Posting Date 
        ExcelBuf.AddColumn('Document Type', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Document Type
        ExcelBuf.AddColumn('Unit Code', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Dimension1    
        ExcelBuf.AddColumn('Unit Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Dimension1   
        ExcelBuf.AddColumn('Department Code', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Dimension2  
        ExcelBuf.AddColumn('Department Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Dimension1 
        ExcelBuf.AddColumn('Store Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Store Name  
        ExcelBuf.AddColumn('Buy-from Vendor No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Buy-from Vendor No.
        ExcelBuf.AddColumn('Vendor Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Buy-from Vendor Name
        ExcelBuf.AddColumn('Vendor Address', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Vendor Address
        ExcelBuf.AddColumn('Vendor Invoice/Cr. Memo No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Vendor Invoice No.
        ExcelBuf.AddColumn('Vendor Invoice Date', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Document Date
        ExcelBuf.AddColumn('Receipt/Return No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Posting Group', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Vendor Posting Group
        ExcelBuf.AddColumn('VAT Registration No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//VAT Registration No.
        ExcelBuf.AddColumn('Type', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Type
        ExcelBuf.AddColumn('Code No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Item No.
        ExcelBuf.AddColumn('Item Description', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Item Description    
        ExcelBuf.AddColumn('Ledger Description', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Ledger Description           
        ExcelBuf.AddColumn('Location Code', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Location Code
        ExcelBuf.AddColumn('Location Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Location Name
        ExcelBuf.AddColumn('City', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//City
        ExcelBuf.AddColumn('Ship-to City', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Ship-to City
        ExcelBuf.AddColumn('Quantity', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Quantity
        ExcelBuf.AddColumn('Unit of Measurement', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Unit Price', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Line Amount
        ExcelBuf.AddColumn('Discount Amount ', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Discount Amt
        ExcelBuf.AddColumn('Gross Amount ', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Unit Cost        
        ExcelBuf.AddColumn('VAT Amount', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//VAT Amount
        ExcelBuf.AddColumn('Total Amount', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Total Amount

    end;

    procedure MakeExcelDataBody()
    var
        BlankFiller: Text[250];
        Item: Record Item;
        PurchInvHeader1: Record "Purch. Inv. Header";
        cdPostedDocumentNo1: Text;
        cdReferenceNo1: Text;
        dtPostingDate1: Date;
        cdVendorReferenceNo1: Text;
        cdVendorInvoiceNo1: Text;
        cdVendorInvoiceDate1: Date;
        VATAmt: Decimal;
    begin
        ExcelBuf.NewRow;
        CompanyInformation.Get();
        ExcelBuf.AddColumn(CompanyInformation.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company        
        ExcelBuf.AddColumn("Purch. Inv. Line"."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Document No
        ExcelBuf.AddColumn(("Purch. Inv. Line"."Posting Date"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);//Posting Date
        ExcelBuf.AddColumn('Purchase Invoice', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Document Type
        ExcelBuf.AddColumn("Purch. Inv. Line"."Shortcut Dimension 1 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Dimension1
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, PurchInvHeader."Shortcut Dimension 1 Code");
        IF DimensionValue.Find('-') then
            UnitName := DimensionValue.Name;
        ExcelBuf.AddColumn(UnitName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Line"."Shortcut Dimension 2 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Dimension2
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, PurchInvHeader."Shortcut Dimension 2 Code");
        IF DimensionValue.Find('-') then
            DeptName := DimensionValue.Name;
        ExcelBuf.AddColumn(DeptName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//DEPT Name        
        ExcelBuf.AddColumn(PurchInvHeader."Store Name", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Store Name      
        PurchInvHeader.Get("Purch. Inv. Line"."Document No.");
        // HisPurchSalesHeader.Reset();
        // HisPurchSalesHeader.SetRange("Record Type", HisPurchSalesHeader."Record Type"::GRN);
        // HisPurchSalesHeader.SetRange("Document Type", HisPurchSalesHeader."Document Type"::Order);
        // HisPurchSalesHeader.SetRange("Document No.", "Purch. Inv. Line"."Document No.");
        // IF HisPurchSalesHeader.FindFirst() then
        ExcelBuf.AddColumn("Purch. Inv. Line"."Buy-from Vendor No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Buy-from Vendor No.
        if Vendor.Get("Purch. Inv. Line"."Buy-from Vendor No.") then
            ExcelBuf.AddColumn(Vendor.Name + ' ' + Vendor."Name 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Buy-from Vendor Name

        ExcelBuf.AddColumn(Vendor.Address + ' ' + Vendor."Address 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Vendor Address
        IF PurchInvHeader."Vendor Invoice No." <> '' then
            ExcelBuf.AddColumn(PurchInvHeader."Vendor Invoice No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//Vendor Invoice No_
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Vendor Invoice No_
                                                                                                   // if PurchInvHeader."Document Date" <> 0D then
                                                                                                   //     ExcelBuf.AddColumn(HisPurchSalesHeader."Document Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Date)//Document Date
                                                                                                   // else
        ExcelBuf.AddColumn(PurchInvHeader."Document Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Document Date
        ExcelBuf.AddColumn("Purch. Inv. Line"."Receipt No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(PurchInvHeader."Vendor Posting Group", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Vendor Posting Group
        ExcelBuf.AddColumn(PurchInvHeader."VAT Registration No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//VAT Registration No.
        ChrItemNo := '';
        OrigianlDocNo := '';
        OrigianlDocDate := 0D;
        ExcelBuf.AddColumn("Purch. Inv. Line".Type, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Type
        if "Purch. Inv. Line".Type = "Purch. Inv. Line".Type::"Charge (Item)" then
            ExcelBuf.AddColumn(ChrItemNo, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//ItemNo
        else
            ExcelBuf.AddColumn("Purch. Inv. Line"."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//ItemNo

        if "Purch. Inv. Line".Type = "Purch. Inv. Line".Type::"Charge (Item)" then begin
            if Item.Get(ChrItemNo) then
                ExcelBuf.AddColumn(Item.Description + '' + Item."Description 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//ItemName
        end else
            ExcelBuf.AddColumn("Purch. Inv. Line".Description + '' + "Purch. Inv. Line"."Description 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//ItemName
        txtLedgerDescription := '';
        PurchInvLine.Reset();
        PurchInvLine.SetRange(Type, "Purch. Inv. Line".Type::"G/L Account");
        PurchInvLine.SetRange("No.", "Purch. Inv. Line"."No.");
        IF PurchInvLine.FindFirst() then begin
            GLAccount.Get(PurchInvLine."No.");
            txtLedgerDescription := GLAccount.Name;
        end;

        ExcelBuf.AddColumn(txtLedgerDescription, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Vendor Posting Group

        if LocationRec.Get("Purch. Inv. Line"."Location Code") then;
        if "Purch. Inv. Line"."Location Code" <> '' then
            ExcelBuf.AddColumn("Purch. Inv. Line"."Location Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//Location Code
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Location Code
        if LocationRec.Name <> '' then
            ExcelBuf.AddColumn(LocationRec.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//Location Name
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Location Name
        IF PurchInvHeader."Buy-from City" <> '' then
            ExcelBuf.AddColumn(PurchInvHeader."Buy-from City", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//City
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//City
        if PurchInvHeader."Ship-to City" <> '' then
            ExcelBuf.AddColumn(PurchInvHeader."Ship-to City", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//Ship-to City
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Ship-to City
        ExcelBuf.AddColumn("Purch. Inv. Line".Quantity, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//Quantity        
        ExcelBuf.AddColumn("Purch. Inv. Line"."Unit of Measure Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//Quantity
        ExcelBuf.AddColumn("Purch. Inv. Line"."Direct Unit Cost", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//Unit Cost
        ExcelBuf.AddColumn("Purch. Inv. Line"."Inv. Discount Amount", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Purch. Inv. Line"."Line Amount", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//Line Amount
        VATAmt := Round(("Purch. Inv. Line"."Line Amount" * "Purch. Inv. Line"."VAT %" / 100), 0.01);
        ExcelBuf.AddColumn(VATAmt, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//VAT Amount                                                                                                                  //      ExcelBuf.AddColumn(0, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//TDS Amount
        ExcelBuf.AddColumn("Purch. Inv. Line"."Line Amount" + VATAmt, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//Discount

    end;


    procedure MakeExcelDataBody_Cr()
    var
        BlankFiller: Text[250];
        Item: Record Item;
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        cdPostedDocumentNo: Text;
        cdReferenceNo: Text;
        dtPostingDate: Date;
        VATAmt: Decimal;
    begin

        ExcelBuf.NewRow;
        CompanyInformation.Get();
        ExcelBuf.AddColumn(CompanyInformation.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Document No
        ExcelBuf.AddColumn(("Purch. Cr. Memo Line"."Posting Date"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);//Posting Date
        ExcelBuf.AddColumn('Purchase Credit Note', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Document Type
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Shortcut Dimension 1 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Dimension1
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, PurchCrMemoHdr."Shortcut Dimension 1 Code");
        IF DimensionValue.Find('-') then
            UnitName := DimensionValue.Name;
        ExcelBuf.AddColumn(UnitName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Shortcut Dimension 2 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Dimension2
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, PurchCrMemoHdr."Shortcut Dimension 2 Code");
        IF DimensionValue.Find('-') then
            DeptName := DimensionValue.Name;
        ExcelBuf.AddColumn(DeptName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//DEPT Name    
        ExcelBuf.AddColumn(PurchCrMemoHdr."Store Name", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Store Name
        PurchCrMemoHdr.Get("Purch. Cr. Memo Line"."Document No.");
        // HisPurchSalesHeader.Reset();
        // HisPurchSalesHeader.SetRange("Record Type", HisPurchSalesHeader."Record Type"::"GRN Return");
        // HisPurchSalesHeader.SetRange("Document Type", HisPurchSalesHeader."Document Type"::"Return Order");
        // HisPurchSalesHeader.SetRange("Document No.", "Purch. Cr. Memo Line"."Document No.");
        // IF HisPurchSalesHeader.FindFirst() then
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Buy-from Vendor No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Buy-from Vendor No.
        if Vendor.Get("Purch. Cr. Memo Line"."Buy-from Vendor No.") then
            ExcelBuf.AddColumn(Vendor.Name + ' ' + Vendor."Name 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Buy-from Vendor Name

        ExcelBuf.AddColumn(Vendor.Address + ' ' + Vendor."Address 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Vendor Address
        IF PurchCrMemoHdr."Vendor Cr. Memo No." <> '' then
            ExcelBuf.AddColumn(PurchCrMemoHdr."Vendor Cr. Memo No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//Vendor Invoice No_
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Vendor Invoice No_
                                                                                                   // if PurchCrMemoHdr."Document Date" <> 0D then
                                                                                                   //     ExcelBuf.AddColumn(HisPurchSalesHeader."Document Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Date)//Document Date
                                                                                                   // else
        ExcelBuf.AddColumn(PurchCrMemoHdr."Document Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Document Date
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Return Shipment No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(PurchCrMemoHdr."Vendor Posting Group", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Vendor Posting Group
        ExcelBuf.AddColumn(PurchCrMemoHdr."VAT Registration No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//VAT Registration No.
        ChrItemNo := '';
        OrigianlDocNo := '';
        OrigianlDocDate := 0D;
        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Type, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Type
        if "Purch. Cr. Memo Line".Type = "Purch. Cr. Memo Line".Type::"Charge (Item)" then
            ExcelBuf.AddColumn(ChrItemNo, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//ItemNo
        else
            ExcelBuf.AddColumn("Purch. Cr. Memo Line"."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//ItemNo

        if "Purch. Cr. Memo Line".Type = "Purch. Cr. Memo Line".Type::"Charge (Item)" then begin
            if Item.Get(ChrItemNo) then
                ExcelBuf.AddColumn(Item.Description + '' + Item."Description 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//ItemName
        end else
            ExcelBuf.AddColumn("Purch. Cr. Memo Line".Description + '' + "Purch. Cr. Memo Line"."Description 2", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//ItemName
        txtLedgerDescription := '';
        PurchCrMemoLine.Reset();
        PurchCrMemoLine.SetRange(Type, "Purch. Cr. Memo Line".Type::"G/L Account");
        PurchCrMemoLine.SetRange("No.", "Purch. Cr. Memo Line"."No.");
        IF PurchCrMemoLine.FindFirst() then begin
            GLAccount.Get(PurchCrMemoLine."No.");
            txtLedgerDescription := GLAccount.Name;
        end;

        ExcelBuf.AddColumn(txtLedgerDescription, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Ledger Description

        if LocationRec.Get("Purch. Cr. Memo Line"."Location Code") then;
        if "Purch. Cr. Memo Line"."Location Code" <> '' then
            ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Location Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//Location Code
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Location Code
        if LocationRec.Name <> '' then
            ExcelBuf.AddColumn(LocationRec.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//Location Name
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Location Name
        IF PurchCrMemoHdr."Buy-from City" <> '' then
            ExcelBuf.AddColumn(PurchCrMemoHdr."Buy-from City", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//City
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//City
        if PurchCrMemoHdr."Ship-to City" <> '' then
            ExcelBuf.AddColumn(PurchCrMemoHdr."Ship-to City", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)//Ship-to City
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Ship-to City
        ExcelBuf.AddColumn(-"Purch. Cr. Memo Line".Quantity, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//Quantity
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Unit of Measure Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//Quantity
        ExcelBuf.AddColumn(-"Purch. Cr. Memo Line"."Direct Unit Cost", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//Unit Cost
        ExcelBuf.AddColumn(-"Purch. Cr. Memo Line"."Inv. Discount Amount", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-"Purch. Cr. Memo Line"."Line Amount", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//Line Amount
        VATAmt := Round(("Purch. Cr. Memo Line"."Line Amount" * "Purch. Cr. Memo Line"."VAT %" / 100), 0.01);
        ExcelBuf.AddColumn(-VATAmt, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//VAT Amount
        ExcelBuf.AddColumn(-"Purch. Cr. Memo Line"."Line Amount" + VATAmt, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//VAT Amount

    end;


    procedure CreateExcelbook()
    var
        ExcelFileNameLbl: Label 'PurchaseVATRegister%1_%2', Comment = '%1= DateTime, %2 = UserID';
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', Text001, '', CompanyName, UserId);
        //Error('');
        ExcelBuf.CreateNewBook(Text001);
        ExcelBuf.WriteSheet(Text001, CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename(StrSubstNo(ExcelFileNameLbl, CurrentDateTime, UserId));
        ExcelBuf.OpenExcel();
    end;
}

