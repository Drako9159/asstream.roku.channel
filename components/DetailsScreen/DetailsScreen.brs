' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' entry point of detailsScreen
function Init()
    ' observe "visible" so we can know when DetailsScreen change visibility
    m.top.ObserveField("visible", "OnVisibleChange")
    ' observe "itemFocused" so we can know when another item gets in focus
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")

    ' save a references to the DetailsScreen child components in the m variable
    ' so we can access them easily from other functions
    m.buttons = m.top.FindNode("buttons")
    m.poster = m.top.FindNode("poster")
    m.description = m.top.FindNode("descriptionLabel")
    m.timeLabel = m.top.FindNode("timeLabel")
    m.titleLabel = m.top.FindNode("titleLabel")
    m.releaseLabel = m.top.FindNode("releaseLabel")

    m.backdrop = m.top.FindNode("backdrop")
    m.backdround_poster = m.top.FindNode("background_poster")


    ' create buttons
    result = []
    for each button in ["Reproducir"] ' buttons list contains only "Play" button for now
        result.Push({ title: button })
    end for
    m.buttons.content = ContentListToSimpleNode(result) ' set list of buttons for DetailsScreen


end function



function OnVisibleChange()
    if m.top.visible
        m.buttons.itemSelected = -1
        m.top.buttonSelected = -1
        m.buttons.setFocus(true)
        m.buttons.color = "0xFF0000FF"
    end if

end function

' Populate content details information
sub SetDetailsContent(content as object)
    m.description.text = content.description ' set description of content
    m.poster.uri = content.hdPosterUrl ' set url of content poster

    'm.backdrop.uri = "pkg:/images/background_back.jpg"
    m.backdrop.uri = content.hdBackdropURL


    m.timeLabel.text = GetTime(content.length) ' set length of content
    m.titleLabel.text = content.title ' set title of content
    m.releaseLabel.text = content.releaseDate ' set release date of content
end sub

sub OnJumpToItem() ' invoked when jumpToItem field is populated
    content = m.top.content
    ' check if jumpToItem field has valid value
    ' it should be set within interval from 0 to content.Getchildcount()
    if content <> invalid and m.top.jumpToItem >= 0 and content.GetChildCount() > m.top.jumpToItem
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub

sub OnItemFocusedChanged(event as object)' invoked when another item is focused
    focusedItem = event.GetData() ' get position of focused item
    content = m.top.content.GetChild(focusedItem) ' get metadata of focused item
    SetDetailsContent(content) ' populate DetailsScreen with item metadata
end sub

' The OnKeyEvent() function receives remote control key events
function OnkeyEvent(key as string, press as boolean) as boolean
    result = false
    if press
        currentItem = m.top.itemFocused ' position of currently focused item
        ' handle "left" button keypress
        if key = "left"
            ' navigate to the left item in case of "left" keypress
            m.top.jumpToItem = currentItem - 1
            result = true
            ' handle "right" button keypress
        else if key = "right"
            ' navigate to the right item in case of "right" keypress
            m.top.jumpToItem = currentItem + 1
            result = true
        end if
    end if
    return result
end function