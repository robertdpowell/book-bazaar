package com.bookbazaar.order;

public class OrderPlacedEvent {
    private String orderId;
    private Long bookId;
    private int quantity;

    // Needed for JSON deserialization
    public OrderPlacedEvent() {}

    public OrderPlacedEvent(String orderId, Long bookId, int quantity) {
        this.orderId = orderId;
        this.bookId = bookId;
        this.quantity = quantity;
    }

    // Getters
    public String getOrderId() {
        return orderId;
    }

    public Long getBookId() {
        return bookId;
    }

    public int getQuantity() {
        return quantity;
    }

    // Setters
    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}