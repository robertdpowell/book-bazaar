package com.bookbazaar.order;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class OrderEventConsumer {

    @KafkaListener(topics = "order.placed", groupId = "order-service")
    public void consume(OrderPlacedEvent event) {
        System.out.println("📥 Kafka consumer received order: " + event.getOrderId()
                + ", bookId=" + event.getBookId() + ", quantity=" + event.getQuantity());
    }
}