@isTest
private class MultiSelectLookupControllerTest {
  @isTest
  static void retrieveRecordsTest() {
    Contact con = new Contact();
    con.LastName = 'TestName';

    String objectName = 'Contact';
    String fieldAPINames = 'Id,Name';
    String filterFieldAPIName = 'Name';
    String strInput = 'TestName';

    Test.startTest();
    MultiSelectLookupController.retrieveRecords(
      objectName,
      fieldAPINames,
      filterFieldAPIName,
      strInput
    );
    Test.stopTest();
  }
}