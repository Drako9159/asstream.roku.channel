sub init()
    m.pinLabel = m.top.findNode("pinLabel")
    m.numberGrid = m.top.findNode("numberGrid")
    m.instructionLabel = m.top.findNode("instructionLabel")
    m.qrCodePoster = m.top.findNode("qrCodePoster")
    m.qrCodePoster.visible = true

   
    
    appInfo = CreateObject("roAppInfo")
    m.securityCode = appInfo.GetValue("security_code")
    if m.securityCode = invalid then m.securityCode = ""
    m.enteredPin = ""
    
    content = CreateObject("roSGNode", "ContentNode")
    for i = 1 to 9
        item = CreateObject("roSGNode", "ContentNode")
        item.title = i.ToStr()
        content.appendChild(item)
    end for
    
    itemClear = CreateObject("roSGNode", "ContentNode")
    itemClear.title = "CLR"
    content.appendChild(itemClear)
    
    item0 = CreateObject("roSGNode", "ContentNode")
    item0.title = "0"
    content.appendChild(item0)
    
    itemDel = CreateObject("roSGNode", "ContentNode")
    itemDel.title = "DEL"
    content.appendChild(itemDel)
    
    m.numberGrid.content = content
    m.numberGrid.observeField("itemSelected", "onNumberSelected")
    m.top.observeField("focusedChild", "onFocusChange")

   

end sub




sub onFocusChange()
    if m.top.hasFocus() then
        m.numberGrid.setFocus(true)
    end if
end sub

sub onNumberSelected()
    idx = m.numberGrid.itemSelected
    item = m.numberGrid.content.getChild(idx)
    
    if item.title = "CLR" then
        m.enteredPin = ""
    else if item.title = "DEL" then
        if Len(m.enteredPin) > 0 then
            m.enteredPin = left(m.enteredPin, Len(m.enteredPin) - 1)
        end if
    else
        m.enteredPin = m.enteredPin + item.title
    end if
    
    ' Update display with asterisks
    displayStr = ""
    for i = 1 to Len(m.enteredPin)
        displayStr = displayStr + "* "
    end for
    m.pinLabel.text = displayStr
    
    if Len(m.enteredPin) = Len(m.securityCode) then
        if m.enteredPin = m.securityCode then
            m.pinLabel.text = "¡Correcto!"
            m.top.unlocked = true
        else
            m.enteredPin = ""
            m.pinLabel.text = "Código incorrecto. Intente de nuevo."
        end if
    end if
end sub
