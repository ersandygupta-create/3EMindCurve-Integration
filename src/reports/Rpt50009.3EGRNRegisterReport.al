report 50009 "3E GRN Register Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'GRN Register Excel';

    dataset
    {
        dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Quantity = FILTER(<> 0), "No." = FILTER(<> ''));

            trigger OnAfterGetRecord()
            begin
                UserName := '';
                if Users.get(SystemCreatedBy) then
                    UserName := Users."User Name";

                if blnExportToExcel then
                    MakeExcelDataBody
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Order Date", StartDate, EndDate);

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
                    TableRelation = Location;
                    ApplicationArea = All;
                }
                field("Unit Code"; DivisionCode)
                {
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
                    ApplicationArea = All;
                }
                field("Department Code"; BranchCode)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
                }
                field(Item; ItemCode)
                {
                    TableRelation = Item;
                    ApplicationArea = All;
                }
                field("Vendor Code"; VendorCode)
                {
                    ApplicationArea = All;
                    TableRelation = Vendor;

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
        Text001: Label 'GRN Register Excel';
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
        LocationCode: Text;
        GSTINNo: Text;
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
        PurchRecHeader: Record "Purch. Rcpt. Header";
        PurchRecLine: Record "Purch. Rcpt. Line";
        Users: Record User;
        UserName: Text;
        UserSetup: Record "User Setup";

    procedure MakeExcelInfo()
    begin

        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Company Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('GRN No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Financial Year
        ExcelBuf.AddColumn('GRN Date', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Transaction Type        
        ExcelBuf.AddColumn('Vendor Code', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Seller GST No
        ExcelBuf.AddColumn('Vendor Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Company
        ExcelBuf.AddColumn('Vendor VAt Reg. No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Department Code
        ExcelBuf.AddColumn('Order No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Financial Quarter
        ExcelBuf.AddColumn('Order Date', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Transaction Type
        ExcelBuf.AddColumn('Invoice No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Financial Quarter
        ExcelBuf.AddColumn('Invoice Date', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Transaction Type
        ExcelBuf.AddColumn('Business Unit', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Type of Document
        ExcelBuf.AddColumn('Business Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Unit Name
        ExcelBuf.AddColumn('Posting Description', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Posting Description
        ExcelBuf.AddColumn('Department Code', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Dept
        ExcelBuf.AddColumn('Department Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Dept Name
        ExcelBuf.AddColumn('Item Code', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Type
        ExcelBuf.AddColumn('Item Description', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Invoice No./Original Invoice No. 
        ExcelBuf.AddColumn('Ordered Qty', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Invoice Date/ Original Invoice Date
        ExcelBuf.AddColumn('UOM', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//UOM
        ExcelBuf.AddColumn('Received Qty', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Credit/Debit Note/Refund/Sales Return Voucher Number
        ExcelBuf.AddColumn('Invoiced Qty', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Credit/Debit Note/Refund/Sales Return Voucher Number                                                                                                 //ExcelBuf.AddColumn('Pending Quantity', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Credit/Debit Note/Refund/Sales Return Voucher Date 
        ExcelBuf.AddColumn('Pending Qty', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Unit Price', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Item Category Code
        ExcelBuf.AddColumn('Created by', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Product Group Code		
        ExcelBuf.AddColumn('Creation date', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);//Customer No

    end;

    procedure MakeExcelDataBody()
    var
        PurchRecHeader: Record "Purch. Rcpt. Header";
        Vendor: Record Vendor;
        intPrCount: Integer;
        PurchReceiptHeader: Record "Purch. Rcpt. Header";
        Users: Record User;
        ApprovalEntries: Record "Approval Entry";
        PurchaseHeader: Record "Purchase Header";
        DeptName: Text[100];
        UnitName: Text[100];
    begin
        ExcelBuf.NewRow;
        PurchRecHeader.Reset();
        //PurchRecHeader.SetRange(DocumentType, PurchRecLine."Document No.");
        PurchRecHeader.SetRange("No.", "Purch. Rcpt. Line"."Document No.");
        IF PurchRecHeader.FindFirst() then;
        CompanyInformation.Get();
        ExcelBuf.AddColumn(CompanyInformation.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company Name        
        ExcelBuf.AddColumn(PurchRecHeader."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn(PurchRecHeader."Posting Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company        
        ExcelBuf.AddColumn(PurchRecHeader."Buy-from Vendor No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn(PurchRecHeader."Buy-from Vendor Name", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn(PurchRecHeader."VAT Registration No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn(PurchRecHeader."Order No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn(PurchRecHeader."Order Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("No.", PurchRecHeader."Order No.");
        if PurchaseHeader.FindFirst() then;
        ExcelBuf.AddColumn(PurchaseHeader."Vendor Invoice No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn(PurchaseHeader."Document Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn(PurchRecHeader."Shortcut Dimension 1 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, PurchRecHeader."Shortcut Dimension 1 Code");
        IF DimensionValue.Find('-') then
            UnitName := DimensionValue.Name;
        ExcelBuf.AddColumn(UnitName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(PurchRecHeader."Posting Description", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Posting Description
        ExcelBuf.AddColumn(PurchRecHeader."Shortcut Dimension 2 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//Dept Code
        DimensionValue.Reset();
        DimensionValue.SetRange(Code, PurchRecHeader."Shortcut Dimension 2 Code");
        IF DimensionValue.Find('-') then
            DeptName := DimensionValue.Name;
        ExcelBuf.AddColumn(DeptName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//DEPT Name
        ExcelBuf.AddColumn("Purch. Rcpt. Line"."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn("Purch. Rcpt. Line".Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn("Purch. Rcpt. Line".Quantity, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//company
        ExcelBuf.AddColumn("Purch. Rcpt. Line"."Unit of Measure Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//UOM
        ExcelBuf.AddColumn("Purch. Rcpt. Line"."Qty. Rcd. Not Invoiced", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//company
        ExcelBuf.AddColumn("Purch. Rcpt. Line"."Quantity Invoiced", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//company
        ExcelBuf.AddColumn("Purch. Rcpt. Line"."Qty. Rcd. Not Invoiced", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//company
        ExcelBuf.AddColumn("Purch. Rcpt. Line"."Direct Unit Cost", false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);//company
        ExcelBuf.AddColumn(UserName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
        ExcelBuf.AddColumn(PurchRecHeader.SystemCreatedAt, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);//company
    end;



    procedure CreateExcelbook()
    begin
        // ExcelBuf.CreateBookAndOpenExcel('', Text001, '', CompanyName, UserId);
        // Error('');
        ExcelBuf.CreateNewBook(Text001);
        ExcelBuf.WriteSheet(Text001, CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename(Text001);
        ExcelBuf.OpenExcel();
    end;
}

