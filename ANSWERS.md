# Theoretische Fragen (während der Entwicklung)

---

## Database & Backend

### 1. Erkläre den Unterschied zwischen `@OneToMany` und `@ManyToOne` JPA Annotations

Diese JPA-Annotations werden verwendet, um Beziehungen zwischen Entitäten in einer relationalen Datenbank abzubilden. Sie beschreiben die Kardinalität der Beziehung aus der Perspektive der jeweiligen Entität:

* **`@OneToMany`**:
    * Beschreibt eine Beziehung, bei der eine Instanz der Entität mit vielen Instanzen einer anderen Entität verknüpft ist.
    * Bei diesem Anwendung : Ein `User` kann viele `Event`s organisieren oder registrieren.
    * Die "Many"-Seite (die Events) enthält normalerweise den FOREIGN_KEY zur "One"-Seite (dem User).
    *  `mappedBy` gibt an, woher .

* **`@ManyToOne`**:
    * Beschreibt eine Beziehung, bei der viele Instanzen der Entität mit einer Instanz einer anderen Entität verknüpft sind.
    * Bei diesem Anwendung : Viele `Event`s können von einem `User` organisiert oder registriert werden.
    * Die "Many"-Seite (die Events) ist hier die besitzende Seite der Beziehung und enthält den FOREIGN_KEY zur "One"-Seite (dem User).

**Zusammenfassend**: `OneToMany` ist auf der "Elternseite", `ManyToOne` auf der "Kindseite".

### 2. Was ist der Unterschied zwischen `@RestController` und `@Controller`?

Beide Annotations werden verwendet, um Classes als Spring-Component zu kennzeichnen, die als Controller dienen und HTTP-Requests verarbeiten.

* **`@Controller`** ist traditionaller Spring Model-View-Controller, wird generell mit HTML-Seiten verwendet
    
    * Wenn eine Methode einen `String` zurückgibt, wird dieser `String` standardmäßig als Name einer View-Datei interpretiert.
    * Wenn Daten (z.B. JSON/XML) direkt zurückgegeben werden sollen, muss zusätzlich die `@ResponseBody`-Annotation auf die Methode angewendet werden.
    * ideal für web applications, in dem man templates wie thymeleaf 

* **`@RestController`**:
    * Eine Convenience-Annotation, die eine Kombination aus `@Controller` und `@ResponseBody` darstellt.
    * Wird generell für die Erstellung von **RESTful Web Services** verwendet.
    * @RestController kombiniert @Controller + @ResponseBody – JSON wird automatisch zurückgegeben.
    * Ideal für API-Endpunkte, die von Frontend-Frameworks (wie Flutter, React) oder anderen Microservices konsumiert werden.

**Zusammenfassend**: Verwende `@RestController` für REST APIs, die Daten (z.B. JSON) zurückgeben. Verwende `@Controller` für Webanwendungen, die HTML-Seiten rendern, oder wenn du explizit steuern möchtest, wann `@ResponseBody` angewendet wird.

---

## Frontend & Mobile

### 1. Erkläre den Flutter Widget Lifecycle

Der Widget Lifecycle beschreibt den Lebenszyklus eines Flutter Widgets:
 Wie es entsteht, wie es sich verändert und wie es gelöscht wird.

Das gilt besonders für StatefulWidgets (also Widgets mit veränderbarem Zustand).

**Für `StatefulWidget`s (vereinfacht):**


* **`createState()`**
- Wird einmal aufgerufen, wenn das Widget gebaut wird.

* **`initState()`**:
    * Wird genau einmal aufgerufen, wenn das `State`-Objekt erstellt wird (nach `createState()`).
   

* **`build()`**:
    * Wird jedes Mal aufgerufen, wenn sich der Zustand des Widgets ändert, die Abhängigkeiten aktualisiert werden oder ein `setState()` aufgerufen wird.
    * am häufigsten aufgerufen.

* **`didUpdateWidget(covariant T oldWidget)`**:
    * Wird aufgerufen, wenn das Eltern-Widget das Widget neu aufbaut

* **`setState()`**:

    * Wird manuell aufgerufen, um den Zustand des Widgets zu ändern und Flutter anzuweisen, die `build()`-Methode erneut aufzurufen, um die UI zu aktualisieren.


* **`dispose()`**:
    * Wird dauerhaft aufgerufen, wenn das `State`-Objekt nie wieder verwendet wird.


**Für `StatelessWidget`s**:
Sie haben nur eine `build()`-Methode. Da sie keinen veränderbaren Zustand haben, gibt es keine  `setState()` oder `dispose()` Methoden. Sie werden einfach neu aufgebaut, wenn sich ihr Eltern-Widget sie neu aufbaut.

### 2. Was sind die Vorteile von `StatelessWidget` vs `StatefulWidget`?

Die Wahl zwischen `StatelessWidget` und `StatefulWidget` hängt davon ab, ob ein Widget seinen internen Zustand im Laufe der Zeit ändern muss.

**StatelessWidget Vorteile:**

* Einfach und schnell, 
* kein veränderbaren Zustatnd,
* ideal für UI-Elements, die nicht verändert werden


**StatefulWidget Vorteile:**

* **Interner, veränderbarer Zustand**:  Zustand kann in der Zeit ändern,  für UI-Elemente wie Formularfelder, dropdowmenus,  Checkboxen geeignet und notwendig für interaktive Nutzungserlebnis.

* Verwende **`StatelessWidget`**, wenn sich die inhalte oder properties des Widgets nie ändern, nachdem es erstellt wurde (z.B. `Text`, `Icon`, `Image`, `AppBar`). 

* Verwende **`StatefulWidget`**, wenn sich das Widget im Laufe der Zeit ändern muss, basierend auf Benutzerinteraktionen, externen Datenänderungen oder Timern (z.B. `Checkbox`, `TextField`, `Slider`). Wenn du `setState()` aufrufen musst, um die UI zu aktualisieren, brauchst du ein `StatefulWidget`.

### 3. Welche State Management Libraries verwendest du/würdest du verwenden und warum?

Die Wahl der State Management Library hängt oft von der Komplexität des Projekts, der Team-Erfahrung und persönlichen Präferenzen ab.

* Ich würde hauptsächlich die folgenden State Management Libraries verwenden und warum:

* **Provider (Derzeit präferiert und auch in diesem Projekt genutzt)**:
    * **Warum**: `Provider` ist ein Wrapper um `InheritedWidget`. Es ist einfach zu erlernen, flexibel und deckt die meisten State Management-Anforderungen ab.
    * **Vorteile**:
        * Leicht zu verstehen und zu implementieren für kleinere bis mittlere Anwendungen.
        * Gut für komplexe Anwendungen skalierbar, indem man mehrere Provider kombiniert.
        * Es ermöglicht eine effiziente Aktualisierung nur der Teile des Widget-Trees, die sich tatsächlich ändern, was die Performance verbessert.
    * **Anwendung in diesem Projekt**: Ich habe in diesem Projekt bereits `setState` verwendet, aber `Provider` wäre der nächste logische Schritt, um den State des eingeloggten Benutzers (z.B. `userId`, `role`) oder die globale Event-Liste zu verwalten, damit nicht jeder Screen die Daten neu laden muss.

* **Bloc / Cubit (Für komplexere Anwendungen)**:
    * **Warum**: Für sehr große und komplexe Anwendungen

* **Riverpod (Modernere Alternative zu Provider)**:
    * **Warum**: Eine Weiterentwicklung von `Provider`

- Zusammenfassend würde ich für dieses Projekt mit seinen aktuellen Anforderungen bei `setState` für lokale UI-States bleiben und `Provider` für globale Zustände (wie Benutzerinformationen nach dem Login) implementieren. Für zukünftige, komplexre PRojekte und in diesem app für weitere Wachstum würde ich `Riverpod` oder `Bloc/Cubit` in Betracht ziehen, wenn ich bespielsweise dashboards in komplexeren kontext für participants und organizers seperat erstellen würde, wie interessierte oder gespeicherte events.



## Allgemein

### 1. Wie würdest du die Performance deiner App messen?

Die Performance einer Flutter-App kann auf verschiedene Weisen gemessen werden, um Engpässe zu identifizieren und zu optimieren:

* **Laut Recherchen** 

* **Flutter DevTools**:
    * **Performance Overlay**: überwacht FPS
    * **CPU Profiler**: Analysiert die CPU
    * **Memory Tab**: Überwacht die Speichernutzung

* **IDE-Integration (z.B. VS Code, Android Studio)**:
    * Die IDEs bieten oft direkte Links zu den Flutter DevTools und zeigen grundlegende Performance-Indikatoren wie CPU-Auslastung an.

* **`flutter analyze` und `flutter doctor`**:

### 2. Wie würdest du das Testing der App verbessern, wenn du mehr Zeit investieren würdest?

Wenn ich mehr Zeit für das Testing der App investieren würde, würde ich
- mehr Unit tests für Logik in backend schreiben `mockito` nutzen, um HTTP-Requests und Responses realistik testen können. 
- the widgets einzelne teste, ob alles in sich richtig läuft. screenings und ausfüllung von feldern (leergelassen, unzulässige charakters, Time-Date-Formatting usw.)
- navigationen testen, mit tätigen von buttons zu richtiger seite gelanden?
- fehlermeldungen richtig funktioniert
- testen ob die screens richtig in anderen geräten mit verschieden opsystems, Größen und Richtungen haben, kompatable or not 
