port module Ui.Loading exposing
    ( view
    )

import Css exposing (..)
import FeatherIcons
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (attribute, css, href, id, src, style)
import Html.Styled.Events exposing (onClick)
import Item exposing (decodeItem)
import List.Extra as LE
import Types exposing (..)
import Ui.Theme exposing (colors)

view =
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