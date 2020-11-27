@isTest
private class MultiSelectLookupFieldControllerTest {
  @isTest
  static void retrieveRecordsTest() {
    Contact testContact = new Contact();
    testContact.LastName = 'TestName_01';
    insert testContact;

    String objectName = 'Contact';
    String fieldName = 'Name';
    String value = 'TestName';
    List<String> selectedRecId;

    Test.startTest();
    MultiSelectLookupFieldController.getResults(
      objectName,
      fieldName,
      value,
      selectedRecId
    );
    Test.stopTest();
  }

}