// Welcome to your new AL extension.

codeunit 90002 "bmsBC Regex TA"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryTestInitialise: Codeunit "Library - Test Initialize";
        LibraryAssert: CodeUnit Assert;
        libraryTestUtility: Codeunit "Library - Utility";
        LibraryTestSales: Codeunit "Library - Sales";
        LibraryTestPurch: Codeunit "Library - Purchase";
        isInitialized: Boolean;
        drilldownDone: Boolean;

    local procedure Initialize()
    begin
        //Generic Fresh Data-setup 
        LibraryTestInitialise.OnTestInitialize(90002);

        //Lazy Data-Setup
        if not isInitialized then
            LibraryTestInitialise.OnBeforeTestSuiteInitialize(90002);

        isInitialized := true;
        commit();

        LibraryTestInitialise.OnAfterTestSuiteInitialize(90002);
    end;

    [Test]
    procedure Scenario001_RegexRulesPageSorting()
    var
        FieldRegexRules: Record "bmsField Regex Rules";
        FieldRegexRulesTestPage: TestPage "bmsField Regex Rules";
    begin
        //Setting up Lazy and fresh elements
        //[GIVEN] Set of Regex rules
        Initialize();

        //[WHEN] Open regex rules page
        FieldRegexRulesTestPage.OpenEdit();
        FieldRegexRulesTestPage.GoToRecord(FieldRegexRules);

        //[THEN] The record is sort in the right order
        LibraryAssert.AreEqual('Table No.,Field No.', FieldRegexRules.CurrentKey, 'The sort key is not corret');
    end;

    [Test]
    [HandlerFunctions('FieldRegexExpressionModalHandler')]
    procedure Scenario002_RegexRulesPageBusinessSetup()
    var
        FieldRegexRules: Record "bmsField Regex Rules";
        FieldRegexRulesTestPage: TestPage "bmsField Regex Rules";
    begin
        //[GIVEN] Regex UI

        //[WHEN] Set an specific Regex rules (by partially filling in all fields, and then completely)
        //Partially Filling
        FieldRegexRules.Validate("Table No.", 37);
        FieldRegexRules.Insert(true);

        FieldRegexRulesTestPage.OpenEdit();
        FieldRegexRulesTestPage.GoToRecord(FieldRegexRules);

        //[THEN] regex action tyoe field should be not editable, and the drilldown action on field Regex field expression not possible
        LibraryAssert.AreEqual(false, FieldRegexRulesTestPage."Regex Action Type".Enabled(), 'error');
        FieldRegexRulesTestPage."Regex Field Expression".Drilldown();
        LibraryAssert.IsFalse(drilldownDone, 'The drilldown should not be possible');
        FieldRegexRulesTestPage.Close();

        //Filling all fields
        FieldRegexRules.Init();
        FieldRegexRules.validate("Table No.", 36);
        FieldRegexRules.Validate("Field No.", 14);
        FieldRegexRules.Validate("Regex Action Type", FieldRegexRules."Regex Action Type"::Match);
        FieldRegexRules.Insert(true);

        FieldRegexRulesTestPage.OpenEdit();
        FieldRegexRulesTestPage.GoToRecord(FieldRegexRules);

        //[THEN] Regex action type field should be editable, and the drilldown action on field Regex field expression is possible
        LibraryAssert.IsTrue(FieldRegexRulesTestPage."Regex Action Type".Enabled(), 'Regex action type field should be editable');
        FieldRegexRulesTestPage."Regex Field Expression".Drilldown();
        LibraryAssert.IsTrue(drilldownDone, 'The drilldown should be possible');
    end;

    [Test]
    procedure Scenario003_TestMatchRegex()
    var
        Customer: Record Customer;
        CustomerCardTestPage: TestPage "Customer Card";
    begin
        //Setting up Lazy and fresh elements
        Initialize();

        //[GIVEN] an Customer
        LibraryTestSales.CreateCustomer(Customer);

        //[WHEN] Set an specific Email and Phone number for a customer
        CustomerCardTestPage.OpenEdit();
        CustomerCardTestPage.GoToRecord(Customer);
        CustomerCardTestPage."E-Mail".Value := libraryTestUtility.GenerateRandomEmail();
        CustomerCardTestPage."Phone No.".Value := libraryTestUtility.GenerateRandomPhoneNo();

        //[THEN] The email and phone format must follow the regex structure 
        CustomerCardTestPage.Close();
    end;

    [Test]
    procedure Scenario004_TestMatchRegex()
    var
        Vendor: Record Vendor;
        VendorCardTestPage: TestPage "Vendor Card";
    begin
        //Setting up Lazy and fresh elements
        Initialize();

        //[GIVEN] an Customer
        LibraryTestPurch.CreateVendor(Vendor);

        //[WHEN] Set an specific Email and Phone number for a customer
        VendorCardTestPage.OpenEdit();
        VendorCardTestPage.GoToRecord(Vendor);
        VendorCardTestPage."Home Page".Value := 'https://www.toto.toto/';


        //[THEN] The email and phone format must follow the regex structure 
        VendorCardTestPage.Close();
    end;

    [Test]
    procedure Scenario005_TestReplaceRegex()
    var
        Customer: Record Customer;
    begin
        //Setting up Lazy and fresh elements
        Initialize();

        //[GIVEN] an Customer
        LibraryTestSales.CreateCustomer(Customer);

        //[WHEN] Set an adress 2 matching with the regex Pattern
        Customer.Validate("Address 2", 'Example');
        Customer.Modify(true);

        //[THEN] The Adress 2 value in replace by TT
        LibraryAssert.AreEqual('TT', Customer."Address 2", 'The Customer Adresse,must by replace for TT Value');
    end;

    [ModalPageHandler]
    procedure FieldRegexExpressionModalHandler(var FieldRegexExpressionTestPage: TestPage "bmsField Regex Expression")
    begin
        drilldownDone := true;
    end;


}