module Types exposing
    ( Document
    , Image
    , Item
    , ItemLocation
    , ItemLocationMetadata
    , Video
    , brokenImage
    , brokenVideo
    , Locations
    )

import Browser
import Browser.Navigation as Navigation
import Html.Styled exposing (..)
import Url


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


type alias Item =
    { status : String
    , location : ItemLocation
    }

type alias Locations =
    { locations : List ItemLocationMetadata
    }

type alias ItemLocationMetadata =
    { id : String
    , title : String
    , about : String
    , description : String
    , heroImage : String
    , x : Float
    , y : Float
    }


type alias ItemLocation =
    { metadata : ItemLocationMetadata
    , panoramas : List Image
    , videos : List Video
    , quadVideos : List Video
    , slideshows : List Image
    , cached : Bool
    }


type alias Image =
    { image : String
    , caption : String
    }


brokenImage =
    { image = ""
    , caption = "broken image"
    }


type alias Video =
    { kind : String
    , poster : String
    , caption : String
    , video : String
    }


brokenVideo =
    { kind = "video"
    , poster = ""
    , caption = "broken video"
    , video = ""
    }
