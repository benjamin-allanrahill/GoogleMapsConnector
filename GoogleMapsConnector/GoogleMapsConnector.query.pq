// Use this file to write queries to test your data connector

let
    /*
    Source = Json.Document(File.Contents("C:\Users\ballanrahill\source\repos\GoogleMapsConnector\GoogleMapsConnector\config.json")),
    #"Converted to Table" = Record.ToTable(Source),
    Name = #"Converted to Table"{0}[Name],
    API_KEY = #"Converted to Table"{0}[Value] as text,
    */
    t = Table.FromColumns(
    {
        {"Bangor, ME", "Orono, ME", "Portland, ME"}, { "Florida", "Texas", "Boston"}
    },
    {"Origin", "Destination"}
    ),
    result = GoogleMapsConnector.Contents(t)
in
    result