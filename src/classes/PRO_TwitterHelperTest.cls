@isTest
public with sharing class PRO_TwitterHelperTest {
	
	/*
	*	PlaceHolder class for code coverage
	*/
	static testMethod void test_PRO_TwitterHelper(){
		PRO_TwitterHelper helper = new PRO_TwitterHelper();
		PRO_TwitterHelper.Twitter twitter = new PRO_TwitterHelper.Twitter();
		twitter.created_at = '';
		twitter.id = '';
		twitter.id_str = '';
		twitter.text = '';
		twitter.source = '';
		twitter.truncated = '';
		twitter.in_reply_to_status_id = '';
		twitter.in_reply_to_status_id_str = '';
		twitter.in_reply_to_user_id = '';
		twitter.in_reply_to_user_id_str = '';
		twitter.in_reply_to_screen_name = '';
		twitter.user = new  PRO_TwitterHelper.TwitterUser();
		twitter.geo = '';
		twitter.coordinates = '';
		twitter.place = '';
		twitter.contributors = '';
		twitter.retweet_count = '';
		twitter.favorite_count = '';
		twitter.entities = new PRO_TwitterHelper.MainEntity();
		twitter.favorited = '';
		twitter.retweeted = '';
		twitter.lang = '';
		twitter.possibly_sensitive = '';
		
		// User record
		PRO_TwitterHelper.TwitterUser user = new PRO_TwitterHelper.TwitterUser();
		user.id='';
		user.id_str='';
		user.name='';
		user.screen_name='';
		user.location='';
		user.description='';
		user.followers_count='';
		user.friends_count='';
		user.listed_count='';
		user.url='';
		user.created_at='';
		user.favourites_count='';
		user.utc_offset='';
		user.protected_x='';
		user.time_zone='';
		user.geo_enabled='';
		user.verified='';
		user.statuses_count='';
		user.lang='';
		user.contributors_enabled='';
		user.is_translator='';
		user.is_translation_enabled='';
		user.profile_background_color='';
		user.profile_background_image_url='';
		user.profile_background_image_url_https='';
		user.profile_background_tile='';
		user.profile_image_url='';
		user.profile_image_url_https='';
		user.profile_banner_url='';
		user.profile_link_color='';
		user.profile_sidebar_border_color='';
		user.profile_sidebar_fill_color='';
		user.profile_text_color='';
		user.profile_use_background_image='';
		user.default_profile='';
		user.default_profile_image='';
		user.following='';
		user.follow_request_sent='';
		user.notifications='';
		user.entities= new PRO_TwitterHelper.UserEntity();
		
		
		// Main Entity
		PRO_TwitterHelper.MainEntity mainEntity = new PRO_TwitterHelper.MainEntity();
		mainEntity.hashtags = new List<String>();
		mainEntity.symbols = new List<String>();
		mainEntity.urls = new List<PRO_TwitterHelper.TwitterURL>();
		mainEntity.user_mentions = new List<String>();
		mainEntity.media = new List<PRO_TwitterHelper.TwitterMedia>();
		
		// Twitter Media class 
		PRO_TwitterHelper.TwitterMedia media = new PRO_TwitterHelper.TwitterMedia();
		media.id='';
		media.id_str='';
		media.indices=  new List<String>();
		media.media_url='';
		media.media_url_https='';
		media.url='';
		media.display_url='';
		media.expanded_url='';
		media.type='';
		media.sizes= new PRO_TwitterHelper.Sizes();
		
		// Media atts class
		PRO_TwitterHelper.Sizes size = new PRO_TwitterHelper.Sizes();
		size.large = new PRO_TwitterHelper.mediaAtts();
		size.medium = new PRO_TwitterHelper.mediaAtts();
		size.thumb = new PRO_TwitterHelper.mediaAtts();
		size.small = new PRO_TwitterHelper.mediaAtts();
		
		// Media atts class 
		PRO_TwitterHelper.mediaAtts atts = new PRO_TwitterHelper.mediaAtts();
		atts.w ='';
		atts.h ='';
		atts.resize ='';
		
		// Twitter Url
		PRO_TwitterHelper.TwitterURL turl = new PRO_TwitterHelper.TwitterURL();
		turl.url = '';
		turl.expanded_url = '';
		turl.display_url = '';
		turl.indices = new List<String>();
		
		// UserEntity
		PRO_TwitterHelper.UserEntity entity = new PRO_TwitterHelper.UserEntity();
		entity.description = new PRO_TwitterHelper.Description();
		
		// Description
		PRO_TwitterHelper.Description des = new PRO_TwitterHelper.Description();
		des.urls = new List<Object>();
	}
}