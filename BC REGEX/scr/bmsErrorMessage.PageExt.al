pageextension 80200 "bmsError Message" extends "Error Messages"
{
    actions
    {
        addafter(OpenRelatedRecord_Promoted)
        {
            actionref(AskforAssistcne; bmsAskforsupport)
            {
            }
        }
        addafter(OpenRelatedRecord)
        {
            action(bmsAskforsupport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send the support request';
                Image = SendMail;
                ToolTip = 'Send the Support call to a help-desk service';
                trigger OnAction()
                var
                    TempEmailItem: Record "Email Item" temporary;
                    user: Record User;
                    mailmngt: Codeunit "Mail Management";
                    EmailScenario: Enum "Email Scenario";
                    textBuilder: TextBuilder;
                begin
                    companyinfo.TestField("bmsSupport Email Address");
                    if Confirm('Are you sur that you want to contact the support service for assistance ?') then begin

                        textBuilder.AppendLine('Hello');
                        textBuilder.AppendLine();
                        textBuilder.AppendLine('<br><br>We need help with the following error');
                        textBuilder.AppendLine('<br>Error Context: ');
                        user.get(UserSecurityId());
                        textBuilder.AppendLine('<br>Company Name: ' + companyinfo.Name);
                        textBuilder.AppendLine('<br>User Contact Name: ' + user."Full Name");
                        textBuilder.AppendLine('<br>User Contact Email: ' + user."Authentication Email");
                        textBuilder.AppendLine('<br>Table Number: ' + format(rec."Context Table Number"));
                        textBuilder.AppendLine('<br>Record ID: ' + format(rec."Context Record ID"));
                        textBuilder.AppendLine('<br>Field Name: ' + rec."Context Field Name");
                        textBuilder.AppendLine('<br> Message: ' + rec.Message);
                        textBuilder.AppendLine('<br>Support Url: ' + rec."Support Url");
                        textBuilder.AppendLine('<br>Error Datetime: ' + format(rec."Created On"));
                        textBuilder.AppendLine();
                        textBuilder.AppendLine('<br><br>CallStack: <br>');
                        textBuilder.AppendLine(rec.GetErrorCallStack());

                        TempEmailItem.Init();
                        TempEmailItem.Validate("From Name", user."Full Name");
                        TempEmailItem.Validate("From Address", 'pedro.pereraaguila@axiansfrance.onmicrosoft.com');
                        TempEmailItem.Validate("Send CC", user."Authentication Email");
                        TempEmailItem.Validate(Subject, 'Error: ' + format(rec."Context Record ID"));
                        TempEmailItem."Message Type" := TempEmailItem."Message Type"::"From Email Body Template";
                        TempEmailItem.Validate("Send to", companyinfo."bmsSupport Email Address");
                        //TempEmailItem.Body.CreateOutStream(outstr);
                        //outstr.WriteText(textBuilder.ToText());
                        TempEmailItem.SetBodyText(textBuilder.ToText());
                        TempEmailItem."Plaintext Formatted" := false;
                        TempEmailItem.SendAsHTML(true);
                        TempEmailItem.Insert(true);

                        mailmngt.Send(TempEmailItem, EmailScenario::Notification);
                    end;
                end;
            }
        }
    }

    var
        companyinfo: Record "Company Information";

    trigger OnOpenPage()
    begin
        companyinfo.get();
    end;
}