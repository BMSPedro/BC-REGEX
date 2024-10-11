

page 80202 "bmsField Regex Rules"
{
    PageType = Worksheet;
    ApplicationArea = Basic, Suite;
    UsageCategory = Administration;
    SourceTable = "bmsField Regex Rules";
    RefreshOnActivate = true;
    Caption = 'Field Regex Rules';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(TableNo; rec."Table No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Table No.';
                    ToolTip = 'Specifies the identifier of the table that includes the monitored field.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AllObjWithCaption: Record AllObjWithCaption;
                    begin
                        if Page.RunModal(Page::Objects, AllObjWithCaption) = ACTION::LookupOK then begin
                            rec.Validate("Table No.", AllObjWithCaption."Object ID");
                            rec.Validate("Table Caption", AllObjWithCaption."Object Name");
                        end;
                    end;
                }
                field("Table Caption"; Rec."Table Caption")
                {
                    Caption = 'Table Caption';
                    ToolTip = 'Specifies the name of the table that includes the monitored field.';
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Field No"; Rec."Field No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the identifier of the monitored field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldTable: Record Field;
                    begin
                        FieldTable.SetRange(TableNo, rec."Table No.");

                        if Page.RunModal(Page::"Fields Lookup", FieldTable) = Action::LookupOK then begin
                            Rec.Validate("Field No.", FieldTable."No.");
                            rec.Validate("Field Caption", FieldTable."Field Caption");
                        end;
                    end;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the name of the monitored field.';
                }
                field("Regex Action Type"; Rec."Regex Action Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Regex Action Type';
                    Enabled = rec."Field No." <> 0;
                }
                field("Regex Field Expression"; Rec."Regex Field Expression")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Regex Field Expression';
                    Editable = rec."Field No." <> 0;
                    trigger OnDrillDown()
                    var
                        FieldRegexExpression: Record "bmsField Regex expression";
                    begin
                        if (rec."Field No." <> 0) and (rec."Regex Action Type" <> rec."Regex Action Type"::" ") then begin
                            FieldRegexExpression.Reset();
                            FieldRegexExpression.SetRange("Table No", rec."Table No.");
                            FieldRegexExpression.SetRange("Field No", rec."Field No.");
                            Page.RunModal(Page::"bmsField Regex Expression", FieldRegexExpression);
                        end;
                    end;
                }
            }
        }
    }
}
