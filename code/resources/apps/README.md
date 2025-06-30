Of course. Here is the content of the `README.md` file in plain Markdown format, which you can easily copy.

```markdown
# Creating GUISER Application Definition Files

This guide provides instructions on how to create the JSON files used by the GUISER framework to define and build MATLAB App Designer applications.

## Overview

A GUISER application definition is a single JSON file that describes the entire structure and layout of your user interface. This file has two main top-level properties: `dataStructure` and `guiComponents`.

```

{
"dataStructure": { ... },
"guiComponents": [ ... ]
}

```

## 1. `dataStructure`

This object defines the data model for your application. It is a hierarchical structure of fields that will be used to store the state of the application's data. While it can be an empty object if your app is simple, it is good practice to define the data fields that will be linked to your UI components.

### Example:

```

"dataStructure": {
"gui": {
"userName": "",
"userAge": 0,
"isAdmin": false
},
"results": {
"lastComputation": "N/A"
}
}

```

## 2. `guiComponents`

This property is an array of objects, where each object defines a single UI component (like a button, panel, or text field). The components are defined in a flat list, and their parent-child relationships are established using `Tag` and `ParentTag`.

### Component Definition Structure

Each component object in the array has two properties:

* `className`: The full MATLAB class name of the GUISER component to create.
* `properties`: An object containing the specific properties for that component.

```

{
"className": "guiser.component.UIButton",
"properties": {
"Tag": "confirmButton",
"ParentTag": "mainPanel",
"Text": "Confirm"
}
}

```

### Key Properties

While each component has many available properties, the following are the most critical for defining the UI structure:

* **`className` (string, required)**: The fully qualified name of the component class. All available components are located in the `+guiser/+component` package (e.g., `guiser.component.UIPanel`, `guiser.component.UIButton`).
* **`Tag` (string, REQUIRED)**: A **unique** identifier for the component within the application. **This field is mandatory for every single component.** It is used to identify the component, store its handle, and establish parent-child relationships.
* `ParentTag` (string, required for all but one **component)**: The `Tag` of the component that will act as the parent for this component.
    * There must be exactly **one** root component in your application, and its `ParentTag` must be an empty string (`""`). This component is typically the `guiser.component.UIFigure`.
    * All other components must have a `ParentTag` that corresponds to the `Tag` of another component in the list.

### Building the UI Hierarchy

The framework builds the UI by first creating the root component (the one with `ParentTag: ""`). It then recursively finds and creates all components that list the root's `Tag` as their `ParentTag`, and so on, until the entire tree is constructed.

### Finding Available Components and Properties

* **Component Classes**: A complete list of available UI components can be found by inspecting the files in the `+guiser/+component/` directory.
* **Component Properties**: The properties available for each component are defined by the mixin classes it inherits from (e.g., `UIText`, `UIValue`, `UIBackgroundColor`). The definitive list of properties that can be set on each underlying MATLAB object is located in the `resources/matlabPropertyMapping.json` file. Refer to this file to see which "guiserTerm" maps to which "matlabTerm".
```