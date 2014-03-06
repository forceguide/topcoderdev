public with sharing class PRO_FacebookOAuthController {
   
    public static User         loggedInUser            {get; set;}
    

    /*
    *   Construtor
    */
    public PRO_FacebookOAuthController() {}
	
	
	/*
    *   description : Exchange the code with access token
    *   return String   response
    */
    public PageReference fetchFaceBookAccessToken(){
        Boolean isOauthSucess = false; 
		String domainName = '';
		if (PRO_OAuthController.domainSettings != null){
        	if (!String.isBlank(PRO_OAuthController.domainSettings.Domain_Name__c)) domainName = '/'+PRO_OAuthController.domainSettings.Domain_Name__c;
        }
        // Send a request
        if (PRO_OAuthController.facebookSettings != null){
            if (!String.isBlank(PRO_OAuthController.facebookSettings.Client_Id__c) && !String.isBlank(PRO_OAuthController.facebookSettings.Client_Secret__c) && !String.isBlank(ApexPages.currentPage().getParameters().get('code'))){
                String endPointUrl = PRO_UrlUtil.FACEBOOK_OAUTH_URL+'client_id='+PRO_OAuthController.facebookSettings.Client_Id__c+'&client_secret='+PRO_OAuthController.facebookSettings.Client_Secret__c+
                                        '&redirect_uri='+PRO_OAuthController.SALESFORCE_BASEURL+domainName+'/apex/PRO_FacebookOAuthConnection&code='+ApexPages.currentPage().getParameters().get('code');

                // Send a http request 
                isOauthSucess = updateUser(PRO_HttpCalloutHelper.sendHttpRequest(endPointUrl,'GET','','facebook'));
            }
        } 
        return new PageReference(domainName+'/apex/PRO_OAuthConnection?media=facebook&success='+isOauthSucess).setRedirect(true); 
    }


    /*
    *   description : get the response and update it to the user record
    *   return Boolean  true, if user record updated successfully else vice-versa
    */
    @TestVisible
    private static Boolean updateUser(String resBody){
        Boolean isSuccess = true;
        // If it is facebook update the facebook settings 
        if (!String.isBlank(resBody) && resBody.contains('access_token')){
            // Get the access token
            for (Integer i=0;i<resBody.split('&').size();i++){
                if (resBody.split('&')[i].split('=')[0] == 'access_token'){
                    PRO_OAuthController.loggedInUser.Facebook_Access_token__c = resBody.split('&')[i].split('=')[1];
                }
            }
            if (!Test.isRunningTest()) update PRO_OAuthController.loggedInUser; 
  		}
        return isSuccess; 
    } 
    
    /*
    *   description : Get the resfresh token only if access token is expires and upates the user record with 
    *				  new access token
    *   return Boolean  true, if get the 
    */
    public static Boolean fetchRefreshToken(String responseBody){
    	Boolean isSuccess = false;
    	// Parse the response 
		PRO_FacebookHelper.FacebookError faceBookError = (PRO_FacebookHelper.FacebookError)JSON.deserializeStrict(responseBody,PRO_FacebookHelper.FacebookError.class);
		
		// Check the message 
		if (faceBookError.error.message.contains('Session has expired') || faceBookError.error.message.contains('session is invalid') || faceBookError.error.message.contains('user logged out')){
			String refreshTokenUrl = PRO_UrlUtil.FACEBOOK_REFRESH_TOKEN+'&client_id='+PRO_OAuthController.facebookSettings.Client_Id__c+'&client_secret='+PRO_OAuthController.facebookSettings.Client_Secret__c+'fb_exchange_token='+PRO_OAuthController.loggedInUser.Facebook_Access_token__c;
			
			// Get the acess token
			isSuccess = updateUser(PRO_HttpCalloutHelper.sendHttpRequest(refreshTokenUrl,'GET','','facebook'));				
		}
		return isSuccess; 
    }
    
}