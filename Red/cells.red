Red [
    Title:  "Cells"
    Number: 7
    Author: 9214
    Date:   31/10/2019
    Needs:  View
]

formula?: func [text][all [text text/1 = #"="]]
cell?: func [value [any-type!]][
    to logic! all [object? :value equal? class-of value class-of cell!]
]

process: function [face /local match][
    if all [face/data series? face/data][
        formula: copy face/data
        parse expression: next copy formula [
            any [
                ahead [set match word!]
                if (cell? get/any match)
                change only skip (make path! reduce [match 'data])
                | skip
            ]
        ]
        face/data: none
        if face/data: math/safe expression [
            face/extra/old: face/data
            face/extra/formula: formula
        ]
    ]
]

set [label! cell!] layout/only [
    base silver center middle
    field
        on-focus [
            face/color: linen
            if face/extra/formula [
                face/extra/old: face/data
                face/data: face/extra/formula
            ]
        ]
        on-unfocus [
            face/color: none
            if all [face/extra/old face/extra/formula][face/data: face/extra/old]
        ]
        on-enter [if formula? face/text [process face]]
]

shape: 5x9
grid: reduce collect [
    repeat y shape/y + 1 [
        repeat x shape/x + 1 [
            row: y - 1
            column: #"A" + x - 2
            type: get pick [label! cell!] to logic! any [x = 1 y = 1]
            face: keep make type [
                size: 96x24
                offset: subtract 1 + size * as-pair x y size
                text: case [
                    all [x = 1 y = 1][none]
                    x = 1 [form row]
                    y = 1 [form column]
                ]
                extra: object [
                    formula: old: none
                ]
            ]
            unless any [column < #"A" zero? row][
                set to word! rejoin [column row] face
            ]
        ]
    ]
]

view make face! [
    text: "Cells"
    type: 'window
    size: face/offset + face/size + 1
    pane: grid
]
