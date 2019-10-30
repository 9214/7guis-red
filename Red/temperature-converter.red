Red [
    Title: "7GUIs task"
    Number: 2
    Author: 9214
    Date:   29/10/2019
]

view [
    title "Temperature Converter"
    celsius: field react [
        farenheit/data: any [attempt [face/data * (9.0 / 5.0) + 32.0] farenheit/data]
    ]
    text "Celsius ="
    farenheit: field react [
        celsius/data: any [attempt [face/data - 32.0 * (5.0 / 9.0)] celsius/data]
    ]
    text "Farenheit"
]
