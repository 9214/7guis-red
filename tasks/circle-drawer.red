Red [
	Title:  "Circle Drawer"
	Number: 6
	Author: 9214
	Date:   30/10/2019
	Needs:  View
]

distance: func [this that][
	square-root add
		power that/x - this/x 2
		power that/y - this/y 2
]

history: object [
	timeline: make block! 16
	update: function [position new old /extern timeline][
		delta: reduce [position new old length? to block! new]
		insertion: back insert/only timeline delta
		timeline: remove/part head timeline insertion
	]
	undo: does [
		unless tail? timeline [
			delta: timeline/1
			change/part delta/1 delta/3 delta/4
			timeline: next timeline
		]
	]
	redo: does [
		unless head? timeline [
			timeline: back timeline
			delta: timeline/1
			change/part delta/1 delta/2 delta/4
		]
	]
]

set [default maximum stroke][20 70 [fill-pen glass circle (event/offset) (default)]]

view [
	title "Circle Drawer"
	below center
	panel [
		button "Undo" [history/undo]
		button "Redo" [history/redo]
	]
	canvas: base white 640x480 all-over draw make block! 16
		on-over [
			forall circles [
				if number? circles/1 [
					within?: circles/1 > distance circles/-1 event/offset
					circles/-3: either within? [latest: circles gray][glass]
				]
			]
		]
		on-down [
			append face/draw compose bind stroke 'event
			history/update
				position: skip tail face/draw negate length? stroke
				copy position
				[]
		]
		on-alt-down [
			if latest/-3 = gray [
				old: first picked: latest
				view/flags [
					title "Adjust radius"
					on-close [unless old = picked/1 [history/update picked picked/1 old]]
					slider data picked/1 / to float! maximum [picked/1: maximum * face/data]
				][
					no-min no-max
				]
			]
		]
	do [circles: canvas/draw]
]
