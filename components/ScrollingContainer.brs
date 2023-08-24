sub init()
    m.focusedIndex = 0
    m.infiniteScrolling = false
    m.availableItemsCount = 0
    m.componentFocused = false

    m.defaultConfig = {
        itemsContent: {}
        infiniteScrolling: false
    }

    setupRefs()
    setupObservers()
end sub

sub setupRefs()
    top = m.top
    m.itemsContainer = top.findNode("itemsContainer")
end sub

sub setupObservers()
    m.top.observeField("focusedChild", "focused")
end sub

sub focused(evt as object)
    if not m.componentFocused
        defaultItemFocused = m.itemsContainer.getChild(m.focusedIndex)
        if defaultItemFocused = invalid then return
        defaultItemFocused.setFocus(true)
        m.componentFocused = true
    end if
end sub

sub createItems(evt as object)
    config = evt.getData()
    m.defaultConfig.append(config)
    contentItems = m.defaultConfig.itemsContent
    m.availableItemsCount = contentItems.getChildCount()
    m.infiniteScrolling = m.defaultConfig.infiniteScrolling
    xPosition = 0

    for itemIndex = 0 to m.availableItemsCount - 1
        item = contentItems.getChild(itemIndex)
        itemBoundaries = getItemBounds(item.type)
        xPosition += itemBoundaries.margin
        itemHeight = itemBoundaries.height + itemBoundaries.labelHeight

        scrollingItem = m.itemsContainer.createChild("ScrollingItem")
        scrollingItem.id = str(itemIndex).trim()
        scrollingItem.itemIndex = itemIndex
        scrollingItem.translation = [0, xPosition]
        scrollingItem.width = itemBoundaries.width
        scrollingItem.height = itemHeight
        scrollingItem.opacity = 0.5
        xPosition += (itemHeight + itemBoundaries.margin + itemBoundaries.bottomPadding)
    end for
end sub

function getItemBounds(itemType) as object
    bounds = {}

    if itemType = "hero"
        bounds = {
            "bottomPadding": 12,
            "height": 321,
            "labelHeight": 0,
            "margin": 12,
            "width": 1148
        }
    else if itemType = "row"
        bounds = {
            "bottomPadding": 12,
            "height": 120,
            "labelHeight": 30,
            "margin": 12,
            "width": 1148
        }
    else if itemType = "banner"
        bounds = {
            "bottomPadding": 12,
            "height": 291,
            "labelHeight": 30,
            "margin": 12,
            "width": 1148
        }
    end if

    return bounds
end function

function onKeyEvent(key as string, pressed as boolean) as boolean
    if not pressed then return false
    handled = false

    currentFocusedIndex = m.focusedIndex

    if key = "down"
        m.focusedIndex++
        if m.focusedIndex = m.availableItemsCount and m.infiniteScrolling
            m.focusedIndex = 0
            handled = true
        else if m.focusedIndex = m.availableItemsCount and not m.infiniteScrolling
            m.focusedIndex = m.availableItemsCount - 1
            handled = false
        else
            handled = true
        end if
    else if key = "up"
        m.focusedIndex--
        if m.focusedIndex < 0 and m.infiniteScrolling
            m.focusedIndex = m.availableItemsCount - 1
            handled = true
        else if m.focusedIndex < 0 and not m.infiniteScrolling
            m.focusedIndex = 0
            handled = false
        else
            handled = true
        end if
    end if

    if currentFocusedIndex <> m.focusedIndex and handled
        currentFocusedItem = m.itemsContainer.getChild(currentFocusedIndex)
        currentFocusedItem.setFocus(false)
        currentFocusedItem = m.itemsContainer.getChild(m.focusedIndex)
        currentFocusedItem.setFocus(true)
    end if

    return handled
end function
