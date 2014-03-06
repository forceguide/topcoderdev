@isTest
global class PRO_FacebookResponseMock implements HttpCalloutMock {
    
    // Implement this interface method
    global static HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id": "100007889885603", "feed": {"data": [{"message": "Test Scheduler", "updated_time": "'+System.now().addMinutes(-10)+'", "id": "100007889885603_1382228842050099", "created_time": "'+System.now().addMinutes(-15)+'"}, {"message": "Twitter test", "application": {"name": "Twitter", "namespace": "twitter", "id": "2231777543"}, "updated_time": "2014-03-04T20:34:04+0000", "id": "100007889885603_1382224625383854", "created_time": "2014-03-04T20:34:04+0000"}]}}');
        return res;
    } 
}