/*
*	Received facebook object structure
*/

public with sharing class PRO_FacebookHelper {
	
	// Facebook Wrapper class 
	public class Facebook{
		public String 		id  			{get; set;}
		public Feed 		feed			{get; set;}	
	}
	
	// Feed object
	public class Feed{
		public List<FacebookData>	data 	{get; set;}
		public Paging 				paging	{get; set;}
	}
	
	// FacebookData object 
	public class FacebookData{
		public String 		message 		{get; set;}
		public Application  application		{get; set;}
		public String 		updated_time	{get; set;}
		public String 		id 				{get; set;}
		public String		created_time	{get; set;}
		public String 		picture			{get; set;}	
	}
	
	// Application object
	public class Application{
		public String name 				{get; set;}
		public String namespace 		{get; set;}
		public String id 				{get; set;}
	}
	
	// Paging object
	public class Paging{ 
		public String previous 			{get; set;}
		public String next 				{get; set;}
	}
	
	// Facebook error object 
	public class FacebookError {
		public Error 	error	{get; set;}
	}
	
	// Facebook error object 
	public class Error{
		public String type 				{get; set;}
		public String message 			{get; set;}
		public String code				{get; set;}
		public String error_subcode		{get; set;}
	}
}