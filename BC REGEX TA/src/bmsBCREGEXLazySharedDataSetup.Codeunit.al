codeunit 90001 bmsBCREGEXLazySharedDataSetup
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Library - Test Initialize", OnBeforeTestSuiteInitialize, '', true, true)]
    local procedure setLazySharedDataSetup(CallerCodeunitID: Integer)
    var
        CompanyInformation: Record "Company Information";

    begin
        case CallerCodeunitID of
            90002:
                CreateFieldRegexRuleAndExpression();

            90003:
                begin
                    CompanyInformation.Get();
                    CompanyInformation.Validate("bmsSupport Email Address", LibraryTestUtility.GenerateRandomEmail());
                    CompanyInformation.Modify(true);
                end;
        end;
    end;

    var
        LibraryTestUtility: codeunit "Library - Utility";


    procedure CreateFieldRegexRuleAndExpression()
    var
        FieldRegexRules: record "bmsField Regex Rules";
        FieldRegexExpression: Record "bmsField Regex expression";
    begin
        //Rule 1 Customer table, Match Email field
        FieldRegexRules.Init();
        FieldRegexRules.Validate("Table No.", 18);
        FieldRegexRules.Validate("Field No.", 102);
        FieldRegexRules.validate("Regex Action Type", FieldRegexRules."Regex Action Type"::Match);
        FieldRegexRules.Insert(true);

        FieldRegexExpression.init();
        FieldRegexExpression.Validate("Table No", FieldRegexRules."Table No.");
        FieldRegexExpression.Validate("Field No", FieldRegexRules."Field No.");
        FieldRegexExpression.Validate(Priority, 1);
        FieldRegexExpression.Validate("Regex description", LibraryTestUtility.GenerateRandomText(100));
        FieldRegexExpression.Validate(Regex, '^[^@]+@[^@]+\.[^@]+$');
        FieldRegexExpression.Insert(true);

        //Rule 2 Customer table, Match Phone field
        FieldRegexRules.Init();
        FieldRegexRules.Validate("Table No.", 18);
        FieldRegexRules.Validate("Field No.", 9);
        FieldRegexRules.validate("Regex Action Type", FieldRegexRules."Regex Action Type"::Match);
        FieldRegexRules.Insert(true);

        FieldRegexExpression.init();
        FieldRegexExpression.Validate("Table No", FieldRegexRules."Table No.");
        FieldRegexExpression.Validate("Field No", FieldRegexRules."Field No.");
        FieldRegexExpression.Validate(Priority, 1);
        FieldRegexExpression.Validate("Regex description", LibraryTestUtility.GenerateRandomText(100));
        FieldRegexExpression.Validate(Regex, '^([ \+()0-9-]{16,20})');
        FieldRegexExpression.Insert(true);

        //Rule 3 Customer table, Replace Adress field
        FieldRegexRules.Init();
        FieldRegexRules.Validate("Table No.", 18);
        FieldRegexRules.Validate("Field No.", 6);
        FieldRegexRules.validate("Regex Action Type", FieldRegexRules."Regex Action Type"::Replace);
        FieldRegexRules.Insert(true);

        FieldRegexExpression.init();
        FieldRegexExpression.Validate("Table No", FieldRegexRules."Table No.");
        FieldRegexExpression.Validate("Field No", FieldRegexRules."Field No.");
        FieldRegexExpression.Validate(Priority, 1);
        FieldRegexExpression.Validate("Regex description", LibraryTestUtility.GenerateRandomText(100));
        FieldRegexExpression.Validate(Regex, 'Example');
        FieldRegexExpression.Insert(true);

        //Rule 4 Vendor table, Match Home page field
        FieldRegexRules.Init();
        FieldRegexRules.Validate("Table No.", 23);
        FieldRegexRules.Validate("Field No.", 103);
        FieldRegexRules.validate("Regex Action Type", FieldRegexRules."Regex Action Type"::Match);
        FieldRegexRules.Insert(true);

        FieldRegexExpression.init();
        FieldRegexExpression.Validate("Table No", FieldRegexRules."Table No.");
        FieldRegexExpression.Validate("Field No", FieldRegexRules."Field No.");
        FieldRegexExpression.Validate(Priority, 1);
        FieldRegexExpression.Validate("Regex description", LibraryTestUtility.GenerateRandomText(100));
        FieldRegexExpression.Validate(Regex, '^(http|https):\/\/([^":])+$');
        FieldRegexExpression.Insert(true);
    end;
}