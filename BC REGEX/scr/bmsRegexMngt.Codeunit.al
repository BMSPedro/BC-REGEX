codeunit 80200 "bmsRegex Mngt"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Global Triggers", 'OnDatabaseInsert', '', false, false)]
    local procedure trackInserts(RecRef: RecordRef)
    var
        fieldRegexRules: Record "bmsField Regex Rules";
        fieldRegexExpression: Record "bmsField Regex expression";
        regexbaseCU: Codeunit Regex;
        fieldref: FieldRef;
        expressionMatch: Boolean;
    begin
        fieldRegexRules.Reset();
        fieldRegexRules.SetRange("Table No.", RecRef.Number);
        if fieldRegexRules.FindSet() then
            repeat
                fieldref := RecRef.Field(fieldRegexRules."Field No.");
                if format(fieldref.Value) <> '' then begin
                    fieldRegexExpression.Reset();
                    fieldRegexExpression.SetRange("Table No", fieldRegexRules."Table No.");
                    fieldRegexExpression.SetRange("Field No", fieldRegexRules."Field No.");
                    if fieldRegexExpression.FindSet() then
                        repeat
                            if format(fieldref.Value) <> ' ' then begin
                                if fieldRegexRules."Regex Action Type" = fieldRegexRules."Regex Action Type"::Match then
                                    expressionMatch := regexbaseCU.IsMatch(fieldref.Value, fieldRegexExpression.Regex);
                                if fieldRegexRules."Regex Action Type" = fieldRegexRules."Regex Action Type"::Replace then begin
                                    fieldref.Validate(regexbaseCU.Replace(fieldref.Value, fieldRegexExpression.Regex, 'TT'));
                                    expressionMatch := true;
                                end;
                            end;
                        until (fieldRegexExpression.Next() = 0) or (expressionMatch);
                    if not expressionMatch then
                        error(fieldref.Caption);
                end;

            until fieldRegexRules.Next() = 0;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Global Triggers", OnDatabaseModify, '', false, false)]
    local procedure trackmodify(RecRef: RecordRef)
    var
        fieldRegexRules: Record "bmsField Regex Rules";
        fieldRegexExpression: Record "bmsField Regex expression";
        regexbaseCU: Codeunit Regex;
        fieldref: FieldRef;
        expressionMatch: Boolean;
    begin
        fieldRegexRules.Reset();
        fieldRegexRules.SetRange("Table No.", RecRef.Number);
        if fieldRegexRules.FindSet() then
            repeat
                fieldref := RecRef.Field(fieldRegexRules."Field No.");
                if format(fieldref.Value) <> '' then begin
                    fieldRegexExpression.Reset();
                    fieldRegexExpression.SetRange("Table No", fieldRegexRules."Table No.");
                    fieldRegexExpression.SetRange("Field No", fieldRegexRules."Field No.");
                    if fieldRegexExpression.FindSet() then
                        repeat
                            if fieldRegexRules."Regex Action Type" = fieldRegexRules."Regex Action Type"::Match then
                                expressionMatch := regexbaseCU.IsMatch(fieldref.Value, fieldRegexExpression.Regex);
                            if fieldRegexRules."Regex Action Type" = fieldRegexRules."Regex Action Type"::Replace then begin
                                fieldref.Validate(regexbaseCU.Replace(fieldref.Value, fieldRegexExpression.Regex, 'TT'));
                                expressionMatch := true;
                            end;
                        until (fieldRegexExpression.Next() = 0) or (expressionMatch);
                    if not expressionMatch then
                        error(fieldref.Caption);
                end;
            until fieldRegexRules.Next() = 0;
    end;

}