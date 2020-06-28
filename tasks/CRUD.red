Red [
	Title:  "CRUD"
	Number: 5
	Author: @9214
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

system/view/VID/GUI-rules/active?: no

view [
	title "CRUD"
	text "Filter prefix:"
	prefix: field
	return
	list: text-list 170x200
		on-alt-down [face/selected: none]
		on-change [
			unless zero? face/selected [
				face/extra: at model/data index? find/same
					model/view
					pick face/data face/selected
			]
		]
		react [
			database: model/data
			face/data: sort collect [
				forall database [
					if any [
						empty? prefix/text
						find/match database/1/surname prefix/text
					][
						keep pick model/view index? database
					]
				]
			]
			if empty? face/data [face/selected: none]
		]
	panel [
		text "Name:" name: field return
		text "Surname:" surname: field return
	]
	return
	button "Create" [
		unless any [empty? name/text empty? surname/text][
			append/only model/data model/construct
				copy name/text
				copy surname/text
		]
	]
	update: button "Update" [
		list/selected: none
		foreach field [name surname][
			unless empty? entry: select get field 'text [
				list/extra/1/:field: copy entry  
			]
		]
	]
	delete: button "Delete" [remove list/extra]
	react [update/enabled?: delete/enabled?: make logic! list/selected]
]
