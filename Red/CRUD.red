Red [
    Title:  "CRUD"
    Number: 5
    Author: 9214
    Date:   29/10/2019
    Needs:  View
]

model: deep-reactor [
    data: [
        [name "Hans"  surname "Emil"]
        [name "Max"   surname "Mustermann"]
        [name "Roman" surname "Tisch"]
    ]
    format: func [entry][rejoin [entry/name comma space entry/surname]]
    construct: func [name surname][reduce ['name name 'surname surname]]
    view: is [collect [foreach entry data [keep format entry]]]
]

; disable OS-specific 'Cancel' button layout
system/view/VID/GUI-rules/active?: no
view [
    title "CRUD"
    text "Filter prefix:"
    prefix: field
    return
    list: text-list 170x200
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
                    if any [
						empty? prefix/text
						find/match database/1/surname prefix/text
					][
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
            append/only model/data model/construct copy name/text copy surname/text
        ]
    ]
    update: button "Update" [
        entry: list/extra/1
        list/selected: none
        case/all [
            not empty? name/text [entry/name: copy name/text]
            not empty? surname/text [entry/surname: copy surname/text]
        ]
        ; force MODEL/VIEW update
        append model/data []
    ]
    delete: button "Delete" [remove list/extra]
    react [update/enabled?: delete/enabled?: to logic! list/selected]
]
