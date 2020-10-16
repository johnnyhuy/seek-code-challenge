package com.example.domain;

import java.util.Objects;

public class ApiResponse<E> {
    private String message;
    private int status;
    private E body;

    public ApiResponse(String message, int status, E body) {
        this.message = message;
        this.status = status;
        this.body = body;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Object getBody() {
        return body;
    }

    public void setBody(E body) {
        this.body = body;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ApiResponse<?> that = (ApiResponse<?>) o;
        return status == that.status &&
                Objects.equals(message, that.message) &&
                Objects.equals(body, that.body);
    }

    @Override
    public int hashCode() {
        return Objects.hash(message, status, body);
    }
}
