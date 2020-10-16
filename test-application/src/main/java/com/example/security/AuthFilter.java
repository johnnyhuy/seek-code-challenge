package com.example.security;

import com.example.domain.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.container.ResourceInfo;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.Provider;
import java.io.IOException;

@Provider
@Component
@Authenticated
public class AuthFilter implements ContainerRequestFilter {
    @Context
    ResourceInfo resourceInfo;
    private final String validToken;

    @Autowired
    public AuthFilter(@Value("${auth.token}") String validToken) {
        this.validToken = validToken;
    }

    @Override
    public void filter(ContainerRequestContext requestContext) throws IOException {
        Authenticated classAnnotation = resourceInfo.getResourceClass().getAnnotation(Authenticated.class);
        Authenticated methodAnnotation = resourceInfo.getResourceMethod().getAnnotation(Authenticated.class);

        if (classAnnotation != null || methodAnnotation != null) { // auth the request
            String token = requestContext.getHeaderString("X-API-Token");
            if (!validToken.equals(token)) {
                requestContext.abortWith(
                        Response
                                .status(401)
                                .entity(new ApiResponse<>("Provide valid X-API-Token.", 401, ""))
                                .build()
                );
            }
        }
    }
}
