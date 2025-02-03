function IsDeepLinking(args as Object)
    ' check if deep linking args is valid
    return args <> invalid and args.mediaType <> invalid and args.mediaType <> "" and args.contentId <> invalid and args.contentId <> "" 
end function

sub PerformDeepLinking(args as Object)
    ' Validar si se pasó contenido para deep linking
    if IsDeepLinking(args) then


        print "Media type: "; args.mediaType
        print "Content ID: "; args.contentId


        ' implementDeepLinking(args) 
        m.deepLinkingArgs = args
        m.grid.ObserveField("content", "implementDeepLinking")


        ' navigateToGridScreen()
    else
        ' Si los argumentos son inválidos, igualmente redirigir a la pantalla principal
        navigateToGridScreen()
    end if
end sub



sub navigateToGridScreen()
    ' navigate to the grid screen
    m.top.ComponentController.CallFunc("show", {
        view: m.grid
    })

end sub


sub implementDeepLinking()
    args = m.deepLinkingArgs
    if IsDeepLinking(args) then
        ' Extract the mediaType and contentId
        mediaType = args.mediaType
        contentId = args.contentId

        ' Handle deep linking based on mediaType
        if mediaType = "movie" then
            ' Navigate to the movie screen with the specified contentId
            ' OpenVideoPlayerItem(contentId)
            playableItem = FindNodeById(m.grid.content, contentId)
            OpenVideoPlayerItem(playableItem)
            
        else if mediaType = "series" then
            ' Navigate to the series screen with the specified contentId
            
        else
            ' Unknown mediaType; show error or default screen
            ' showErrorScreen("Unsupported media type: " + mediaType)
        end if
    else
        ' If args are invalid, navigate to the home screen or show an error
        ' showErrorScreen("Invalid deep linking arguments")
    end if
end sub

