package com.example.resource;

import com.example.db.MessageService;
import com.example.domain.ApiResponse;
import com.example.security.Authenticated;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.ws.rs.*;
import javax.ws.rs.core.Response;
import java.util.List;

@Service
@Path("v1")
public class MessageResource {

    private static final Logger LOG = LoggerFactory.getLogger(MessageResource.class);
    private final MessageService messageService;

    @Autowired
    public MessageResource(final MessageService messageService) {this.messageService = messageService;}

    @GET
    @Path("getMessages")
    @Produces("application/json")
    public ApiResponse<List<String>> messages() {
        return new ApiResponse<>("", 200, messageService.getMessages());
    }

    @POST
    @Authenticated
    @Path("putMessage")
    @Produces("application/json")
    @Consumes("text/plain")
    public Response putMessage(String message) {
        if (message.isEmpty()) {
            return Response
                    .status(400)
                    .entity(new ApiResponse<>("Provide a message.", 400, ""))
                    .build();
        }

        LOG.info("Persisting message: " + message);
        messageService.insertMessage(message);
        return Response.ok(new ApiResponse<>("Message accepted.", 200, "")).build();
    }
}
