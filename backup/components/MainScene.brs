' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

sub Show(args as Object)
    AppInfo = CreateObject("roAppInfo")
    ' update theme elements
    m.top.theme = {
        global: {
        	OverhangLogoUri: AppInfo.GetValue("OverhangLogoUri")
            OverhangTitle: AppInfo.GetValue("OverhangTitle")	 		
            OverhangTitleColor: AppInfo.GetValue("OverhangTitleColor")		
            OverhangBackgroundUri: AppInfo.GetValue("OverhangBackgroundUri")		
            OverhangBackgroundColor: AppInfo.GetValue("OverhangBackgroundColor")	

            textColor: AppInfo.GetValue("textColor")
            focusRingColor: AppInfo.GetValue("focusRingColor")
            progressBarColor: AppInfo.GetValue("progressBarColor")
			busySpinnerColor: AppInfo.GetValue("busySpinnerColor")                  

           	backgroundImageURI: AppInfo.GetValue("backgroundImageURI") 
            backgroundColor: AppInfo.GetValue("backgroundColor")
        }
    }

    m.grid = CreateObject("roSGNode", "GridView")
    m.grid.SetFields({
        style: "standard"
        posterShape: "16x9"
    })
    content = CreateObject("roSGNode", "ContentNode")
    content.AddFields({
        HandlerConfigGrid: {
            name: "RootHandler"
        }
    })
    m.grid.content = content
    m.grid.ObserveField("rowItemSelected", "OnGridItemSelected")

    m.top.ComponentController.CallFunc("show", {
        view: m.grid
    })

    
    ' Init_backup()
    
    'm.loadingIndicator = m.top.FindNode("loadingIndicator") ' store loadingIndicator node to m
    ' InitScreenStack()

    ' Authenticate screen 
    'ShowAuthenticateScreen()
    
    'ShowGridScreen()
    'RunContentTask() ' retrieving content

    if IsDeepLinking(args)
        PerformDeepLinking(args)
    end if

    m.top.signalBeacon("AppLaunchComplete")
end sub






sub Init_backup()
    ' set background color for scene. Applied only if backgroundUri has empty value
    m.top.backgroundColor = "0x662D91"
    m.top.backgroundUri = "pkg:/images/background.webp"
    m.loadingIndicator = m.top.FindNode("loadingIndicator") ' store loadingIndicator node to m
    InitScreenStack()

    ' Authenticate screen 
    ShowAuthenticateScreen()
    
    ShowGridScreen()
    RunContentTask() ' retrieving content
end sub







' The OnKeyEvent() function receives remote control key events
function OnkeyEvent(key as string, press as boolean) as boolean
    
    result = false
    if press
        ' handle "back" key press
        if key = "back"
            numberOfScreens = m.screenStack.Count()
            ' close top screen if there are two or more screens in the screen stack
            if numberOfScreens > 1
                CloseScreen(invalid)
                result = true
            end if
        end if
    end if
    ' The OnKeyEvent() function must return true if the component handled the event,
    ' or false if it did not handle the event.
    return result
end function

sub OnGridItemSelected(event as Object)
    grid = event.GetRoSGNode()
    selectedIndex = event.GetData()
    rowContent = grid.content.GetChild(selectedIndex[0])
    detailsView = ShowDetailsView(rowContent, selectedIndex[1])
    detailsView.ObserveField("wasClosed", "OnDetailsWasClosed")
end sub

sub OnDetailsWasClosed(event as Object)
    details = event.GetRoSGNode()
    m.grid.jumpToRowItem = [m.grid.rowItemFocused[0], details.itemFocused]
end sub

sub Input(args as object)
    ' handle roInput event deep linking
    if IsDeepLinking(args)
        PerformDeepLinking(args)
    end if
end sub


sub ShowChannelRSGScreen()
    ' The roSGScreen object is a SceneGraph canvas that displays the contents of a Scene node instance
    screen = CreateObject("roSGScreen")
    ' message port is the place where events are sent
    m.port = CreateObject("roMessagePort")

    ' sets the message port which will be used for events from the screen
    screen.SetMessagePort(m.port)
    ' every screen object must have a Scene node, or a node that derives from the Scene node
    scene = screen.CreateScene("MainScene")

    screen.Show() ' Init method in MainScene.brs is invoked


    ' event loop
    while(true)
        ' waiting for events from screen
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.IsScreenClosed() then return
        end if


        ' handle events from the remote
        if msgType = "roUniversalControlEvent"
            if msg.isButtonPressed()
                if msg.GetButton() = "OK"
                    ' do something
                    
                end if
            end if
        end if

        if msgType = "roSGNodeEvent"
            if msg.GetNode() = invalid
                
                return
            end if
        end if

        if msgType = "roInputEvent"
            if msg.isScreenClosed()
                
                return
            end if
            if msg.isScreenServerButtonPressed()
                
                return
            end if

        end if
    end while

end sub

