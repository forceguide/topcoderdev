public with sharing class PRO_OAuthController {
    
    private static final String DATE_TIME_FORMAT = 'dd MMMM yyyy HH:mm:ss';
    
    // Face book variables
    public String                           fbErrorMessage          {get; set;}         
    public static PRO_Facebook_Settings__c  facebookSettings        {get {
                                                                        if (facebookSettings != null) return facebookSettings;
                                                                        facebookSettings = PRO_Facebook_Settings__c.getOrgDefaults();
                                                                        return facebookSettings;
                                                                     }set;}
                                                                     

    public Boolean                          fbConnected             {get; set;}
    public String                           fbLastFetched           {get; set;}    
    
    public Boolean                          hasFaceBookSettings     {get; set;}

    public static String                    SALESFORCE_BASEURL      {get {
                                                                        if (SALESFORCE_BASEURL != null) return SALESFORCE_BASEURL;
                                                                        SALESFORCE_BASEURL = URL.getSalesforceBaseUrl().toExternalForm();
                                                                        return SALESFORCE_BASEURL;
                                                                    } set;}
   
    // Twitter Variables 
    public String                           tErrorMessage           {get; set;} 
    public String                           twitterOauthCode        {get; set;}         
    public static PRO_Twitter_Settings__c   twitterSettings         {get {
                                                                        if (twitterSettings != null) return twitterSettings;
                                                                        twitterSettings = PRO_Twitter_Settings__c.getOrgDefaults();
                                                                        return twitterSettings;
                                                                     }set;}
    
    public static PRO_Domain_Settings__c   domainSettings         {get {
                                                                        if (domainSettings != null) return domainSettings;
                                                                        domainSettings = PRO_Domain_Settings__c.getOrgDefaults();
                                                                        return domainSettings;
                                                                     }set;}
    
    public Boolean                          hasTwitterSettings      {get; set;}
    public Boolean                          twitterConnected        {get; set;}
    public String                           twitterLastFetched      {get; set;}    
    
                                                                                
    
    public static User                      loggedInUser            {get {
                                                                        if (loggedInUser != null) return loggedInUser;
                                                                        loggedInUser = [SELECT Id, Twitter_Access_token__c, Twitter_Oauth_Secret__c, Twitter_Last_Fetched_Date_time__c, 
                                                                                            Facebook_Last_Fetched_Date_time__c, Facebook_Access_token__c 
                                                                                                FROM User WHERE Id=: UserInfo.getUserId() LIMIT 1];
                                                                        return loggedInUser;
                                                                     } set;} 
    
                                                                    
                                                                    
    
    /*
    *   Constructor
    */
    public PRO_OAuthController() { 
        hasFaceBookSettings = true;
        hasTwitterSettings = true;
        
        // Error message variables 
        fbErrorMessage = '';
        tErrorMessage = '';
        
        // Oauth facebook message
        String media = ApexPages.currentPage().getParameters().get('media');
        if (!String.isBlank(media)){
            if (ApexPages.CurrentPage().getParameters().get('success') == 'true') ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,(media == 'facebook' ? 'Facebook ' : 'Twitter ')+' : OAuth has been done successfully.'));
            else ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,(media == 'facebook' ? 'Facebook ' : 'Twitter ')+': OAuth failed.'));
        }
            
        
  
        
        // Check current user settings
        fbConnected = (!String.isBlank(loggedInUser.Facebook_Access_token__c) ? true : false); 
        fbLastFetched = (loggedInUser.Facebook_Last_Fetched_Date_time__c != null ? loggedInUser.Facebook_Last_Fetched_Date_time__c.formatGmt(DATE_TIME_FORMAT) : null);

        twitterConnected = (!String.isBlank(loggedInUser.Twitter_Access_token__c) ? true : false); 
        twitterLastFetched = (loggedInUser.Twitter_Last_Fetched_Date_time__c != null ? loggedInUser.Twitter_Last_Fetched_Date_time__c.formatGmt(DATE_TIME_FORMAT) : null);
        
        // Check facebook settings
        checkfaceOAuthSettings();
        
        // Check twitter settings
        checkTwitterOAuthSettings();
        
        // Get twitter oauth code
       if (hasTwitterSettings) twitterOauthCode = getOAuthCode();
    }

    /*
    *   description : Checks whether the user entered facebook app credentials in the custom settings
    *   return null
    */
    public PageReference checkfaceOAuthSettings(){
        
        // Check facebook settings
        if (facebookSettings != null){ 
            fbErrorMessage = 'Facebook : ';
            // Check client Id
            if (String.isBlank(facebookSettings.Client_Id__c)){
                fbErrorMessage += ' Client Id';
                hasFaceBookSettings = false;
            }

            // Check client secret
            if (String.isBlank(facebookSettings.Client_Secret__c)){
                fbErrorMessage += (fbErrorMessage.contains('Client Id') ? ' and ' : '')+'Client Secret';
                hasFaceBookSettings = false;
            }

            // Check Scope 
            if (String.isBlank(facebookSettings.Scope__c)){
                fbErrorMessage += ((fbErrorMessage.contains('Client Id') || fbErrorMessage.contains('Client Secret')) ? ' and ' : '')+' Scope';
                hasFaceBookSettings = false;
            }
            
            // Error message
            if (!hasFaceBookSettings) fbErrorMessage += ' is/are required.';
        }
        return null;
    }
    
     /*
    *   description : Checks whether the user entered twitter app credentials in the custom settings
    *   return null
    */
    public PageReference checkTwitterOAuthSettings(){
        // Check twitter settings
        if (twitterSettings != null){ 
            tErrorMessage = 'Facebook : ';
           
            // Check Consumer Key
            if (String.isBlank(twitterSettings.Consumer_key__c)){
                tErrorMessage += ' Consumer Key';
                hasTwitterSettings = false;
            }

            // Check Consumer Secret
            if (String.isBlank(twitterSettings.Consumer_Secret__c)){
                tErrorMessage += (tErrorMessage.contains('Consumer Key') ? ' and ' : '')+'Consumer Secret';
                hasTwitterSettings = false;
            }

            // Error message
            if (!hasTwitterSettings) tErrorMessage += ' is/are required.';
        }
        return null;
    }

    /*
    *   description : Revoke the facebook access 
    *   return PageReference null
    */
    public PageReference revokeFacebookAccess(){
        loggedInUser.Facebook_Access_token__c = '';
        loggedInUser.Facebook_Last_Fetched_Date_time__c = null; 
        update loggedInUser;
        
        
        // Set the fbConnected to false
        fbConnected = false;
        return null;
    }
    
    /*
    *   description : Revoke the twitter access 
    *   return PageReference null
    */
    public PageReference revokeTwitterAccess(){
        loggedInUser.Twitter_Access_token__c = '';
        loggedInUser.Twitter_Oauth_Secret__c = null;
        loggedInUser.Twitter_Last_Fetched_Date_time__c = null;
        loggedInUser.Twitter_UserId__c = null;
        loggedInUser.Twitter_User_Name__c = null;
        update loggedInUser;
        
        
        // Set the twitterConnected to false
        twitterConnected = false;
        return null;
    }
    
    /*
    *   Description : Get the twitter oauth code
    *   @ return oauth code
    */
    @TestVisible
    private static String getOAuthCode(){
        String oauthCode = '';
        // put the twitter parameters in a map
        Map<String, String> parameters = PRO_TwitterOAuthController.mapHeaders(loggedInUser);
        
        // Create a base string
        String signstr = PRO_TwitterOAuthController.createBaseString(parameters,PRO_UrlUtil.TWITTER_REQUEST_TOKEN_URL,'GET'); 
         
         // Get 
        String header = PRO_TwitterOAuthController.setAuthHeader(signstr, parameters,loggedInUser);
        
        String response = PRO_HttpCalloutHelper.sendHttpRequest(PRO_UrlUtil.TWITTER_REQUEST_TOKEN_URL, 'GET', header, 'twitter');
        
        // Get the oauth code
        if (!String.isBlank(response)){
            List<String> responseList = response.split('&');
            
            // Responses list
            for (Integer i=0;i<responseList.size();i++){
                if (responseList[i].split('=')[0] == 'oauth_token'){
                    oauthCode = responseList[i].split('=')[1];
                }
            }
        }
        return oauthCode;
    } 
}