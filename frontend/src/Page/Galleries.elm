module Page.Galleries exposing (view)

import Css exposing (..)
import FeatherIcons
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (attribute, css, href, id, src, style)
import Html.Styled.Events exposing (onClick)
import Item exposing (decodeItem)
import List.Extra as LE
import Types exposing (..)
import Ui.Loading as Loading
import Ui.Theme exposing (..)


urlWithPrefix id url =
    -- "http://localhost:8081/" ++ url
    "http://dev.himalayanacademy.com/virtualtour/index.php/thumb/500/" ++ id ++ "/" ++ url


itemsPerPage =
    12


location l =
    a
        [ css
            [ flexGrow (int 1)
            , ifDesktop [
                width (pct 33)
            ]
            , ifMobile [
                width (pct 50)
            ]
            , visited [ color (hex "#000") ]
            , color (hex "#000")
            , outline none
            , textAlign center
            ]
        , href <| "#/location/" ++ l.id
        ]
        [ h1 [ css [ color colors.marroon ] ] [ text l.title ]
        , img
            [ src <| urlWithPrefix l.id l.heroImage
            , css
                [ borderRadius (px 20)
                , border3 (px 3) solid (hex "#8c3945")
                , maxWidth (pct 80)
                , maxHeight (px 250)
                , overflow hidden
                ]
            ]
            []
        , p [] [ text l.about ]
        ]


locations pageNum model =
    let
        total =
            List.length model.locations

        items =
            model.locations
                |> List.drop (pageNum * itemsPerPage)
                |> List.take itemsPerPage
    in
    List.map location items


pagination pageNum numberOfItems =
    let
        numberOfPages =
            (numberOfItems // itemsPerPage) + 1

        pages =
            List.range 0 numberOfPages

        page n =
            if n == pageNum then
                span
                    [ css
                        [ fontSize (rem 2)
                        , color (hex "#000")
                        , width (px 80)
                        , textDecoration none
                        ]
                    ]
                    [ text (String.fromInt n) ]

            else
                a
                    [ css
                        [ fontSize (rem 2)
                        , color colors.headerBackground
                        , width (px 80)
                        , textDecoration none
                        ]
                    , href ("#/galleries/" ++ String.fromInt n)
                    ]
                    [ text (String.fromInt n) ]

        pageElements =
            List.map page pages
    in
    div
        [ css
            [ displayFlex
            , alignItems center
            , justifyContent center
            ]
        ]
    <|
        pageElements


view pageNum model =
    if List.length model.locations > 0 then
        { title = "Galleries"
        , body =
            [ div
                [ css
                    [ displayFlex
                    , flexWrap wrap
                    ]
                ]
              <|
                locations pageNum model
            , pagination pageNum <| List.length model.locations
            ]
        }

    else
        { title = "Loading Galleries..."
        , body =
            Loading.view
        }
