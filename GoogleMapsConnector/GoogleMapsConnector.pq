// This file contains your Data Connector logic
section GoogleMapsConnector;

[DataSource.Kind="GoogleMapsConnector", Publish="GoogleMapsConnector.Publish"]
shared GoogleMapsConnector.Contents = (originList as text, destinationList as text, apiKey as text) =>
    let
        Source = Json.Document(Web.Contents("https://maps.googleapis.com/maps/api/distancematrix/" & "json?units=imperial" & "&origins=" & originList & "&destinations=" & destinationList & "&key=" & apiKey)),
        rows = Source[rows],
        #"Converted to Table" = Table.FromList(rows, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"elements"}, {"elements"}),
        #"Expanded elements" = Table.ExpandListColumn(#"Expanded Column1", "elements"),
        #"Expanded elements1" = Table.ExpandRecordColumn(#"Expanded elements", "elements", {"distance", "duration", "status"}, {"distance", "duration", "status"}),
        #"Expanded distance" = Table.ExpandRecordColumn(#"Expanded elements1", "distance", {"text", "value"}, {"text", "value"}),
        #"Expanded duration" = Table.ExpandRecordColumn(#"Expanded distance", "duration", {"text", "value"}, {"text.1", "value.1"}),
        #"Removed Columns" = Table.RemoveColumns(#"Expanded duration",{"value", "value.1", "status"}),
        #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"text", "Distance"}, {"text.1", "Time"}})
    in
        #"Renamed Columns";

// Data Source Kind description
GoogleMapsConnector = [
    TestConnection = (dataSourcePath) => 
        let
            json = Json.Document(dataSourcePath),
            origins = json[originList],
            destinations = json[destinationList]
        in
            { "GoogleMapsConnector.Conents", origins, destinations}, 
    Authentication = [
        Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
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
