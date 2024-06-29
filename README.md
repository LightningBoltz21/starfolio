# starfolio

A mobile application that enables students to create a portfolio of their high school experiences.
Created by Anish Malepati, 2024 as an FBLA project.

The "lib" directory contains the majority of the files related to both Android and iOS development:

- the BINDINGS folder contain classes that link app controllers with dependencies
- the COMMON folder contains styles and widgets that are used in multiple sections of the app, such
  as loader animations, snackbars, etc.
- the DATA folder contains user and authentication repositories that manage CRUD (create, read,
  update, and delete) operations to the Authentication and FireStore servers
- the FEATURES folder contains controllers, models, and screens pertaining to authentication,
  discover (your portfolio), and personalization (user profiles)
    - CONTROLLERS
        - forget_password handles the actions when a user forgets their password (password reset
          link
          sent to their email)
        - login handles local login
        - onboarding handles the pages that guide the user in using the application when they first
          download the app
        - signup and verify email handles the actions when a user creates a new Starfolio account
        - portfolio controller handles the states of the categories and experiences in the Portfolio
          screen
        - user controller handles the state of the user (which user is signed in, etc.)
    - MODELS
        - category_model contains a "blueprint" for a category that will contain the user's
          experiences
        - experience contains a "blueprint" for an experience that contains title, date range,
          description, and an image
        - user model contains a "blueprint" for a user with name, grade/role (in the school),
          school/org, profile picture, etc.
    - SCREENS
        - contains widgets and screens corresponding to the controllers, what you SEE; named
          respectively
- the UTILS folder contains helper classes to ease programming, stores several variables/enums
    - CONSTANTS
        - colors contains variables for the hex codes of colors
        - enums contains variables/attributes for text sizes
        - image_strings contains variables for the links to images stored locally (icons, etc.)
        - sizes contains sizes of whitespace containers, standard image sizes, etc.
        - text_strings contains long texts stored in variables that can be used again and again
          throughout the app
    - DEVICES
        - gets info from the device (dark or light mode for example)
    - EXCEPTIONS
        - contains custom exceptions that display in the case of an error; important to prevent
          crashes and provide user output on issues
    - FORMATTERS
        - functions to convert variable types/formats (eg. a text String to a DateTime object)
    - HELPERS
        - other general helper functions to make coding easier (color mapping, get screen size,
          etc.)
    - LOCAL STROAGE
        - functions to store data on the device pertaining to the app
    - POPUPS
        - loader and snackbar custom classes, dictates how long they popup, how to call them, and
          more
    - THEME
        - custom, attractive themes for app bars, checkboxes, etc. to fit the appearance of the
          app (controls color, text fonts, etc.)
    - VALIDATORS
        - functions to take input Strings and validate they are in the right format before saving
          them locally OR in the database

pubspec.yaml contains dependencies/libraries that are used by Flutter and other parts of the
application
splash.yaml controls/animates splash screens (STAR loader when app is first launched)
