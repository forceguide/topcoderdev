@isTest
public with sharing class PRO_UrlUtilTest {
	
	static testMethod void test_ProUrlUtil(){
		Test.startTest();
		System.assertEquals('https://graph.facebook.com/oauth/access_token?',PRO_UrlUtil.FACEBOOK_OAUTH_URL);
		System.assertEquals('https://graph.facebook.com/me?',PRO_UrlUtil.FACEBOOK_GRAPH_URL);
		System.assertEquals('fields=feed.fields(message,application,picture,updated_time)',PRO_UrlUtil.FACEBOOK_GRAPH_QUERY);
		System.assertEquals('https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token',PRO_UrlUtil.FACEBOOK_REFRESH_TOKEN);
		System.assertEquals('https://api.twitter.com/oauth/authorize',PRO_UrlUtil.TWITTER_OAUTH_URL);
		System.assertEquals('https://api.twitter.com/oauth/request_token',PRO_UrlUtil.TWITTER_REQUEST_TOKEN_URL);
		System.assertEquals('https://api.twitter.com/oauth/access_token',PRO_UrlUtil.TWITTER_ACCESS_TOKEN_URL);
		System.assertEquals('https://api.twitter.com/1.1/statuses/user_timeline.json',PRO_UrlUtil.TWITTER_STATUS_URL);
		Test.stopTest();
	}
}