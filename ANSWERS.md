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


### 1. `createState()`
- Wird **einmal** aufgerufen, wenn das Widget **gebaut wird**.
- Es erstellt das **State-Objekt**, wo sich der "Zustand" befindet.

 Beispiel aus `AuthForm`:
```dart
@override
State<AuthForm> createState() => _AuthFormState();
```

* **`initState()`**:
    * Wird genau einmal aufgerufen, wenn das `State`-Objekt erstellt wird (nach `createState()`).
    * Hier werden Initialisierungen durchgeführt, wie das Abrufen von Daten.
    * Man kann `setState()` hier nicht aufrufen, weila das Widget noch nicht richtig aufgebaut ist.
    * `super.initState()` muss immer zuerst aufgerufen werden.

* **`didChangeDependencies()`**:
    * Wird direkt nach `initState()` aufgerufen und auch, wenn sich die Abhängigkeiten des Widgets ändern (z.B. wenn sich ein `InheritedWidget` ändert, von dem dieses Widget abhängt).
 

* **`build()`**:
    * Wird jedes Mal aufgerufen, wenn sich der Zustand des Widgets ändert, die Abhängigkeiten aktualisiert werden oder ein `setState()` aufgerufen wird.
    * Gibt den Widget-Tree zurück, der von diesem Widget gerendert werden soll.
    * Sollte keine Seiteneffekte haben und rein sein (nur Widgets zurückgeben).
    * Die am häufigsten aufgerufene Methode.

* **`didUpdateWidget(covariant T oldWidget)`**:
    * Wird aufgerufen, wenn das übergeordnete Widget das Widget neu aufbaut und ihm ein *neues* Widget des *gleichen `runtimeType`* mit einem *anderen Schlüssel* (oder gar keinem Schlüssel) übergibt.
    * Ermöglicht es, auf Änderungen der übergebenen `widget`-Properties zu reagieren.
    * `super.didUpdateWidget(oldWidget)` muss zuerst aufgerufen werden.

* **`setState()`**:
    * Eine Methode der `State`-Klasse (nicht des Widgets selbst).
    * Wird manuell aufgerufen, um den Zustand des Widgets zu ändern und Flutter anzuweisen, die `build()`-Methode erneut aufzurufen, um die UI zu aktualisieren.

* **`deactivate()`**:
    * Wird aufgerufen, wenn das `State`-Objekt aus dem Widget-Tree entfernt wird.
    * Kann kurzfristig sein (z.B. wenn das Widget in eine andere Position verschoben wird) oder dauerhaft (z.B. wenn es aus dem Tree entfernt wird).
    * Wenn das Widget wieder in den Tree eingefügt wird, wird `activate()` aufgerufen.

* **`dispose()`**:
    * Wird dauerhaft aufgerufen, wenn das `State`-Objekt aus dem Widget-Tree entfernt wird und **nie wieder verwendet wird**.
    * Hier sollten alle Ressourcen freigegeben werden (Controller, Listener, Timer), um Memory Leaks zu vermeiden.
    * `super.dispose()` muss immer am Ende aufgerufen werden.

**Für `StatelessWidget`s**:
Sie haben nur eine `build()`-Methode. Da sie keinen veränderbaren Zustand haben, gibt es keine  `setState()` oder `dispose()` Methoden. Sie werden einfach neu aufgebaut, wenn sich ihr übergeordnetes Widget sie neu aufbaut.

### 2. Was sind die Vorteile von `StatelessWidget` vs `StatefulWidget`?

Die Wahl zwischen `StatelessWidget` und `StatefulWidget` hängt davon ab, ob ein Widget seinen internen Zustand im Laufe der Zeit ändern muss.

**StatelessWidget Vorteile:**

* **Einfacher und leichter**: Sie haben keinen internen Zustand, der verwaltet werden muss, was den Code einfacher und leichter zu lesen macht.
* **Bessere Performance (potenziell)**: Da sie sich nicht ändern, müssen sie seltener neu aufgebaut werden als `StatefulWidget`s, was die Render-Performance verbessern kann, insbesondere bei großen Widget-Trees.
* **Weniger Overhead**: Kein `State`-Objekt, keine `initState`, `dispose` usw., was weniger Speicherplatz und CPU-Zyklen bedeutet.
* **Immutabilität**: Sie sind unveränderlich

**StatefulWidget Vorteile:**

* **Interner, veränderbarer Zustand**: Sie können ihren eigenen Zustand über die Zeit ändern, was für interaktive UI-Elemente wie Formularfelder, Checkboxen oder komplexere Datenanzeigen unerlässlich ist.
* **Reaktion auf Benutzerinteraktionen**: Sie können auf Benutzer-Inputs (z.B. Button-Klicks, Texteingaben) reagieren und ihre UI entsprechend aktualisieren.
* **Lebenszyklusmethoden**: Zugang zu Methoden wie `initState()` und `dispose()`, die für das Setup und die Bereinigung von Ressourcen wichtig sind.

**Wann man was verwendet:**
* Verwende **`StatelessWidget`**, wenn sich die inhalte oder properties des Widgets nie ändern, nachdem es erstellt wurde (z.B. `Text`, `Icon`, `Image`, `AppBar`). Wenn ein Widget nur Daten anzeigt oder andere Widgets zusammensetzt, ohne selbst interaktiv zu sein, ist `StatelessWidget` die richtige Wahl.
* Verwende **`StatefulWidget`**, wenn sich das Widget im Laufe der Zeit ändern muss, basierend auf Benutzerinteraktionen, externen Datenänderungen oder Timern (z.B. `Checkbox`, `TextField`, `Slider`). Wenn du `setState()` aufrufen musst, um die UI zu aktualisieren, brauchst du ein `StatefulWidget`.

### 3. Welche State Management Libraries verwendest du/würdest du verwenden und warum?

Die Wahl der State Management Library hängt oft von der Komplexität des Projekts, der Team-Erfahrung und persönlichen Präferenzen ab.

**Ich würde hauptsächlich die folgenden State Management Libraries verwenden und warum:**

* **Provider (Derzeit präferiert und auch in diesem Projekt genutzt)**:
    * **Warum**: `Provider` ist ein Wrapper um `InheritedWidget`. Es ist einfach zu erlernen, flexibel und deckt die meisten State Management-Anforderungen ab.
    * **Vorteile**:
        * Leicht zu verstehen und zu implementieren für kleinere bis mittlere Anwendungen.
        * Gut für komplexe Anwendungen skalierbar, indem man mehrere Provider kombiniert.
        * Es ermöglicht eine effiziente Aktualisierung nur der Teile des Widget-Trees, die sich tatsächlich ändern, was die Performance verbessert.
    * **Anwendung in diesem Projekt**: Ich habe in diesem Projekt bereits `setState` verwendet, aber `Provider` wäre der nächste logische Schritt, um den State des eingeloggten Benutzers (z.B. `userId`, `role`) oder die globale Event-Liste zu verwalten, damit nicht jeder Screen die Daten neu laden muss.

* **Bloc / Cubit (Für komplexere Anwendungen)**:
    * **Warum**: Für sehr große und komplexe Anwendungen, bei denen eine strikte Trennung von Geschäftslogik und UI, sowie eine detaillierte Kontrolle über den State-Fluss erforderlich sind. Cubit ist eine einfachere Variante von Bloc.
    * **Vorteile**:
        * **Striktes Muster**: Erzwingt ein klares, testbares und vorhersagbares Architekturmuster (Events -> Bloc/Cubit -> States).
        * **Skalierbarkeit**: Ideal für große Teams und Enterprise-Anwendungen, da es die Wartbarkeit und Erweiterbarkeit stark verbessert.
        * **Testbarkeit**: Ausgezeichnete Testbarkeit der Geschäftslogik, da sie von der UI entkoppelt ist.
        * **Debuggen**: Macht das Debuggen einfacher, da der State-Fluss klar definiert ist.
    * **Anwendung in diesem Projekt**: Wenn das Projekt wachsen und viele komplexe Interaktionen oder Offline-Funktionen umfassen würde, wäre Bloc/Cubit eine starke Wahl.

* **Riverpod (Modernere Alternative zu Provider)**:
    * **Warum**: Eine Weiterentwicklung von Provider, die die Probleme von Provider löst (z.B. die Notwendigkeit von `BuildContext` für den Zugriff auf Provider, und die Möglichkeit von Programmierfehlern bei der globalen Zugänglichkeit).
    * **Vorteile**:
        * **Compile-Time Safety**: Bietet bessere Kompilierzeit-Fehlererkennung.
        * **Kein `BuildContext` für den Zugriff**: Kann Provider von überall aus aufrufen, ohne den `BuildContext` zu benötigen.
        * **Bessere Testbarkeit**: Noch einfacher zu testen als Provider.
        * **Starke Typisierung**: Mehr Sicherheit durch verbesserte Typinferenz.
    * **Anwendung in diesem Projekt**: Eine ausgezeichnete Wahl für neue Projekte, da es die Vorteile von Provider bietet und dessen Schwachstellen behebt.

**Zusammenfassend würde ich für dieses Projekt mit seinen aktuellen Anforderungen bei `setState` für lokale UI-States bleiben und `Provider` für globale Zustände (wie Benutzerinformationen nach dem Login) implementieren. Für zukünftiges Wachstum würde ich `Riverpod` oder `Bloc/Cubit` in Betracht ziehen.**
