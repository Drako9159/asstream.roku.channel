' Copyright (c) 2020 Roku, Inc. All rights reserved.

sub OnContentSet() ' invoked when item metadata retrieved
    content = m.top.itemContent
    ' set poster uri if content is valid
    if content <> invalid 
        m.top.FindNode("poster").uri = content.hdPosterUrl
        m.top.observeField("focused", "OnFocusedChanged")
    end if


    

end sub




sub OnFocusedChanged()
    ' Ajusta el tamaño del póster cuando se enfoca
    if m.top.focused
        m.top.poster.width = 200 ' Ajusta el nuevo ancho cuando se enfoca
        m.top.poster.height = 240 ' Ajusta el nuevo alto cuando se enfoca
    else
        ' Restablece el tamaño del póster cuando no está enfocado
        m.top.poster.width = 150 ' Ajusta el ancho normal
        m.top.poster.height = 180 ' Ajusta el alto normal
    end if
end sub
