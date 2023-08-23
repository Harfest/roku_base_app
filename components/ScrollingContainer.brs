sub init()
    m.focusedIndex = 0
    m.infiniteScrolling = false
    m.availableItemsCount = 0

    m.defaultConfig = {
        contentPadding: 0
        itemsBoundaries: []
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
    defaultItemFocused = m.itemsContainer.getChild(m.focusedIndex) ' focus on the first item (I'm not sure if at this moment the list is pouplated)
    defaultItemFocused.setFocus(true)
end sub

sub createItems(evt as object)
    config = evt.getData()
    m.defaultConfig.append(config)
    itemsBoundaries = m.defaultConfig.itemsBoundaries
    contentPadding = m.defaultConfig.contentPadding
    m.availableItemsCount = itemsBoundaries.count()
    m.infiniteScrolling = m.defaultConfig.infiniteScrolling

    initialPosition = 0
    initialPosition += contentPadding

    for itemIndex = 0 to m.availableItemsCount - 1
        item = itemsBoundaries[itemIndex]
        scrollingItem = m.itemsContainer.createChild("ScrollingItem")
        scrollingItem.id = str(itemIndex).trim()
        scrollingItem.itemIndex = itemIndex
        scrollingItem.translation = [contentPadding, initialPosition]
        scrollingItem.width = item.width
        scrollingItem.height = item.height
        scrollingItem.opacity = 0.5
        initialPosition += (item.height + item.margin)
    end for
end sub

function onKeyEvent(key as string, pressed as boolean) as boolean
    if not pressed then return false
    handled = false

    currentFocusedItem = m.itemsContainer.getChild(m.focusedIndex)
    currentFocusedItem.setFocus(false)

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

    currentFocusedItem = m.itemsContainer.getChild(m.focusedIndex)
    currentFocusedItem.setFocus(true)

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
