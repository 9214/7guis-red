Red [
    Title:  "CRUD"
    Number: 5
    Author: 9214
    Date:   29/10/2019
    Needs:  View
]

model: deep-reactor [
    data: [
        #(name: "Hans" surname: "Emil")
        #(name: "Max" surname: "Mustermann")
        #(name: "Roman" surname: "Tisch")
    ]
    format: func [entry][rejoin [entry/name comma space entry/surname]]
    construct: func [name surname][to map! compose [name: (name) surname: (surname)]]
    view: is [collect [foreach entry data [keep format entry]]]
]

; disable OS-specific 'Cancel' button layout
system/view/VID/GUI-rules/active?: no
view [
    title "CRUD"
    text "Filter prefix:"
    prefix: field
    return
    listbox: text-list 170x200
        on-alt-down [face/selected: none]
        on-change [
            face/extra: at model/data index? find/same
                model/view
                pick face/data face/selected
        ]
        react [
            database: model/data
            if empty? face/data: sort collect [
                forall database [
                    if any [empty? prefix/text find/match database/1/surname prefix/text][
                        keep pick model/view index? database
                    ]
                ]
            ][
                face/selected: none
            ]
        ]
    panel [
        text "Name:" name: field return
        text "Surname:" surname: field return
    ]
    return
    button "Create" [
        if all [name/data surname/data][
            append model/data model/construct copy name/text copy surname/text
        ]
    ]
    update: button "Update" [
        entry: listbox/extra/1
        listbox/selected: none
        case/all [
            not empty? name/text [entry/name: copy name/text]
            not empty? surname/text [entry/surname: copy surname/text]
        ]
        ; force MODEL/VIEW update (MAP! is not a reactive source)
        append model/data []
    ]
    delete: button "Delete" [remove listbox/extra]
    react [update/enabled?: delete/enabled?: to logic! listbox/selected]
]
