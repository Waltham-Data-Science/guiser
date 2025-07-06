# GUISER - GUI SERialized toolbox

![Tests](.github/badges/tests.svg)
![Code Issues](.github/badges/code_issues.svg)

**GUISER** is a powerful MATLAB toolbox designed to streamline the creation of complex graphical user interfaces. It allows developers to define and build UIs from serialized JSON files, promoting a clean, organized, and platform-independent development process. By separating the UI definition from the application logic, GUISER makes it easier to manage, version, and collaborate on sophisticated MATLAB applications.

This project is built upon a template that includes robust CI/CD workflows for automated testing and the packaging of the toolbox for distribution.

***

## Key Features

* **Declarative UI Definition**: Define your entire application layout, including components, properties, and parent-child relationships, in a human-readable JSON file.
* **Component-Based Architecture**: Build your UI from a library of pre-defined components (`UIButton`, `UIPanel`, `UIGridLayout`, etc.) that are easily configurable.
* **Extensible by Design**: Easily create new, specialized components by inheriting from base classes and mixins to encapsulate custom behavior and simplify your UI definitions.
* **Simplified Callback Management**: The framework provides a clean pattern for handling UI events, allowing for default behaviors that can be easily extended with custom user code.
* **Automatic UI Generation**: The `guiser.App.class.base` class handles the heavy lifting of parsing the JSON definition and constructing the live MATLAB UI, letting you focus on your app's core logic.

***

## Quick Start: See It in Action

To see a demonstration of the GUISER framework, simply run the included example application. Make sure the `guiser` toolbox is on your MATLAB path, and then execute the following command:

```matlab
app = guiser.App.class.ExampleApp();
````

This will launch a sample application that showcases various UI components and their interactions, all built from the `guiserExampleApp.json` definition file.

-----

## Documentation

This repository contains extensive documentation to help you get started and master the GUISER framework.

  * **[Creating a UI Definition (JSON)](https://www.google.com/url?sa=E&source=gmail&q=https://github.com/Waltham-Data-Science/guiser/blob/main/guiser/code/resources/apps/README.md)**: Learn the structure of the JSON file, how to define the data model, and how to list and configure UI components.
  * **[UI Component Reference](https://www.google.com/url?sa=E&source=gmail&q=https://github.com/Waltham-Data-Science/guiser/blob/main/ComponentGuide.md)**: A comprehensive reference guide for all available UI components and their configurable parameters.
  * **[Creating New Components](https://www.google.com/url?sa=E&source=gmail&q=https://github.com/Waltham-Data-Science/guiser/blob/main/guiser/code/+guiser/+component/CreatingNewObjects.md)**: A step-by-step guide on how to create your own custom UI components to extend the framework.

-----

## Requirements

  * **MATLAB R2023a** or later is recommended. The toolbox packaging features specifically require a recent MATLAB version.

-----

## Support & Contributing

If you need help, have a feature request, or would like to report a bug, please [create an issue](https://www.google.com/url?sa=E&source=gmail&q=https://github.com/Waltham-Data-Science/guiser/issues) on our GitHub page. We also welcome contributions\!
