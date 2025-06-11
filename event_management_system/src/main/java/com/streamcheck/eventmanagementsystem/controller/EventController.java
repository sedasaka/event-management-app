package com.streamcheck.eventmanagementsystem.controller;

import com.streamcheck.eventmanagementsystem.model.Event;
import com.streamcheck.eventmanagementsystem.service.EventService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/events")
public class EventController {

    @Autowired
    private EventService eventService;

    // GET /api/events - Alle Events abrufen
    @GetMapping
    public ResponseEntity<List<Event>> getAllEvents() {
        List<Event> events = eventService.getAllEvents();
        return new ResponseEntity<>(events, HttpStatus.OK);
    }

    // GET /api/events/{id} - Event-Details anzeigen
    @GetMapping("/{id}")
    public ResponseEntity<Event> getEventById(@PathVariable Long id) {
        Optional<Event> event = eventService.getEventById(id);
        return event.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build()); // 404 Not Found
    }

    // POST /api/events - Neues Event erstellen
    @PostMapping
    public ResponseEntity<Event> createEvent(@Valid @RequestBody Event event) {
        // Hier könnte eine Validierung erfolgen, ob der organizerId existiert und die Rolle "ORGANIZER" hat
        Event createdEvent = eventService.createEvent(event);
        return new ResponseEntity<>(createdEvent, HttpStatus.CREATED);
    }

    // PUT /api/events/{id} - Event aktualisieren
    @PutMapping("/{id}")
    public ResponseEntity<Event> updateEvent(@PathVariable Long id, @Valid @RequestBody Event event) {
        Optional<Event> updated = eventService.updateEvent(id, event);
        return updated.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build()); // 404 Not Found
    }


    // DELETE /api/events/{id} - Event löschen
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEvent(@PathVariable Long id) {
        boolean deleted = eventService.deleteEvent(id);
        if (deleted) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT); // 204 No Content
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND); // 404 Not Found
        }
    }
}