report 50007 "3E Purchase Order Print"
{
    ApplicationArea = All;
    Caption = 'Purchase Order Print';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Rpt50007.3EPurchaseOrder.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            RequestFilterHeading = 'Purchase Order Print';
            column(CompanyName; CompInfo.Name)
            {
            }
            column(CompanyAddress; CompAdd)
            {
            }
            column(ComWebSite; compinfo."Home Page")
            {
            }
            column(Email; Email)
            {
            }
            column(PhoneNo; PhoneNo)
            {
            }
            column(txtcomment; txtcomment)
            {

            }
            column(txtcommentNote; txtcommentNote)
            {

            }
            column(txtVendorComment; txtVendorComment)
            {
            }
            column(PayTerms; PurchaseHeader."Payment Terms Code")
            {
            }
            column(LocationAdd; LocationAdd)
            {
            }
            column(LocationEmail; LocationEmail)
            {
            }
            column(LocationPhoneNo; LocationPhoneNo)
            {
            }
            column(LocationWebsite; LocationWebsite)
            {
            }
            column(Contact; Contact) { }
            column(Document_Type; "Document Type")
            {
            }
            column(PurchInvNo; "No.")
            {
            }
            column(PurchInvPostingDate; Format("Posting Date", 0, '<Day,2>/<Month,3>/<Year4>'))
            {
            }
            column(OrderDate; PurchaseHeader."Order Date")
            {
            }
            column(Status; Status)
            {
            }
            column(SystemCreatedBy; userc."User Name")
            {
            }
            column(SystemModifiedBy; userm."User Name")
            {
            }
            column(ApprovedBy; userId)
            {
            }
            column(CreatedBy; PreparedBy)
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SupplierAdd; PurchaseHeader."Buy-from Address" + ', ' + PurchaseHeader."Buy-from Address 2" + ', ' + PurchaseHeader."Buy-from City" + ', ' + PurchaseHeader."Buy-from Post Code")
            {
            }
            column(SupplierPhoneNo; SupplierPhoneNo)
            {
            }
            column(SupplierName; SupplierName)
            {
            }
            column(LastAEdt; LastAEdt) { }
            column(DrugLigNo; DrugLigNo) { }
            column(SupplierEmail; SupplierEmail)
            {
            }
            column(SupplierGSTIN; PurchaseHeader."VAT Registration No.")
            {
            }
            column(SupplierPANNo; SupplierPANNo)
            {
            }
            column(LocationName; LocationName)
            {
            }
            column(AmtWords; AmtWords[1])
            {
            }
            column(txtPurchaseHeader; txtPurchaseHeader)
            {

            }
            column(Currency_Code; CdCurrencyCode)
            {

            }
            column(CompInfoPicture; CompanyInformation.Picture)
            {
            }
            column(VATAmount; VATAmount) { }
            column(TotalAmountInclVAT; TotalAmountInclVAT) { }
            column(VATBaseAmount; VATBaseAmount) { }
            column(VATDiscountAmount; VATDiscountAmount) { }
            trigger OnAfterGetRecord()
            var
                TempPrepmtPurchLine: Record "Purchase Line" temporary;
                TempPurchLine: Record "Purchase Line" temporary;

            begin

                Clear(TempPurchaseLine);
                Clear(PurchPost);
                TempPurchaseLine.DeleteAll();
                TempVATAmountLine.DeleteAll();
                PurchPost.GetPurchLines(PurchaseHeader, TempPurchaseLine, 0);
                TempPurchaseLine.CalcVATAmountLines(0, PurchaseHeader, TempPurchaseLine, TempVATAmountLine);
                TempPurchaseLine.UpdateVATOnLines(0, PurchaseHeader, TempPurchaseLine, TempVATAmountLine);
                VATAmount := TempVATAmountLine.GetTotalVATAmount();
                VATBaseAmount := TempVATAmountLine.GetTotalVATBase();
                VATDiscountAmount :=
                  TempVATAmountLine.GetTotalVATDiscount(PurchaseHeader."Currency Code", PurchaseHeader."Prices Including VAT");
                TotalAmountInclVAT := TempVATAmountLine.GetTotalAmountInclVAT();

                PostedVoucher.InitTextVariable;
                PostedVoucher.FormatNoText(AmtWords, Round(TotalAmountInclVAT, 1), PurchaseHeader."Currency Code");

                IF PurchaseHeader."Currency Code" <> '' then
                    CdCurrencyCode := PurchaseHeader."Currency Code"
                else
                    CdCurrencyCode := 'AED';


                SupplierName := '';
                SupplierAdd := '';
                SupplierEmail := '';
                SupplierPhoneNo := '';

                IF Customer.Get("Buy-from Vendor No.") THEN begin
                    SupplierName := Customer.Name + '' + Customer."Name 2";
                    IF CountryRegion.Get(Customer."Country/Region Code") THEN;
                    SupplierAdd := Customer.Address + ', ' + Customer."Address 2" + ', ' + Customer.City + ', ' + FORMAT(Customer."Post Code") + ', ' + CountryRegion.Name;
                    SupplierEmail := Customer."E-Mail";
                    SupplierPhoneNo := Customer."Phone No.";
                    SupplierGSTIN := Customer."VAT Registration No.";
                end;

                LocationAdd := '';
                LocationEmail := '';
                LocationPhoneNo := '';
                LocationGSTIN := '';
                LocationName := '';
                IF PurchaseHeader."Location Code" <> '' THEN BEGIN
                    Location.RESET;
                    Location.SETRANGE(Code, PurchaseHeader."Location Code");
                    IF Location.FINDFIRST THEN BEGIN
                        CountryRegion.Get(Location."Country/Region Code");
                        LocationName := Location.Name;
                        LocationAdd := Location.Address + ', ' + Location."Address 2" + ', ' + Location.City + ', ' + FORMAT(Location."Post Code") + ', ' + CountryRegion.Name;
                        LocationEmail := Location."E-Mail";
                        LocationPhoneNo := Location."Phone No.";
                        LocationWebsite := Location."Home Page";
                        Contact := Location.Contact;
                    END;
                end;



                if userc.Get(SystemCreatedBy) then;
                if userm.Get(SystemModifiedBy) then;

                txtcomment := '';
                PurchCommentLine.Reset();
                PurchCommentLine.SetRange("Document Type", "Document Type");
                //PurchCommentLine.SetRange(Type, PurchCommentLine.Type::"Term & Condition");
                PurchCommentLine.SetRange("No.", "No.");
                IF PurchCommentLine.FindSet() then begin
                    repeat
                        txtcomment += PurchCommentLine.Comment;
                    until PurchCommentLine.Next() = 0;
                end;

                txtcommentNote := '';
                PurchCommentLine.Reset();
                PurchCommentLine.SetRange("Document Type", "Document Type");
                PurchCommentLine.SetRange("Document Line No.", PurchCommentLine."Document Line No.");
                PurchCommentLine.SetRange("No.", "No.");
                IF PurchCommentLine.FindSet() then begin
                    repeat
                        txtcommentNote += PurchCommentLine.Comment;
                    until PurchCommentLine.Next() = 0;

                end;
                txtDescription := '';
                ExtendedTextLine.Reset();
                ExtendedTextLine.SetRange("Table Name", ExtendedTextLine."Table Name"::Item);
                ExtendedTextLine.SetRange("No.", PurchaseLine."Vendor Item No.");
                IF ExtendedTextLine.FINDFIRST THEN BEGIN
                    repeat
                        txtDescription += ExtendedTextLine.Text;
                    UNTIL ExtendedTextLine.NEXT() = 0;

                    txtVendorComment := '';
                    VendorComment.Reset();
                    VendorComment.SetRange("Table Name", VendorComment."Table Name"::Vendor);
                    //VendorComment.SetRange(Type, VendorComment.Type::"Term & Condition");
                    VendorComment.SetRange("No.", "Buy-from Vendor No.");
                    IF VendorComment.FindFirst() then begin
                        repeat
                            txtVendorComment += VendorComment.Comment;
                        until VendorComment.Next() = 0;

                    end;

                    userId := '';
                    PreparedBy := '';
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Table ID", 38);
                    ApprovalEntry.SETRANGE("Document No.", "No.");
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
                    IF ApprovalEntry.FINDLAST THEN
                        userId := ApprovalEntry."Last Modified By User ID";
                    PreparedBy := ApprovalEntry."Sender ID";
                    LastAEdt := ApprovalEntry."Last Date-Time Modified";

                end;
            end;

        }
        dataitem(PurchaseLine; "Purchase Line")
        {
            DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            DataItemLinkReference = purchaseHeader;
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

            column(Description; Description + ', ' + PurchaseLine."Description 2")
            {
            }
            column(ExttxtDesc; txtDescription)
            {
            }
            column(Line_No_; PurchaseLine."Line No.")
            {
            }
            column(UOM; PurchaseLine."Unit of Measure Code")
            {
            }
            column(Quantity;
            Quantity)
            {
            }
            column(Direct_Unit_Cost;
            "Direct Unit Cost")
            {
            }
            column(freeQty; freeQty)
            {
            }
            column(Line_Amount; "Line Amount")
            {
            }
            column(Line_Discount__; "Line Discount %")
            {
            }
            column(Line_Discount_Amount;
            "Line Discount Amount")
            {
            }
            column(Inv__Discount_Amount;
            "Inv. Discount Amount" + "Line Discount Amount")
            {
            }
            column(Amount; Amount)
            {
            }
            column(SNo; SNo)
            {
            }
            column(ItemCode;
            PurchaseLine."No.")
            {
            }
            column(VAT__; "VAT %")
            {
            }
            column(Amount_Including_VAT; "Amount Including VAT")
            {
            }
            // column(VATAmount; VATAmount)
            // {
            // }
            trigger OnPreDataItem()
            begin
                SNo := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                SNo += 1;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
        CountryRegion.Get(CompInfo."Country/Region Code");
        CompAdd := CompInfo.Address + ', ' + CompInfo."Address 2" + ', ' + CompInfo.City + ', ' + FORMAT(CompInfo."Post Code") + ', ' + CountryRegion.Name;
        Email := CompInfo."E-Mail";
        PhoneNo := CompInfo."Phone No.";
        GSTIN := CompInfo."VAT Registration No.";
        DrugLigNo := CompInfo."Registration No.";
    end;

    var
        CompInfo: Record "Company Information";
        CompanyInformation: Record "Company Information";
        Customer: Record "Vendor";
        CompAdd: Text[500];
        CountryRegion: Record "Country/Region";
        Email: Code[100];
        PhoneNo: Code[50];
        GSTIN: Code[15];
        DrugLigNo: Code[200];
        Location: Record Location;
        LocationName: Text[100];
        LocationEmail: Code[100];
        LocationPhoneNo: Code[50];
        LocationGSTIN: Code[15];
        LocationWebsite: Text[200];
        LocationAdd: Code[200];
        SupplierName: Text[300];
        SupplierAdd: Text[500];
        SupplierEmail: Text[100];
        SupplierPhoneNo: Text[20];
        SupplierGSTIN: Code[20];
        SupplierPANNo: Code[10];
        freeQty: Decimal;
        LineGSTAmount: Decimal;
        recPurchaseLine: Record "Purchase Line";
        Sno: Integer;
        CheckReport: Report "Check";
        AmtWords: array[2] of Text[500];
        TotalInclTaxAmount: Decimal;
        RecordIDList: List of [RecordID];
        ComponentJObject: JsonObject;
        CdCurrencyCode: Code[20];
        PurchCommentLine: Record "Purch. Comment Line";
        VendorComment: Record "Comment Line";
        txtcommentNote: Text;
        txtcomment: Text;
        txtVendorComment: Text;
        txtPurchaseHeader: Text[150];
        userc: Record User;
        userm: Record User;
        userId: Text;
        PreparedBy: Text;
        ApprovalEntry: Record "Approval Entry";
        ExtendedTextLine: Record "Extended Text Line";
        txtDescription: Text;
        PaymentTerms: Record "Payment Terms";
        PayTerms: Text;
        LastAEdt: DateTime;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempPurchaseLine: Record "Purchase Line" temporary;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        PurchPost: Codeunit "Purch.-Post";
        PostedVoucher: Report "3E Voucher - Post Voucher";
        Contact: Text[50];

}
