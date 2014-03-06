@isTest
public with sharing class PRO_FacebookOAuthControllerTest {
	
	/*
	*	setUp Twitter data 
	*/
	private static void setupFacebookSettings(){
		PRO_Facebook_Settings__c settings = new PRO_Facebook_Settings__c(Client_Id__c='key',Client_Secret__c='secret',Scope__c='read');
		insert settings;
	}
	
	/*
	*	Test getOAuthCode method
	*/
	static testMethod void test_getOAuthCode(){
		// Create twitter settings
		setupFacebookSettings();
		Test.startTest();
		
		// Set mock callout class 
    	Test.setMock(HttpCalloutMock.class, new PRO_FacebookAccessToken());
		
		// Set page reference with out code parameters 
		System.Test.setCurrentPageReference(new PageReference('/apex/x?'));
		PRO_FacebookOAuthController cls = new PRO_FacebookOAuthController();
		
		System.assertEquals('/apex/PRO_OAuthConnection?media=facebook&success=false',cls.fetchFaceBookAccessToken().getUrl());
		System.assert(cls.fetchFaceBookAccessToken() != null);
		
		// Set page reference with code parameters 
		System.Test.setCurrentPageReference(new PageReference('/apex/x?code="dsfdfasdf"'));
		cls = new PRO_FacebookOAuthController();
		
		User user = PRO_FacebookOAuthController.loggedInUser;
		
		System.assertEquals('/apex/PRO_OAuthConnection?media=facebook&success=true',cls.fetchFaceBookAccessToken().getUrl());
		System.assert(cls.fetchFaceBookAccessToken() != null);
		Test.stopTest();
	}
	
	/*
	*	Test updateUser method
	*/
	static testMethod void test_updateUser(){
		// Create twitter settings
		Test.startTest();
		
		// Set page reference with out code parameters 
		System.Test.setCurrentPageReference(new PageReference('/apex/x?'));
		
		System.assertEquals(true,PRO_FacebookOAuthController.updateUser('access_token=fdagfdga'));
		Test.stopTest();
	}
	
	/*
	*	Test fetchRefreshToken method
	*/
	static testMethod void test_fetchRefreshToken(){ 
		// Create twitter settings
		Test.startTest();
		
		// Set mock callout class 
    	Test.setMock(HttpCalloutMock.class, new PRO_FacebookSessionMock());
    	
		// Set page reference with out code parameters 
		System.Test.setCurrentPageReference(new PageReference('/apex/x?'));
		
		System.assertEquals(true,PRO_FacebookOAuthController.fetchRefreshToken('{"error": {"message": "Session has expired","type": "OAuthException","code": 190,"error_subcode": 467}}'));
		System.assert(PRO_FacebookOAuthController.fetchRefreshToken('{"error": {"message": "Session has expired","type": "OAuthException","code": 190,"error_subcode": 467}}') != null);
		Test.stopTest();
	}
}