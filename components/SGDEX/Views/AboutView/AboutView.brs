' Copyright (c) 2024 Roku, Inc. All rights reserved.

sub Init()
    ' Set up the back button
    m.backButtonAbout = m.top.FindNode("backButtonAbout")

    if m.backButtonAbout <> invalid
        m.backButtonAbout.ObserveField("buttonSelected", "OnBackButtonSelected")
        'm.backButtonAbout.SetFocus(true)
    end if
    
    ' Get app info for version
    appInfo = CreateObject("roAppInfo")
    versionInfo = m.top.FindNode("versionInfo")
    if versionInfo <> invalid and appInfo <> invalid
        majorVersion = appInfo.GetValue("major_version")
        minorVersion = appInfo.GetValue("minor_version")
        buildVersion = appInfo.GetValue("build_version")
        if majorVersion <> "" and minorVersion <> "" and buildVersion <> ""
            versionInfo.text = "Versión " + majorVersion + "." + minorVersion + "." + buildVersion
        end if
    end if
end sub




sub OnBackButtonSelected(event as Object)
    ' Close the About view and return to GridView
    print "------> Back button selected, closing About view"
    
    ' Use ViewManager to close the current view and return to previous view
    m.top.getScene().ComponentController.ViewManager.CallFunc("runProcedure", {
        fn: "closeView"
        fp: ["", {}]
    })
end sub

function SGDEX_GetViewType() as String
    return "aboutView"
end function


' Handle key events for navigation
function OnKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press

        if key = "back" and m.backButtonAbout <> invalid and m.backButtonAbout.HasFocus()
            print "------> Back key pressed, closing About view"
            OnBackButtonSelected(m.backButtonAbout)
            handled = true
        end if
        
        m.backButtonAbout.SetFocus(true)
        handled = true
        
    end if

    return handled
end function

