Red [
    Title: "Timer"
    Number: 4
    Author: 9214
    Date:   29/10/2019
    Needs:  View
]

format: func [value][
    value: form to float! value
    rejoin [take/part value skip find/tail value dot 2 space "sec."]
]

set [limit rate][0:0:20 0:0:0.001]

reset: does [
    timer/extra: now/time/precise
    timer/rate: rate
]

view/flags [
    title "Timer"
    below
    progress react later [
        face/data: subtract 100% duration/extra - timer/data / duration/extra
        if timer/data >= duration/extra [timer/rate: none]
    ]
    timer: base 0x0 rate rate on-time [
        face/data: now/time/precise - timer/extra
        estimation/text: format face/data
    ]
    estimation: text
    duration: slider 50% 
        on-change [unless timer/data >= duration/extra [timer/rate: rate]]
        react [face/extra: face/data * limit]
    button "Reset" [reset]
    do [reset]
][
    no-min no-max
]
