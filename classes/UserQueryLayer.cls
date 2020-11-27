/**
 * Created by cristofers on 2019-09-24.
 */

public with sharing class UserQueryLayer /*extends SObjectQueryLayer */{
       /* @TestVisible
        protected override Schema.SObjectType getSObjectType() {
            return User.sObjectType;
        }
        public User getUserByOpp (Id userId) {
            return [
                    SELECT Id, Title, FirstName, LastName, Company__c, Street, City, PostalCode, Phone, Fax, Register__c, Email, MobilePhone, SeatOfTheSociety__c, CommercialRegisterAddition__c, CommercialRegister__c
                    FROM User
                    WHERE Id = :userId
                    LIMIT 1
            ];
        }*/

}