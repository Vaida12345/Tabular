## Example

Similar to `Codable`, we start by defining the keys (columns).
```swift
enum TabularKeys: String, TabularKey {
    case timeStamp
    case value
}
```
> Note:
> The `rawValue` will be used as column names.

Then, we can create an empty table
```swift
var table = Tabular<TabularKeys>()
```

To add rows to the table, use `append(_:)`, or the shorthand:
```swift
table.append { row in
    row[.timeStamp] = String(measurement.timeSinceSampleStart)
    row[.value] = String(describing: voltageQuantity)
}
```
The type of cells can only be `String`.

Last but not least, save the table as `csv`.
```swift
try table.write(to: .documentsDirectory/"\(sample.startDate.description).csv")
```

Also featuring beautifully printed tables
```swift
print(exampleTable)
┏━━━━━━┳━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━┓
┃ Year ┃ Make  ┃                 Model                  ┃      Description       ┃  Price  ┃
┡━━━━━━╇━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━┩
│ 1997 │ Ford  │ E350                                   │ ac, abs, moon          │ 3000.00 │
│ 1999 │ Chevy │ Venture "Extended Edition"             │                        │ 4900.00 │
│ 1999 │ Chevy │ Venture "Extended Edition, Very Large" │                        │ 5000.00 │
│ 1996 │ Jeep  │ Grand Cherokee                         │ MUST SELL!             │ 4799.00 │
│      │       │                                        │ air, moon roof, loaded │         │
└──────┴───────┴────────────────────────────────────────┴────────────────────────┴─────────┘
```
