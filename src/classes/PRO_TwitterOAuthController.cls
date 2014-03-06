public with sharing class PRO_TwitterOAuthController {
    
    /*
    *   Constrcutor
    */
    public PRO_TwitterOAuthController() {}
    
    /*
    *   description : Exchange the code with access token
    *   return String   response
    */
    public PageReference fetchTwitterAccessToken(){
        Boolean isOauthSucess = false; 
        String domainName = '';
		if (PRO_OAuthController.domainSettings != null){
        	if (!String.isBlank(PRO_OAuthController.domainSettings.Domain_Name__c)) domainName = '/'+PRO_OAuthController.domainSettings.Domain_Name__c;
        }
        if (!String.isBlank(ApexPages.currentPage().getParameters().get('oauth_token')) && 
        	!String.isBlank(ApexPages.currentPage().getParameters().get('oauth_verifier'))){
	        // put the twitter parameters in a map
	        Map<String, String> parameters = PRO_TwitterOAuthController.mapHeaders(PRO_OAuthController.loggedInUser);
	        parameters.put('oauth_token',ApexPages.currentPage().getParameters().get('oauth_token'));
	        parameters.put('oauth_verifier',ApexPages.currentPage().getParameters().get('oauth_verifier'));
	        
	        // Create a base string
	        String signstr = PRO_TwitterOAuthController.createBaseString(parameters,PRO_UrlUtil.TWITTER_ACCESS_TOKEN_URL,'POST'); 
	         
	         // Get the header String
	        String header = PRO_TwitterOAuthController.setAuthHeader(signstr, parameters,PRO_OAuthController.loggedInUser); 
	        
	        String response = PRO_HttpCalloutHelper.sendHttpRequest(PRO_UrlUtil.TWITTER_ACCESS_TOKEN_URL, 'POST', header, 'twitter');
			
			// save the access token in the user record
			 if (!String.isBlank(response) && response.contains('oauth_token')){
	            // Get the access token
	            for (Integer i=0;i<response.split('&').size();i++){
	                if (response.split('&')[i].split('=')[0] == 'oauth_token')PRO_OAuthController.loggedInUser.Twitter_Access_token__c = response.split('&')[i].split('=')[1];
	                if (response.split('&')[i].split('=')[0] == 'oauth_token_secret')PRO_OAuthController.loggedInUser.Twitter_Oauth_Secret__c = response.split('&')[i].split('=')[1];
	                if (response.split('&')[i].split('=')[0] == 'user_id')PRO_OAuthController.loggedInUser.Twitter_UserId__c = response.split('&')[i].split('=')[1];
	                if (response.split('&')[i].split('=')[0] == 'screen_name')PRO_OAuthController.loggedInUser.Twitter_User_Name__c = response.split('&')[i].split('=')[1];
	            }
	            if (!Test.isRunningTest()) update PRO_OAuthController.loggedInUser; 
	            isOauthSucess = true;
	  		}
        }
        return new PageReference(domainName+'/apex/PRO_OAuthConnection?media=twitter&success='+isOauthSucess).setRedirect(true);  
    }
    
    
    /*
    *   Description : Map header parametes 
    *   @ return Map<String, String> header parameters with its value
    */
    public static Map<String, String> mapHeaders(User currentUser){
    	String domainName = '';
		if (PRO_OAuthController.domainSettings != null){
        	if (!String.isBlank(PRO_OAuthController.domainSettings.Domain_Name__c)) domainName = '/'+PRO_OAuthController.domainSettings.Domain_Name__c;
        }
        String nonce = String.valueOf(Crypto.getRandomLong());
        String timeStamp = String.valueOf(DateTime.now().getTime()/1000);
       	String callbackUrl = String.isBlank(currentUser.Twitter_Access_token__c) ? EncodingUtil.urlEncode('https://'+ApexPages.currentPage().getHeaders().get('Host')+domainName+Page.PRO_TwitterOAuthConnection.getUrl(),'UTF-8') : '';
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('oauth_consumer_key',PRO_OAuthController.twitterSettings.Consumer_key__c);
        parameters.put('oauth_signature_method','HMAC-SHA1');
        parameters.put('oauth_timestamp',timestamp);
        parameters.put('oauth_nonce',nonce);
        parameters.put('oauth_callback',callbackUrl);
        System.debug('Map is '+parameters);
        return parameters;
    }
    
    
    
    /*
    *   Description : Create a authorization header values
    *   @ return String auth header values 
    */
    public static String setAuthHeader(String encodedString, Map<String, String> parameters, User currentUser){
        String header = 'OAuth ';
        String token = '';
        
        // Check user has twitter oauth secret
        if (!String.isBlank(currentUser.Twitter_Oauth_Secret__c)) token = currentUser.Twitter_Oauth_Secret__c;
        else if (parameters.containsKey('oauth_token')) token = PRO_OAuthController.twitterSettings.Consumer_Secret__c;
        	
        Blob sign = Crypto.generateMac('HmacSHA1', Blob.valueOf(encodedString), Blob.valueOf(PRO_OAuthController.twitterSettings.Consumer_Secret__c+'&'+token));
        String signature = EncodingUtil.urlEncode(EncodingUtil.base64encode(sign), 'UTF-8');

        for (String key : parameters.keySet()) {
            header = header + key + '="'+parameters.get(key)+'", ';
        }
        header = header + 'oauth_signature="'+signature+'"';
        return header;
    }
    
   /*
    *   Description : Create a base string
    *   @ return String encoded auth headers for request
    */
    public static String createBaseString(Map<String,String> oauthParams, String host, String method) {
        Map<String,String> p = oauthParams.clone();
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();
        String s = keys.get(0)+'='+p.get(keys.get(0));
        for(Integer i=1;i<keys.size();i++) {
            s = s + '&' + keys.get(i)+'='+p.get(keys.get(i));
        }
        return  method.toUpperCase()+ '&' +
                EncodingUtil.urlEncode(host, 'UTF-8') + '&' +
                EncodingUtil.urlEncode(s, 'UTF-8');
    } 
}