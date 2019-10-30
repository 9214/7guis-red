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
update: does [
    history: remove/part head history back insert/only history copy canvas/draw
]


view [
    title "Circle Drawer"
    below center
    panel [
        button "Undo" [
            history: next history
            append clear canvas/draw any [history/1 history]
        ]
        button "Redo" [
            history: back history
            append clear canvas/draw any [history/1 history]
        ]
    ]
    canvas: base white 640x480 all-over
        draw make block! 16
        on-down [
            append face/draw compose [fill-pen glass circle (event/offset) 20]
            update
        ]
        on-over [
            forall circles [
                if number? circles/1 [
                    circles/-3: either circles/1 > distance circles/-1 event/offset [
                        active: circles
                        gray
                    ][  
                        active: none
                        glass
                    ]
                ]
            ]
        ]
        on-alt-down [
            if selected: active [
                view/flags [
                    title "Adjust radius"
                    on-close [update]
                    slider data selected/1 / to float! 70 [selected/1: 70 * face/data]
                ][no-min no-max]
            ]
        ]
    do [circles: canvas/draw]
]
