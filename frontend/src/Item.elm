module Item exposing
    ( decodeImage
    , decodeItem
    , decodeItemLocation
    , decodeItemLocationMetadata
    , decodeVideo
    , toLocationUrl
    , decodeLocations
    , toLocationsUrl
    )

import Http
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Types exposing (..)
import Url.Builder


decodeItem : Json.Decode.Decoder Item
decodeItem =
    Json.Decode.succeed Item
        |> Json.Decode.Pipeline.required "status" Json.Decode.string
        |> Json.Decode.Pipeline.required "location" decodeItemLocation

decodeLocations : Json.Decode.Decoder Locations
decodeLocations =
    Json.Decode.succeed Locations
        |> Json.Decode.Pipeline.required "locations" (Json.Decode.list decodeItemLocationMetadata)


decodeItemLocationMetadata : Json.Decode.Decoder ItemLocationMetadata
decodeItemLocationMetadata =
    Json.Decode.succeed ItemLocationMetadata
        |> Json.Decode.Pipeline.required "id" Json.Decode.string
        |> Json.Decode.Pipeline.required "title" Json.Decode.string
        |> Json.Decode.Pipeline.required "about" Json.Decode.string
        |> Json.Decode.Pipeline.required "description" Json.Decode.string
        |> Json.Decode.Pipeline.required "hero_image" Json.Decode.string
        |> Json.Decode.Pipeline.required "x" Json.Decode.float
        |> Json.Decode.Pipeline.required "y" Json.Decode.float


decodeItemLocation : Json.Decode.Decoder ItemLocation
decodeItemLocation =
    Json.Decode.succeed ItemLocation
        |> Json.Decode.Pipeline.required "metadata" decodeItemLocationMetadata
        |> Json.Decode.Pipeline.required "panoramas" (Json.Decode.list decodeImage)
        |> Json.Decode.Pipeline.required "videos" (Json.Decode.list decodeVideo)
        |> Json.Decode.Pipeline.required "quad-videos" (Json.Decode.list decodeVideo)
        |> Json.Decode.Pipeline.required "slideshows" (Json.Decode.list decodeImage)
        |> Json.Decode.Pipeline.required "cached" Json.Decode.bool


decodeImage : Json.Decode.Decoder Image
decodeImage =
    Json.Decode.succeed Image
        |> Json.Decode.Pipeline.required "image" Json.Decode.string
        |> Json.Decode.Pipeline.required "caption" Json.Decode.string


decodeVideo : Json.Decode.Decoder Video
decodeVideo =
    Json.Decode.succeed Video
        |> Json.Decode.Pipeline.required "kind" Json.Decode.string
        |> Json.Decode.Pipeline.required "poster" Json.Decode.string
        |> Json.Decode.Pipeline.required "caption" Json.Decode.string
        |> Json.Decode.Pipeline.required "video" Json.Decode.string


env =
    "production"

whatIsTheCorrectServer =
    if env == "development" then
        "http://localhost:8081"
    else
        "http://dev.himalayanacademy.com/virtualtour/index.php"
      


toLocationUrl : String -> String
toLocationUrl location =
    Url.Builder.crossOrigin whatIsTheCorrectServer 
        [ "location", location ]
        []

toLocationsUrl :  String
toLocationsUrl =
    Url.Builder.crossOrigin whatIsTheCorrectServer 
        [ "locations" ]
        []
