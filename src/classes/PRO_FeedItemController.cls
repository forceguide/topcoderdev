/*
*	This class sends a http request to facebook and twitter, gets the 
*	response back and creates a feed item
*/

public with sharing class PRO_FeedItemController {
	
	/*
	*	Description : Sends a Http request to facebook and fetches all  the post between the given time frame
	*	return void
	*/
	public static List<String> fetchFaceBookPosts(User currentUser){
		List<String> faceBookPostsList = new List<String>();
		
		
		// Facebook settings 
		PRO_Facebook_Settings__c  facebookSettings = PRO_OAuthController.facebookSettings;
		
		// Call http callout method and get the reponse
		try{
			String reqUrl = PRO_UrlUtil.FACEBOOK_GRAPH_URL+'access_token='+currentUser.Facebook_Access_token__c+'&'+PRO_UrlUtil.FACEBOOK_GRAPH_QUERY;
			String response = PRO_HttpCalloutHelper.sendHttpRequest(reqUrl,'GET','','facebook'); // Get the json response 
			
			// Parse the response 
			PRO_FacebookHelper.Facebook feedData = (PRO_FacebookHelper.Facebook)JSON.deserializeStrict(response,PRO_FacebookHelper.Facebook.class);
			
			// Get the facebook posts
			if (feedData != null){ 
				Integer i=0;
				for (PRO_FacebookHelper.FacebookData fbData : feedData.feed.data){
					if (PRO_OAuthController.domainSettings != null){
						if (PRO_OAuthController.domainSettings.Number_of_posts__c != null && (i+1) > PRO_OAuthController.domainSettings.Number_of_posts__c) break;  
					}
					// Discard the posts from external applications
					if (fbData.application == null){
						if (DateTime.valueOfGMT((fbData.updated_time).replaceAll('T',' ').replace('+0000','')) > currentUser.Facebook_Last_Fetched_Date_time__c || (DateTime.valueOfGMT((fbData.updated_time).replaceAll('T',' ').replace('+0000','')) < System.now() 
								&& DateTime.valueOfGMT((fbData.updated_time).replaceAll('T',' ').replace('+0000','')) > System.now().addHours(-1))){
							faceBookPostsList.add(fbData.message != null ? fbData.message : fbData.picture);
						}
					}
					i++;
				}
			}
			// Insert feed item and feed comment if we have any
		}catch(Exception ex){
			System.debug('Message is '+ex.getMessage());
		}
		return faceBookPostsList;
	}
	
	/*
	*	Description : Sends a Http request to facebook and fetches all  the post between the given time frame
	*	return void
	*/
	public static List<String> fetchTwitterPosts(User currentUser){ 
		List<String> twitterPostsList = new List<String>();
		
		try{
			// put the twitter parameters in a map
		    Map<String, String> parameters = PRO_TwitterOAuthController.mapHeaders(currentUser);
		    parameters.put('oauth_token',currentUser.Twitter_Access_token__c);
		    
	        // Create a base string
	        String signstr = PRO_TwitterOAuthController.createBaseString(parameters,PRO_UrlUtil.TWITTER_STATUS_URL,'GET'); 
	         
	        // Get the header
	        String header = PRO_TwitterOAuthController.setAuthHeader(signstr, parameters,currentUser); 
	        
	        // Get the response
	        String response = PRO_HttpCalloutHelper.sendHttpRequest(PRO_UrlUtil.TWITTER_STATUS_URL, 'GET', header, 'twitter');
			
			// Check if response is not null
			if (!String.isBlank(response)){
				response = response.replace('protected','protected_x');
				// Parse the response 
				List<PRO_TwitterHelper.Twitter> twitterDataList = (List<PRO_TwitterHelper.Twitter>)JSON.deserializeStrict(response,List<PRO_TwitterHelper.Twitter>.class);
				
				// Check if twitter data is not null and Discard the posts from external applications
				if (!twitterDataList.isEmpty()){ 
					Integer i=0;
					for (PRO_TwitterHelper.Twitter twitter : twitterDataList){
						if (String.valueOf(twitter.source).trim() == 'web'){ 
							if (PRO_OAuthController.domainSettings != null){
								if (PRO_OAuthController.domainSettings.Number_of_posts__c != null && (i+1) > PRO_OAuthController.domainSettings.Number_of_posts__c) break;  
							}
							System.debug(twitter.created_at);
							if (dateTimeFromString(twitter.created_at) > currentUser.Twitter_Last_Fetched_Date_time__c || (dateTimeFromString(twitter.created_at) < System.now() &&
									dateTimeFromString(twitter.created_at) > System.now().addHours(-1))){ 
								// Check if there is any image 		
								if (twitter.entities.media != null){ 
									for (PRO_TwitterHelper.TwitterMedia media : twitter.entities.media){ 
										twitterPostsList.add(media.media_url); 
									}
								}else{
									twitterPostsList.add(twitter.text); 
								}
							}
						}
					}
				}
			}
		}catch(Exception ex){
			System.debug('Message is '+ex.getMessage());
		}
		return twitterPostsList; 
	}
	
	/*
	*	Description : Converts the string into datetime  
	*	return DateTime Converted DateTime
	*/
	private static DateTime dateTimeFromString(String dateTimeString){ 
		try{
			Map<String, Integer >	mapMonths = new Map<String, Integer>{ 'jan' => 1,
																		  'feb'	=> 2,
																		  'mar'	=> 3,
																		  'apr'	=> 4, 
																		  'may'	=> 5,
																		  'jun'	=> 6,
																		  'jul'	=> 7,
																		  'aug'	=> 8,
																		  'sep'	=> 9,
																		  'oct'	=> 10,
																		  'nov'	=> 11,
																		  'dec'	=> 12
																		};
			List<String> stringList = dateTimeString.replace('+0000','').split(' '); 
			return DateTime.newInstanceGMT(Integer.valueOf(stringList[5]),
										   mapMonths.get(stringList[1].toLowerCase()),
										   Integer.valueOf(stringList[2]),
										   Integer.valueOf(stringList[3].split(':')[0]),
										   Integer.valueOf(stringList[3].split(':')[1]),
										  Integer.valueOf(stringList[3].split(':')[2])
										);
		}catch(Exception ex){
			System.debug('Message is '+ex.getMessage());
		}
		return System.now();
	}
}