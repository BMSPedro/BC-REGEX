pageextension 80201 "bmsCompany Information" extends "Company Information"
{
    layout
    {
        addafter("E-Mail")
        {
            field("bmsSupport Email Adress"; Rec."bmsSupport Email Address")
            {
                ApplicationArea = all;
                ToolTip = 'Support Email Adress';
            }
        }
    }
}