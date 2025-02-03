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
           	backgroundImageURI: AppInfo.GetValue("backgroundImageURI") 
            backgroundColor: AppInfo.GetValue("backgroundColor")
        }
    }
    
    ShowLoginDialog()

    ' PlayVideoById("679544c8129dd935d43146d9")

    ShowGridComponent()

    ' test deep linking
    ' curl -d "" "http://192.168.0.247:8060/launch/dev?contentId=67959cf9c707667e3da4f9d3&mediaType=movie"

    ' Check for deep linking
    ' action(m)

    if IsDeepLinking(args)
        PerformDeepLinking(args)
    end if

    ' Signal AppLaunchComplete beacon
    m.top.signalBeacon("AppLaunchComplete")
end sub

sub ShowGridComponent()
    ' Create the grid view
    ' style: standard, hero, zoom, rmp 
    ' posterShape: portrait, 4x3, 16x9, square
    m.grid = CreateObject("roSGNode", "GridView")
    m.grid.SetFields({
        style: "rmp"
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
end sub


' ========== FUNCIÓN DE MANEJO DEL OBSERVER ==========
sub OnGridContentChanged(event as Object)

    grid = event.GetRoSGNode()
    content = grid.content

    playableItem = FindNodeById(m.grid.content, "679544c8129dd935d43146d9")

    OpenVideoPlayerItem(playableItem)
    
end sub


' Helper function finds child node by specified contentId
function FindNodeById(content as Object, contentId as String) as Object
    for each element in content.GetChildren(-1, 0)
        if element.id = contentId
            return element
        else if element.getChildCount() > 0
            result = FindNodeById(element, contentId)
            if result <> invalid
                return result
            end if
        end if
    end for
    return invalid
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

sub PlayVideoById(videoId as String)
    ' Create the content node
    content = CreateObject("roSGNode", "ContentNode")
    content.AddFields({
        HandlerConfigGrid: {
            name: "RootHandler"
        }
    })
    ' Find the video content by id
    videoContent = FindVideoContentById(content, videoId)
    if videoContent <> invalid
        videoView = OpenVideoPlayerItem(videoContent)
        videoView.ObserveField("wasClosed", "OnVideoWasClosed")
    else
        ? "Video not found: "; videoId
    end if
end sub


function FindVideoContentById(content as Object, videoId as String) as Object
    for each item in content.GetChildren()
        if item.id = videoId
            return item
        end if
    end for
    return invalid
end function 



