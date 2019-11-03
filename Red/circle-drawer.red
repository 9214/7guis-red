Red [
    Title:  "Circle Drawer"
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

update: function [position new old /extern history][
    delta: reduce [position new old length? to block! new]
    insertion: back insert/only history delta
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
                delta: history/1
                change/part delta/1 delta/3 delta/4
                history: next history
            ]
        ]
        button "Redo" [
            unless head? history [
                history: back history
                delta: history/1
                change/part delta/1 delta/2 delta/4
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
                []
        ]
        on-over [
            forall circles [
                if number? circles/1 [
                    within?: circles/1 > distance circles/-1 event/offset
                    circles/-3: either within? [latest: circles gray][glass]
                ]
            ]
        ]
        on-alt-down [
            if latest/-3 = gray [
                old: first picked: latest
                view/flags [
                    title "Adjust radius"
                    on-close [unless old = picked/1 [update picked picked/1 old]]
                    slider data picked/1 / to float! maximum [picked/1: maximum * face/data]
                ][
                    no-min no-max
                ]
            ]
        ]
    do [circles: canvas/draw]
]
