report 50001 "3E Vendor Ledger Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Rpt50001.3EVendorLedgerReport.rdl';
    Caption = 'Vendor Ledger Report';
    ApplicationArea = aLL;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(CompanyInfoName; recCompanyInfo.Name)
            {
            }
            column(CompanyInfoAddress1; recCompanyInfo.Address)
            {
            }
            column(CompanyInfoAddress2; recCompanyInfo."Address 2")
            {
            }
            column(CompanyInfoHome; recCompanyInfo."Home Page")
            {
            }
            column(PrintLineNarration; PrintLineNarration)
            {

            }
            column(CompanyInfoCity; recCompanyInfo."City")
            {
            }
            column(CompanyInfoPostCode; recCompanyInfo."Post Code")
            {
            }
            column(CompanyInfoPhoneNo2; recCompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoVATNo; recCompanyInfo."VAT Registration No.")
            {
            }
            column(CompInfoReg; recCompanyInfo."Registration No.")
            {
            }
            column(CompanyInfoCIN; recCompanyInfo.GLN)
            {
            }
            column(Comapny_Logo; recCompanyInfo.Picture)
            {
            }
            column(TodayFormatted; Format(Today))
            {
            }
            column(PageNo; CurrReport.PageNo)
            {
            }
            column(PeriodCustDatetFilter; StrSubstNo(Text000, VendDateFilter))
            {
            }
            column(CustomerFilter; Vendor.GetFilters)
            {
            }
            column(CompanyName; recCompanyInfo.Name)
            {
            }
            column(PrintAmountsInLCY; PrintAmountsInLCY)
            {
            }
            column(ExcludeBalanceOnly; ExcludeBalanceOnly)
            {
            }
            column(CustFilterCaption; TableCaption + ': ' + VendFilter)
            {
            }
            column(CustFilter; VendFilter)
            {
            }
            column(AmountCaption; AmountCaption)
            {
            }
            column(RemainingAmtCaption; RemainingAmtCaption)
            {
            }
            column(No_Cust; Vendor."No.")
            {
            }
            column(Name_Cust; Vendor.Name)
            {
            }
            column(Vend_City; Vendor.City)
            {
            }
            column(Vend_Post; Vendor."Post Code")
            {
            }
            column(Address1; Vendor.Address)
            {
            }
            column(Address2; Vendor."Address 2")
            {
            }
            column(GSTno; Vendor."VAT Registration No.")
            {
            }
            column(PhoneNo_Cust; Vendor."Phone No.")
            {
                IncludeCaption = true;
            }
            column(Vend_Email; Vendor."E-Mail")
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(StartBalanceLCY; StartBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(StartBalAdjLCY; StartBalAdjLCY)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceLCY; VendBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(CustLedgerEntryAmtLCY; "Vendor Ledger Entry"."Amount (LCY)" + Correction + ApplicationRounding)
            {
                AutoFormatType = 1;
            }
            column(StartBalanceLCYAdjLCY; StartBalanceLCY + StartBalAdjLCY)
            {
                AutoFormatType = 1;
            }
            column(StrtBalLCYCustLedgEntryAmt; StartBalanceLCY + "Vendor Ledger Entry"."Amount (LCY)" + Correction + ApplicationRounding)
            {
                AutoFormatType = 1;
                IncludeCaption = false;
            }
            column(CustDetailTrialBalCaption; VendDetailTrialBalCaptionLbl)
            {
            }
            column(PageNoCaption; PageNoCaptionLbl)
            {
            }
            column(AllAmtsLCYCaption; AllAmtsLCYCaptionLbl)
            {
            }
            column(RepInclCustsBalCptn; RepInclVendsBalCptnLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DueDateCaption; DueDateCaptionLbl)
            {
            }
            column(BalanceLCYCaption; BalanceLCYCaptionLbl)
            {
            }
            column(AdjOpeningBalCaption; AdjOpeningBalCaptionLbl)
            {
            }
            column(BeforePeriodCaption; BeforePeriodCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(OpeningBalCaption; OpeningBalCaptionLbl)
            {
            }
            column(OpeningBalance; StartBalanceLCY)
            {
            }
            column(TotalCreditAmt; TotalCreditAmt)
            {
            }
            column(TotalDebitAmt; TotalDebitAmt)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code") WHERE(Reversed = FILTER(false));
                RequestFilterFields = "Document No.";
                column(PostDate_CustLedgEntry; "Posting Date")
                {
                }
                column(DocType_CustLedgEntry; "Document Type")
                {
                    IncludeCaption = true;
                }
                column(DocNo_CustLedgEntry; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_CustLedgEntry; txtDescription)
                {
                }
                column(CustAmount; ABS(VendAmount))
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(CustRemainAmount; VendRemainAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(CustEntryDueDate; Format(VendEntryDueDate))
                {
                }
                column(EntryNo_CustLedgEntry; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(CustCurrencyCode; VendCurrencyCode)
                {
                }
                column(CustBalanceLCY1; VendBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(DebitAmt; decDebitAmt)
                {
                }
                column(CreditAmt; decCreditAmt)
                {
                }
                column(ExtDocNo; "External Document No.")
                {
                }
                column(ChequeNo; txtChequeNo + '' + UTR)
                {
                }
                column(ChequeDate; dtChequeDate)
                {
                }
                column(PostedDesc; PostedDesc)
                {
                }
                column(DocumentDate; Format("Vendor Ledger Entry"."Document Date", 0, '<Day,2>-<Month Text,3>-<Year4>'))
                {
                }
                column(VPG; "Vendor Ledger Entry"."Vendor Posting Group")
                {
                }
                column(ExternalDocumentNo; "Vendor Ledger Entry"."External Document No.")
                {
                }
                column(Narration; txtNarr + ' ' + GLNarration)
                {
                }
                column(AppiedEntries; AppiedEntries)
                {
                }
                column(TotalAmttoVendor; TotalAmttoVendor)
                {
                }
                dataitem(AppliedEntries; "Vendor Ledger Entry")
                {
                    CalcFields = "Amount (LCY)";
                    DataItemLink = "Closed by Entry No." = FIELD("Entry No.");
                    DataItemTableView = SORTING("Entry No.");
                    column(DocumentType_Applied;
                    AppliedEntries."Document Type")
                    {
                    }
                    column(PostingDate_Applied; Format(AppliedEntries."Posting Date"))
                    {
                    }
                    column(DocumentNo_Applied; AppliedEntries."Document No.")
                    {
                    }
                    column(ExternalDocNo_Applied; AppliedEntries."External Document No.")
                    {
                    }
                    column(Amount_Applied; Format(AppliedEntries."Amount (LCY)") + '-' + Format(AppliedEntries."Closed by Amount"))
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin

                    end;
                }
                dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
                {
                    DataItemLink = "Document No." = FIELD("Document No.");
                    DataItemTableView = SORTING("Document No.", "Line No.");
                    column(ShowItem; ShowItems)
                    {
                    }
                    column(Item_No; "Purch. Inv. Line"."No.")
                    {
                    }
                    column(Item_Name; "Purch. Inv. Line".Description)
                    {
                    }
                    column(Itm_ModelNo; "Purch. Inv. Line"."Description 2")
                    {
                    }
                    column(Itm_Qty; "Purch. Inv. Line".Quantity)
                    {
                    }
                    column(Item_UnitPrice; "Purch. Inv. Line"."Direct Unit Cost")
                    {
                    }
                    column(SILLineAmount; "Purch. Inv. Line"."Line Amount")
                    {
                    }
                    column(TaxAmount; decPurGSTAmt + decPurTDSAmt)
                    {
                    }
                    column(Itm_UOM; "Purch. Inv. Line"."Unit of Measure Code")
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        CurrReport.ShowOutput(ShowItems);
                        if ("Vendor Ledger Entry"."Document Type" <> "Vendor Ledger Entry"."Document Type"::Invoice) or (not ShowItems) then
                            CurrReport.Break;
                        // PurchInvHeader.Get("Purch. Inv. Line"."Document No.");
                        // CalcStatistics.OnGetPurchInvHeaderGSTAmount(PurchInvHeader, decPurGSTAmt);
                        // CalcStatistics.OnGetPurchInvHeaderTDSAmount(PurchInvHeader, decPurTDSAmt);
                    end;
                }
                dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
                {
                    DataItemLink = "Document No." = FIELD("Document No.");
                    DataItemTableView = SORTING("Document No.", "Line No.");
                    column(SCMShowItem; ShowItems)
                    {
                    }
                    column(SCMItem_No; "Purch. Cr. Memo Line"."No.")
                    {
                    }
                    column(SCMItem_Name; "Purch. Cr. Memo Line".Description)
                    {
                    }
                    column(SCMItm_ModelNo; "Purch. Cr. Memo Line"."Description 2")
                    {
                    }
                    column(SCMItm_Qty; "Purch. Cr. Memo Line".Quantity)
                    {
                    }
                    column(SCMItem_UnitPrice; Abs((("Purch. Cr. Memo Line"."Direct Unit Cost") * "Purch. Cr. Memo Line"."Line Discount %" / 100) - "Purch. Cr. Memo Line"."Direct Unit Cost"))
                    {
                    }
                    column(SCMLineAmt; "Purch. Cr. Memo Line"."Line Amount")
                    {
                    }
                    column(SCMTaxAmount; decPurCrGSTAmt + decPurCrTDSAmt)
                    {
                    }
                    column(SCMItm_UOM; "Purch. Cr. Memo Line"."Unit of Measure Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CurrReport.ShowOutput(ShowItems);
                        if ("Vendor Ledger Entry"."Document Type" <> "Vendor Ledger Entry"."Document Type"::"Credit Memo") or (not ShowItems) then
                            CurrReport.Break;
                        // PurchCrMemoHeader.Get("Purch. Cr. Memo Line"."Document No.");
                        // CalcStatistics.OnGetPurchCrMemoHeaderGSTAmount(PurchCrMemoHeader, decPurCrGSTAmt);
                        // CalcStatistics.OnGetPurchCrMemoHeaderTDSAmount(PurchCrMemoHeader, decPurCrTDSAmt);
                    end;
                }
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No." = FIELD("Entry No.");
                    DataItemTableView = SORTING("Vendor Ledger Entry No.", "Entry Type", "Posting Date") WHERE("Entry Type" = FILTER("Appln. Rounding" | "Correction of Remaining Amount"));
                    column(EntryType_DtldCustLedgEntry; Format("Entry Type"))
                    {
                    }
                    column(Correction; Correction)
                    {
                        AutoFormatType = 1;
                    }
                    column(CustBalanceLCY2; VendBalanceLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(ApplicationRounding; ApplicationRounding)
                    {
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        case "Entry Type" of
                            "Entry Type"::"Appln. Rounding":
                                if PrintAmountsInLCY then begin
                                    ApplicationRounding := ApplicationRounding + "Amount (LCY)";
                                end else begin
                                    ApplicationRounding := ApplicationRounding + Amount;
                                end;
                            "Entry Type"::"Correction of Remaining Amount":
                                if PrintAmountsInLCY then begin
                                    Correction := Correction + "Amount (LCY)";
                                end else begin
                                    Correction := Correction + Amount;
                                end;
                        end;
                        if PrintAmountsInLCY then
                            VendBalanceLCY := VendBalanceLCY + "Amount (LCY)"
                        else
                            VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";//ak
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date", VendDateFilter);
                        Correction := 0;
                        ApplicationRounding := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields(Amount, "Remaining Amount", "Amount (LCY)", Amount, "Remaining Amt. (LCY)", "Remaining Amount", "Amount (LCY)");
                    decCreditAmt := 0;
                    decDebitAmt := 0;
                    VendLedgEntryExists := true;
                    VendAmount := "Amount (LCY)";
                    VendRemainAmount := "Remaining Amt. (LCY)";
                    VendCurrencyCode := '';

                    if "Vendor Ledger Entry"."Amount (LCY)" < 0 then begin
                        decCreditAmt := "Amount (LCY)";
                        VendBalanceLCY := VendBalanceLCY - "Amount (LCY)";
                        remAmount := "Vendor Ledger Entry"."Remaining Amount";
                    end
                    else begin
                        ;
                        decDebitAmt := "Amount (LCY)";
                        VendBalanceLCY := VendBalanceLCY - "Amount (LCY)";
                        remAmount := "Vendor Ledger Entry"."Remaining Amount";

                    end;

                    if ("Document Type" = "Document Type"::Payment) or ("Document Type" = "Document Type"::Refund) then
                        VendEntryDueDate := 0D
                    else
                        VendEntryDueDate := "Due Date";


                    if "Vendor Ledger Entry".Amount > 0 then begin
                        recGLEntry.Reset;

                        recGLEntry.SetCurrentKey("Document No.", "Posting Date");
                        recGLEntry.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                        recGLEntry.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                        recGLEntry.SetFilter(Amount, '<=0');
                        recGLEntry.Find('-');

                        if recGLEntry."Source Type" = recGLEntry."Source Type"::"Bank Account" then begin
                            recBank.Get(recGLEntry."Source No.");
                            txtDescription := recBank.Name;
                        end
                        else begin
                            recGLAccount.Get(recGLEntry."G/L Account No.");
                            txtDescription := recGLAccount.Name;
                            //txtDescription := "Vendor Ledger Entry".Description;
                        end;
                    end
                    else begin
                        recGLEntry.Reset;
                        recGLEntry.SetCurrentKey("Document No.", "Posting Date");
                        recGLEntry.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                        recGLEntry.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                        recGLEntry.SetFilter(Amount, '>=0');
                        recGLEntry.Find('-');

                        /*
                          IF recGLEntry."Source Type" = recGLEntry."Source Type"::Customer THEN
                          BEGIN
                            recCustomer.GET(recGLEntry."Source No.");
                            txtDescription := recCustomer.Name;
                          END

                          IF recGLEntry."Source Type" = recGLEntry."Source Type"::Vendor THEN
                          BEGIN
                            recVendor.GET(recGLEntry."Source No.");
                            txtDescription := recVendor.Name;
                          END
                          ELSE
                        */
                        if recGLEntry."Source Type" = recGLEntry."Source Type"::"Bank Account" then begin
                            recBank.Get(recGLEntry."Source No.");
                            txtDescription := recBank.Name;
                        end
                        else begin
                            recPurInvLine.Reset;
                            recPurInvLine.SetRange(recPurInvLine."Document No.", "Vendor Ledger Entry"."Document No.");
                            if recPurInvLine.Find('-') then begin
                                recPurInvHrd.Reset;
                                recPurInvHrd.SetRange(recPurInvHrd."No.", "Vendor Ledger Entry"."Document No.");
                                if recPurInvHrd.Find('-') then begin
                                    txtChequeNo := recPurInvHrd."Vendor Invoice No.";
                                    dtChequeDate := recPurInvHrd."Order Date";
                                    PostedDesc := recPurInvHrd."Posting Description";
                                end;
                                recPostSetUp.Reset;
                                recPostSetUp.SetRange(recPostSetUp."Gen. Bus. Posting Group", recPurInvLine."Gen. Bus. Posting Group");
                                recPostSetUp.SetRange(recPostSetUp."Gen. Prod. Posting Group", recPurInvLine."Gen. Prod. Posting Group");
                                if recPostSetUp.Find('-') then
                                    if recPostSetUp."Purch. Account" <> '' then begin
                                        recGLAccount.Get(recPostSetUp."Purch. Account");
                                        txtDescription := recGLAccount.Name;
                                    end;
                            end;
                        end;

                        if txtDescription = '' then begin
                            recGLAccount.Get(recGLEntry."G/L Account No.");
                            txtDescription := recGLAccount.Name;
                        end;
                        recGLEntry.Reset;
                        recGLEntry.SetRange("Document No.", "Document No.");
                        if recGLEntry.FindLast then
                            txtDescription := recGLEntry.Description;
                    end;


                    txtChequeNo := '';
                    dtChequeDate := 0D;
                    recBankAccountLedgerEntry.Reset;
                    recBankAccountLedgerEntry.SetRange("Document No.", "Document No.");
                    recBankAccountLedgerEntry.SetRange("Posting Date", "Posting Date");
                    if recBankAccountLedgerEntry.Find('-') then begin
                        txtChequeNo := recBankAccountLedgerEntry."3E Cheque No.";
                        dtChequeDate := recBankAccountLedgerEntry."3E Cheque Date";
                    end;


                    txtNarr := '';
                    txtNarr2 := '';
                    GLNarration := '';
                    recPurchCommentLine.Reset;
                    recPurchCommentLine.SetRange("No.", "Document No.");
                    if recPurchCommentLine.Find('-') then
                        repeat
                            if (StrLen(txtNarr) + StrLen(recPurchCommentLine.Comment)) < 250 then
                                txtNarr += recPurchCommentLine.Comment + ' '
                            else
                                txtNarr2 += recPurchCommentLine.Comment;
                        until recPurchCommentLine.Next = 0;

                    GLE.Reset;
                    GLE.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                    GLE.SetRange("Source No.", "Vendor Ledger Entry"."Vendor No.");
                    GLE.SetRange("Posting Date", "Posting Date");
                    GLE.SetRange("Transaction No.", "Transaction No.");
                    if GLE.FindFirst then begin
                        UTR := GLE."3E UTR No.";
                        GLNarration := GLE.Comment;
                    end;



                    AppiedEntries := '';
                    VendorLedgerEntry.Reset;
                    VendorLedgerEntry.SetRange("Closed by Entry No.", "Entry No.");
                    if VendorLedgerEntry.FindFirst then begin
                        repeat
                            VendorLedgerEntry.CalcFields("Amount (LCY)");
                            AppiedEntries += Format(VendorLedgerEntry."Document Type") + '-' + Format(VendorLedgerEntry."Posting Date") + '-' +
                                             VendorLedgerEntry."Document No." + '-' + VendorLedgerEntry."External Document No." + '-' + 'Rs.' + Format(VendorLedgerEntry."Amount (LCY)") + ',';
                        until VendorLedgerEntry.Next = 0;
                    end;



                end;

                trigger OnPreDataItem()
                begin
                    VendLedgEntryExists := false;
                    CurrReport.CreateTotals(VendAmount, "Amount (LCY)", VendAmount, Amount);
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(Name1_Cust; Vendor.Name)
                {
                }
                column(CustBalanceLCY4; VendBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(StartBalanceLCY2; StartBalanceLCY)
                {
                }
                column(StartBalAdjLCY2; StartBalAdjLCY)
                {
                }
                column(CustBalStBalStBalAdjLCY; VendBalanceLCY - StartBalanceLCY - StartBalAdjLCY)
                {
                    AutoFormatType = 1;
                }

                trigger OnAfterGetRecord()
                begin
                    if not VendLedgEntryExists and ((StartBalanceLCY = 0) or ExcludeBalanceOnly) then begin
                        StartBalanceLCY := 0;
                        CurrReport.Skip;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                if PrintOnlyOnePerPage then
                    PageGroupNo := PageGroupNo + 1;

                StartBalanceLCY := 0;
                StartBalAdjLCY := 0;
                TotalCreditAmt := 0;
                TotalDebitAmt := 0;
                if VendDateFilter <> '' then begin
                    if GetRangeMin("Date Filter") <> 0D then begin
                        SetRange("Date Filter", 0D, GetRangeMin("Date Filter") - 1);
                        CalcFields("Net Change (LCY)");
                        StartBalanceLCY := "Net Change (LCY)";
                    end;

                    SetFilter("Date Filter", VendDateFilter);
                    CalcFields("Net Change (LCY)", "Net Change");
                    if PrintAmountsInLCY then
                        StartBalAdjLCY := "Net Change (LCY)"
                    else
                        StartBalAdjLCY := "Net Change";

                    VendLedgEntry.SetCurrentKey("Vendor No.", "Posting Date");
                    VendLedgEntry.SetRange("Vendor No.", "No.");
                    VendLedgEntry.SetFilter("Posting Date", VendDateFilter);
                    if VendLedgEntry.FindFirst then
                        repeat
                            VendLedgEntry.SetFilter("Date Filter", VendDateFilter);
                            VendLedgEntry.CalcFields("Amount (LCY)", Amount, "Amount (LCY)");
                            if VendLedgEntry."Amount (LCY)" < 0 then
                                TotalCreditAmt += VendLedgEntry."Amount (LCY)"
                            else
                                TotalDebitAmt += VendLedgEntry."Amount (LCY)";

                            if PrintAmountsInLCY then
                                StartBalAdjLCY := StartBalAdjLCY - VendLedgEntry."Amount (LCY)"
                            else
                                StartBalAdjLCY := StartBalAdjLCY - VendLedgEntry.Amount;

                            "Detailed Vendor Ledg. Entry".SetCurrentKey("Vendor Ledger Entry No.", "Entry Type", "Posting Date");
                            "Detailed Vendor Ledg. Entry".SetRange("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
                            "Detailed Vendor Ledg. Entry".SetFilter("Entry Type", '%1|%2',
                            "Detailed Vendor Ledg. Entry"."Entry Type"::"Correction of Remaining Amount",
                            "Detailed Vendor Ledg. Entry"."Entry Type"::"Appln. Rounding");
                            "Detailed Vendor Ledg. Entry".SetFilter("Posting Date", VendDateFilter);
                            if "Detailed Vendor Ledg. Entry".Find('-') then
                                repeat
                                    if PrintAmountsInLCY then
                                        StartBalAdjLCY := StartBalAdjLCY - "Detailed Vendor Ledg. Entry"."Amount (LCY)"
                                    else
                                        StartBalAdjLCY := StartBalAdjLCY - "Detailed Vendor Ledg. Entry".Amount
                                until "Detailed Vendor Ledg. Entry".Next = 0;
                            "Detailed Vendor Ledg. Entry".Reset;
                        until VendLedgEntry.Next = 0;

                    VendLedgEntry.SetCurrentKey("Vendor No.", "Posting Date");
                    VendLedgEntry.SetRange("Vendor No.", Vendor."No.");
                    VendLedgEntry.SetFilter("Posting Date", '%1..%2', 0D, dtStartDate - 1);
                    if GD1Filter <> '' then
                        VendLedgEntry.SetFilter("Global Dimension 1 Code", GD1Filter);
                    if GD2Filter <> '' then
                        VendLedgEntry.SetFilter("Global Dimension 2 Code", GD2Filter);

                end;

                //CurrReport.PrintOnlyIfDetail := ExcludeBalanceOnly or (StartBalanceLCY = 0);
                VendBalanceLCY := StartBalanceLCY;
            end;


            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CurrReport.CreateTotals("Vendor Ledger Entry"."Amount (LCY)", "Vendor Ledger Entry".Amount, StartBalanceLCY, StartBalAdjLCY, Correction, ApplicationRounding);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewPageperCustomer; PrintOnlyOnePerPage)
                    {
                        Caption = 'New Page per Vendor';
                        ApplicationArea = All;
                    }
                    field(ExcludeCustHaveaBalanceOnly; ExcludeBalanceOnly)
                    {
                        Caption = 'Exclude Vendor That Have a Balance Only';
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    // field(PrintLineNarration; PrintLineNarration)
                    // {
                    //     Caption = 'Print Narration';
                    //     ApplicationArea = All;
                    // }
                    field("Not Show Item"; ShowItems)
                    {
                        Caption = 'Show Item';
                        ApplicationArea = All;
                        Visible = false;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            PrintToExcel := true;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        PrintToExcel := false;
        PrintAmountsInLCY := true;
        ShowItems := false;
    end;

    trigger OnPostReport()
    begin

    end;

    trigger OnPreReport()
    begin
        VendFilter := Vendor.GetFilters;
        VendDateFilter := Vendor.GetFilter("Date Filter");

        dtStartDate := Vendor.GetRangeMin("Date Filter");
        dtEndDate := Vendor.GetRangeMax("Date Filter");

        GD1Filter := Vendor.GetFilter("Global Dimension 1 Filter");
        GD2Filter := Vendor.GetFilter("Global Dimension 2 Filter");

        if Vendor.GetRangeMin("Date Filter") > Vendor.GetRangeMax("Date Filter") then
            Error('Starting Date cannot be greater then Ending Date');

        with "Vendor Ledger Entry" do
            if PrintAmountsInLCY then begin
                AmountCaption := FieldCaption("Amount (LCY)");
                RemainingAmtCaption := FieldCaption("Remaining Amt. (LCY)");
            end else begin
                AmountCaption := FieldCaption(Amount);
                RemainingAmtCaption := FieldCaption("Remaining Amount");
            end;

        recCompanyInfo.Get();
        recCompanyInfo.CalcFields(Picture);


    end;

    var
        Text000: Label 'Period: %1';
        PrintLineNarration: Boolean;
        recCompanyInfo: Record "Company Information";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        VendFilter: Text[250];
        VendDateFilter: Text[30];
        AmountCaption: Text[80];
        RemainingAmtCaption: Text[30];
        VendAmount: Decimal;
        VendRemainAmount: Decimal;
        VendBalanceLCY: Decimal;
        VendCurrencyCode: Code[10];
        VendEntryDueDate: Date;
        StartBalanceLCY: Decimal;
        StartBalAdjLCY: Decimal;
        Correction: Decimal;
        ApplicationRounding: Decimal;
        VendLedgEntryExists: Boolean;
        PageGroupNo: Integer;
        VendDetailTrialBalCaptionLbl: Label 'Vend - Detail Trial Bal.';
        PageNoCaptionLbl: Label 'Page';
        AllAmtsLCYCaptionLbl: Label 'All amounts are in AED';
        RepInclVendsBalCptnLbl: Label 'This report also includes vendor that only have balances.';
        PostingDateCaptionLbl: Label 'Posting Date';
        DueDateCaptionLbl: Label 'Due Date';
        BalanceLCYCaptionLbl: Label 'Balance (AED)';
        AdjOpeningBalCaptionLbl: Label 'Adj. of Opening Balance';
        BeforePeriodCaptionLbl: Label 'Total (AED) Before Period';
        TotalCaptionLbl: Label 'Total (AED)';
        OpeningBalCaptionLbl: Label 'Total Adj. of Opening Balance';
        "-----------------": Integer;
        txtChequeNo: Text[40];
        dtChequeDate: Date;
        PostedDesc: Text[100];
        recBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        ShowItems: Boolean;
        dtStartDate: Date;
        dtEndDate: Date;
        GD1Filter: Text[120];
        GD2Filter: Text[120];
        decDebitAmt: Decimal;
        decCreditAmt: Decimal;
        "----Print Des---": Integer;
        txtDescription: Text[1024];
        recGLEntry: Record "G/L Entry";
        recBank: Record "Bank Account";
        recPurInvLine: Record "Purch. Inv. Line";
        recPurInvHrd: Record "Purch. Inv. Header";
        recPostSetUp: Record "General Posting Setup";
        recGLAccount: Record "G/L Account";
        txtNarr: Text;
        recPurchaseHdr: Record "Purch. Inv. Header";
        recPurchCrHdr: Record "Purch. Cr. Memo Hdr.";
        recPurchCommentLine: Record "Purch. Comment Line";
        "-----": Integer;
        ExcelBuffer: Record "Excel Buffer" temporary;
        txtData: array[30] of Text;
        PrintToExcel: Boolean;
        txtNarr2: Text;
        DocumentType: Text;
        TotalCreditAmt: Decimal;
        TotalDebitAmt: Decimal;
        txtNarration: Text[1024];
        cdVendCode: Code[50];
        vendLedger: Record "Vendor Ledger Entry";
        Address: Text[1024];
        UTR: Text[60];
        GLE: Record "G/L Entry";
        remAmount: Decimal;
        S1: Text[60];
        GLNarration: Text;
        AppiedEntries: Text;
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        decPurGSTAmt: Decimal;
        cdAssessCode: Code[50];
        decPurTDSAmt: Decimal;
        decPurCrGSTAmt: Decimal;
        decPurCrTDSAmt: Decimal;
        RecCompanyName: Code[100];
        TotalAmttoVendor: Decimal;



    procedure InitializeRequest(ShowAmountInLCY: Boolean; SetPrintOnlyOnePerPage: Boolean; SetExcludeBalanceOnly: Boolean; PrintToExcel: Boolean)
    begin
        PrintOnlyOnePerPage := SetPrintOnlyOnePerPage;
        PrintAmountsInLCY := ShowAmountInLCY;
        ExcludeBalanceOnly := SetExcludeBalanceOnly;
    end;



}

