@isTest
public with sharing class PRO_TwitterOAuthControllerTest {
	
	private static User user;
	
	/*
	*	setup test data
	*/
	private static void setupTestData(){
		 Id profileId = [SELECT Id FROM Profile WHERE Name ='System Administrator' LIMIT 1].Id;
		 User adminUser = [SELECT Id, Name FROM User WHERE ProfileId=:profileId LIMIT 1];
		 System.runAs(adminUser){
			 user = new User(UserName='Test.user2763@demo.com',Email='Test.email@demo.com',Lastname='User',FirstName='Test',Alias='tuser',CommunityNickname='tuser1',
			 				ProfileId=profileId,TimeZoneSidKey='GMT',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',Twitter_Oauth_Secret__c = 'twittersecret',
			 				LanguageLocaleKey='en_US',UserPermissionsMobileUser=false,Twitter_Access_token__c ='twittertoken',Twitter_Last_Fetched_Date_time__c = System.now(),
			 				Facebook_Last_Fetched_Date_time__c = System.now(),Facebook_Access_token__c = 'facebooktoken');
			 insert user;
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
	*	Test getOAuthCode method
	*/
	static testMethod void test_getOAuthCode(){
		// Create twitter settings 
		setupTwitterSettings();
		setupTestData();
		Test.startTest();
		
		// Set mock callout class 
    	Test.setMock(HttpCalloutMock.class, new PRO_TwitterOauthToken());
		
		// Set page reference with out code parameters 
		System.Test.setCurrentPageReference(new PageReference('/apex/x?'));
		PRO_TwitterOAuthController cls = new PRO_TwitterOAuthController();
		
		System.assertEquals('/apex/PRO_OAuthConnection?media=twitter&success=false',cls.fetchTwitterAccessToken().getUrl());
		System.assert(cls.fetchTwitterAccessToken() != null);
		
		// Set page reference with code parameters 
		System.Test.setCurrentPageReference(new PageReference('/apex/x?oauth_token="dsfdfasdf"&oauth_verifier="dfsdsdfaasd"'));
		
		cls = new PRO_TwitterOAuthController();
		
		
		System.assertEquals('/apex/PRO_OAuthConnection?media=twitter&success=true',cls.fetchTwitterAccessToken().getUrl());
		System.assert(cls.fetchTwitterAccessToken() != null);
		
		
		// TEST OTHER METHODS 
		System.assertEquals(5,PRO_TwitterOAuthController.mapHeaders(user).size());
		System.assert(PRO_TwitterOAuthController.setAuthHeader('Test',PRO_TwitterOAuthController.mapHeaders(user),user).startsWith('OAuth'));
		System.assert(PRO_TwitterOAuthController.createBaseString(PRO_TwitterOAuthController.mapHeaders(user),'www.google.com','GET').startsWith('GET'));
		Test.stopTest();
	}
}