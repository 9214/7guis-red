Red [
	Title:  "Timer"
	Number: 4
	Author: @9214
	Date:   29/10/2019
	Needs:  View
]

set [start limit] reduce [now/time/precise 0:0:20]

view [
	title "Timer"
	below
	elapsed: progress
	text rate 0:0:0.01 on-time [
		time: now/time/precise - start
		if 100% > elapsed/data: time / duration/extra [face/data: round time]
	]
	duration: slider 50% react [face/extra: face/data * limit]
	button "Reset" [start: now/time/precise]
]
