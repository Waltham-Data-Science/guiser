# GUISER UI Component Reference

This document provides a comprehensive reference for all UI component classes available in the GUISER framework. Each entry details the purpose of the component and the parameters available for configuration in the JSON definition file.
---

## guiser.component.UIButton
A standard push button that a user can click to trigger an action.
### Parameters
* **BackgroundColor**: Sets the background color of the button. This should be a 1x3 RGB triplet with values from 0 to 1 (e.g., `[1 1 1]` for white) or a valid MATLAB color name string.
* **ButtonPushedFcn**: Specifies the name of the app method to execute when the button is clicked. This must be a string that matches the name of a public method in your app class.
* **Enable**: Controls whether the button is interactive. Valid values are the strings `'on'` (default) or `'off'`.
* **FontAngle**: Sets the angle of the button's text font. Valid values are the strings `'normal'` (default) or `'italic'`.
* **FontColor**: Defines the color of the button's text. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **FontName**: Specifies the font for the button's text. Valid values are strings like `'Helvetica'`, `'Arial'`, `'Courier New'`, or `'Times New Roman'`.
* **FontSize**: Sets the size of the button's text in points. This must be a positive numeric value.
* **FontWeight**: Sets the weight of the button's text font. Valid values are the strings `'normal'` (default) or `'bold'`.
* **Icon**: Defines an image to be displayed on the button. This should be a string containing the path to an image file relative to the `guiser/code` directory.
* **IconAlignment**: Determines the position of the icon relative to the text. Valid values are strings like `'left'`, `'right'`, `'top'`, or `'bottom'`.
* **Layout**: Specifies the button's position within a `UIGridLayout`. This should be an object with `Row` and `Column` properties, like `{"Row": 1, "Column": 2}`.
* **ParentTag**: The tag of the parent component this button belongs to. This must be a string matching the `Tag` of a container component like a `UIPanel` or `UIGridLayout`.
* **Position**: Defines the size and location of the button in pixels, specified as `[left, bottom, width, height]`. This is typically used when not placing the component in a `UIGridLayout`.
* **Tag**: A unique string identifier for this button. This tag is used for parenting other components and for accessing the component's handle in the app.
* **Text**: The text label displayed on the button. This should be a string.
* **Tooltip**: A string of text that appears when the user hovers the mouse over the button. This is useful for providing extra information.
* **Visible**: Controls the visibility of the button. Valid values are the strings `'on'` (default) or `'off'`.

---

## guiser.component.UIButtonGroup
A container for radio buttons or toggle buttons that enforces mutually exclusive selection.
### Parameters
* **BackgroundColor**: Sets the background color of the button group panel. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **BorderType**: Defines the style of the border around the panel. Valid values are strings like `'none'`, `'line'`, `'beveledin'`, `'beveledout'`, `'etchedin'`, or `'etchedout'`.
* **FontAngle**: Sets the angle of the title's font. Valid values are the strings `'normal'` (default) or `'italic'`.
* **FontColor**: Defines the color of the title's text. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **FontName**: Specifies the font for the title's text. Valid values are strings like `'Helvetica'`, `'Arial'`, `'Courier New'`, or `'Times New Roman'`.
* **FontSize**: Sets the size of the title's text in points. This must be a positive numeric value.
* **FontWeight**: Sets the weight of the title's font. Valid values are the strings `'normal'` (default) or `'bold'`.
* **Layout**: Specifies the button group's position within a `UIGridLayout`. This should be an object with `Row` and `Column` properties.
* **ParentTag**: The tag of the parent component. This must be a string matching the `Tag` of a container component.
* **Position**: Defines the size and location of the button group in pixels, specified as `[left, bottom, width, height]`.
* **SelectedTag**: The `Tag` of the child radio button that should be selected by default. This must be a string matching the `Tag` of a `UIRadioButton` inside this group.
* **SelectionChangedFcn**: Specifies the name of the app method to execute when the selected button changes. This must be a string that matches the name of a public method in your app class.
* **Tag**: A unique string identifier for this button group.
* **Title**: The text that appears as the title of the button group panel. This should be a string.
* **Visible**: Controls the visibility of the button group. Valid values are the strings `'on'` (default) or `'off'`.
---

## guiser.component.UICheckbox
A checkbox that a user can select or deselect to represent a logical state (true/false).
### Parameters
* **BackgroundColor**: Sets the background color of the checkbox component. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **Enable**: Controls whether the checkbox is interactive. Valid values are the strings `'on'` (default) or `'off'`.
* **FontAngle**: Sets the angle of the checkbox's text font. Valid values are the strings `'normal'` (default) or `'italic'`.
* **FontColor**: Defines the color of the checkbox's text. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **FontName**: Specifies the font for the checkbox's text. Valid values are strings like `'Helvetica'`, `'Arial'`, `'Courier New'`, or `'Times New Roman'`.
* **FontSize**: Sets the size of the checkbox's text in points. This must be a positive numeric value.
* **FontWeight**: Sets the weight of the checkbox's text font. Valid values are the strings `'normal'` (default) or `'bold'`.
* **Layout**: Specifies the checkbox's position within a `UIGridLayout`. This should be an object with `Row` and `Column` properties.
* **ParentTag**: The tag of the parent component. This must be a string matching the `Tag` of a container component.
* **Position**: Defines the size and location of the checkbox in pixels, specified as `[left, bottom, width, height]`.
* **Tag**: A unique string identifier for this checkbox.
* **Text**: The text label displayed next to the checkbox. This should be a string.
* **Tooltip**: A string of text that appears when the user hovers the mouse over the checkbox.
* **Value**: The logical state of the checkbox. This must be a boolean value, `true` or `false`.
* **ValueChangedFcn**: Specifies the name of the app method to execute when the checkbox is checked or unchecked. This must be a string that matches the name of a public method in your app class.
* **Visible**: Controls the visibility of the checkbox. Valid values are the strings `'on'` (default) or `'off'`.
---

## guiser.component.UIEditField
A single-line text box where a user can enter or edit text.
### Parameters
* **BackgroundColor**: Sets the background color of the edit field. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **Enable**: Controls whether the edit field is interactive. Valid values are the strings `'on'` (default) or `'off'`.
* **FontAngle**: Sets the angle of the text font. Valid values are the strings `'normal'` (default) or `'italic'`.
* **FontColor**: Defines the color of the text. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **FontName**: Specifies the font for the text. Valid values are strings like `'Helvetica'`, `'Arial'`, `'Courier New'`, or `'Times New Roman'`.
* **FontSize**: Sets the size of the text in points. This must be a positive numeric value.
* **FontWeight**: Sets the weight of the text font. Valid values are the strings `'normal'` (default) or `'bold'`.
* **HorizontalAlignment**: Defines the horizontal alignment of the text within the field. Valid values are the strings `'left'`, `'center'`, or `'right'`.
* **Layout**: Specifies the edit field's position within a `UIGridLayout`. This should be an object with `Row` and `Column` properties.
* **ParentTag**: The tag of the parent component. This must be a string matching the `Tag` of a container component.
* **Placeholder**: Instructional text that appears in the edit field when it is empty. This should be a string.
* **Position**: Defines the size and location of the edit field in pixels, specified as `[left, bottom, width, height]`.
* **Tag**: A unique string identifier for this edit field.
* **Tooltip**: A string of text that appears when the user hovers the mouse over the edit field.
* **Value**: The text content of the edit field. This should be a string.
* **ValueChangedFcn**: Specifies the name of the app method to execute after the user finalizes a change (e.g., presses Enter). This must be a string that matches a public method name in your app class.
* **ValueChangingFcn**: Specifies the name of the app method to execute as the user is typing. This must be a string that matches a public method name in your app class.
* **Visible**: Controls the visibility of the edit field. Valid values are the strings `'on'` (default) or `'off'`.
---

## guiser.component.UIFigure
The main application window that contains all other UI components.
### Parameters
* **CloseRequestFcn**: Specifies the name of the app method to execute when a user attempts to close the figure. This must be a string that matches a public method name in your app class.
* **Color**: Sets the background color of the figure window. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **Name**: The text that appears in the title bar of the figure window. This should be a string.
* **Position**: Defines the initial size and location of the figure window on the screen, specified as `[left, bottom, width, height]`.
* **Tag**: A unique string identifier for the figure.
* **Visible**: Controls the visibility of the figure. Valid values are the strings `'on'` (default) or `'off'`.

---

## guiser.component.UIGridLayout
A layout manager that arranges components in a grid.
### Parameters
* **BackgroundColor**: Sets the background color of the grid layout area. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **ColumnSpacing**: The amount of space in pixels between columns. This must be a non-negative numeric value.
* **ColumnWidth**: Defines the width of each column. This must be a cell array of values, where each value is a number (for pixels), a string like `'1x'` (for weighted proportion), or the string `'fit'`.
* **Layout**: Specifies the grid's position within a parent `UIGridLayout`. This should be an object with `Row` and `Column` properties.
* **Padding**: The space in pixels between the grid boundary and its contents, specified as `[left, bottom, right, top]`.
* **ParentTag**: The tag of the parent component. This must be a string matching the `Tag` of a container component.
* **RowHeight**: Defines the height of each row. This must be a cell array of values, where each value is a number (for pixels), a string like `'1x'` (for weighted proportion), or the string `'fit'`.
* **RowSpacing**: The amount of space in pixels between rows. This must be a non-negative numeric value.
* **Tag**: A unique string identifier for this grid layout.
* **Visible**: Controls the visibility of the grid layout. Valid values are the strings `'on'` (default) or `'off'`.

---

## guiser.component.UILabel
A static text label used to display non-interactive text.
### Parameters
* **BackgroundColor**: Sets the background color of the label. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **FontAngle**: Sets the angle of the label's text font. Valid values are the strings `'normal'` (default) or `'italic'`.
* **FontColor**: Defines the color of the label's text. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **FontName**: Specifies the font for the label's text. Valid values are strings like `'Helvetica'`, `'Arial'`, `'Courier New'`, or `'Times New Roman'`.
* **FontSize**: Sets the size of the label's text in points. This must be a positive numeric value.
* **FontWeight**: Sets the weight of the label's text font. Valid values are the strings `'normal'` (default) or `'bold'`.
* **HorizontalAlignment**: Defines the horizontal alignment of the text within the label's bounds. Valid values are the strings `'left'`, `'center'`, or `'right'`.
* **Layout**: Specifies the label's position within a `UIGridLayout`. This should be an object with `Row` and `Column` properties.
* **ParentTag**: The tag of the parent component. This must be a string matching the `Tag` of a container component.
* **Position**: Defines the size and location of the label in pixels, specified as `[left, bottom, width, height]`.
* **Tag**: A unique string identifier for this label.
* **Text**: The text to be displayed by the label. This should be a string.
* **VerticalAlignment**: Defines the vertical alignment of the text within the label's bounds. Valid values are the strings `'top'`, `'center'`, or `'bottom'`.
* **Visible**: Controls the visibility of the label. Valid values are the strings `'on'` (default) or `'off'`.

---

## guiser.component.UIListbox
A list box that displays a list of items for user selection.
### Parameters
* **BackgroundColor**: Sets the background color of the listbox. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **DoubleClickFcn**: Specifies the name of the app method to execute when an item is double-clicked. This must be a string matching a public method name in your app class.
* **Enable**: Controls whether the listbox is interactive. Valid values are the strings `'on'` (default) or `'off'`.
* **Items**: The list of items to display in the listbox. This must be a JSON array of strings, like `["Item A", "Item B"]`.
* **Layout**: Specifies the listbox's position within a `UIGridLayout`. This should be an object with `Row` and `Column` properties.
* **Multiselect**: Controls whether the user can select multiple items. Valid values are the strings `'on'` or `'off'` (default).
* **ParentTag**: The tag of the parent component. This must be a string matching the `Tag` of a container component.
* **Position**: Defines the size and location of the listbox in pixels, specified as `[left, bottom, width, height]`.
* **Tag**: A unique string identifier for this listbox.
* **Tooltip**: A string of text that appears when the user hovers the mouse over the listbox.
* **Value**: The currently selected item or items. This must be a string (for single selection) or an array of strings (for multi-select) that matches an entry in the `Items` property.
* **ValueChangedFcn**: Specifies the name of the app method to execute when the selection changes. This must be a string matching a public method name in your app class.
* **Visible**: Controls the visibility of the listbox. Valid values are the strings `'on'` (default) or `'off'`.
---

## guiser.component.UIPanel
A container component that can group other components and display a title and border.
### Parameters
* **BackgroundColor**: Sets the background color of the panel. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **BorderType**: Defines the style of the border around the panel. Valid values are strings like `'none'`, `'line'`, `'beveledin'`, `'beveledout'`, `'etchedin'`, or `'etchedout'`.
* **FontAngle**: Sets the angle of the title's font. Valid values are the strings `'normal'` (default) or `'italic'`.
* **FontColor**: Defines the color of the title's text. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **FontName**: Specifies the font for the title's text. Valid values are strings like `'Helvetica'`, `'Arial'`, `'Courier New'`, or `'Times New Roman'`.
* **FontSize**: Sets the size of the title's text in points. This must be a positive numeric value.
* **FontWeight**: Sets the weight of the title's font. Valid values are the strings `'normal'` (default) or `'bold'`.
* **Layout**: Specifies the panel's position within a `UIGridLayout`. This should be an object with `Row` and `Column` properties.
* **ParentTag**: The tag of the parent component. This must be a string matching the `Tag` of a container component.
* **Position**: Defines the size and location of the panel in pixels, specified as `[left, bottom, width, height]`.
* **Tag**: A unique string identifier for this panel.
* **Title**: The text that appears in the border at the top of the panel. This should be a string.
* **Visible**: Controls the visibility of the panel. Valid values are the strings `'on'` (default) or `'off'`.

---

## guiser.component.UIRadioButton
A radio button, which is typically used within a `UIButtonGroup` for exclusive selection.
### Parameters
* **BackgroundColor**: Sets the background color of the radio button component. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **Enable**: Controls whether the radio button is interactive. Valid values are the strings `'on'` (default) or `'off'`.
* **FontAngle**: Sets the angle of the radio button's text font. Valid values are the strings `'normal'` (default) or `'italic'`.
* **FontColor**: Defines the color of the radio button's text. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **FontName**: Specifies the font for the radio button's text. Valid values are strings like `'Helvetica'`, `'Arial'`, `'Courier New'`, or `'Times New Roman'`.
* **FontSize**: Sets the size of the radio button's text in points. This must be a positive numeric value.
* **FontWeight**: Sets the weight of the radio button's text font. Valid values are the strings `'normal'` (default) or `'bold'`.
* **Layout**: Specifies the radio button's position within a `UIGridLayout`. This should be an object with `Row` and `Column` properties.
* **ParentTag**: The tag of the parent `UIButtonGroup`. This must be a string matching the `Tag` of a `UIButtonGroup` component.
* **Position**: Defines the size and location of the radio button in pixels, specified as `[left, bottom, width, height]`.
* **Tag**: A unique string identifier for this radio button.
* **Text**: The text label displayed next to the radio button. This should be a string.
* **Tooltip**: A string of text that appears when the user hovers the mouse over the radio button.
* **Value**: The logical state of the radio button. This must be a boolean value, `true` (if selected) or `false`.
* **Visible**: Controls the visibility of the radio button. Valid values are the strings `'on'` (default) or `'off'`.
---

## guiser.component.UITab
A single tab within a `UITabGroup`.

### Parameters
* **BackgroundColor**: Sets the background color of the tab's content area. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **ParentTag**: The tag of the parent `UITabGroup`. This must be a string matching the `Tag` of a `UITabGroup` component.
* **Tag**: A unique string identifier for this tab.
* **Title**: The text that appears on the tab itself. This should be a string.

---

## guiser.component.UITabGroup
A container that manages a collection of `UITab` components.
### Parameters
* **Layout**: Specifies the tab group's position within a `UIGridLayout`. This should be an object with `Row` and `Column` properties.
* **ParentTag**: The tag of the parent component. This must be a string matching the `Tag` of a container component.
* **Position**: Defines the size and location of the tab group in pixels, specified as `[left, bottom, width, height]`.
* **SelectedTab**: The `Tag` of the child `UITab` that should be visible by default. This must be a string matching the `Tag` of a `UITab` inside this group.
* **TabLocation**: Determines where the tab labels appear. Valid values are the strings `'top'`, `'bottom'`, `'left'`, or `'right'`.
* **Tag**: A unique string identifier for this tab group.
* **Visible**: Controls the visibility of the tab group. Valid values are the strings `'on'` (default) or `'off'`.

---

## guiser.component.UITable
A component for displaying data in a scrollable grid or table.

### Parameters
* **CellEditCallback**: The name of the app method to execute when a user edits an editable cell.
* **CellSelectionCallback**: The name of the app method to execute when a user selects a cell.
* **ColumnEditable**: A logical array (e.g., `[false, true, true]`) specifying which columns can be edited by the user.
* **ColumnName**: A JSON array of strings to use as headers for the table columns.
* **ColumnWidth**: A JSON array where each element is a number (pixels) or a string (like `'auto'` or `'1x'`).
* **Data**: The data for the table. In JSON, this **must** be an array of objects, where each object represents one row and each key-value pair represents a cell in that row. This structure is required for the data to be processed correctly. For example:
    ```json
    "Data": [
      { "Name": "John Doe", "Age": 38, "IsAdmin": true },
      { "Name": "Jane Smith", "Age": 29, "IsAdmin": false }
    ]
    ```
* **Enable**: Controls whether the table is interactive. Valid values are `'on'` or `'off'`.
* **Layout**: Specifies the table's position within a `UIGridLayout`.
* **ParentTag**: The tag of the parent component.
* **Position**: The size and location of the table in pixels `[left, bottom, width, height]`.
* **RowName**: A JSON array of strings for row headers, or the string `'numbered'`.
* **Tag**: A unique string identifier for this table.
* **Tooltip**: A string of text that appears when the user hovers the mouse over the table.
* **Units**: Specifies the units for the `Position` property. Valid values are strings like `'pixels'` or `'normalized'`.
* **Visible**: Controls the visibility of the table. Valid values are `'on'` or `'off'`.

---

## guiser.component.UITextArea
A multi-line text box for entering or editing larger blocks of text.
### Parameters
* **BackgroundColor**: Sets the background color of the text area. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **Enable**: Controls whether the text area is interactive. Valid values are the strings `'on'` (default) or `'off'`.
* **FontAngle**: Sets the angle of the text font. Valid values are the strings `'normal'` (default) or `'italic'`.
* **FontColor**: Defines the color of the text. This should be a 1x3 RGB triplet with values from 0 to 1 or a valid MATLAB color name string.
* **FontName**: Specifies the font for the text. Valid values are strings like `'Helvetica'`, `'Arial'`, `'Courier New'`, or `'Times New Roman'`.
* **FontSize**: Sets the size of the text in points. This must be a positive numeric value.
* **FontWeight**: Sets the weight of the text font. Valid values are the strings `'normal'` (default) or `'bold'`.
* **Layout**: Specifies the text area's position within a `UIGridLayout`. This should be an object with `Row` and `Column` properties.
* **ParentTag**: The tag of the parent component. This must be a string matching the `Tag` of a container component.
* **Placeholder**: Instructional text that appears in the text area when it is empty. This should be a string.
* **Position**: Defines the size and location of the text area in pixels, specified as `[left, bottom, width, height]`.
* **Tag**: A unique string identifier for this text area.
* **Tooltip**: A string of text that appears when the user hovers the mouse over the text area.
* **Value**: The text content of the text area. This should be a string, which can include newline characters.
* **ValueChangedFcn**: Specifies the name of the app method to execute after the user finalizes a change. This must be a string that matches a public method name in your app class.
* **ValueChangingFcn**: Specifies the name of the app method to execute as the user is typing. This must be a string that matches a public method name in your app class.
* **Visible**: Controls the visibility of the text area. Valid values are the strings `'on'` (default) or `'off'`.
* **WordWrap**: Controls whether long lines of text wrap automatically. Valid values are the strings `'on'` (default) or `'off'`.