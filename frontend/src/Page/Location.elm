port module Page.Location exposing
    ( Model
    , Msg
    , empty
    , fromStrings
    , receivedData
    , update
    , view
    )

import Css exposing (..)
import FeatherIcons
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (attribute, class, css, href, id, src, style)
import Html.Styled.Events exposing (onClick)
import Item exposing (decodeItem)
import List.Extra as LE
import String.Extra as SE
import Types exposing (..)
import Ui.Slider exposing (slider)
import Ui.Theme exposing (..)


port changePanoramaImage : Int -> Cmd msg


changePano id =
    changePanoramaImage id


type Msg
    = ChangeSubView String
    | ChangeCurrentItem Int


type SubView
    = Panoramas
    | Videos
    | QuadVideos
    | Slideshow
    | Metadata


type alias Model =
    { subView : SubView
    , location : String
    , data : Maybe Item
    , currentItem : Int
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSubView u ->
            ( { model | subView = subViewFromString u, currentItem = 0 }, Cmd.none )

        ChangeCurrentItem i ->
            let
                nextCmd =
                    case model.subView of
                        Panoramas ->
                            changePano i

                        _ ->
                            Cmd.none
            in
            ( { model | currentItem = i }, nextCmd )


navigation id label url active =
    let
        borderIfActive =
            if active then
                borderBottom3 (px 3) solid (hex "#8c3945")

            else
                border (px 0)
    in
    span
        [ css
            [ paddingBottom (px 2)
            , displayFlex
            , justifyContent spaceBetween
            , verticalAlign middle
            , cursor pointer
            , textDecoration none
            , color (hex "#000")
            , borderIfActive
            , ifDesktop
                [ paddingLeft (px 10)
                , paddingRight (px 10)
                , fontSize (px 24)
                ]
            , ifMobile
                [ padding (px 5) ]
            ]
        , onClick (ChangeSubView url)
        ]
        [ span
            [ css
                [ paddingLeft (px 4) ]
            ]
            [ text label ]
        ]


firstImage listOfImages =
    let
        img =
            Maybe.withDefault brokenImage <| LE.getAt 1 listOfImages
    in
    makeThumb 200 img.image


navigationThumb id label url imageUrl active =
    div
        [ css
            [ cursor pointer
            ]
        , onClick (ChangeSubView url)
        ]
        [ img
            [ css
                [ maxWidth (px 150)
                , height (px 100)
                , border3 (px 1) solid (hex "#333333")
                ]
            , src imageUrl
            ]
            []
        ]


receivedData : Model -> Item -> Model
receivedData model item =
    { model | data = Just item }


loadingView =
    let
        loadIcon =
            FeatherIcons.loader
                |> FeatherIcons.withSize 60
                |> FeatherIcons.withSizeUnit "px"
                |> FeatherIcons.withClass "spin"
                |> FeatherIcons.toHtml []
                |> fromUnstyled
    in
    [ div
        [ css
            [ displayFlex
            , flexDirection column
            , alignItems center
            , height (calc (vh 100) minus (px 48))
            , fontSize (px 60)
            ]
        ]
        [ span [ css [ flex2 (num 1) (num 1) ] ] []
        , loadIcon
        , h4 [] [ text "Loading..." ]
        , span [ css [ flex2 (num 1) (num 1) ] ] []
        ]
    ]


header : Model -> List (Html Msg)
header model =
    let
        isActive s =
            let
                m =
                    fromStrings s model.location
            in
            model.subView == m.subView

        hasContent l h =
            if List.length l > 0 then
                h

            else
                div [] []
    in
    case model.data of
        Just d ->
            [ nav
                [ css
                    [ displayFlex
                    , flexDirection column
                    , color colors.marroon
                    , alignItems center
                    , verticalAlign middle
                    , justifyContent center
                    ]
                ]
                [ h1
                    [ css
                        [ fontFamilies [ "Lato", .value sansSerif ]
                        , flex2 (int 1) (int 1)
                        , ifDesktop
                            [ fontSize (px 24)
                            , paddingRight (px 10)
                            ]
                        , ifMobile
                            [ fontSize (px 24) ]
                        ]
                    ]
                    [ text d.location.metadata.title ]
                , ul
                    [ css
                        [ listStyle none
                        , displayFlex
                        , justifyContent spaceAround
                        , verticalAlign middle
                        , padding (px 0)
                        , ifDesktop [ display none ]
                        ]
                    ]
                    [ navigation d.location.metadata.id "Description" "" <| isActive ""
                    , hasContent d.location.slideshows <| navigation d.location.metadata.id "Photos" "slideshows" <| isActive "slideshows"
                    , hasContent d.location.panoramas <| navigation d.location.metadata.id "360° Photos" "panoramas" <| isActive "panoramas"
                    , hasContent d.location.videos <| navigation d.location.metadata.id "Videos" "videos" <| isActive "videos"
                    , hasContent d.location.quadVideos <| navigation d.location.metadata.id "4K Videos" "videos4k" <| isActive "videos4k"
                    ]
                ]
            ]

        _ ->
            [ div [] [] ]


metadataView : Item -> List (Html msg)
metadataView data =
    let
        metadata =
            data.location.metadata
    in
    [ div
        [ css
            [ displayFlex
            , justifyContent spaceBetween
            , textAlign center
            , flexDirection column
            , maxHeight (pct 100)
            ]
        ]
        [ div
            [ css
                [ ifDesktop
                    [ flex2 (int 1) (int 1)
                    , padding (px 20)
                    ]
                ]
            ]
            [ img
                [ css
                    [ borderRadius (px 20)
                    , border3 (px 3) solid (hex "#8c3945")
                    , maxHeight (px 300)
                    ]
                , src <| makeThumb 500 metadata.heroImage
                ]
                []
            ]
        , p
            [ css
                [ flex2 (int 1) (int 2)
                , backgroundColor (rgba 240 240 240 0.4)
                , borderRadius (px 20)
                , fontSize (px 20)
                , padding (px 20)
                , textAlign left
                ]
            ]
            [ text metadata.description ]
        , p
            [ css
                [ textAlign center
                , ifMobile [ display none ]
                ]
            ]
            [ img
                [ css
                    [ maxWidth (pct 80)
                    , paddingBottom (px 15)
                    ]
                , src "https://dev.himalayanacademy.com/virtualtour/points-of-interest/feet.svg"
                ]
                []
            ]
        ]
    ]


slideshowsView : Item -> Int -> List (Html Msg)
slideshowsView data index =
    let
        metadata =
            data.location.metadata

        images =
            data.location.slideshows

        slideshows =
            data.location.slideshows

        currentImage =
            Maybe.withDefault brokenImage <| LE.getAt index images

        thumbs =
            List.indexedMap
                (\i image ->
                    img
                        [ css
                            [ borderRadius (px 12)
                            , ifDesktop
                                [ height (px 120)
                                , padding (px 5)
                                ]
                            , ifMobile
                                [ height (px 60)
                                , padding (px 5)
                                ]
                            ]
                        , src <| makeThumb 200 image.image
                        , onClick (ChangeCurrentItem i)
                        ]
                        [ text image.caption ]
                )
                images
    in
    [ div
        [ css
            [ displayFlex
            , flexDirection column
            , justifyContent spaceBetween
            , ifDesktop
                [ padding (px 25)
                ]
            ]
        ]
        [ div
            [ css
                [ flex2 (int 2) (int 1)
                , padding (px 20)
                , textAlign center
                ]
            ]
            [ img
                [ src <| makeThumb 800 currentImage.image
                , css
                    [ borderRadius (px 20)
                    , border3 (px 3) solid (hex "#8c3945")
                    , ifDesktop
                        [ maxWidth (pct 70) ]
                    , ifMobile
                        [ maxWidth (pct 90) ]
                    ]
                ]
                []
            , p [ css [] ] [ text currentImage.caption ]
            ]
        , div
            [ css
                [ flex (int 1)
                ]
            ]
            thumbs
        ]
    ]


panoramasView : Item -> Int -> List (Html Msg)
panoramasView data index =
    let
        metadata =
            data.location.metadata

        images =
            data.location.panoramas

        currentImage =
            Maybe.withDefault brokenImage <| LE.getAt index images

        assets =
            List.indexedMap
                (\i image ->
                    img
                        [ id <| "img-" ++ String.fromInt i
                        , src <| urlWithPrefix image.image
                        , attribute "crossorigin" "anonymous"
                        ]
                        []
                )
                images

        thumbs =
            List.indexedMap
                (\i image ->
                    img
                        [ css
                            [ borderRadius (px 12)
                            , ifDesktop
                                [ height (px 120)
                                , padding (px 5)
                                ]
                            , ifMobile
                                [ height (px 60)
                                , padding (px 5)
                                ]
                            ]
                        , src <| makeThumb 200 image.image
                        , onClick (ChangeCurrentItem i)
                        ]
                        [ text image.caption ]
                )
                images
    in
    [ div
        [ css
            [ displayFlex
            , flexDirection column
            , justifyContent spaceBetween
            , padding (px 25)
            , textAlign center
            ]
        ]
        [ div
            [ css
                [ flex2 (int 2) (int 1)
                , padding (px 20)
                , textAlign center
                , displayFlex
                , flexDirection column
                ]
            ]
            [ div
                [ css
                    [ displayFlex
                    ]
                ]
                [ div [ css [ flex2 (int 1) (int 1) ] ] []
                , node "a-scene"
                    [ attribute "embedded" "true"
                    , css
                        [ borderRadius (px 20)
                        , border3 (px 3) solid (hex "#8c3945")
                        , width (px 640)
                        , height (px 480)
                        ]
                    ]
                    [ node "a-assets"
                        []
                        assets
                    , node "a-sky"
                        [ id "image-360"
                        , attribute "src" ("#img-" ++ String.fromInt index)
                        , attribute "rotation" "0 -20 0"
                        ]
                        []
                    ]
                , div [ css [ flex2 (int 1) (int 1) ] ] []
                ]
            , p [ css [] ] [ text currentImage.caption ]
            ]
        , div
            [ css
                [ flex (int 1)
                ]
            ]
            thumbs
        ]
    ]


videosView : Item -> List Video -> Int -> List (Html Msg)
videosView data videos index =
    let
        metadata =
            data.location.metadata

        currentVideo =
            Maybe.withDefault brokenVideo <| LE.getAt index videos

        thumbs =
            List.indexedMap
                (\i video ->
                    let
                        poster =
                            case video.kind of
                                "youtube" ->
                                    "http://img.youtube.com/vi/" ++ video.video ++ "/maxresdefault.jpg"

                                _ ->
                                    makeThumb 200 video.poster
                    in
                    img
                        [ css
                            [ borderRadius (px 12)
                            , ifDesktop
                                [ height (px 120)
                                , padding (px 5)
                                ]
                            , ifMobile
                                [ height (px 60)
                                , padding (px 5)
                                ]
                            ]
                        , src poster
                        , onClick (ChangeCurrentItem i)
                        ]
                        [ text video.caption ]
                )
                videos

        videoOrYoutube =
            case currentVideo.kind of
                "video" ->
                    video
                        [ src <| urlWithPrefix currentVideo.video
                        , attribute "controls" "true"
                        , attribute "poster" <| urlWithPrefix currentVideo.poster
                        , css
                            [ ifDesktop
                                [ maxWidth (pct 80) ]
                            , ifMobile
                                [ maxWidth (pct 100) ]
                            ]
                        ]
                        []

                "youtube" ->
                    div [ class "embed-container" ]
                        [ iframe
                            [ src <| "https://www.youtube.com/embed/" ++ currentVideo.video

                            -- , attribute "width" "560"
                            -- , attribute "height" "315"
                            , attribute "frameborder" "0"
                            , attribute "allow" "autoplay; encrypted-media"
                            , attribute "allowfullscreen" "true"
                            ]
                            []
                        ]

                _ ->
                    div [] [ text "broken video" ]
    in
    [ div
        [ css
            [ displayFlex
            , flexDirection column
            , justifyContent spaceBetween
            , padding (px 25)
            , textAlign center
            ]
        ]
        [ div
            [ css
                [ flex2 (int 2) (int 1)
                , ifDesktop
                    [ padding (px 20) ]
                , textAlign center
                ]
            ]
            [ videoOrYoutube
            , p [ css [] ] [ text currentVideo.caption ]
            ]
        , div
            [ css
                [ flex (int 1)
                ]
            ]
            thumbs
        ]
    ]


urlWithPrefix url =
    -- "http://localhost:8081/" ++ url
    "http://dev.himalayanacademy.com/virtualtour/" ++ url


makeThumb size url =
    let
        needle =
            "points-of-interest/"

        change =
            "index.php/thumb/" ++ String.fromInt size ++ "/"
    in
    urlWithPrefix <| SE.replace needle change url


view : List ItemLocationMetadata -> Model -> Document Msg
view locations model =
    let
        ( title, subView ) =
            case ( model.data, model.subView ) of
                ( Nothing, _ ) ->
                    ( "loading...", loadingView )

                ( Just d, Metadata ) ->
                    ( d.location.metadata.title, List.concat [ header model, metadataView d ] )

                ( Just d, Slideshow ) ->
                    ( d.location.metadata.title, List.concat [ header model, slideshowsView d model.currentItem ] )

                ( Just d, Panoramas ) ->
                    ( d.location.metadata.title, List.concat [ header model, panoramasView d model.currentItem ] )

                ( Just d, Videos ) ->
                    ( d.location.metadata.title, List.concat [ header model, videosView d d.location.videos model.currentItem ] )

                ( Just d, QuadVideos ) ->
                    ( d.location.metadata.title, List.concat [ header model, videosView d d.location.quadVideos model.currentItem ] )
    in
    { title = title
    , body = wrapperInSlider model locations subView
    }



-- FIX: model.data is a maybe


wrapperInSlider model locations subView =
    let
        isActive s =
            let
                m =
                    fromStrings s model.location
            in
            model.subView == m.subView

        hasContent l h =
            if List.length l > 0 then
                h

            else
                div [] []

        navigationColumn =
            case model.data of
                Just d ->
                    [ navigationThumb d.location.metadata.id "Description" "" (firstImage d.location.slideshows) <| isActive ""
                    , hasContent d.location.slideshows <| navigationThumb d.location.metadata.id "Photos" "slideshows" (firstImage d.location.slideshows) <| isActive "slideshows"
                    , hasContent d.location.panoramas <| navigationThumb d.location.metadata.id "360° Photos" "panoramas" (firstImage d.location.panoramas) <| isActive "panoramas"
                    , hasContent d.location.videos <| navigationThumb d.location.metadata.id "Videos" "videos" (firstImage d.location.slideshows) <| isActive "videos"
                    , hasContent d.location.quadVideos <| navigationThumb d.location.metadata.id "4K Videos" "videos4k" (firstImage d.location.slideshows) <| isActive "videos4k"
                    ]

                Nothing ->
                    []
    in
    [ div
        [ css
            [ displayFlex
            , flexDirection column

            -- , height (calc (vh 100) minus (px 60))
            ]
        , class "contains-div"
        ]
        [ div
            [ css
                [ height (pct 100)
                , maxHeight (pct 100)
                , displayFlex
                , flexDirection row
                , overflow hidden
                , padding (px 0)
                , margin (px 0)
                ]
            ]
            [ div [ css [ flex2 (int 1) (int 1) ] ] subView
            , div
                -- Right side
                [ css
                    [ width (pct 20)
                    , border3 (px 2) dashed (rgb 11 14 17)
                    , displayFlex
                    ]
                ]
                [ div [ css [ width (pct 20) ] ] []
                , div
                    [ css
                        [ backgroundColor (hex "c3c3c3")
                        , flex2 (int 1) (int 1)
                        , displayFlex
                        , flexDirection column
                        ]
                    ]
                    [ ul
                        [ css
                            [ listStyle none
                            , displayFlex
                            , justifyContent spaceAround
                            , verticalAlign middle
                            , alignItems center
                            , padding (px 0)
                            , flexDirection column
                            ]
                        ]
                        navigationColumn
                    ]
                ]
            ]
        , slider locations
        ]
    ]


fromStrings subViewStr loc =
    let
        subView =
            case subViewStr of
                "panoramas" ->
                    Panoramas

                "videos" ->
                    Videos

                "videos4k" ->
                    QuadVideos

                "slideshows" ->
                    Slideshow

                _ ->
                    Metadata
    in
    Model subView loc Nothing 0


subViewFromString subViewStr =
    case subViewStr of
        "panoramas" ->
            Panoramas

        "videos" ->
            Videos

        "videos4k" ->
            QuadVideos

        "slideshows" ->
            Slideshow

        _ ->
            Metadata


empty =
    Model Metadata "" Nothing 0
