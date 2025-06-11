# Event Management System

Dies ist eine Backend-Anwendung, entwickelt mit Spring Boot, die das Management von Events, 
Benutzern und Event-Registrierungen ermöglicht. Es ist ein RESTful API, konzipiert, um mit einer mobilen Frontend-Anwendung zu interagieren.

Diese Backend-Version ist **OHNE Spring Security** aus entwicklungszwecken vorerst nicht implementiert. 
keine Authentifizierung oder Autorisierung, und Passwörter werden im Klartext

## Inhaltsverzeichnis

1.  [Projektübersicht](#1-projektübersicht)
2.  [Architektur-Entscheidungen](#2-architektur-entscheidungen)
3.  [Backend Setup & Ausführung](#3-backend-setup--ausführung)
    * [Anwendung starten](#anwendung-starten)
    * [API-Endpunkte (ohne Security)](#api-endpunkte-ohne-security)
4.  [Frontend Setup (Mobil App)](#4-frontend-setup-mobil-app)

---

## 1. Projektübersicht

Das "Event Management System" bietet eine Backend-API zur Verwaltung von Events, Benutzern und deren Anmeldungen. 
Es ist darauf ausgelegt, als Rückgrat für eine mobile Anwendung zu dienen.

**Kernfunktionen:**

* **Benutzerverwaltung:** Registrierung und Login von Benutzern mit verschiedenen Rollen (`ORGANIZER`, `PARTICIPANT`).
* **Event-Verwaltung:** Erstellung, Anzeige, Aktualisierung und Löschen von Events.
* **Event-Registrierung:** Benutzer können sich für Events anmelden und ihre Anmeldungen einsehen.

## 2. Architektur-Entscheidungen

### 2.1. Technologie Stack

* **Backend:** Spring Boot (Java)
* **Datenbank:** H2 (in-memory für Entwicklung)
* **Build Tool:** Maven familiar in nutzung
* **Frontend:** Flutter - Dart

### 2.2. Datenmodell (JPA Entities)

Das System basiert auf drei Haupt-JPA-Entitäten, die das Kern-Datenmodell abbilden:

* **`User`**: Repräsentiert einen Benutzer mit `id`, `username`, `email`, `password` (Klartext in dieser Version) und `role` (`ORGANIZER` oder `PARTICIPANT`). Eine `@OneToMany`-Beziehung zu `EventRegistration` (ein user kann an viele events registrieren) ist vorhanden, mit `@JsonIgnore` um Rekursion bei der Serialisierung zu verhindern.
* **`Event`**: Repräsentiert ein Event mit `id`, `title`, `description`, `date`, `time`, `location`, `maxParticipants` und der `organizerId`. Ebenfalls eine `@OneToMany`-Beziehung zu `EventRegistration` mit `@JsonIgnore`. (an einem Event kann viele users registrieren)
* **`EventRegistration`**: Verbindet einen `User` mit einem `Event` über `user` (Many-to-One), `event` (Many-to-One) und einem `registrationDate`. (ein user kann nicht mehrfach an einem Event registrieren.)

### 2.3. RESTful API Design

Die Anwendung folgt den Prinzipien eines RESTful API-Designs, mit klaren Endpunkten und HTTP-Methoden für CRUD-Operationen.

### 2.4. Fehlerbehandlung & Validierung

* **Globale Fehlerbehandlung:** Eine zentrale Fehlerbehandlung (`@ControllerAdvice`) stellt sicher, dass allgemeine Fehler (z.B. 404 Not Found, 400 Bad Request) konsistent behandelt werden.

## Datenbankkonfiguration

Die Anwendung ist für die Verwendung einer In-Memory H2-Datenbank konfiguriert.

### H2 Database (Empfohlen für schnellen Start / Entwicklung)

Standardmäßig ist die Anwendung für H2 konfiguriert. 
H2 ist eine In-Memory-Datenbank, d.h. alle Daten gehen beim Neustart der Anwendung verloren. Oder wir konfigurieren unser `application.properties`, damit wir nicht bei jedem Neustart die daten verlieren:
````properties
spring.datasource.url=jdbc:h2:file:./data/my_h2_database
````

* Keine zusätzliche Konfiguration nötig.

## Anwendung starten

Navigiere im Terminal zum Stammverzeichnis des Backend-Projekts (wo die `pom.xml` liegt) und führe aus:

````bash
mvn spring-boot:run
````

## API-Endpunkte (ohne Security)
Nach dem Start der Anwendung sind folgende Endpunkte (standardmäßig auf http://localhost:8080/api/) zugänglich:

* **User Management:**

`POST /api/users/register`
`POST /api/users/login`
`GET /api/users/{id}`


* **Event Management:**

`GET /api/events`
`GET /api/events/{id}`
`POST /api/events`
`PUT /api/events/{id}`
`DELETE /api/events/{id}`


* **Event Registration:**

`POST /api/events/{eventId}/register`
`GET /api/users/{userId}/registrations`

Endpunkte mit Tools wie Postman testen. (ein Paar Screenshots von Postmann)
![img.png](/data/screenshots/img.png)
![img_1.png](/data/screenshots/img_1.png)


## 4. Frontend Setup (Mobil App)

Flutter/Mobile App Entwicklung 
