package com.streamcheck.eventmanagementsystem.service;

import com.streamcheck.eventmanagementsystem.model.Event;
import com.streamcheck.eventmanagementsystem.model.EventRegistration;
import com.streamcheck.eventmanagementsystem.model.User;
import com.streamcheck.eventmanagementsystem.repository.EventRegistrationRepository;
import com.streamcheck.eventmanagementsystem.repository.EventRepository;
import com.streamcheck.eventmanagementsystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class EventRegistrationService {

    @Autowired
    private EventRegistrationRepository registrationRepository;
    @Autowired
    public UserRepository userRepository;
    @Autowired
    private EventRepository eventRepository;

    @Transactional
    public Optional<EventRegistration> registerForEvent(Long eventId, Long userId) {
        Optional<Event> eventOptional = eventRepository.findById(eventId);
        Optional<User> userOptional = userRepository.findById(userId);

        if (eventOptional.isPresent() && userOptional.isPresent()) {
            Event event = eventOptional.get();
            User user = userOptional.get();


            if (registrationRepository.findByUserAndEvent(user, event).isPresent()) {
                throw new IllegalArgumentException("User is already registered for this event.");
            }


             long currentRegistrations = registrationRepository.findByEvent(event).size();
             if (event.getMaxParticipants() != null && currentRegistrations >= event.getMaxParticipants()) {
                throw new IllegalStateException("Event registration limit reached.");
             }

            EventRegistration registration = new EventRegistration(user, event, LocalDateTime.now());
            return Optional.of(registrationRepository.save(registration));
        }
        return Optional.empty();
    }

    public List<EventRegistration> getUserRegistrations(Long userId) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isPresent()) {
            return registrationRepository.findByUser(userOptional.get());
        }
        return List.of();
    }
}