Red [
    Title:  "Cells"
    Number: 7
    Author: 9214
    Date:   31/10/2019
    Needs:  View
]

set [label! cell!] layout/only [
    text pewter center middle
    field
        on-focus [face/color: linen]
        on-unfocus [face/color: none]
]

shape: 5x9
grid: reduce collect [
    repeat y shape/y + 1 [
        repeat x shape/x + 1 [
            type: get pick [label! cell!] to logic! any [x = 1 y = 1]
            last: keep make type [
                offset: subtract 1 + size * as-pair x y size
                data: case [
                    all [x = 1 y = 1][none]
                    x = 1 [y - 1]
                    y = 1 [#"@" + x - 1]
                ]
            ]
        ]
    ]
]

view make face! [
    text: "Cells"
    type: 'window
    size: last/offset + last/size + 1
    pane: grid
]
