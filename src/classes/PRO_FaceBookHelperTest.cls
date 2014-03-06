@isTest
public with sharing class PRO_FaceBookHelperTest {
	
	/*
	*	Placeholder class for code coverage
	*/
	static testMethod void test_PRO_FacebookHelper(){
		PRO_FacebookHelper helper = new PRO_FacebookHelper();
		PRO_FacebookHelper.Facebook facebook = new PRO_FacebookHelper.Facebook();
		facebook.id = '';
		PRO_FacebookHelper.Feed feedData = new PRO_FacebookHelper.Feed();
		feedData.data = new List<PRO_FacebookHelper.FacebookData>();
		PRO_FacebookHelper.Paging paging = new PRO_FacebookHelper.Paging();
		PRO_FacebookHelper.FacebookData fdData = new PRO_FacebookHelper.FacebookData();
		fdData.message = '';
		fdData.application = new PRO_FacebookHelper.Application();
		fdData.updated_time = '';
		fdData.id = '';
		fdData.created_time = '';
		fdData.picture = '';
		PRO_FacebookHelper.Application app = new PRO_FacebookHelper.Application();
		app.name = '';
		app.namespace = '';
		app.id = '';
		PRO_FacebookHelper.Paging page = new PRO_FacebookHelper.Paging();
		page.previous= '';
		page.next ='';
		PRO_FacebookHelper.FacebookError fberror = new PRO_FacebookHelper.FacebookError();
		fberror.error = new PRO_FacebookHelper.Error();
		PRO_FacebookHelper.Error error = new PRO_FacebookHelper.Error();
		error.type = '';
		error.message = '';
		error.code = '';
		error.error_subcode = '';
	}
}