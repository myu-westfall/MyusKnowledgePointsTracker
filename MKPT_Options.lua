local AddonName, MKPT_env, _ = ...
local L = MKPT_env.L

function MKPT_env.InitializeOptionsMenu()
    local db = MKPT_env.db
    -- Create and register the main category for your addon in the Interface Options
    local category = Settings.RegisterVerticalLayoutCategory(L["Myu's kp Tracker"])
    MKPT_env.categoryId = category:GetID()
    do
        local GetValue = function()
            return db.ui.lockWindow
        end
        local SetValue = function(value)
            MKPT_env.SetLockUi(value)
        end
        local name = L["Lock Window"]
        local defaultValue = false
        local setting = Settings.RegisterProxySetting(
            category,
            "MKPT_LockWindow",
            type(defaultValue),
            name,
            defaultValue,
            GetValue,
            SetValue
        )
        local tooltip = L["Locks window position"]
        Settings.CreateCheckbox(category, setting, tooltip)
    end

    do
        local GetValue = function()
            return db.ui.autohide
        end
        local SetValue = function(value)
            MKPT_env.ToggleAutoHide()
        end
        local name = L["Autohide"]
        local defaultValue = false
        local setting = Settings.RegisterProxySetting(
            category,
            "MKPT_Autohide",
            type(defaultValue),
            name,
            defaultValue,
            GetValue,
            SetValue
        )
        local tooltip = L["Hides the window when the cursor is not over it"]
        Settings.CreateCheckbox(category, setting, tooltip)
    end

    do
        local GetValue = function()
            return db.ui.hideInCombat
        end
        local SetValue = function(value)
            db.ui.hideInCombat = value

            if not InCombatLockdown() then
                return
            end
            if value then
                MKPT_env.ui:Hide()
            elseif MKPT_env.charDb.state.show then
                MKPT_env.ui:Show()
            end
        end
        local name = L["Hide in combat"]
        local defaultValue = false
        local setting = Settings.RegisterProxySetting(
            category,
            "MKPT_HideInCombat",
            type(defaultValue),
            name,
            defaultValue,
            GetValue,
            SetValue
        )
        local tooltip = L["Hides the window when in combat"]
        Settings.CreateCheckbox(category, setting, tooltip)
    end


    do
        local GetValue = function()
            return not db.minimap.hide
        end
        local SetValue = function(value)
            MKPT_env.ToggleMinimapIcon()
        end
        local name = L["Minimap icon"]
        local defaultValue = true
        local setting = Settings.RegisterProxySetting(
            category,
            "MKPT_Minimap",
            type(defaultValue),
            name,
            defaultValue,
            GetValue,
            SetValue
        )
        local tooltip = L["Show/hide minimap icon"]
        Settings.CreateCheckbox(category, setting, tooltip)
    end

    do
        local GetValue = function()
            return not db.compartment.hide
        end
        local SetValue = function(value)
            MKPT_env.ToggleCompartmentIcon()
        end
        local name = L["Show in addon compartment"]
        local defaultValue = true
        local setting = Settings.RegisterProxySetting(
            category,
            "MKPT_Compartment",
            type(defaultValue),
            name,
            defaultValue,
            GetValue,
            SetValue
        )
        local tooltip = L["Show/hide addon compartment entry"]
        Settings.CreateCheckbox(category, setting, tooltip)
    end

    do
        local variableName = "MKPT_BackgroundOpacity"
        local name = L["Background Opacity"]
        local tooltip = L["Changes background opacity"]
        local defaultValue = 0.6
        local minValue = 0.0
        local maxValue = 1.0
        local step = 0.01

        local GetValue = function()
            return db.ui.backgroundColor.a
        end
        local SetValue = function(value)
            local backgroundColor = db.ui.backgroundColor
            backgroundColor.a = value

            MKPT_env.ui:SetBackdropColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)
        end

        local setting = Settings.RegisterProxySetting(
            category,
            variableName,
            type(defaultValue),
            name,
            defaultValue,
            GetValue,
            SetValue
        )
        local options = Settings.CreateSliderOptions(minValue, maxValue, step)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
            return string.format("%.2f", value)
        end)
        Settings.CreateSlider(category, setting, options, tooltip)
    end

    do
        local variableName = "MKPT_RowBackgroundOpacity"
        local name = L["Row Background Opacity"]
        local tooltip = L["Changes row background opacity"]
        local defaultValue = 0.5
        local minValue = 0.0
        local maxValue = 1.0
        local step = 0.01

        local GetValue = function()
            return db.ui.rowBackgroundColor.a
        end
        local SetValue = function(value)
            db.ui.rowBackgroundColor.a = value
            MKPT_env.ui:RenderTree()
        end

        local setting = Settings.RegisterProxySetting(
            category,
            variableName,
            type(defaultValue),
            name,
            defaultValue,
            GetValue,
            SetValue
        )
        local options = Settings.CreateSliderOptions(minValue, maxValue, step)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
            return string.format("%.2f", value)
        end)
        Settings.CreateSlider(category, setting, options, tooltip)
    end


    do
        local variableName = "MKPT_UiScale"
        local name = L["UI scale"]
        local tooltip = L["Resizes the addon window"]
        local defaultValue = 1.0
        local minValue = 0.5
        local maxValue = 1.5
        local step = 0.05

        local GetValue = function()
            return db.ui.scale
        end
        local SetValue = function(value)
           MKPT_env.SetUiScale(value)
        end

        local setting = Settings.RegisterProxySetting(
            category,
            variableName,
            type(defaultValue),
            name,
            defaultValue,
            GetValue,
            SetValue
        )
        local options = Settings.CreateSliderOptions(minValue, maxValue, step)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
            return string.format("%.2f", value)
        end)
        Settings.CreateSlider(category, setting, options, tooltip)
    end


    Settings.RegisterAddOnCategory(category)
end
