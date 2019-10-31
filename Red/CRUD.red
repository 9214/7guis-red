Red [
    Title: "CRUD"
    Number: 5
    Author: 9214
    Date:   29/10/2019
    Needs:  View
]

model: deep-reactor [
    prefix: none
    data: [
        #(name: "Hans" surname: "Emil")
        #(name: "Max" surname: "Mustermann")
        #(name: "Roman" surname: "Tisch")
    ]
    format: func [entry][rejoin [entry/name comma space entry/surname]]
    construct: func [name surname][to map! compose [name: (name) surname: (surname)]]
    view: is [
        collect [
            foreach entry data [
                if any [
                    not prefix
                    attempt [head? find/case entry/surname prefix]
                ][
                    keep format entry
                ]
            ]
        ]
    ]
]

; disable OS-specific 'Cancel' button layout
system/view/VID/GUI-rules/active?: no
view [
    title "CRUD"
    text "Filter prefix:"
    field react [model/prefix: all [face/data face/text]]
    return
    listbox: text-list 170x200
        on-alt-down [face/selected: none]
        on-change [face/extra: at model/data face/selected]
        react [face/data: model/view]
    panel [
        text "Name:" name: field return
        text "Surname:" surname: field return
    ]
    return
    button "Create" [
        all [
            name/data surname/data
            append model/data model/construct copy name/text copy surname/text
        ]
    ]
    button "Update" react [face/enabled?: to logic! listbox/selected][
        entry: listbox/extra/1
        all [
            name/data entry/name: copy name/text
            surname/data entry/surname: copy surname/text
        ]
        ; force MODEL/VIEW update (MAP! is not a reactive source)
        append model/data []
    ]
    button "Delete" react [face/enabled?: to logic! listbox/selected][
        remove listbox/extra
    ]
]
