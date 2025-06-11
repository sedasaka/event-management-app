package com.streamcheck.eventmanagementsystem.controller;

import com.streamcheck.eventmanagementsystem.model.User;
import com.streamcheck.eventmanagementsystem.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;

    // POST /api/users/register - Benutzer registrieren
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@Valid @RequestBody User user) {
        try {
            User newUser = new User(user.getUsername(), user.getEmail(), user.getPassword(), user.getRole());
            User registeredUser = userService.registerUser(newUser);
            return new ResponseEntity<>(registeredUser, HttpStatus.CREATED);
        } catch (IllegalArgumentException e) {

            return new ResponseEntity<>(e.getMessage(), HttpStatus.CONFLICT);
        } catch (Exception e) {
            return new ResponseEntity<>("Registration failed: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // POST /api/users/login - Benutzer anmelden
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@Valid @RequestBody User user) {
        Optional<User> userOptional = userService.loginUser(user.getUsername(), user.getPassword());
        // 401 Unauthorized
        return userOptional.map(value -> new ResponseEntity<>("Login successful, Welcome " + value.getUsername(), HttpStatus.OK)).orElseGet(() -> new ResponseEntity<>("Invalid login data", HttpStatus.UNAUTHORIZED));
    }

    // Get user details
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        Optional<User> user = userService.findById(id);
        return user.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}

