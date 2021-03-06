Red [
	Title:  "Flight Booker"
	Number: 3
	Author: @9214
	Date:   29/10/2019
	Needs:  View
]

view [
	title "Flight Booker"
	style date: field
		data now/date + random 365
		on-key-up [face/color: unless date? face/data [red]]
	below
	option: drop-list data ["one-way flight" "return flight"] select 1
	one-way: date
	two-way: date react [face/enabled?: option/selected = 2]
	button "Book"
		on-click [
			view [
				title "Confirmation"
				text data reduce [
					"You have booked a"
					rejoin [pick [two one] two-way/enabled? "-way flight:"]
					one-way/data
					rejoin skip [slash space two-way/data] pick 0x3 two-way/enabled?
				]
			]
		]
		react [
			face/enabled?: all [
				date? one-way/data
				date? two-way/data
				any [
					not two-way/enabled?
					all [one-way/data <= two-way/data option/selected = 2]
				]
			]
		]
]
