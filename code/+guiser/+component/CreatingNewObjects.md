# Adding and Customizing GUISER UIElements

This guide explains the process of creating new `UIElement` subclasses and customizing their behavior, such as callbacks. Creating specialized components is a powerful way to encapsulate behavior and simplify your JSON UI definitions.

---

### Step 1: Create the Class File

First, create a new `.m` file in the `guiser/code/+guiser/+component/` directory. The name of the file will be the name of your new class.

The most important decision is what your new class will inherit from.
* **Inherit from an existing component:** If your new component is a specialized version of an existing one (e.g., a special button), inherit from that component. This is the easiest approach as you inherit all its properties and behavior.
* **Inherit from `UIElement` and mixins:** If you are creating a fundamentally new type of component, you will inherit from `guiser.component.UIElement` and then add the necessary mixin classes (e.g., `guiser.component.mixin.UIVisualComponent`, `guiser.component.mixin.UITextComponent`, etc.) to build up its properties.

**Example (`UITabNavigatorButton.m`):**
```matlab
% Inherits all the functionality of a standard UIButton
classdef UITabNavigatorButton < guiser.component.UIButton
    % ... class content ...
end
````

-----

### Step 2: Add Custom Properties and Methods

Add any new properties that are unique to your component. Always include validation to ensure the properties are used correctly. You can also add a constructor method or a custom property setter to define default values or behavior.

**Example (`UIListboxEditButton.m`):**

```matlab
classdef UIListboxEditButton < guiser.component.UIButton
    properties
        % Add a new 'action' property with validation
        action (1,:) char {mustBeMember(action, {'MoveUp', 'MoveDown', 'Add', 'Remove'})} = 'Add'
        
        % Add a property to link this button to a specific listbox
        ListboxTag (1,1) string = missing
    end

    methods
        function obj = UIListboxEditButton()
            % Set a default callback for this specialized button
            obj.ButtonPushedFcn = 'ListboxEditButtonPushedFcn';
        end

        function set.action(obj, value)
            % Custom setter for the 'action' property that also sets the icon
            obj.action = value;
            switch value
                case 'MoveUp', obj.Icon = 'resources/icons/up.png';
                case 'MoveDown', obj.Icon = 'resources/icons/down.png';
                case 'Add', obj.Icon = 'resources/icons/plus.png';
                case 'Remove', obj.Icon = 'resources/icons/minus.png';
            end
        end
    end
end
```

-----

### Step 3: Update `UIElement.m` (If Necessary)

The `get.creatorFcn` method in `UIElement.m` determines which MATLAB UI function to call (e.g., `uibutton`, `uipanel`). If your new component is a subclass of an existing one (like `UIListboxEditButton` is a subclass of `UIButton`), you must ensure there is a rule to handle this.

**Example (in `UIElement.m`):**

```matlab
function value = get.creatorFcn(obj)
    % ... other checks ...

    % This check handles UIButton and all of its subclasses
    if isa(obj, 'guiser.component.UIButton')
        value = 'uibutton';
        return;
    end
    
    % ... default logic ...
end
```

-----

### Step 4: Update `matlabPropertyMapping.json` (CRUCIAL)

This is the most important step. The framework's `createComponent` method needs to know how to translate the properties of your new GUISER class to the properties of the underlying MATLAB UI object.

You **must** add a new entry to `matlabPropertyMapping.json` for your new class. If your class is a subclass of an existing component, you can simply copy the entire mapping from the parent class and change the `className`.

**Example (adding `UIListboxEditButton`):**

```json
  // ... other mappings ...
  },
  {
    "className": "guiser.component.UIListboxEditButton",
    "mappings": [
      // Mappings are copied from guiser.component.UIButton
      { "guiserTerm": "Text", "matlabTerm": "Text", "isReadOnly": false, "isPostBuild": false },
      { "guiserTerm": "Icon", "matlabTerm": "Icon", "isReadOnly": false, "isPostBuild": false },
      // ... etc. ...
      { "guiserTerm": "ButtonPushedFcn", "matlabTerm": "ButtonPushedFcn", "isReadOnly": false, "isPostBuild": false }
    ]
  },
  {
  // ... other mappings ...
```

-----

### Step 5: Handling Callbacks (Default and Custom Logic)

The framework is designed to provide default behaviors while allowing you to add your own custom logic. This is achieved through a **"Superclass Call Pattern."**

**How It Works:**

1.  The framework provides default callback methods in the `guiser.App.class.baseCallbacks` class (e.g., a generic `ValueChangedFcn`). This method contains default logic, like enabling/disabling buttons.
2.  In your JSON file, you set the `ValueChangedFcn` property on your component to the name of a method in *your* app class (e.g., `ExampleApp.m`).
    ```json
    "ValueChangedFcn": "myCustomCallback"
    ```
3.  In your app class, you implement your custom method. **The first line of your method must be a call to the base class's version of the callback.** This executes the default framework logic.

**Example (in `ExampleApp.m`):**

```matlab
methods
    function ValueChangedFcn(app, src, evt)
        % This is the method specified in the JSON.
        
        % First, call the parent method to get all the default behavior.
        ValueChangedFcn@guiser.App.class.base(app, src, evt);

        % Now, add your own custom logic below.
        % For example, you could update a plot based on the new listbox selection.
        if strcmp(src.Tag, 'tab3SampleListbox_YourAppUID')
            disp(['The listbox value is now: ' strjoin(evt.Value, ', ')]);
        end
    end
end
```

This pattern gives you maximum flexibility: you can run your code after the default logic, before it, or choose to not call the parent method at all if you want to completely override the default behavior.

