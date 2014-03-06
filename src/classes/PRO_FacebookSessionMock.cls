@isTest
global class PRO_FacebookSessionMock implements HttpCalloutMock {
    
    // Implement this interface method
    global static HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/plain');
        res.setBody('{"error": {"message": "Session has expired","type": "OAuthException","code": 190,"error_subcode": 467}}');
        return res;
    } 
}