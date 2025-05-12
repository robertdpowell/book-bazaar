package com.bookbazaar.order;

import com.bookbazaar.order.model.Order;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/orders")
public class OrderController {

    private final OrderEventPublisher orderEventPublisher;

    public OrderController(OrderEventPublisher orderEventPublisher) {
        this.orderEventPublisher = orderEventPublisher;
    }

    @PostMapping
    public String placeOrder(@RequestBody Order order) {
        String orderId = UUID.randomUUID().toString();

        // Convert the String bookId to Long
        Long bookIdLong = Long.parseLong(order.bookId());

        OrderPlacedEvent event = new OrderPlacedEvent(orderId, bookIdLong, order.quantity());

        orderEventPublisher.publish(event);

        return "✅ Order accepted and published as event.";
    }
}