Red [
    Title: "Circle Drawer"
    Description: "Solution to one of the 7GUIs tasks"
    Number: 6
    Author: 9214
    Date:   30/10/2019
]

; TBD: make history global, instead of keeping it as persistent state for each circle

settings: [
    radius [default 20 max 70]
    color  [default glass selected gray]
    canvas [size 640x480]
]

distance: func [this that][
    square-root add
        power that/x - this/x 2
        power that/y - this/y 2
]

view [
    title "Circle Drawer"
    below center
    panel [
        button "Undo" [
            if value? 'selected [
                selected/radius: first selected/history: back selected/history
            ]
        ]
        button "Redo" [
            if all [value? 'selected not last? selected/history][
                selected/radius: first selected/history: next selected/history
            ]
        ]
    ]
    canvas: base with [size: settings/canvas/size] white all-over
        extra make block! 32
        draw reduce ['box 0x0 settings/canvas/size - 1]
        on-over [
            foreach circle face/extra [
                circle/color: either circle/radius > distance event/offset circle/center [
                    latest: circle
                    circle/selected?: yes
                    settings/color/selected
                ][  
                    circle/selected?: no
                    settings/color/default
                ]
            ]
        ]
        on-down [
            append face/extra object [
                radius: settings/radius/default
                center: event/offset
                color: settings/color/default
                history: next reduce [0 radius]
                selected?: no

                stroke: compose [fill-pen (color) circle (center) (radius)]
                append face/draw stroke
                position: skip tail face/draw negate length? stroke
                
                on-change*: func [word old new][
                    switch word [
                        radius [position/5: new]
                        color  [position/2: new]
                    ]
                ]
            ]
        ]
        on-alt-down [
            if all [value? 'latest latest/selected?][
                view/flags [
                    title "Parameters"
                    on-close [
                        ; my first GC, yay!
                        if all [value? 'selected zero? selected/radius][
                            remove find/same canvas/extra selected
                        ]
                        selected: latest
                    ]
                    below
                    text data rejoin ["Adjust diameter of a circle at" space latest/center]
                    slider
                        data to percent! latest/radius / to float! settings/radius/max
                        on-change [latest/radius: settings/radius/max * face/data]
                        on-up [
                            unless zero? latest/radius [
                                latest/history: back clear insert next latest/history latest/radius
                            ]
                        ]
                ][
                    no-min no-max
                ]
            ]
        ]
]