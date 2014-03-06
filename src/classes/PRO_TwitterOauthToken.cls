@isTest
global class PRO_TwitterOauthToken implements HttpCalloutMock {
    
    // Implement this interface method
    global static HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/plain');
        res.setBody('oauth_token=dfgafdhgadf&oauth_token_secret=dsfsdf&user_id=12451&screen_name=test');
        return res;
    } 
}