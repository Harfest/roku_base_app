sub init()
    setupObservers()
end sub

sub setupObservers()
    m.top.observeField("focusedChild", "focused")
end sub

sub focused(evt as object)
    hasFocus = m.top.hasFocus()
    if hasFocus
        m.top.opacity = 1
        ?"Focused on: " m.top.itemIndex
    else
        m.top.opacity = 0.5
        ?"Unfocused from: " m.top.itemIndex
    end if
end sub
