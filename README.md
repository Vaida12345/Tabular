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
