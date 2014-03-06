@isTest
public with sharing class PRO_OAuthControllerTest {
	
	private static User user;
	private static Boolean setupTestData = false;
	
	/*
	*	setup test data
	*/
	private static void setupTestData(){
		 Id profileId = [SELECT Id FROM Profile WHERE Name ='System Administrator' LIMIT 1].Id;
		 user = new User(UserName='Test.user2763@demo.com',Email='Test.email@demo.com',Lastname='User',FirstName='Test',Alias='tuser',CommunityNickname='tuser1',
		 				ProfileId=profileId,TimeZoneSidKey='GMT',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',
		 				LanguageLocaleKey='en_US',UserPermissionsMobileUser=false);
		 insert user;
		 setupTestData = true; 
	}
	
	/*
	*	Update user data 
	*/
	private static void UpdateuserData(){
		if (user.Id != null){
			User rsUser = [SELECT Id, Twitter_Access_token__c, Twitter_Oauth_Secret__c, Twitter_Last_Fetched_Date_time__c, Facebook_Last_Fetched_Date_time__c, Facebook_Access_token__c 
                                 FROM User WHERE Id=: user.Id LIMIT 1];
            rsUser.Twitter_Access_token__c ='twittertoken';
            rsUser.Twitter_Oauth_Secret__c = 'twittersecret';
            rsUser.Twitter_Last_Fetched_Date_time__c = System.now();
            rsUser.Facebook_Last_Fetched_Date_time__c = System.now();
            rsUser.Facebook_Access_token__c = 'facebooktoken';
            update rsUser;
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
	*	Test OAuthController Constructor
	*/
	static testMethod void test_OAuthControllerConstructor(){
		Test.startTest();
		
		// Create test Data
		if (!setupTestData) setupTestData();
		
		System.runAs(user){
			// Set page reference
			System.Test.setCurrentPageReference(new PageReference('/apex/x?'));
			PRO_OAuthController cls = new PRO_OAuthController();
			
			// Check variable values
			System.assertNotEquals(true,cls.fbConnected);
			System.assertEquals(false,cls.hasFaceBookSettings);
			System.assert(cls.hasTwitterSettings==false);
			System.assertEquals(false,cls.twitterConnected);
			
			// Set page reference
			System.Test.setCurrentPageReference(new PageReference('/apex/x?media=facebook&&success=true'));
			cls = new PRO_OAuthController();
			List<ApexPages.Message> messages = ApexPages.getMessages();
        	System.assertEquals(1, messages.size());
        	
        	System.Test.setCurrentPageReference(new PageReference('/apex/x?media=facebook&&success=false'));
			cls = new PRO_OAuthController();
			messages = ApexPages.getMessages();
        	System.assertEquals(2, messages.size());
		}
		Test.stopTest();
	}
	
	/*
	*	Test revokeFacebookAccess method
	*/
	static testMethod void test_revokeFacebookAccess(){
		Test.startTest();
		// Create test Data
		if (!setupTestData) setupTestData();
		UpdateuserData();
	
		System.runAs(user){
			// Set page reference
			System.Test.setCurrentPageReference(new PageReference('/apex/x?'));
			PRO_OAuthController cls = new PRO_OAuthController();
		
			System.assertEquals('facebooktoken',PRO_OAuthController.loggedInUser.Facebook_Access_token__c);
			System.assertNotEquals('twittertoken1',PRO_OAuthController.loggedInUser.Facebook_Access_token__c);
			System.assert(PRO_OAuthController.loggedInUser.Facebook_Last_Fetched_Date_time__c != null);
			
			cls.revokeFacebookAccess();
			
			// Get user record
			User rsUser = [SELECT Id, Twitter_Access_token__c, Twitter_Oauth_Secret__c, Twitter_Last_Fetched_Date_time__c, Facebook_Last_Fetched_Date_time__c, Facebook_Access_token__c 
                                 FROM User WHERE Id=: user.Id LIMIT 1];
			System.assertEquals(null,rsUser.Facebook_Access_token__c);
			System.assertNotEquals('twittertoken1',rsUser.Facebook_Access_token__c);
			System.assert(rsUser.Facebook_Access_token__c == null);
		}
		Test.stopTest();
	}
	
	/*
	*	Test revokeTwitterAccess method
	*/
	static testMethod void test_revokeTwitterAccess(){
		Test.startTest();
		// Create test Data
		if (!setupTestData) setupTestData();
		UpdateuserData();
	
		System.runAs(user){
			// Set page reference
			System.Test.setCurrentPageReference(new PageReference('/apex/x?'));
			PRO_OAuthController cls = new PRO_OAuthController();
		
			System.assertEquals('twittertoken',PRO_OAuthController.loggedInUser.Twitter_Access_token__c);
			System.assertNotEquals('twittertoken1',PRO_OAuthController.loggedInUser.Twitter_Access_token__c);
			System.assertNotEquals('twittertokens',PRO_OAuthController.loggedInUser.Twitter_Oauth_Secret__c);
			System.assert(PRO_OAuthController.loggedInUser.Twitter_Last_Fetched_Date_time__c != null);
			
			cls.revokeTwitterAccess();
			
			// Get user record
			User rsUser = [SELECT Id, Twitter_Access_token__c, Twitter_Oauth_Secret__c, Twitter_Last_Fetched_Date_time__c, Facebook_Last_Fetched_Date_time__c, Facebook_Access_token__c 
                                 FROM User WHERE Id=: user.Id LIMIT 1];
			System.assertEquals(null,rsUser.Twitter_Access_token__c);
			System.assertNotEquals('twittertoken1',rsUser.Twitter_Access_token__c);
			System.assertNotEquals('twittertokens',rsUser.Twitter_Oauth_Secret__c);
			System.assert(rsUser.Twitter_Last_Fetched_Date_time__c == null);
		}
		Test.stopTest();
	}
	
	/*
	*	Test getOAuthCode method
	*/
	static testMethod void test_getOAuthCode(){
		// Create twitter settings
		setupTwitterSettings();
		Test.startTest();
		
		// Set mock callout class 
    	Test.setMock(HttpCalloutMock.class, new PRO_TwitterOauthToken());
		// Set page reference
		System.Test.setCurrentPageReference(new PageReference('/apex/x?'));
		String outhcode = PRO_OAuthController.getOAuthCode();
		System.assertEquals('dfgafdhgadf',outhcode);
		Test.stopTest();
	}
}