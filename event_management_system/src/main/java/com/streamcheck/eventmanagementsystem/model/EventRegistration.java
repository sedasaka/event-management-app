package com.streamcheck.eventmanagementsystem.model;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "event_registrations")
public class EventRegistration {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "event_id", nullable = false)
    private Event event;

    @Column(nullable = false)
    private LocalDateTime registrationDate;


    public EventRegistration() {
    }

    public EventRegistration(User user, Event event, LocalDateTime registrationDate) {
        this.registrationDate = registrationDate;
        this.event = event;
        this.user = user;
    }

}
