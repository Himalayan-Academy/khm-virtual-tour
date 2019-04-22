module Ui.Slider exposing (slider)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, css, href)
import Html.Styled.Events exposing (onClick)
import Ui.Theme exposing (..)


slider locations =
    div
        [ css
            [ height (px 60)
            , displayFlex
            , backgroundColor (hex "#8c3945")
            , width (pct 100)

            --, position fixed
            --, bottom (px 0)
            ]
        ]
        [ p [] [ text "hello" ]
        , h1 [ class "meleca" ] [ text "meleca" ]
        ]
