report 50101 "XReport"
{
    ApplicationArea = All;
    Caption = 'XReport';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/report/rdl/XReport.rdl';
    dataset
    {
        dataitem(Item; Item)
        {
            column(XLinesPerPage; XLinesPerPage) { }
            column(XLines; XLines) { }
            column(XLine; XLine) { }

            column(No_; "No.") { IncludeCaption = true; }

            trigger OnPreDataItem()
            begin
                XLines := 8; // Replace with XLines = Count for production;
            end;

            // Development trigger to control how many rows are generated
            trigger OnAfterGetRecord()
            begin
                if XLine = XLines then
                    CurrReport.Break();

                XLine += 1;
            end;
        }

        dataitem(XAuxLines; Integer)
        {
            column(XBlanks; XBlanks) { }
            column(XBlank; Number) { }
            column(XTotalsLines; XTotalsLines) { }

            trigger OnPreDataItem()
            begin
                XBlanks := XLinesPerPage - (XLines Mod XLinesPerPage);

                if XBlanks < XTotalsLines then begin
                    XBlanks += XLinesPerPage;
                    XLines += XLinesPerPage;
                end;

                SetRange(Number, 1, XBlanks);
            end;
        }

        dataitem(XSideBars; Integer)
        {
            column(XSideBar; Number) { }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, XLines div XLinesPerPage);
            end;
        }
    }

    trigger OnInitReport()
    begin
        XLinesPerPage := 5;
        XTotalsLines := 3;
    end;

    var
        XLinesPerPage: Integer;
        XLines: Integer;
        XLine: Integer;
        XBlanks: Integer;
        XTotalsLines: Integer;
}
