sub init()
    setupRefs()
    createContent()
end sub

sub setupRefs()
    top = m.top
    m.scrollingContainer = top.findNode("scrollingContainer")
end sub

sub createContent()
    itemsConfig = [
        { ' hero
            width: 1124
            height: 369
            margin: 6
        }
        { ' row
            width: 1124
            height: 150
            margin: 24
        }
        { ' row
            width: 1124
            height: 150
            margin: 24
        }
        { ' row
            width: 1124
            height: 150
            margin: 24
        }
        { ' banner
            width: 1124
            height: 0
            margin: 24
        }
        { ' row
            width: 1124
            height: 150
            margin: 24
        }
        { ' row
            width: 1124
            height: 150
            margin: 24
        }
        { ' row
            width: 1124
            height: 150
            margin: 24
        }
    ]

    scrollingComponentConfig = {
        contentPadding: 12
        itemsBoundaries: itemsConfig
        infiniteScrolling: true
    }

    m.scrollingContainer.config = scrollingComponentConfig
    m.scrollingContainer.setFocus(true)
end sub
