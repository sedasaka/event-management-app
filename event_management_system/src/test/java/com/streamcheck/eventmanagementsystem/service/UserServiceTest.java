package com.streamcheck.eventmanagementsystem.service;

import com.streamcheck.eventmanagementsystem.model.Role;
import com.streamcheck.eventmanagementsystem.model.User;
import com.streamcheck.eventmanagementsystem.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    private User testUser;

    @BeforeEach
    void setUp() {
        testUser = new User("testuser", "test@example.com", Role.PARTICIPANT.toString());
        testUser.setId(1L);
    }

    @Test
    void testRegisterUser_Success() {
        when(userRepository.findByUsername(testUser.getUsername())).thenReturn(Optional.empty());
        when(userRepository.findByEmail(testUser.getEmail())).thenReturn(Optional.empty());
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        User registered = userService.registerUser(testUser);

        assertNotNull(registered);
        assertEquals("testuser", registered.getUsername());
        verify(userRepository, times(1)).save(testUser);
    }

    @Test
    void testRegisterUser_UsernameExists() {
        when(userRepository.findByUsername(testUser.getUsername())).thenReturn(Optional.of(testUser));

        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            userService.registerUser(testUser);
        });

        assertEquals("Username or email already exists.", exception.getMessage());
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void testGetUserById_Found() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(testUser));

        Optional<User> foundUser = userService.findById(1L);

        assertTrue(foundUser.isPresent());
        assertEquals("testuser", foundUser.get().getUsername());
    }

    @Test
    void testGetUserById_NotFound() {
        when(userRepository.findById(2L)).thenReturn(Optional.empty());

        Optional<User> foundUser = userService.findById(2L);

        assertFalse(foundUser.isPresent());
    }
}