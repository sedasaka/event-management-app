package com.streamcheck.eventmanagementsystem.controller;

import com.streamcheck.eventmanagementsystem.model.EventRegistration;
import com.streamcheck.eventmanagementsystem.service.EventRegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api") // Basis-URL für Registrierungen ist anders, da sie Event-spezifisch sind
public class EventRegistrationController {

    @Autowired
    private EventRegistrationService registrationService;

    // POST /api/events/{eventId}/register - Für Event anmelden
    // In einer echten App würde der userId oft aus dem Authentifizierungstoken kommen.
    @PostMapping("/events/{eventId}/register")
    public ResponseEntity<?> registerForEvent(@PathVariable Long eventId, @RequestBody Map<String, Long> requestBody) {
        Long userId = requestBody.get("userId");
        if (userId == null) {
            return new ResponseEntity<>("UserId is required in the request body.", HttpStatus.BAD_REQUEST);
        }

        try {
            Optional<EventRegistration> registration = registrationService.registerForEvent(eventId, userId);
            return registration.map(value -> new ResponseEntity<>(value, HttpStatus.CREATED))
                    .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
        } catch (IllegalArgumentException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.CONFLICT);
        } catch (IllegalStateException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    // GET /api/users/{userId}/registrations - Benutzer-Anmeldungen abrufen
    @GetMapping("/users/{userId}/registrations")
    public ResponseEntity<List<EventRegistration>> getUserRegistrations(@PathVariable Long userId) {
        List<EventRegistration> registrations = registrationService.getUserRegistrations(userId);
        if (registrations.isEmpty() && !registrationService.userRepository.existsById(userId)) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND); // 404, wenn User nicht existiert
        }
        return new ResponseEntity<>(registrations, HttpStatus.OK);
    }
}