codeunit 90003 "bmsError msg 2 helpdesk TA"
{
    Subtype = Test;
    TestPermissions = Disabled;
    //[FEATURE] Send email to the helpdesk plateform

    var
        LibraryTestInitialise: Codeunit "Library - Test Initialize";
        LibraryAssert: CodeUnit Assert;
        libraryTestUtility: Codeunit "Library - Utility";
        LibraryTestERM: Codeunit "Library - ERM";
        isInitialized: Boolean;
        TemplateName: text;

    local procedure Initialize()
    begin
        //Generic Fresh Data-setup 
        LibraryTestInitialise.OnTestInitialize(90003);

        //Lazy Data-Setup
        if not isInitialized then
            LibraryTestInitialise.OnBeforeTestSuiteInitialize(90003);

        isInitialized := true;
        commit();

        //Routines after Test process
        LibraryTestInitialise.OnAfterTestSuiteInitialize(90003);
    end;

    //[Scenario] 001 Setting email adresse on the company information entity
    [Test]
    procedure Scenario001_SetEmailtoCallHelpDesk()
    var
        CompanyInformation: Record "Company Information";
    begin
        //Setting up Lazy and fresh elements
        //[GIVEN] Set Helpdesk Email on company information entity
        Initialize();

        //[WHEN] Check Email field on company information
        CompanyInformation.get();

        //[THEN] Helpdesk email field must be filled
        LibraryAssert.AreNotEqual(' ', CompanyInformation."bmsSupport Email Address", 'The Helpdesk email must be filled');
    end;

    //[Scenario] 002 Open email editor and save email when error in general journal
    [Test]
    [HandlerFunctions('ManageTemplatePage,ManagePostConfirmDialog,ManageErrorMsg,EmailHandler,ManageStrMenuDrafEmail')]
    procedure Scenario002_SetEmailtoCallHelpDesk()
    var
        EmailAccount: Record "Email Account";
        Generaljournalline: Record "Gen. Journal Line";
        Generaljournaltemplate: Record "Gen. Journal Template";
        Generaljournalbatch: Record "Gen. Journal Batch";
        Glaccount: Record "G/L Account";
        EmailConnector: Codeunit "bmsEmail Connector";
        LibraryTestJournals: Codeunit "Library - Journals";
        Accounttype: enum "Gen. Journal Account Type";
        GeneralJournaldoctype: enum "Gen. Journal Document Type";
        Generaljournaltestpage: TestPage "General Journal";
    begin
        //Setting up Lazy and fresh elements
        //[GIVEN] Set Helpdesk Email on company information entity
        Initialize();

        //[WHEN] Email Account is set, and a general journal is post with an error (unbalanced).
        EmailAccount.Init();
        EmailAccount."Email Address" := libraryTestUtility.GenerateRandomEmail();
        EmailAccount.Insert(true);
        EmailConnector.RegisterAccount(EmailAccount);
        LibraryTestErm.CreateGLAccount(glaccount);
        LibraryTestErm.CreateGenJournalTemplate(generaljournaltemplate);
        TemplateName := generaljournaltemplate.Name;
        LibraryTestErm.CreateGenJournalBatch(generaljournalbatch, generaljournaltemplate.Name);

        LibraryTestJournals.CreateGenJournalLine(Generaljournalline, Generaljournaltemplate.Name, Generaljournalbatch.Name, GeneralJournaldoctype::" ", Accounttype::"G/L Account", Glaccount."No.", Accounttype::"G/L Account", '', 100);

        Generaljournaltestpage.OpenView();
        Generaljournaltestpage.GoToRecord(Generaljournalline);
        Generaljournaltestpage.Post.Invoke();

        //[THEN] The error control is done in the UI management function. The error page should open with the option to send an email to support. The email editor page should open with the email. When closed, a draft email should be present in the email outbox.'
    end;

    [ModalPageHandler]
    procedure ManageTemplatePage(var GeneralJournalTemplateTestPage: TestPage "General Journal Template List")
    var
    begin
        GeneralJournalTemplateTestPage.Filter.SetFilter("Name", TemplateName);
        GeneralJournalTemplateTestPage.OK().Invoke();
    end;

    [ModalPageHandler]
    procedure ManageJournalpage(var generaljournaltestpage: TestPage "General Journal")
    begin
    end;

    [ConfirmHandler]
    procedure ManagePostConfirmDialog(Question: text; var Reply: boolean)
    begin
        Reply := true;
    end;

    [StrMenuHandler]
    procedure ManageStrMenuDrafEmail(options: Text; var choice: Integer; instruction: text)
    begin
        choice := 1
    end;

    [PageHandler]
    procedure ManageErrorMsg(var ErrorMessageTestPage: TestPage "Error Messages")
    begin
        ErrorMessageTestPage.bmsAskforsupport.Invoke();
    end;

    [ModalPageHandler]
    procedure EmailHandler(var EmaileditorTestPage: TestPage "Email Editor")
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.get();
        LibraryAssert.AreEqual(CompanyInformation."bmsSupport Email Address", EmaileditorTestPage.ToField.Value, 'There is no email for the Helpdesk or the recipient s address is not correct');
    end;




}