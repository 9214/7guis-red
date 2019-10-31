Red [
    Title: "Temperature Converter"
    Number: 2
    Author: 9214
    Date:   29/10/2019
    Needs:  View
]

view [
    title "Temperature Converter"
    celsius: field react [if number? face/data [farenheit/data: face/data * (9.0 / 5.0) + 32.0]]
    text "Celsius ="
    farenheit: field react [if number? face/data [celsius/data: face/data - 32.0 * (5.0 / 9.0)]]
    text "Farenheit"
]
