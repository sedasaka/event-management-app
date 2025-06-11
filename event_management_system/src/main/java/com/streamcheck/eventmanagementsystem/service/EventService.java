package com.streamcheck.eventmanagementsystem.service;

import com.streamcheck.eventmanagementsystem.model.Event;
import com.streamcheck.eventmanagementsystem.repository.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class EventService {

    @Autowired
    private EventRepository eventRepository;

    public List<Event> getAllEvents() {
        return eventRepository.findAll();
    }

    public Optional<Event> getEventById(Long id) {
        return eventRepository.findById(id);
    }

    @Transactional
    public Event createEvent(Event event) {

        return eventRepository.save(event);
    }

    @Transactional
    public boolean deleteEvent(Long id) {
        if (eventRepository.existsById(id)) {
            eventRepository.deleteById(id);
            return true;
        }
        return false;
    }

    @Transactional
    public Optional<Event> updateEvent(Long id, Event updatedEvent) {
        return eventRepository.findById(id).map(event -> {
            event.setTitle(updatedEvent.getTitle());
            event.setDescription(updatedEvent.getDescription());
            event.setDate(updatedEvent.getDate());
            event.setTime(updatedEvent.getTime());
            event.setLocation(updatedEvent.getLocation());
            event.setMaxParticipants(updatedEvent.getMaxParticipants());
            return eventRepository.save(event);
        });
    }
}