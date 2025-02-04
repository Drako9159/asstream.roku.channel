function IsDeepLinking(args as Object)
    ' check if deep linking args is valid
    return args <> invalid and args.mediatype <> invalid and args.mediatype <> "" and args.contentID <> invalid and args.contentID <> "" 
end function

sub PerformDeepLinking(args as Object)
    ' Validar si se pasó contenido para deep linking
    if IsDeepLinking(args) then

        print "Media type: "; args.mediatype
        print "Content ID: "; args.contentID

        m.deepLinkingArgs = args
        m.grid.ObserveField("content", "implementDeepLinking")
        
    else
        ' Si los argumentos son inválidos, igualmente redirigir a la pantalla principal
        ShowGridComponent()
    end if
end sub

sub implementDeepLinking()
    args = m.deepLinkingArgs
    if IsDeepLinking(args) then
        ' Extract the mediaType and contentId
        mediaType = args.mediatype
        contentId = args.contentID

        playableItem = FindNodeById(m.grid.content, contentId)
        ' print "Playable item: "; playableItem

        ' Handle deep linking based on mediaType
        if playableItem <> invalid and mediaType = "movie" then
            ' Navigate to the movie screen with the specified contentId
            OpenVideoPlayerItem(playableItem)
            
        else if playableItem <> invalid and mediaType = "series" then
            ' Navigate to the series screen with the specified contentId
            OpenVideoPlayerItem(playableItem)

        else if playableItem <> invalid and mediaType = "shortFormVideo" then
            ' Navigate to the series screen with the specified contentId
            OpenVideoPlayerItem(playableItem)
        else
            ' Unknown mediaType; show error or default screen
            ' showErrorScreen("Unsupported media type: " + mediaType)
            ShowGridComponent()
        end if
    else
        ' If args are invalid, navigate to the home screen or show an error
        ' showErrorScreen("Invalid deep linking arguments")
        ShowGridComponent()
    end if
end sub


' Helper function finds child node by specified contentId
function FindNodeById(content as Object, videoId as String) as Object
    for each element in content.GetChildren(-1, 0)
        if element.id = videoId
            return element
        else if element.getChildCount() > 0
            result = FindNodeById(element, videoId)
            if result <> invalid
                return result
            end if
        end if
    end for
    return invalid
end function