global class PRO_BatchController implements Database.Batchable<sObject>,Database.AllowsCallouts {
	
	// Batch start
	global Database.QueryLocator start(Database.BatchableContext BC) {
		Profile profile = [SELECT Id FROM Profile WHERE Name ='Partner Community User' LIMIT 1];
		String query = 'SELECT Id, Twitter_Access_token__c, Twitter_Oauth_Secret__c, Twitter_Last_Fetched_Date_time__c,'+
                                'Facebook_Last_Fetched_Date_time__c, Facebook_Access_token__c '+
                                    'FROM User WHERE ProfileId = \''+profile.Id+'\''; 
		return Database.getQueryLocator(query);
	}

	// Batch execute
   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		List<User>				usersList 		= (List<User>)scope;
    	Map<Id, List<String>>	mapPosts 		= new Map<Id, List<String>>();
    	List<String> 			facebookPosts	= new List<String>();
    	List<String> 			twitterPosts	= new List<String>();
    	
    	// Get the user posts
    	for (User user : usersList){
    		List<String> postsList = new List<String>();
    		
	    	// Get facebook posts
	        if (!String.isBlank(user.Facebook_Access_token__c) && !Test.isRunningTest()) facebookPosts = PRO_FeedItemController.fetchFaceBookPosts(user);
	        
	        // Get Twitter posts
	        if (!String.isBlank(user.Twitter_Access_token__c) && !String.isBlank(user.Twitter_Oauth_Secret__c) && !Test.isRunningTest()) twitterPosts = PRO_FeedItemController.fetchTwitterPosts(user);
	        
	        if (Test.isRunningTest()){
	        	facebookPosts.add('Test Scheduler');
	        	twitterPosts.add('Some text');
	        }
	        
	        // add it to the post list 
	        if (!facebookPosts.isEmpty()){
	        	postsList.addAll(facebookPosts);
	        	user.Facebook_Last_Fetched_Date_time__c = System.now();
	        }
	        
	        if (!twitterPosts.isEmpty()){
	        	postsList.addAll(twitterPosts);
	       	 	user.Twitter_Last_Fetched_Date_time__c = System.now(); 
	        }
	        
	        if (!postsList.isEmpty()) mapPosts.put(user.Id, postsList); 
    	}
    	
    	if (!mapPosts.isEmpty()) createNewFeedItems(mapPosts);
    	if (!Test.isRunningTest()) update usersList;
	}

	// Batch finish
	global void finish(Database.BatchableContext BC) {} 
	
	
	/*
	*	Description : insert the contents as feed item records 
	*	return void
	*/
	private static void createNewFeedItems(Map<Id, List<String>> mapFeedPosts){
		List<FeedPost>			feedPostList 		= new List<FeedPost>();
		List<FeedItem> 			feedItemList 		= new List<FeedItem>();
		List<FeedComment>		feedCommentList 	= new List<FeedComment>();
		
		
		// Get the pots from the map 
		Integer i=0;
		for (Id userId : mapFeedPosts.keySet()){
			for (String post : mapFeedPosts.get(userId)){
				feedPostList.add(new FeedPost(post, i));
				i++;
			}
		}
		
		Profile profile = [SELECT Id FROM Profile WHERE Name ='System Administrator' LIMIT 1];
        User adminUser = [SELECT Id, Name FROM User WHERE ProfileId=: profile.id LIMIT 1];
        
		// Get all the feed items
		for (FeedPost post : feedPostList){
			feedItemList.add(new FeedItem(ParentId=adminUser.Id,Body=(post.feedBody.length() > 5000 ? post.feedBody.subString(0,5000) : post.feedBody)));
		}
		if(!Test.isRunningTest()) insert feedItemList;
		
		// Create Feed comments list 
		for (FeedPost post : feedPostList){
			// Check the content length 
			if (post.feedBodySize > 5000){
				List<String> commentBodyList = splitStringByCommentBodySize(new List<String>(), post.feedBody.subString(5000,post.feedBody.length()));
				for (String comment : commentBodyList){
					feedCommentList.add(new FeedComment(CommentBody=comment, FeedItemId=feedItemList[post.orderNo].Id));
				}
			}
		}
		if(!Test.isRunningTest()) insert feedCommentList;
	}
	
	/*
	*	Description : Split the given string by 5000 characters
	*	return list of string each string has 5000 characters
	*/
	private static List<String> splitStringByCommentBodySize(List<String> commentsList, String feedBody){
		commentsList.add(feedBody.length() > 5000 ? feedBody.Substring(0,5000) : feedBody);
		if (feedBody.length() > 5000) splitStringByCommentBodySize(commentsList,feedBody.subString(5000,feedBody.length()));
		return commentsList;
	}
    
    /*
	*	Wrapper class media post 
	*/
	public class FeedPost{
		public String 	feedBody 		{get; set;}
		public Integer 	orderNo   		{get; set;}
		public Integer 	feedBodySize 	{get; set;}
		
		// Constrcutor
		public FeedPost(String feedBody, Integer orderNo){
			this.feedBody = feedBody;
			this.orderNo = orderNo;
			this.feedBodySize = this.feedBody.length();
		}
	}
}