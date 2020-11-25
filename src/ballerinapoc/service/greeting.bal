import ballerina/http;
import ballerina/mime;
import ballerina/log;
import ballerina/docker;
    @http:ServiceConfig {
        basePath: "/mainBase"
    }
@docker:Config {}
service mainService on new http:Listener(3000) {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/sayHello"
    }
    resource function sayHelloMainService(http:Caller caller, http:Request req) {
        if (mime:APPLICATION_JSON == req.getContentType()) {
                var jsonValue = req.getJsonPayload();
                if(jsonValue is json){
                    json|error message = jsonValue.message;
                    if (message is json){
                        xml response = xml`<response>${message.toString()}</response>`;
                        var result = caller->respond(<@untainted>response);
                    }
                }else{
                    var result = caller->respond("That ain't json");
                }
            }
            var result = caller->respond("That ain't json");

        if (result is error) {
            log:printError("Error sending response", result);
        }
    }
}