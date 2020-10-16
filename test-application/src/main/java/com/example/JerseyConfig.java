package com.example;

import com.example.resource.MessageResource;
import com.example.security.AuthFilter;
import org.glassfish.jersey.server.ResourceConfig;
import org.springframework.context.annotation.Configuration;

@Configuration
public class JerseyConfig extends ResourceConfig {
    public JerseyConfig() {
        register(MessageResource.class);
        register(AuthFilter.class);
    }
}
