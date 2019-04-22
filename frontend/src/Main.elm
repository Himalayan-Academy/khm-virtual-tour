port module Main exposing (main, update, view)

import Basics exposing ((>>))
import Browser
import Browser.Navigation as Navigation
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick)
import Http
import Item
import Page.About as About
import Page.Galleries as Galleries
import Page.Location as Location
import Page.Map as Map
import Types exposing (..)
import Ui.Navigation exposing (header)
import Url
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string, int, top)
import Browser.Dom as Dom
import Task


port initializeMap : () -> Cmd msg
port popMarker : String -> Cmd msg

port unloadMap : () -> Cmd msg

--
-- Issues at: https://github.com/Himalayan-Academy/khm-virtual-tour/issues/
--

-- URLS:
--
-- /locations -> map plottable points of interest
--
-- /location/<name> -> data about given point
--
-- /refesh-cache -> rebuilds cache.


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view >> toUnstyledDocument
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | LocationLoaded (Result Http.Error Item)
    | LocationsLoaded (Result Http.Error Locations)
    | LocationMsg Location.Msg
    | PopMarker String
    | NoOp


type Page
    = NotFound
    | Map
    | Galleries Int
    | Location Location.Model
    | About


type alias Model =
    { key : Navigation.Key
    , page : Page
    , locations : List ItemLocationMetadata
    }


toUnstyledDocument : Document msg -> Browser.Document msg
toUnstyledDocument doc =
    { title = doc.title
    , body = List.map toUnstyled doc.body
    }


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        currentPage =
            fromUrl url

        nextCmd =
            case currentPage of
                Location lm ->
                    fetchLocation lm.location

                Map ->
                    initializeMap ()

                _ ->
                    Cmd.none
    in
    ( Model key (fromUrl url) [], Cmd.batch [ fetchLocations, nextCmd ] )


resetViewport : Cmd Msg
resetViewport =
  Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)

locationWithDefaultSubview loc =
    Location (Location.fromStrings "" loc)


locationWithSubview loc subView =
    Location (Location.fromStrings subView loc)


route : Parser (Page -> a) a
route =
    oneOf
        [ map Map top
        , map Map (s "map")
        , map (Galleries 0) (s "galleries")
        , map Galleries (s "galleries" </> int)
        , map locationWithDefaultSubview (s "location" </> string)
        , map locationWithSubview (s "location" </> string </> string)
        , map About (s "about")
        ]


toRoute : Url.Url -> Page
toRoute url =
    Maybe.withDefault NotFound (parse route url)


fromUrl url =
    -- Treat fragment as path
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> parse route
        |> Maybe.withDefault NotFound


fetchLocation : String -> Cmd Msg
fetchLocation location =
    Http.send LocationLoaded (Http.get (Item.toLocationUrl location) Item.decodeItem)


fetchLocations : Cmd Msg
fetchLocations =
    Http.send LocationsLoaded (Http.get Item.toLocationsUrl Item.decodeLocations)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            let
                page =
                    fromUrl url

                nextCmd =
                    case page of
                        Location lm ->
                            Cmd.batch
                                [ fetchLocation lm.location
                                , unloadMap ()
                                ]

                        Map ->
                            initializeMap ()

                        _ ->
                            if model.page == Map then
                                unloadMap ()

                            else
                                resetViewport
            in
            ( { model | page = page }
            , nextCmd
            )

        LocationLoaded i ->
            let
                page =
                    model.page

                newPage =
                    case ( page, i ) of
                        ( Location m, Ok data ) ->
                            Location <| Location.receivedData m data

                        ( _, _ ) ->
                            page
            in
            ( { model | page = newPage }, Cmd.none )

        LocationsLoaded locations ->
            case locations of
                Ok l ->
                    ( { model | locations = l.locations }, Cmd.none )

                Err e ->
                    -- let
                    --     d = Debug.log "error with payload decode" e
                    -- in
                     
                    ( { model | locations = [] }, Cmd.none )

        LocationMsg m ->
            let
                locationModel =
                    case model.page of
                        Location md ->
                            md

                        _ ->
                            Location.empty

                ( newModel, locationCmd ) =
                    Location.update m locationModel

                nextCmd =
                    Cmd.map LocationMsg locationCmd
            in
            ( { model | page = Location newModel }, nextCmd )


        PopMarker id ->
            (model, popMarker id)

        NoOp -> (model, Cmd.none)


view : Model -> Document Msg 
view model =
    let
        title =
            subView.title

        subView =
            case model.page of
                Map ->
                    Map.view PopMarker model.locations

                Location m ->
                    -- this is shapeshifting code
                    -- because I need to map the Msg from the location
                    -- into Msg from main and I don't yet know the best
                    -- patterns for the new 0.19 Document stuff.
                    let
                        ld =
                            Location.view model.locations m

                        newBody =
                            List.map (\x -> Html.Styled.map LocationMsg x) ld.body
                    in
                    { title = ld.title, body = newBody }

                About ->
                    About.view

                Galleries pageNum ->
                    Galleries.view pageNum model

                NotFound ->
                    { title = "Virtual Tour - Kaua'i Hindu Monastery"
                    , body =
                        [ div
                            []
                            [ span [] [ text "Resource Not Found" ]
                            ]
                        ]
                    }
    in
    { title = title ++ " - Kauai Hindu Monastery Virtual Tour"
    , body = List.concat [ [ header ], subView.body ]
    } 


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
