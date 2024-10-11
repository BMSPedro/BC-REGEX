page 80201 "bmsField Regex Expression"
{
    PageType = List;
    SourceTable = "bmsField Regex expression";

    layout
    {

        area(Content)
        {
            repeater(Group)
            {
                field(Priority; rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Priority';
                }
                field(Description; rec."Regex description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Regex Description';
                }
                field("Regex Expression"; rec.Regex)
                {
                    ApplicationArea = All;
                    ToolTip = 'Regex Expression';
                }
            }
        }
    }
}