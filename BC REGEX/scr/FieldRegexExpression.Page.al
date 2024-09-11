page 80201 "Field Regex Expression"
{
    PageType = List;
    SourceTable = "Field Regex expression";


    layout
    {

        area(Content)
        {
            repeater(Group)
            {
                field("Priority"; rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Priority';
                }
                field("Description"; rec."Regex description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Priority';
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