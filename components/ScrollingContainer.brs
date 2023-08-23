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
        if m.focusedIndex = m.availableItemsCount and m.infiniteScrolling then m.focusedIndex = 0
        if m.focusedIndex = m.availableItemsCount and not m.infiniteScrolling then m.focusedIndex = m.availableItemsCount - 1
        handled = true
    else if key = "up"
        m.focusedIndex--
        if m.focusedIndex < 0 and m.infiniteScrolling then m.focusedIndex = m.availableItemsCount - 1
        if m.focusedIndex < 0 and not m.infiniteScrolling then m.focusedIndex = 0
        handled = true
    end if

    if currentFocusedIndex <> m.focusedIndex and handled
        currentFocusedItem = m.itemsContainer.getChild(currentFocusedIndex)
        currentFocusedItem.setFocus(false)
        currentFocusedItem = m.itemsContainer.getChild(m.focusedIndex)
        currentFocusedItem.setFocus(true)
    end if

    return handled
end function

' sub morph(state, morphs)
'     if TypeGuard_isStringEmpty(state) then return
'     if TypeGuard_isEmptyAssocArray(morphs) then return

'     options = morphs[state]
'     if TypeGuard_isEmptyAssocArray(options) then return

'     animationOptions = []

'     for each nodeOptions in options.items()
'         nodeId = nodeOptions.key
'         node = m.top.findNode(nodeId)
'         nodeMorphOptions = nodeOptions.value
'         nodeAnimationOptions = []

'         if TypeGuard_isNode(node)
'             for each fieldOptions in nodeMorphOptions.items()
'                 fieldName = fieldOptions.key
'                 oldValue = node[fieldName]
'                 newValue = fieldOptions.value

'                 ' Recast all numbers to be floats
'                 if TypeGuard_isNumber(oldValue)
'                     oldvalue = CommonUtils_recast(oldValue, "float")
'                 end if

'                 if TypeGuard_isNumber(newValue)
'                     newValue = CommonUtils_recast(newValue, "float")
'                 end if

'                 if fieldName = "color" or fieldName = "blendColor"
'                     newValueClean = CommonUtils_stringReplace(newValue, "#", "")
'                     newValue = val(newValueClean, 16)
'                     oldReValue% = node[fieldName]
'                     oldValue = oldReValue%
'                 end if

'                 if type(oldValue) = type(newValue) and oldValue <> newvalue
'                     optionsObject = {
'                         field: fieldName
'                         keyValue: [oldValue, newValue]
'                     }
'                     nodeAnimationOptions.push(optionsObject)
'                 end if
'             end for

'             if nodeAnimationOptions.count() > 0
'                 optionsObject = "{{%- o(Animations.morphTemplate) %}}"
'                 optionsObject.nodeId = nodeId
'                 optionsObject.state = state
'                 optionsObject.options = nodeAnimationOptions
'                 animationOptions.push(optionsObject)
'             end if
'         end if
'     end for

'     if animationOptions.count() > 0
'         animationId = constructAnimationId(state, animationOptions)

'         animation = m.animations[animationId]

'         if not TypeGuard_isNode(animation)
'             addAnimation(animationId, animationOptions)
'         end if

'         ' Rechecking just to be sure
'         animation = m.animations[animationId]
'         if not TypeGuard_isNode(animation) then return

'         animate(animationId)
'     end if
' end sub
