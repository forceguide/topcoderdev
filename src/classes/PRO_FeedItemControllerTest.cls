@isTest
public with sharing class PRO_FeedItemControllerTest {
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
	*	Test Facebook Response
	*/
	static testMethod void test_FacebookMockResponse(){
		setupTestData();
		UpdateuserData();
		// Create twitter settings
		Test.startTest();
		
		// Set mock callout class 
    	Test.setMock(HttpCalloutMock.class, new PRO_FacebookResponseMock());
		
		List<String> facebookPosts = PRO_FeedItemController.fetchFaceBookPosts(user);
		
		System.assertEquals('Test Scheduler',facebookPosts[0]);
		Test.stopTest();
	}
	
	/*
	*	Test twitter Response
	*/
	static testMethod void test_TwitterMockResponse(){
		setupTestData();
		UpdateuserData();
		// Create twitter settings
		Test.startTest();
		
		// Set mock callout class 
    	Test.setMock(HttpCalloutMock.class, new PRO_TwitterMockResponse());
		
		List<String> twitterPosts = PRO_FeedItemController.fetchTwitterPosts(user);
		
		System.assertEquals('Some text',twitterPosts[0]);
		Test.stopTest();
	}
}