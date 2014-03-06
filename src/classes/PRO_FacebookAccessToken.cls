@isTest
global class PRO_FacebookAccessToken implements HttpCalloutMock {
    
    // Implement this interface method
    global static HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/plain');
        res.setBody('access_token=dfgafdhgadf');
        return res;
    } 
}