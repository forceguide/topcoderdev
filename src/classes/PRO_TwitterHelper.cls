public with sharing class PRO_TwitterHelper {
	
	/*
	*	Twitter response data structure
	*/
	public class Twitter{
		public String 		created_at					{get; set;}
		public String 		id							{get; set;}
		public String 		id_str						{get; set;}
		public String 		text						{get; set;}
		public String	 	source						{get; set;}
		public String 		truncated					{get; set;}
		public String 		in_reply_to_status_id		{get; set;}
		public String 		in_reply_to_status_id_str	{get; set;}
		public String 		in_reply_to_user_id			{get; set;}
		public String 		in_reply_to_user_id_str		{get; set;}
		public String 		in_reply_to_screen_name		{get; set;}
		public TwitterUser	user						{get; set;}
		public String 		geo							{get; set;} 
		public String 		coordinates					{get; set;} 
		public String 		place						{get; set;} 
		public String 		contributors				{get; set;} 
		public String 		retweet_count				{get; set;} 
		public String 		favorite_count				{get; set;} 
		public MainEntity 	entities					{get; set;}
		public String 		favorited					{get; set;} 
		public String 		retweeted					{get; set;} 
		public String 		lang						{get; set;} 
		public String 		possibly_sensitive			{get; set;}
	}
	
	/*
	*	Twitter user
	*/
	public class TwitterUser{
		public String 		id										{get; set;}
		public String 		id_str									{get; set;}
		public String 		name									{get; set;}
		public String 		screen_name								{get; set;}
		public String 		location								{get; set;}
		public String 		description								{get; set;}
		public String 		followers_count							{get; set;}
		public String 		friends_count							{get; set;}
		public String 		listed_count							{get; set;}
		public String 		url										{get; set;}
		public String 		created_at								{get; set;}
		public String 		favourites_count						{get; set;}
		public String 		utc_offset								{get; set;}
		public String 		protected_x								{get; set;}
		public String 		time_zone								{get; set;}
		public String 		geo_enabled								{get; set;}
		public String 		verified								{get; set;}
		public String 		statuses_count							{get; set;}
		public String 		lang									{get; set;}
		public String 		contributors_enabled					{get; set;}
		public String 		is_translator							{get; set;}
		public String 		is_translation_enabled					{get; set;}
		public String 		profile_background_color				{get; set;}
		public String 		profile_background_image_url			{get; set;}
		public String 		profile_background_image_url_https		{get; set;}
		public String 		profile_background_tile					{get; set;}
		public String 		profile_image_url						{get; set;}
		public String 		profile_image_url_https					{get; set;}
		public String 		profile_banner_url						{get; set;}
		public String 		profile_link_color						{get; set;}
		public String 		profile_sidebar_border_color			{get; set;}
		public String 		profile_sidebar_fill_color				{get; set;}
		public String 		profile_text_color						{get; set;}
		public String 		profile_use_background_image			{get; set;}
		public String 		default_profile							{get; set;}
		public String 		default_profile_image					{get; set;}
		public String 		following								{get; set;}
		public String 		follow_request_sent						{get; set;}
		public String 		notifications							{get; set;}
		public UserEntity	entities								{get; set;}
	}
	
	
	// Main Entity Class 
	public class MainEntity{
		public List<String> 		hashtags					{get; set;}
		public List<String>  		symbols						{get; set;}
		public List<TwitterURL> 	urls						{get; set;}
		public List<String>			user_mentions				{get; set;}
		public List<TwitterMedia>	media						{get; set;}
	}
	
	// Media Class
	public class TwitterMedia {
		public String 				id 							{get; set;} 
		public String 				id_str 						{get; set;} 
		public List<String> 		indices						{get; set;}
		public String 				media_url 					{get; set;} 
		public String 				media_url_https 			{get; set;} 
		public String 				url 						{get; set;} 
		public String 				display_url 				{get; set;} 
		public String 				expanded_url 				{get; set;} 
		public String 				type 						{get; set;} 
		public Sizes  				sizes						{get; set;}	
	}
	
	// Size Class
	public class Sizes{
		public mediaAtts large			{get; set;}
		public mediaAtts medium			{get; set;}
		public mediaAtts thumb			{get; set;}
		public mediaAtts small			{get; set;}
	}
	
	// Media Class
	public class mediaAtts{
		public String 	 w				{get; set;}
		public String 	 h				{get; set;}
		public String 	 resize			{get; set;}
	}
	
	// Twitter url Class 
	public class TwitterURL{
		public String 				url							{get; set;}
		public String 				expanded_url				{get; set;}
		public String 				display_url					{get; set;}
		public List<String> 		indices						{get; set;}
	}
	
	// User Entity Class
	public class UserEntity{
		public Description	description			{get; set;}
	}
	
	// Desription Class
	public class Description{
		public List<Object> 	urls							{get; set;}
	}
}