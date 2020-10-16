package com.example.db;

import java.util.List;

import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;

public interface MessageDAO {

    @SqlUpdate("INSERT INTO test.messages (message) " +
            "VALUES (:message)")
    void insertMessage(String message);

    @SqlQuery("select * from test.messages")
    List<String> getAllMessages();
}
