trigger CaseCommentSetIsPublishedTrigger on CaseComment (Before insert, before Update) {
	for (CaseComment t: Trigger.new)
    {
        t.IsPublished = True;
    }
}