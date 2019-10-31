Red [
    Title: "Circle Drawer"
    Number: 6
    Author: 9214
    Date:   30/10/2019
    Needs:  View
]

distance: func [this that][
    square-root add
        power that/x - this/x 2
        power that/y - this/y 2
]

history: make block! 16

update: func [position new old part /local insertion][
    insertion: back insert/only history reduce [position new old part]
    history: remove/part head history insertion
]

set [default maximum][20 70]

stroke: [fill-pen glass circle (event/offset) (default)]

view [
    title "Circle Drawer"
    below center
    panel [
        button "Undo" [
            unless tail? history [
                chunk: history/1
                change/part chunk/1 chunk/3 chunk/4
                history: next history
            ]
        ]
        button "Redo" [
            unless head? history [
                history: back history
                chunk: history/1
                change/part chunk/1 chunk/2 chunk/4
            ]
        ]
    ]
    canvas: base white 640x480 all-over
        draw make block! 16
        on-down [
            append face/draw compose bind stroke 'event
            update
                position: skip tail face/draw negate length? stroke
                copy position
                make block! 0
                tail face/draw
        ]
        on-over [
            forall circles [
                if number? circles/1 [
                    circles/-3: either circles/1 > distance circles/-1 event/offset [
                        latest: circles
                        gray
                    ][  
                        glass
                    ]
                ]
            ]
        ]
        on-alt-down [
            if latest/-3 = gray [
                previous: first selected: latest
                view/flags [
                    title "Adjust radius"
                    on-close [
                        unless previous = selected/1 [update selected selected/1 previous 1]
                    ]
                    slider data selected/1 / to float! maximum [selected/1: maximum * face/data]
                ][no-min no-max]
            ]
        ]
    do [circles: canvas/draw]
]
