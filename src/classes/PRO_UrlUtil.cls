public with sharing class PRO_UrlUtil {
	
	// Face book URls
	public static final String FACEBOOK_OAUTH_URL = 'https://graph.facebook.com/oauth/access_token?';
	public static final String FACEBOOK_GRAPH_URL = 'https://graph.facebook.com/me?';
	public static final String FACEBOOK_GRAPH_QUERY = 'fields=feed.fields(message,application,picture,updated_time)';
	public static final String FACEBOOK_REFRESH_TOKEN = 'https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token';
	
	
	// Twitter Urls
	public static final String TWITTER_OAUTH_URL = 'https://api.twitter.com/oauth/authorize';
	public static final String TWITTER_REQUEST_TOKEN_URL = 'https://api.twitter.com/oauth/request_token';
	public static final String TWITTER_ACCESS_TOKEN_URL = 'https://api.twitter.com/oauth/access_token';
	public static final String TWITTER_STATUS_URL = 'https://api.twitter.com/1.1/statuses/user_timeline.json';
}