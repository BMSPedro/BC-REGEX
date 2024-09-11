pageextension 80201 "Company Information" extends "Company Information"
{
    layout
    {
        addafter("E-Mail")
        {
            field("Support Email Adress"; Rec."Support Email Address")
            {
                ApplicationArea = all;
                ToolTip = 'Support Email Adress';
            }
        }
    }
}