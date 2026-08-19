report 50005 "3E Sales VAT Register"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Sales VAT Register';

    dataset
    {
        dataitem("Purch. Inv. Line"; "Sales Invoice Line")
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
                    SetFilter("Sell-to Customer No.", VendorCode);

                if GLAccountNo <> '' then
                    SetFilter("No.", GLAccountNo);
            end;
        }
        dataitem("Purch. Cr. Memo Line"; "Sales Cr.Memo Line")
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
                    SetFilter("Sell-to Customer No.", VendorCode);

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


                field("Customer Code"; VendorCode)
                {
                    ApplicationArea = All;

                    TableRelation = Customer;

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
        PostingYear := Format(Date2DMY(EndDate, 3));

        if blnExportToExcel then
            MakeExcelInfo;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        PostingYear: Text[4];
        CompanyInformation: Record "Company Information";
        ExcelBuf: Record "Excel Buffer" temporary;
        blnExportToExcel: Boolean;
        Text001: Label 'Sales VAT Register';
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        GenPostingSetup: Record "General Posting Setup";
        Location: Record Location;
        ShiptoAddress: Record "Ship-to Address";
        Vendor: Record Customer;
        FiscalYearStartDate: Date;
        FiscalYearEndDate: Date;
        LastYearStartDate: Date;
        LastYearEndDate: Date;
        Month: Integer;
        txtQuarter: Text;
        PurchInvHeader: Record "Sales Invoice Header";
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
        HisPurchSalesHeader: Record "3E HIS Revenue Header";
        cdVendorInvoiceNo: Text;
        cdVendorInvoiceDate: Date;
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        dtDocumentDate: Date;
        ItemCode: Text;
        VendorCode: Text;
        DocumentType: Option " ",INVOICE,"CREDIT NOTE";
        GLAccountNo: Text;
        DeptName: Text[100];
        UnitName: Text[100];

    procedure MakeExcelInfo()
    begin

        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Company Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Company
        ExcelBuf.AddColumn('Invoice No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Invoice No./Original Invoice No. 
        ExcelBuf.AddColumn('Invoice Date', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Invoice Date/ Original Invoice Date
        ExcelBuf.AddColumn('Transaction Type', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Transaction Type
        ExcelBuf.AddColumn('Unit Code', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Unit Code
        ExcelBuf.AddColumn('Unit Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Unit Name
        ExcelBuf.AddColumn('Department Code', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Department Code
        ExcelBuf.AddColumn('Department Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Department Name
        ExcelBuf.AddColumn('Customer No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Customer No
        ExcelBuf.AddColumn('Customer Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Customer Name
        ExcelBuf.AddColumn('Customer Address', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Customer Address
        ExcelBuf.AddColumn('Customer VAT Reg. No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Customer GSTIN
        ExcelBuf.AddColumn('Customer Type', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Customer Type
        ExcelBuf.AddColumn('Month Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Month Name
        ExcelBuf.AddColumn('Financial Year', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Financial Year
        ExcelBuf.AddColumn('Type of Document', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Type of Document
        ExcelBuf.AddColumn('Type', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Type
        ExcelBuf.AddColumn('Code No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//ItemNo	
        ExcelBuf.AddColumn('Item Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//ItemName
        ExcelBuf.AddColumn('Quantity', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Quantity
        ExcelBuf.AddColumn('Unit of Measure', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Unit of Measure
        ExcelBuf.AddColumn('Unit Price', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Unit Price Excl. GST
        ExcelBuf.AddColumn('Discount', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Discount
        //ExcelBuf.AddColumn('Financial Quarter', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Financial Quarter
        ExcelBuf.AddColumn('Gross Amount', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Gross Amount
        ExcelBuf.AddColumn('VAT Amount', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//VAT Amount
        ExcelBuf.AddColumn('Total Amount', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Tax Base Amount


    end;

    procedure MakeExcelDataBody()
    var
        BlankFiller: Text[250];
        Item: Record Item;
        PurchInvHeader1: Record "Sales Invoice Header";
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
        ExcelBuf.AddColumn(CompanyInformation.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company Name
        PurchInvHeader.Get("Purch. Inv. Line"."Document No.");
        ExcelBuf.AddColumn("Purch. Inv. Line"."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Sales Shipment/Sales Receipt No
        ExcelBuf.AddColumn("Purch. Inv. Line"."Posting Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);//Sales Shipment/Sales Receipt No
        ExcelBuf.AddColumn('Sales', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Transaction Type
        ExcelBuf.AddColumn("Purch. Inv. Line"."Shortcut Dimension 1 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//unit Code
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, "Purch. Inv. Line"."Shortcut Dimension 1 Code");
        IF DimensionValue.Find('-') then
            UnitName := DimensionValue.Name;
        ExcelBuf.AddColumn(UnitName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Inv. Line"."Shortcut Dimension 2 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Department Code
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, "Purch. Inv. Line"."Shortcut Dimension 2 Code");
        IF DimensionValue.Find('-') then
            DeptName := DimensionValue.Name;
        ExcelBuf.AddColumn(DeptName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//DEPT Name        
        ExcelBuf.AddColumn("Purch. Inv. Line"."Sell-to Customer No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Document Date
                                                                                                                                      // HisPurchSalesHeader.Reset();
                                                                                                                                      // HisPurchSalesHeader.SetRange("Record Type", HisPurchSalesHeader."Record Type"::Revenue);
                                                                                                                                      // HisPurchSalesHeader.SetRange("Document Type", HisPurchSalesHeader."Document Type"::Invoice);
                                                                                                                                      // HisPurchSalesHeader.SetRange("Document No.", "Purch. Inv. Line"."Document No.");
                                                                                                                                      // IF HisPurchSalesHeader.FindFirst() then
        ExcelBuf.AddColumn(PurchInvHeader."Bill-to Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn(PurchInvHeader."Sell-to Address" + '' + PurchInvHeader."Sell-to Address 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        IF PurchInvHeader."VAT Registration No." <> '' then
            ExcelBuf.AddColumn(PurchInvHeader."VAT Registration No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)//Consignee Name
        else
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name

        ExcelBuf.AddColumn(PurchInvHeader."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn(FORMAT("Purch. Inv. Line"."Posting Date", 0, '<Month Text>'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Month Name
        ExcelBuf.AddColumn(PostingYear, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Department Code
        ExcelBuf.AddColumn('Invoice', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Type of Document
        ExcelBuf.AddColumn("Purch. Inv. Line".Type, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Type
        ExcelBuf.AddColumn("Purch. Inv. Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn("Purch. Inv. Line".Description + '' + "Purch. Inv. Line"."Description 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn("Purch. Inv. Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//Consignee Name
        ExcelBuf.AddColumn("Purch. Inv. Line"."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn("Purch. Inv. Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//Consignee Name
        ExcelBuf.AddColumn(Abs("Purch. Inv. Line"."Line Discount Amount"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//Consignee Name

        //ExcelBuf.AddColumn(txtQuarter, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Financial Quarter

        ExcelBuf.AddColumn("Purch. Inv. Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//Gross Amount
        VATAmt := Round(("Purch. Inv. Line"."Line Amount" * "Purch. Inv. Line"."VAT %" / 100), 0.01);
        ExcelBuf.AddColumn(VATAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//VAT Amount
        ExcelBuf.AddColumn("Purch. Inv. Line"."Line Amount" + VATAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//Consignee Name

    end;


    procedure MakeExcelDataBody_Cr()
    var
        BlankFiller: Text[250];
        Item: Record Item;
        PurchCrMemoHdr: Record "Sales Cr.Memo Header";
        cdPostedDocumentNo: Text;
        dtPostingDate: Date;
        VendorLedgerEntry: Record "Cust. Ledger Entry";
        VATAmt: Decimal;
    begin
        ExcelBuf.NewRow;
        CompanyInformation.Get();
        ExcelBuf.AddColumn(CompanyInformation.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company Name
        PurchCrMemoHdr.Get("Purch. Cr. Memo Line"."Document No.");
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Sales Shipment/Sales Receipt No
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Posting Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);//Sales Shipment/Sales Receipt No
        ExcelBuf.AddColumn('Sales', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Transaction Type
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Shortcut Dimension 1 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//unit Code
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, "Purch. Cr. Memo Line"."Shortcut Dimension 1 Code");
        IF DimensionValue.Find('-') then
            UnitName := DimensionValue.Name;
        ExcelBuf.AddColumn(UnitName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Shortcut Dimension 2 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Department Code
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, "Purch. Inv. Line"."Shortcut Dimension 2 Code");
        IF DimensionValue.Find('-') then
            DeptName := DimensionValue.Name;
        ExcelBuf.AddColumn(DeptName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//DEPT Name        
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Sell-to Customer No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Document Date
                                                                                                                                          // HisPurchSalesHeader.Reset();
                                                                                                                                          // HisPurchSalesHeader.SetRange("Record Type", HisPurchSalesHeader."Record Type"::Revenue);
                                                                                                                                          // HisPurchSalesHeader.SetRange("Document Type", HisPurchSalesHeader."Document Type"::Invoice);
                                                                                                                                          // HisPurchSalesHeader.SetRange("Document No.", "Purch. Cr. Memo Line"."Document No.");
                                                                                                                                          //IF HisPurchSalesHeader.FindFirst() then
        ExcelBuf.AddColumn(PurchCrMemoHdr."Bill-to Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn(PurchCrMemoHdr."Sell-to Address" + '' + PurchCrMemoHdr."Sell-to Address 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        IF PurchCrMemoHdr."VAT Registration No." <> '' then
            ExcelBuf.AddColumn(PurchCrMemoHdr."VAT Registration No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)//Consignee Name
        else
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn(PurchCrMemoHdr."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn(FORMAT("Purch. Cr. Memo Line"."Posting Date", 0, '<Month Text>'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Month Name
        ExcelBuf.AddColumn(PostingYear, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Department Code
        ExcelBuf.AddColumn('Credit Note', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Type of Document
        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Type, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Type
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn("Purch. Cr. Memo Line".Description + '' + "Purch. Cr. Memo Line"."Description 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn(-"Purch. Cr. Memo Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//Consignee Name
        ExcelBuf.AddColumn("Purch. Cr. Memo Line"."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//Consignee Name
        ExcelBuf.AddColumn(-"Purch. Cr. Memo Line"."Unit Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//Consignee Name
        ExcelBuf.AddColumn(Abs("Purch. Cr. Memo Line"."Line Discount Amount") + ABS("Purch. Cr. Memo Line"."Inv. Discount Amount"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//Consignee Name
        ExcelBuf.AddColumn(-"Purch. Cr. Memo Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        VATAmt := Round(("Purch. Cr. Memo Line"."Line Amount" * "Purch. Cr. Memo Line"."VAT %" / 100), 0.01);
        ExcelBuf.AddColumn(VATAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//VAT Amount
        ExcelBuf.AddColumn(-"Purch. Cr. Memo Line"."Line Amount" - VATAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//Consignee Name

    end;


    procedure CreateExcelbook()
    var
        ExcelFileNameLbl: Label 'SalesVATRegister%1_%2', Comment = '%1= DateTime, %2 = UserID';
    begin
        ExcelBuf.CreateNewBook(Text001);
        ExcelBuf.WriteSheet(Text001, CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename(StrSubstNo(ExcelFileNameLbl, CurrentDateTime, UserId));
        ExcelBuf.OpenExcel();
    end;
}

