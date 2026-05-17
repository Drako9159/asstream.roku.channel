sub init()
    m.number = m.top.findNode("number")
    m.bg = m.top.findNode("bg")
end sub

sub onContentChange()
    if m.top.itemContent <> invalid
        m.number.text = m.top.itemContent.title
    end if
end sub
