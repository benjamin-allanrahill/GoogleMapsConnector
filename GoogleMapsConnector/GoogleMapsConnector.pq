// This file contains your Data Connector logic
section GoogleMapsConnector;

 API_KEY = Text.FromBinary(Extension.Contents("config.txt"));


[DataSource.Kind="GoogleMapsConnector", Publish="GoogleMapsConnector.Publish"]

// function to get the distance and duration for each column
GoogleMapsConnector.RowData = (origin as text, destination as text) =>
    let
        url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=" & origin & "&destinations=" & destination & "text)" & API_KEY,
        Source = Json.Document(Web.Contents(url, [Timeout=#duration(0,0,10,0)])),
        rows = Source[rows]

        /*
        ,
        #"Converted to Table" = Table.FromList(rows, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"elements"}, {"elements"}),
        #"Expanded elements" = Table.ExpandListColumn(#"Expanded Column1", "elements"),
        #"Expanded elements1" = Table.ExpandRecordColumn(#"Expanded elements", "elements", {"distance", "duration", "status"}, {"distance", "duration", "status"}),
        #"Expanded distance" = Table.ExpandRecordColumn(#"Expanded elements1", "distance", {"text", "value"}, {"text", "value"}),
        #"Expanded duration" = Table.ExpandRecordColumn(#"Expanded distance", "duration", {"text", "value"}, {"text.1", "value.1"}),
        #"Removed Columns" = Table.RemoveColumns(#"Expanded duration",{"value", "value.1", "status"}),
        #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"text", "Distance"}, {"text.1", "Duration"}})
    in
        #"Renamed Columns";
        */
    in
        rows;

//function get distance for each a column
shared GoogleMapsConnector.Contents = (locTable as table) => 
    let
       Table = Table.AddColumn(locTable, "Custom", each GoogleMapsConnector.RowData([Origin], [Destination]))
    in
        Table;
// Data Source Kind description
GoogleMapsConnector = [
    
    TestConnection = () => { "GoogleMapsConnector.Contents", "Bangor", "Orono"}, 
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
       // Windows = [],
        Anonymous  = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
GoogleMapsConnector.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = GoogleMapsConnector.Icons,
    SourceTypeImage = GoogleMapsConnector.Icons
];

GoogleMapsConnector.Icons = [
    Icon16 = { Extension.Contents("GoogleMapsConnector16.png"), Extension.Contents("GoogleMapsConnector20.png"), Extension.Contents("GoogleMapsConnector24.png"), Extension.Contents("GoogleMapsConnector32.png") },
    Icon32 = { Extension.Contents("GoogleMapsConnector32.png"), Extension.Contents("GoogleMapsConnector40.png"), Extension.Contents("GoogleMapsConnector48.png"), Extension.Contents("GoogleMapsConnector64.png") }
];
