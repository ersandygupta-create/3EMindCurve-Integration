report 50008 "3E Vendor Payment Report"
{
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Vendor Payment Report';
    RDLCLayout = './src/reports/Rpt50008.3EVendorPaymentReport.rdl';

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                WHERE("Bal. Account Type" = FILTER(Vendor), Reversed = filter(false));
            column(BankAccNo; BankAccNo)
            {
            }
            column(IFSCCode; IFSCCode)
            {
            }
            column(BankAdd; BankAdd)
            {
            }
            column(BankCity; BankCity)
            {
            }
            column(VendMobile; VendMobile)
            {
            }
            column(VendEmail; VendEmail)
            {
            }
            // column(Amount; ABS(VendorAmount))
            // {
            // }
            column(Amount; "Bank Account Ledger Entry"."Amount (LCY)")
            {
            }
            column(BankAccountCode; BankAccountCode)
            {
            }
            column(txtCompanyName; txtCompanyName)
            {
                AutoFormatType = 1;
            }
            column(CompAdd; CompAdd) { }
            column(CompVATNo; CompVATNo) { }
            column(ComBankAccNo; ComBankAccNo)
            {
            }
            column(VendorName; VendorName)
            {
                AutoFormatType = 1;
            }
            column(VendorName2; VendorName2)
            {
            }
            column(VendorName1; VendorName1)
            {
            }
            column(BankDocNo; "Document No.")
            {
            }
            column(Vendorno; "Bank Account Ledger Entry"."Bal. Account No.")
            {
            }
            column(DocumentDt; Format("Bank Account Ledger Entry"."Document Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(StartDate; Format(StartDate, 0, '<Day,2>-<Month Text,3>-<Year4>'))
            {
            }
            column(EndDate; Format(EndDate, 0, '<Day,2>-<Month Text,3>-<Year4>'))
            {
            }
            column(CompCity; CompCity) { }
            column(CompPostcode; CompPostcode) { }
            column(CompCounty; CompCounty) { }
            column(ChequeNo; ChequeNo) { }
            column(ChequeDt; Format(ChequeDt, 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(SwiftCode; SwiftCode) { }
            column(IBANNo; IBANNo) { }
            trigger OnAfterGetRecord()
            begin

                //"Bank Account Ledger Entry".CalcFields("Amount (LCY)");
                VendorAmount := "Bank Account Ledger Entry"."Amount (LCY)";//FORMAT(ROUND(ABS("Bank Account Ledger Entry"."Amount (LCY)"),1,'<'),0,1) +'00';
                ChequeNo := "Bank Account Ledger Entry"."3E Cheque No.";
                ChequeDt := "Bank Account Ledger Entry"."3E Cheque Date";

                BenificiaryName := '';
                BankAccNo := '';
                IFSCCode := '';
                BankAdd := '';
                BankCity := '';
                VendMobile := '';
                VendorName := '';
                VendorName1 := '';
                SwiftCode := '';
                IBANNo := '';
                VendorBankAccount.RESET();
                VendorBankAccount.SETRANGE("Vendor No.", "Bank Account Ledger Entry"."Bal. Account No.");
                IF VendorBankAccount.FINDLAST() THEN BEGIN
                    BenificiaryName := VendorBankAccount.Name;
                    BankAccNo := VendorBankAccount."Bank Account No.";
                    //IFSCCode := VendorBankAccount."3E IFSC Code";
                    BankAdd := VendorBankAccount.Address + ' ' + VendorBankAccount."Address 2";
                    BankCity := VendorBankAccount.City;
                    VendorName1 := VendorBankAccount.Name;
                    VendMobile := VendorBankAccount."Phone No.";
                    SwiftCode := VendorBankAccount."SWIFT Code";
                    IBANNo := VendorBankAccount.IBAN;
                END;

                VendorName := '';
                VendorName2 := '';
                VendEmail := '';
                VendorName2 := '';
                Vendor.RESET;
                Vendor.SETRANGE("No.", "Bank Account Ledger Entry"."Bal. Account No.");
                IF Vendor.FINDFIRST THEN BEGIN
                    VendEmail := Vendor."E-Mail"; //Vendor."E-Mail";
                    VendorName := Vendor.Name;
                    VendorName2 := Vendor."Name 2";
                END;
            end;


            trigger OnPreDataItem()
            begin
                CompanyInformation.GET();
                "Bank Account Ledger Entry".SETRANGE("Posting Date", StartDate, EndDate);

                if ChequeNo <> '' then
                    "Bank Account Ledger Entry".SETRANGE("3E Cheque No.", ChequeNo);
                if BankAccountCode <> '' then
                    "Bank Account Ledger Entry".SetRange("Bank Account No.", BankAccountCode);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Start Date"; StartDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';
                    Caption = 'Start Date';
                }
                field("End Date"; EndDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';
                    Caption = 'End Date';
                }
                field("Bank Account Code"; BankAccountCode)
                {
                    TableRelation = "Bank Account"."No.";
                    ToolTip = 'Specifies the value of the Bank Account Code field.';
                    Caption = 'Bank Account Code';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        BankAccountList: Page 371;
                    begin
                        BankAccount.RESET;
                        BankAccount.SETFILTER(BankAccount."No.", BankAccountCode);
                        IF BankAccount.FINDFIRST THEN BEGIN
                            BankAccountList.LOOKUPMODE(TRUE);
                            BankAccountList.SETTABLEVIEW(BankAccount);
                            IF BankAccountList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                BankAccountList.GETRECORD(BankAccount);
                                BankAccountCode := BankAccount."No.";
                                ComBankAccNo := BankAccount."Bank Account No.";
                                BankAccountName := BankAccount.Name;
                            END;
                        END;
                    end;
                }
                field("Bank Account No."; ComBankAccNo)
                {
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                    Caption = 'Bank Account No.';
                    ApplicationArea = All;
                }
                field("Bank Account Name"; BankAccountName)
                {
                    ToolTip = 'Specifies the value of the Bank Account Name field.';
                    Caption = 'Bank Account Name';
                    ApplicationArea = All;
                }
                field("Company Name"; txtCompanyName)
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                    Caption = 'Company Name';
                    ApplicationArea = All;
                }
                field(ChequeNo; ChequeNo)
                {
                    ToolTip = 'Specifies the value of the Cheque No. field.';
                    Caption = 'Cheque No';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            CompanyInformation.GET;
            txtCompanyName := CompanyInformation.Name;
            CompAdd := CompanyInformation.Address + ',' + CompanyInformation."Address 2";
            CompCity := CompanyInformation.City;
            CompPostcode := CompanyInformation."Post Code";
            CompCounty := CompanyInformation."Country/Region Code";
            CompVATNo := CompanyInformation."VAT Registration No.";
        end;
    }

    labels
    {
    }

    var
        CompanyInformation: Record 79;
        BankAccount: Record 270;
        CompCounty: Text[20];
        CompPostcode: Text[20];
        CompCity: Text[50];
        BankAccountCode: Code[20];
        txtCompanyName: Text;
        StartDate: Date;
        EndDate: Date;
        BankAccountName: Text;
        VendorBankAccount: Record 288;
        BenificiaryName: Text[150];
        BankAccNo: Code[150];
        Vendor: Record 23;
        BankAdd: Text[100];
        IFSCCode: Code[150];
        VendMobile: Code[150];
        VendEmail: Text[150];
        BankCity: Text;
        ComBankAccNo: Text;
        VendorName: Text;
        VendorName1: Text;
        VendorName2: Text;
        VendorAmount: Decimal;
        BankDocNo: Code[20];
        ChequeNo: Text[30];
        ChequeDt: Date;
        CompAdd: Text[200];
        CompVATNo: Text[20];
        SwiftCode: Code[30];
        IBANNo: Code[50];

}

