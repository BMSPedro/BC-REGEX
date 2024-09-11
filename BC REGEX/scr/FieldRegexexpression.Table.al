table 80200 "Field Regex expression"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Field No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Priority"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Regex"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Regex description"; text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Table No", "Field No", Priority, Regex)
        {
            Clustered = true;
        }
    }
}