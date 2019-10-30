Red [
    Title: "Circle Drawer"
    Description: "Solution to one of the 7GUIs tasks"
    Number: 6
    Author: 9214
    Date:   30/10/2019
]

distance: func [this that][
    square-root add
        power that/x - this/x 2
        power that/y - this/y 2
]

history: make block! 16
view [
    title "Circle Drawer"
    below center
    panel [
        button "Undo" [canvas/draw: first history: next history]
        button "Redo" [canvas/draw: first history: back history]
    ]
    canvas: base white 640x480 all-over
        draw make block! 16
        on-down [
            append face/draw compose [fill-pen glass circle (event/offset) 20]
            insert/only history copy face/draw
        ]
        on-over [
            forall circles [
                if number? circles/1 [
                    circles/-3: either circles/1 > distance circles/-1 event/offset [
                        active: circles gray
                    ][
                        glass
                    ]
                ]
            ]
        ]
        on-alt-down [
            selected: active
            view [
                title "Adjust radius"
                on-close [insert/only history copy canvas/draw]
                slider data selected/1 / to float! 70 [selected/1: 70 * face/data]
            ]
        ]
    do [circles: canvas/draw]
]
