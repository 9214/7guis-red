Red [
    Title:  "Cells"
    Number: 7
    Author: 9214
    Date:   31/10/2019
    Needs:  View
]

formula?: func [text][all [string? text #"=" = first trim/head copy text]]
cell?: func [value [any-type!]][
    all [object? :value equal? class-of value class-of cell!]
]

process: function [face /local match][
    cell: [set match word! if (cell? get/any match)]
    parse expression: next copy/deep face/data rule: [
        any [
            ahead paren! into rule
            | change only cell (make path! reduce [match 'data])
            | skip
        ]
    ]
    face/extra/formula: copy face/text
    face/data: none
    if face/extra/relation [react/unlink face/extra/relation 'all]
    face/extra/relation: reduce [
        to set-path! reduce [face/extra/name 'text]
        'mold/only 'math/safe expression
    ]
    expression: react face/extra/relation
    react/unlink face/extra/relation face
    unless expression [do face/extra/relation]
]

layout [
    label!: base silver center middle
    cell!: field right font-size 8
        on-focus [face/color: linen]
        on-unfocus [
            face/color: if face/extra/relation [mint + 111]
            if all [face/extra/value formula? face/text][
                face/text: face/extra/value
            ]
        ]
        on-enter [
            if formula? face/text [process face]
            if all [
                face/extra/formula
                empty? face/extra/formula
                face/extra/relation
            ][
                react/unlink face/extra/relation 'all
                face/extra/relation: none
            ]
        ]
        on-dbl-click [
            if face/extra/formula [
                face/extra/value: copy face/text
                face/text: face/extra/formula
            ]
        ]
]

shape: 5x9
grid: reduce collect [
    repeat y shape/y + 1 [
        repeat x shape/x + 1 [
            set [row column] reduce [y - 1 #"A" + x - 2]
            type: get pick [label! cell!] to logic! any [x = 1 y = 1]
            face: keep make type [
                size: 80x20
                offset: subtract 1 + size * as-pair x y size
                text: case [
                    all [x = 1 y = 1] none
                    x = 1 [form row]
                    y = 1 [form column]
                ]
                extra: object [relation: formula: value: name: none]
            ]
            unless any [column < #"A" zero? row][
                set face/extra/name: to word! rejoin [column row] face
            ]
        ]
    ]
]

view make face! [
    text: "Cells"
    type: 'window
    size: face/offset + face/size
    pane: grid
]
