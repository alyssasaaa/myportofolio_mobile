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

AI DISCLOSURE:
I used CODEX to debug changes and since the assignment requirements are not much, I heavily rely on the code hint given in the assignment website and use codex to help me on the README.md instead.

AI CHATLOG:
https://chatgpt.com/s/cx_6afabc309e00819188a1da521026e367 
