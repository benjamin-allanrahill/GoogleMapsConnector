// Use this file to write queries to test your data connector

let
    /*
    Source = Json.Document(File.Contents("C:\Users\ballanrahill\source\repos\GoogleMapsConnector\GoogleMapsConnector\config.json")),
    #"Converted to Table" = Record.ToTable(Source),
    Name = #"Converted to Table"{0}[Name],
    API_KEY = #"Converted to Table"{0}[Value] as text,
    */
    result = GoogleMapsConnector.Contents("California", "Florida")
in
    result