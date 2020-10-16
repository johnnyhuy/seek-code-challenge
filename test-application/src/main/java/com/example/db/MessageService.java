package com.example.db;

import java.util.List;

import org.jdbi.v3.core.Jdbi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class MessageService {

    private final MessageDAO messageDAO;

    @Autowired
    public MessageService(final Jdbi jdbi) {
        this.messageDAO = jdbi.onDemand(MessageDAO.class);
    }

    public void insertMessage(final String message) {
        messageDAO.insertMessage(message);
    }

    public List<String> getMessages() {
        return messageDAO.getAllMessages();
    }
}
