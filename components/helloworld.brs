sub init()
    setupRefs()
    createContent()
end sub

sub setupRefs()
    top = m.top
    m.scrollingContainer = top.findNode("scrollingContainer")
end sub

sub createContent()
    ' build the list based on content nodes that return boudaries (width, height, focused width and height, label size) and do the calculations based on that
    content = buildContent()

    scrollingComponentConfig = {
        itemsContent: content
        infiniteScrolling: false
    }

    m.scrollingContainer.config = scrollingComponentConfig
    m.scrollingContainer.setFocus(true)
end sub

function buildContent() as object
    content = CreateObject("roSGNode", "ContentNode")

    ' append hero
    heroContentNode = createObject("roSGNode", "ContentNode")
    heroContentNode.update({type: "hero", id: "hero"}, true)
    content.appendChild(heroContentNode)

    ' append row
    for i = 0 to 2
        rowContentNode = createObject("roSGNode", "ContentNode")
        rowContentNode.update({type: "row", id: substitute("row{0}", str(i).trim())}, true)
        content.appendChild(rowContentNode)
    end for

    ' append banner
    bannerContentNode = createObject("roSGNode", "ContentNode")
    bannerContentNode.update({type: "banner", id: "banner"}, true)
    content.appendChild(bannerContentNode)

    ' append more rows
    for i = 3 to 7
        rowContentNode = createObject("roSGNode", "ContentNode")
        rowContentNode.update({type: "row", id: substitute("row{0}", str(i).trim())}, true)
        content.appendChild(rowContentNode)
    end for

    return content
end function
