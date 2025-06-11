package com.streamcheck.eventmanagementsystem.repository;

import com.streamcheck.eventmanagementsystem.model.Event;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface EventRepository extends JpaRepository<Event, Long> {

           List<Event> findByOrganizerId(Long organizerId);


    List<Event> findByDate(LocalDate date);

    List<Event> findByTitleContainingIgnoreCase(String title);

    List<Event> findByLocationAndDate(String location, LocalDate date);
}