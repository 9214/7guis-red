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

update: func [position new old][
    history: insert/only history reduce [position new old]
    history: remove/part head history back history
]

set [default maximum][20 70]

view [
    title "Circle Drawer"
    below center
    panel [
        button "Undo" [
            unless tail? history [
                change/part history/1/1 history/1/3 tail history/1/1
                history: next history
            ]
        ]
        button "Redo" [
            unless head? history [
                history: back history
                change/part history/1/1 history/1/2 tail history/1/1
            ]
        ]
    ]
    canvas: base white 640x480 all-over
        draw make block! 16
        on-down [
            append face/draw compose [fill-pen glass circle (event/offset) (default)]
            update
                position: skip tail face/draw -5
                copy position
                make block! 0
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
                    on-close [unless previous = selected/1 [update selected selected/1 previous]]
                    slider data selected/1 / to float! maximum [selected/1: maximum * face/data]
                ][no-min no-max]
            ]
        ]
    do [circles: canvas/draw]
]
