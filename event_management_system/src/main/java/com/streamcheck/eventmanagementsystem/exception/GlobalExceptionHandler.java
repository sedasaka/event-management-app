package com.streamcheck.eventmanagementsystem.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ResponseEntity<String> handleNoHandlerFoundException(NoHandlerFoundException ex, WebRequest request) {
        return new ResponseEntity<>("Requested API endpoint was not found.", HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ResponseEntity<Map<String, String>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(error ->
                errors.put(error.getField(), error.getDefaultMessage()));
        return new ResponseEntity<>(errors, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ResponseEntity<String> handleAllUncaughtException(Exception ex, WebRequest request) {
        // Log the exception for debugging purposes
        System.err.println("An unexpected error occurred: " + ex.getMessage());
        return new ResponseEntity<>("An internal server error occurred.", HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler({IllegalArgumentException.class, IllegalStateException.class})
    public ResponseEntity<String> handleServiceExceptions(RuntimeException ex) {
        HttpStatus status = HttpStatus.BAD_REQUEST;
        if (ex instanceof IllegalArgumentException) {
            status = HttpStatus.CONFLICT;
        } else if (ex instanceof IllegalStateException) {
            status = HttpStatus.BAD_REQUEST;
        }
        return new ResponseEntity<>(ex.getMessage(), status);
    }
}