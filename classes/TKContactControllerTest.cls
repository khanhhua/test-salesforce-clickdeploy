@isTest
public class TKContactControllerTest {
    static testMethod void getContactsWithAccountIdsTest() {
        Id rtype = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('doctorsSurgery').getRecordTypeId();
        Account a = new Account(Name='Name',
                                RecordTypeId=rtype);
        insert a;

        Contact c1 = new Contact(FirstName='Test',
                                 LastName='Test',
                                 Title='Prof',
                                 Email='email@gmail.com',
                                 AccountId=a.Id,
                                 Salutation='Mr');
        insert c1;

        List<String> ids = new List<String>();
        ids.add(a.Id);
        List<Contact> contacts = TKContactController.getContactsWithAccountIds(ids);
        System.assertEquals(contacts.size(), 1);
    }
}