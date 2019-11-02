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
        parse expression: next copy/deep face/data rule: [
            any [
                ahead [any-list! into rule | set match word!]
                if (cell? get/any match)
                change only skip (make path! reduce [match 'data])
                | skip
            ]
        ]
        formula: copy face/text
        face/data: none
        if set/any 'result math/safe expression [
            face/extra/formula: formula face/text: mold :result
        ]
    ]
]

set [label! cell!] layout/only [
    base silver center middle
    field right font-size 8
        on-focus [face/color: linen]
        on-unfocus [
            face/color: none
            either face/data [
                if formula? face/text [face/text: face/extra/old]
            ][
                face/extra/formula: none
            ]
        ]
        on-enter [if formula? face/text [process face]]
        on-dbl-click [
            if face/extra/formula [
                face/extra/old: copy face/text
                face/text: copy face/extra/formula
            ]
        ]
]

shape: 5x9
grid: reduce collect [
    repeat y shape/y + 1 [
        repeat x shape/x + 1 [
            row: y - 1
            column: #"A" + x - 2
            type: get pick [label! cell!] to logic! any [x = 1 y = 1]
            face: keep make type [
                size: 60x20
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
