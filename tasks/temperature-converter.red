Red [
	Title:  "Temperature Converter"
	Number: 2
	Author: @9214
	Date:   29-Oct-2019
	Needs:  View
]

view [
	title "Temperature Converter"
	celsius: field on-key-up [
		if number? face/data [fahrenheit/data: face/data * 9 / 5 + 32]
	]
	text "Celsius ="
	fahrenheit: field on-key-up [
		if number? face/data [celsius/data: face/data - 32 * 5 / 9]
	]
	text "Fahrenheit"
]
