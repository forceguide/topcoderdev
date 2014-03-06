public with sharing class PRO_HttpCalloutHelper {
	
	
 	/*
 	*	description : send the http request and fetch the response and save it to the user record
 	*	return String 	response
 	*/
	public static String sendHttpRequest(String endpointUrl, String method, String header, String socialMedia){
		HttpRequest httpRequest = new HttpRequest();

		// request options
		httpRequest.setEndpoint(endpointUrl);
    	httpRequest.setMethod(method);
    	
    	// Set header
    	if (!String.isBlank(header)){
    		httpRequest.setHeader('Authorization',header);
    	}

    	// Http response 
    	HttpResponse response = new Http().send(httpRequest);
		
		if (response.getStatusCode() != 200 && socialMedia =='facebook' && !Test.isRunningTest()) {
			Boolean isSucess = PRO_FacebookOAuthController.fetchRefreshToken(response.getBody()); 
			String reqUrl = PRO_UrlUtil.FACEBOOK_GRAPH_URL+'access_token='+PRO_FacebookOAuthController.loggedInUser.Facebook_Access_token__c+'&'+PRO_UrlUtil.FACEBOOK_GRAPH_QUERY;
			sendHttpRequest(reqUrl,'GET','','facebook'); 
		}
    	// returns the response
    	return response.getBody(); 
	}

}