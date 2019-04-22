module Ui.Theme exposing (colors, ifDesktop, ifMobile)

import Css exposing (hex, px)
import Css.Media as Media exposing (..)


colors =
    { headerBackground = hex "#8c3945"
    , headerForeground = hex "#FFF"
    , marroon = hex "#8c3945"
    }

ifMobile =
    withMedia
        [ only screen
            [ Media.minWidth (px 300), Media.maxWidth (px 800) ]
        ]

ifDesktop =
    withMedia
     [ only screen
        [ Media.minWidth (px 800) ]
     ]