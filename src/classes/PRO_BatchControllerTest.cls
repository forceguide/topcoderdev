@isTest
public with sharing class PRO_BatchControllerTest {
	
	/*
	*	setup test data
	*/
	private static void setupTestData(){
		User user = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
		System.runAs(user){
			UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
			Profile profile1 = [SELECT Id FROM Profile WHERE name = 'System Administrator'];
			
			User portalUser = new User(
										UserRoleId = portalRole.Id,
										ProfileId = profile1.Id,
										Username = System.now().millisecond() + 'test2@test.com',
									   	Alias = 'batman',
										Email='bruce.wayne@wayneenterprises.com',
										EmailEncodingKey='UTF-8',
										Firstname='Bruce',
										Lastname='Wayne',
										LanguageLocaleKey='en_US',
										LocaleSidKey='en_US',
										TimeZoneSidKey='America/Chicago'
									);
			insert portalUser;
			
			// Create account 
			Id accId = Database.insert(new Account(Name='Test Account',OwnerId = portalUser.Id)).getId();
			
			// Create contact
			List<Contact> contactList = new List<Contact>();
		 
			for (Integer i=0;i<1;i++){
			 	contactList.add(new Contact(LastName='Test Contact '+i,AccountId=accId));
			}
			insert contactList;
			 
			// Insert users List
			List<User> usersList = new List<User>();
			Id profileId = [SELECT Id FROM Profile WHERE Name ='Partner Community User' LIMIT 1].Id;
			for (Integer i=0;i<1;i++){
				 usersList.add(new User(UserName='Test.user2763'+i+'@demo.com',Email='Test.email'+i+'@demo.com',Lastname='User'+i+'',FirstName='Test',Alias='tuser',CommunityNickname='tuser1'+i+'',
				 				ProfileId=profileId,TimeZoneSidKey='GMT',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',
				 				LanguageLocaleKey='en_US',UserPermissionsMobileUser=false, Twitter_Access_token__c ='twittertoken',
				 				Twitter_Oauth_Secret__c = 'twittersecret',Twitter_Last_Fetched_Date_time__c = System.now(),
				 				Facebook_Last_Fetched_Date_time__c = System.now(),Facebook_Access_token__c = 'facebooktoken',ContactId=contactList[i].Id));
			}
			insert usersList;
		}
	}
	
	/*
	*	setUp Twitter data 
	*/
	private static void setupTwitterSettings(){
		PRO_Twitter_Settings__c settings = new PRO_Twitter_Settings__c(Consumer_key__c='key',Consumer_Secret__c='secret');
		insert settings;
	}
	
	/*
	*	setUp Twitter data 
	*/
	private static void setupFacebookSettings(){
		PRO_Facebook_Settings__c settings = new PRO_Facebook_Settings__c(Client_Id__c='key',Client_Secret__c='secret',Scope__c='read');
		insert settings;
	}
	
	// Test batch apex
	static testMethod void test_batchApex() {
		// Create test Data
		setupTestData();
		setupTwitterSettings();
		setupFacebookSettings();
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new PRO_FacebookResponseMock());
		PRO_BatchController batch = new PRO_BatchController();
		Database.executebatch(batch,10);
		Test.stopTest();
	}
}