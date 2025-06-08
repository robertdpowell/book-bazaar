package com.bookbazaar.order;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.test.context.EmbeddedKafka;
import org.testcontainers.containers.KafkaContainer;
import org.testcontainers.utility.DockerImageName;

import java.util.concurrent.*;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest

public class KafkaOrderPublisherIntegrationTest  {

    static KafkaContainer kafka = new KafkaContainer(DockerImageName.parse("confluentinc/cp-kafka:7.3.3"));

    @BeforeAll
    static void startKafka() {
        kafka.start();
        System.setProperty("spring.kafka.bootstrap-servers", kafka.getBootstrapServers());
    }

    @AfterAll
    static void stopKafka() {
        kafka.stop();
    }

    @Autowired
    private KafkaTemplate<String, OrderPlacedEvent> kafkaTemplate;

    private static final BlockingQueue<OrderPlacedEvent> queue = new LinkedBlockingQueue<>();

    @KafkaListener(topics = "order.placed", groupId = "test")
    public void consume(OrderPlacedEvent event) {
        queue.offer(event);
    }

    @Test
    void shouldPublishAndConsumeOrderPlacedEvent() throws InterruptedException {
        OrderPlacedEvent event = new OrderPlacedEvent("test-order", 1L, 2);
        kafkaTemplate.send("order.placed", event);

        OrderPlacedEvent received = queue.poll(10, TimeUnit.SECONDS);
        assertEquals("test-order", received.getOrderId());
        assertEquals(1L, received.getBookId());
        assertEquals(2, received.getQuantity());
    }
}