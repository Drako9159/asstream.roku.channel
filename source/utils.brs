' Helper function convert AA to Node
function ContentListToSimpleNode(contentList as object, nodeType = "ContentNode" as string) as object
    result = CreateObject("roSGNode", nodeType) ' create node instance based on specified nodeType
    if result <> invalid
        ' go through contentList and create node instance for each item of list
        for each itemAA in contentList
            item = CreateObject("roSGNode", nodeType)
            item.SetFields(itemAA)
            result.AppendChild(item)
        end for
    end if
    return result
end function

' Helper function convert seconds to mm:ss format
' getTime(138) returns 2:18
function GetTime(length as integer) as string
    minutes = (length \ 60).ToStr()
    seconds = length mod 60
    if seconds < 10
        seconds = "0" + seconds.ToStr()
    else
        seconds = seconds.ToStr()
    end if
    return minutes + ":" + seconds
end function
