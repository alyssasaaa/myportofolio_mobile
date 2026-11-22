# myportofolio_mobile

## MyPortfolio Flutter project.
Name: Alyssa Rahma Adjani

Class: PBP KI

### Assignment 7

1. A widget tree is a hierarchical structure of widgets that describes an application's UI. A parent widget contains child widgets through properties such as child or children and controls their arrangement within its layout. Each child can contain more widgets, forming the tree. In my project, a Row contains three InfoCard widgets, while each InfoCard contains widgets that display its title and content.

2. The widgets used in my project are listed below.

   | Widget | Function in my project |
   |---|---|
   | `MyApp` | Builds the application's root configuration. |
   | `MaterialApp` | Configures the application theme and home page. |
   | `MyHomePage` | Builds the portfolio's main page. |
   | `Scaffold` | Provides the page structure, including the app bar and body. |
   | `AppBar` | Displays the application title at the top. |
   | `InfoCard` | Displays my NPM, full name, or class. |
   | `ItemCard` | Displays a portfolio action and handles taps. |
   | `Card` | Provides an elevated surface for identity information. |
   | `Container` | Sets dimensions and padding around its content. |
   | `Padding` | Adds space around a widget. |
   | `Row` | Arranges the identity cards horizontally. |
   | `Column` | Arranges widgets vertically. |
   | `Center` | Centers its child within the available space. |
   | `SizedBox` | Adds fixed spacing between widgets. |
   | `Text` | Displays titles, labels, identity information, and messages. |
   | `GridView.count` | Arranges the action cards in three columns. |
   | `Material` | Provides the colored Material surface for an action card. |
   | `InkWell` | Detects taps and provides an ink ripple effect. |
   | `Icon` | Displays a symbol representing an action. |
   | `SnackBar` | Displays a temporary message after an action card is tapped. |

3. MaterialApp provides application-level functionality for a Material Design app, including themes, navigation, localization support, and the initial page. It is commonly placed near the root so that descendant widgets can access shared configuration. In my project, it sets the application title, configures the color scheme, and displays MyHomePage through its home property.

4. Stateless widgets are widgets that don't change (they are immutable). They cannot change their state during the runtime of the app, which means the widgets cannot be redrawn while the app is in action. On the other hand, stateful widgets are the ones that change its properties during runtime. They are dynamic and mutable and can be drawn multiple times within its lifetime. 

    I use StatelessWidget when the UI depends on supplied data and context, such as my identity and action cards. I use StatefulWidget when a widget needs to manage changing local data, such as a counter, a selected option, or a visibility toggle.

5. BuildContext is an object that represents the location of a widget within the widget tree. It's passed to the build method of a widget and is used to interact with the widget tree and retrieve information about the widget's environment. This is crucial because the available theme, screen information, and other inherited data depend on that location. In my project, Theme.of(context) retrieves the theme, MediaQuery.of(context) retrieves screen information, and ScaffoldMessenger.of(context) obtains the messenger used to display a SnackBar.

6. Hot reload loads code changed into the VM or the browser and rebuilds the widget tree, preserving the app state. It does not rerun main() or initState(). While, hot restart loads code changes into the VM or the browser and restart the Flutter app, losing the app state. 


    If we make changes to the initializers of global variables and static fields, we must rely on the hot restart because to restart the state where the initializers are hold is necessary to see the changes. Moreover, a hot restart is needed to apply changes to initialization code in main() or initState().

#### Assignment 7 AI Usage Report

| AI disclosure description | AI chat log |
| --- | --- |
| • I relied primarily on the code hints provided on the assignment website to implement the app.<br>• I used Codex to help debug my changes.<br>• I also used Codex to help write my Assignment 7 README. | [View the Assignment 7 Codex conversation](https://chatgpt.com/s/cx_6afabc309e00819188a1da521026e367) |

### Assignment 8

1. `Navigator.push()` adds a new route to the top of the navigation stack while keeping the previous route underneath it. `Navigator.pushReplacement()` replaces the current route with a new route, so the replaced route cannot be reached by simply popping the new route. `Navigator.pop()` removes the top route and reveals the route underneath it. It can also close a dialog, since dialogs are routes too.

   In my portofolio mobile, `Navigator.push()` opens `CompetitionFormPage` from the Add Competitions action card. This keeps the home screen underneath the form so the device's system Back button can return to it. The Home option in the drawer uses `Navigator.pushReplacement()` with `MyHomePage()`, replacing the form with a home screen. 

2. `Scaffold` gives the pages a similar structure, with an `AppBar` at the top, a drawer, and a body for the page content. When moving from Home to Add Competition, the title and body change, but the navigation is still familiar because both pages use the same `LeftDrawer`. For example, my pages also follow an indigo color theme. The home AppBar uses the theme’s primary color generated from an indigo seed, while the Competition AppBar and Save button use `Colors.indigo` directly.

3. I chose this layout because the form has nine inputs, so putting them vertically using `Column` makes them easier to follow. Each field has `Padding` to give some space between the inputs. The form also uses `SingleChildScrollView` because all the fields might not fit on a phone screen. When the keyboard opens, the available space becomes smaller, so users can scroll to the other fields and the Save button.

4. `GlobalKey<FormState>` lets the Save button access the form’s state through `currentState`. Each field has a `validator` that checks its input. It returns an error message if the value is invalid, or `null` if it is valid. When Save is pressed, `validate()` runs these checks. The summary dialog only opens if all fields pass.

   For example, entering `abcdefgh` in Competition URL is rejected because it is not a valid URL. Using `TextInputType.url` only provides a keyboard suitable for typing URLs. It does not stop users from typing or pasting incorrect values, so a validator is still needed. Leaving this field blank is allowed because it is optional.

#### Assignment 8 AI Usage Report

| AI disclosure description | AI chat log |
| --- | --- |
| • I used Codex to map my Django Competition fields to Flutter inputs and debug the `_competitionName` and `_title` mismatch.<br>• Codex reviewed my Save button and pointed out that both optional URLs were missing from the summary and reset. I updated the code and tested the form using `flutter run`.<br>• I shared a screenshot of layout overflow warnings. Codex fixed the home screen layout and competition dropdowns, then verified the changes with widget tests at three phone widths.<br>• Codex helped me check the Assignment 8 requirements, gave me hints for questions 2–4, reviewed my draft for question 2, and helped format this disclosure. | [View the Assignment 8 Codex conversation](https://chatgpt.com/s/cx_6b02b765b7a081918cce4b4a856fb3eb) |