package com.streamcheck.eventmanagementsystem.repository;

import com.streamcheck.eventmanagementsystem.model.Event;
import com.streamcheck.eventmanagementsystem.model.EventRegistration;
import com.streamcheck.eventmanagementsystem.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EventRegistrationRepository extends JpaRepository<EventRegistration, Long> {

    List<EventRegistration> findByUser(User user);

    List<EventRegistration> findByEvent(Event event);

    Optional<EventRegistration> findByUserAndEvent(User user, Event event);
}