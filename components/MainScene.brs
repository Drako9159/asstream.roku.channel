' ********** Copyright 2019 Roku Corp.  All Rights Reserved. **********

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
           	backgroundImageURI: GetRandomBackgroundImage() 
            backgroundColor: AppInfo.GetValue("backgroundColor")
        }
    }

    print "----------> Theme Loaded"
    
    ' check for security 

    isSecure = AppInfo.GetValue("security")
    if isSecure = "true" then
        CreateSecurityView()
        
    else
        ShowLoginDialog()
        ShowGridComponent()
        print "----------> GridView Loaded"
    end if
    
    ' test deep linking
    ' curl -d "" "http://192.168.0.247:8060/launch/dev?contentID=67a3c7b6b4e8c78e753a1c9d&mediaType=movie"
    ' rm -rf as_stream.zip && zip -r as_stream.zip . -x "/.git/*" "/.git/**"
    ' define optionals
    ' telnet roku-ip-address 8085
    ' telnet 192.168.0.247 8085

    ' Check for deep linking
    ' action(m)

    if IsDeepLinking(args)
        PerformDeepLinking(args)
    end if

    ' Signal AppLaunchComplete beacon
    m.top.signalBeacon("AppLaunchComplete")
end sub


sub CreateSecurityView()
    m.securityView = CreateObject("roSGNode", "SecurityView")
    m.securityView.observeField("unlocked", "onUnlocked")
    m.top.ComponentController.CallFunc("show", {
        view: m.securityView
    })
end sub

sub onUnlocked()
    m.securityView.visible = false
    ShowLoginDialog()
    ShowGridComponent()
    print "----------> GridView Loaded"
end sub

function ShowGridComponent()
    ' Create the grid view
    ' style: standard, hero, zoom, rmp 
    ' posterShape: portrait, 4x3, 16x9, square
    m.grid = CreateObject("roSGNode", "GridView")
    m.grid.SetFields({
        style: "standard"
        posterShape: "portrait"
    })

    ' Create the content node
    content = CreateObject("roSGNode", "ContentNode")
    content.AddFields({
        HandlerConfigGrid: {
            name: "RootHandler"
        }
    })

    m.grid.content = content
    m.grid.ObserveField("rowItemSelected", "OnGridItemSelected")

    ' m.grid.ObserveField("content", "OnGridContentSet")
    ' m.grid.ObserveField("content", "OnGridContentChanged")
    ' id = "679544c8129dd935d43146d9"

    m.top.ComponentController.CallFunc("show", {
        view: m.grid
    })

   
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

sub ShowLoginDialog()
    ' Signal AppDialogInitiate beacon
    m.top.signalBeacon("AppDialogInitiate")

    ' Show login dialog logic here


    ' Signal AppDialogComplete beacon
    m.top.signalBeacon("AppDialogComplete")
end sub

function GetRandomBackgroundImage() as String
    images = [
        "pkg:/images/random/random_01.jpg",
        "pkg:/images/random/random_02.jpg",
        "pkg:/images/random/random_03.jpg",
        "pkg:/images/random/random_04.jpg",
        "pkg:/images/random/random_05.jpg",
        "pkg:/images/random/random_06.jpg",
        "pkg:/images/random/random_07.jpg"
    ]

    ' Rnd(N) devuelve un entero entre 1 y N
    randomIndex = Rnd(images.Count()) - 1
    return images[randomIndex]
end function
