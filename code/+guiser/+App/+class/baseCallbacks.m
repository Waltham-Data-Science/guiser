% guiser/code/+guiser/+App/+class/baseCallbacks.m

classdef baseCallbacks < handle
%baseCallbacks A mixin class for guiser.App.base that contains a library of common callback functions.

    methods
        function CloseWindowFcn(app, src, ~)
            % CloseWindowFcn Handles the request to close a figure window.
            % This function calls the user-overridable UserCloseWindowFcn to
            % determine if the window should actually close.
            
            shouldClose = app.UserCloseWindowFcn(src);
            
            if shouldClose
                delete(src);
            end
        end

        function MenuOpeningFcn(app, src, evt)
            % MenuOpeningFcn Default callback that fires before a context menu is shown.
            app.UserMenuOpeningFcn(src, evt);
        end

        function MenuSelectedFcn(app, src, evt)
            % MenuSelectedFcn Default callback for when a menu item is selected.
            app.UserMenuSelectedFcn(src, evt);
        end

        function ValueChangedFcn(app, src, evt)
            % ValueChangedFcn A generic callback for value changes after user finalizes them.
            
            tag_parts = strsplit(src.Tag, '_');
            baseTag = tag_parts{1};
            if isfield(app.ComponentObjects, baseTag)
                componentObj = app.ComponentObjects.(baseTag);
                if isa(src, 'matlab.ui.container.ButtonGroup')
                    selectedHandle = evt.NewValue;
                    if ~isempty(selectedHandle)
                        selectedHandleTagParts = strsplit(selectedHandle.Tag, '_');
                        selectedBaseTag = selectedHandleTagParts{1};
                        componentObj.SelectedTag = selectedBaseTag;
                    end
                elseif isprop(componentObj, 'Value') && (isprop(evt, 'Value') || isfield(evt,'Value'))
                    componentObj.Value = evt.Value;
                elseif isa(src, 'matlab.ui.control.TextArea')
                    componentObj.Value = src.Value;
                end

                app.ComponentObjects.(baseTag) = componentObj;

                if isa(src, 'matlab.ui.container.ButtonGroup') && ~isempty(evt.NewValue)
                    selectedHandleTagParts = strsplit(evt.NewValue.Tag, '_');
                    selectedBaseTag = selectedHandleTagParts{1};
                    allComponentTags = fieldnames(app.ComponentObjects);
                    for i = 1:numel(allComponentTags)
                        childTag = allComponentTags{i};
                        childObj = app.ComponentObjects.(childTag);
                        if isa(childObj, 'guiser.component.UIRadioButton') && strcmp(childObj.ParentTag, baseTag)
                            childObj.Value = strcmp(childTag, selectedBaseTag);
                            app.ComponentObjects.(childTag) = childObj;
                        end
                    end
                end
            end

            app.EnableDisable();
        end

        function ValueChangingFcn(app, src, evt)
            % ValueChangingFcn A generic callback for real-time value changes.
            
            tag_parts = strsplit(src.Tag, '_');
            baseTag = tag_parts{1};

            if isfield(app.ComponentObjects, baseTag)
                componentObj = app.ComponentObjects.(baseTag);
                if isprop(componentObj, 'Value') && isprop(evt, 'Value')
                    componentObj.Value = evt.Value;
                    app.ComponentObjects.(baseTag) = componentObj;
                end
            end
        end

        function TabNavigatorButtonPushedFcn(app, src, ~)
            % TabNavigatorButtonPushedFcn Callback for UITabNavigatorButton clicks.
            tabGroupHandle = [];
            allUIHandleTags = fieldnames(app.UIHandles);
            for i = 1:numel(allUIHandleTags)
                tag = allUIHandleTags{i};
                if isa(app.UIHandles.(tag), 'matlab.ui.container.TabGroup')
                    tabGroupHandle = app.UIHandles.(tag);
                    break;
                end
            end
            
            if isempty(tabGroupHandle)
                warning('GUISER:Callback:NoTabGroupFound', 'TabNavigatorButtonPushedFcn could not find a UITabGroup in the app.');
                return;
            end

            tag_parts = strsplit(src.Tag, '_');
            baseTag = tag_parts{1};
            navButtonObj = app.ComponentObjects.(baseTag);

            allTabs = tabGroupHandle.Children;
            selectedTab = tabGroupHandle.SelectedTab;
            currentIndex = find(allTabs == selectedTab, 1);

            if strcmp(navButtonObj.direction, 'next')
                if currentIndex < numel(allTabs)
                    tabGroupHandle.SelectedTab = allTabs(currentIndex + 1);
                end
            elseif strcmp(navButtonObj.direction, 'previous')
                if currentIndex > 1
                    tabGroupHandle.SelectedTab = allTabs(currentIndex - 1);
                end
            end
            
            app.EnableDisable();
        end

        function TabNavigatorButtonEnableDisable(app, ~, ~)
            % TabNavigatorButtonEnableDisable Updates the enable state of all tab navigator buttons.
            allComponentTags = fieldnames(app.ComponentObjects);
            
            navButtonTags = {};
            for i = 1:numel(allComponentTags)
                tag = allComponentTags{i};
                if isa(app.ComponentObjects.(tag), 'guiser.component.UITabNavigatorButton')
                    navButtonTags{end+1} = tag;
                end
            end
            
            if isempty(navButtonTags), return; end

            tabGroupHandle = [];
            allUIHandleTags = fieldnames(app.UIHandles);
            for i = 1:numel(allUIHandleTags)
                tag = allUIHandleTags{i};
                if isa(app.UIHandles.(tag), 'matlab.ui.container.TabGroup')
                    tabGroupHandle = app.UIHandles.(tag);
                    break;
                end
            end
            
            if isempty(tabGroupHandle), return; end

            allTabs = tabGroupHandle.Children;
            selectedTab = tabGroupHandle.SelectedTab;
            currentIndex = find(allTabs == selectedTab, 1);

            for i = 1:numel(navButtonTags)
                tag = navButtonTags{i};
                navButtonObj = app.ComponentObjects.(tag);
                navButtonHandle = app.UIHandles.(tag);
                
                newState = 'off';
                if strcmp(navButtonObj.direction, 'previous')
                    if currentIndex > 1, newState = 'on'; end
                elseif strcmp(navButtonObj.direction, 'next')
                    if currentIndex < numel(allTabs), newState = 'on'; end
                end

                navButtonObj.Enable = newState;
                navButtonHandle.Enable = newState;
            end
        end

        function ListboxEditButtonPushedFcn(app, src, ~)
            % ListboxEditButtonPushedFcn Callback for UIListboxEditButton clicks.
            
            tag_parts = strsplit(src.Tag, '_');
            baseTag = tag_parts{1};
            buttonObj = app.ComponentObjects.(baseTag);
            
            if ismissing(buttonObj.ListboxTag)
                warning('GUISER:Callback:NoListboxTag', 'The UIListboxEditButton "%s" does not have its ListboxTag property set.', baseTag);
                return;
            end

            listboxHandle = app.UIHandles.(buttonObj.ListboxTag);
            listboxObj = app.ComponentObjects.(buttonObj.ListboxTag);
            
            switch buttonObj.action
                case 'Add'
                    app.UserListboxEditButtonAddAction(listboxHandle);
                case 'Remove'
                    if ~isempty(listboxHandle.Value)
                        newItems = setdiff(listboxObj.Items, listboxHandle.Value, 'stable');
                        listboxObj.Items = newItems;
                        listboxHandle.Items = newItems;
                        listboxHandle.Value = {}; % Clear selection
                    end
                case 'MoveUp'
                    if ~isempty(listboxHandle.Value)
                        indices = find(ismember(listboxObj.Items, listboxHandle.Value));
                        newItems = listboxObj.Items;
                        for i = sort(indices, 'ascend')'
                            if i > 1
                                [newItems(i-1), newItems(i)] = deal(newItems(i), newItems(i-1));
                            end
                        end
                        listboxObj.Items = newItems;
                        listboxHandle.Items = newItems;
                    end
                case 'MoveDown'
                    if ~isempty(listboxHandle.Value)
                        indices = find(ismember(listboxObj.Items, listboxHandle.Value));
                        newItems = listboxObj.Items;
                        for i = sort(indices, 'descend')'
                            if i < numel(newItems)
                                [newItems(i+1), newItems(i)] = deal(newItems(i), newItems(i+1));
                            end
                        end
                        listboxObj.Items = newItems;
                        listboxHandle.Items = newItems;
                    end
            end
            app.EnableDisable();
        end

        function ListboxEditButtonEnableDisable(app)
            % ListboxEditButtonEnableDisable Manages the state of listbox edit buttons.
            allComponentTags = fieldnames(app.ComponentObjects);
            
            for i = 1:numel(allComponentTags)
                tag = allComponentTags{i};
                component = app.ComponentObjects.(tag);

                if isa(component, 'guiser.component.UIListboxEditButton')
                    buttonHandle = app.UIHandles.(tag);
                    listboxHandle = app.UIHandles.(component.ListboxTag);
                    
                    hasSelection = ~isempty(listboxHandle.Value);
                    
                    if any(strcmp(component.action, {'MoveUp', 'MoveDown', 'Remove'}))
                        if hasSelection
                            buttonHandle.Enable = 'on';
                            component.Enable = 'on';
                        else
                            buttonHandle.Enable = 'off';
                            component.Enable = 'off';
                        end
                    end
                end
            end
        end

        function UserListboxEditButtonAddAction(app, listboxHandle)
            % UserListboxEditButtonAddAction Placeholder for custom 'Add' button logic.
            warning('GUISER:NotImplemented', 'The "Add" action for the listbox "%s" has not been implemented. Override UserListboxEditButtonAddAction in your app class.', listboxHandle.Tag);
        end
    end
end