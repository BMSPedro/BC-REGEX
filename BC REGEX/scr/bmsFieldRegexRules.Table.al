

table 80201 "bmsField Regex Rules"
{
    Caption = 'Field Regex Rules';
    ReplicateData = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = "Table Metadata".ID;
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." where(TableNo = field("Table No."));
        }
        field(3; "Field Caption"; Text[100])
        {
            Caption = 'Field Caption';
        }

        field(4; "Regex Action Type"; Enum "bmsRegex Action Type")
        {

        }
        field(5; "Regex Field Expression"; Integer)
        {
            CalcFormula = count("bmsField Regex expression" where("Table No" = field("Table No."), "Field No" = field("Field No.")));
            FieldClass = FlowField;
        }
        field(6; "Table Caption"; Text[250])
        {
            Caption = 'Table Caption';
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        FieldRegexExpression: Record "bmsField Regex expression";
    begin
        FieldRegexExpression.reset();
        FieldRegexExpression.SetRange("Table No", rec."Table No.");
        FieldRegexExpression.SetRange("Field No", rec."Field No.");
        FieldRegexExpression.DeleteAll();
    end;
}