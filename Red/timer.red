Red [
    Title: "Timer"
    Number: 4
    Author: 9214
    Date:   29/10/2019
    Needs:  View
]

set [limit rate][0:0:10 0:0:0.001]

reset: does [
    duration/extra: duration/data * limit
    estimation/extra: now/time/precise
    estimation/rate: rate
]

view [
    title "Timer"
    below
    progress react later [
        face/data: subtract 100% duration/extra - estimation/data / duration/extra
    ]
    estimation: text on-time [
        face/data: now/time/precise - face/extra
        if estimation/data >= duration/extra [estimation/rate: none]
    ]
    duration: slider 50% [
        face/extra: face/data * limit
        unless estimation/data >= duration/extra [estimation/rate: rate]
    ]
    button "Reset" [reset]
    do [reset]
]
