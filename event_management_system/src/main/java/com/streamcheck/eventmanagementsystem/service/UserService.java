package com.streamcheck.eventmanagementsystem.service;

import com.streamcheck.eventmanagementsystem.model.User;
import com.streamcheck.eventmanagementsystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public User registerUser(User user) {

        if (userRepository.findByUsername(user.getUsername()).isPresent() ||
                userRepository.findByEmail(user.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Username or email already exists.");
        }

        return userRepository.save(user);
    }


    public Optional<User> loginUser(String username, String password) {
        Optional<User> userOptional = userRepository.findByUsername(username);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (user.getPassword() != null && user.getPassword().equals(password)) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
}