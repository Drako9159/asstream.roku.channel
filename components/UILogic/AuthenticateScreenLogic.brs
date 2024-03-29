
' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub ShowAuthenticateScreen()
    m.AuthenticateScreen = CreateObject("roSGNode", "AuthenticateScreen")
    m.AuthenticateScreen.ObserveField("rowItemSelected", "OnGridScreenItemSelectedAuthenticate")
    ShowScreen(m.AuthenticateScreen) ' show GridScreen
end sub

sub OnGridScreenItemSelectedAuthenticate(event as Object)
    grid = event.GetRoSGNode()
    ' extract the row and column indexes of the item the user selected
    m.selectedIndex = event.GetData()
    ' the entire row from the RowList will be used by the Video node
    rowContent = grid.content.GetChild(m.selectedIndex[0])
    ShowDetailsScreen(rowContent, m.selectedIndex[1])
end sub