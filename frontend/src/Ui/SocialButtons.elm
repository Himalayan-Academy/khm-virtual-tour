module Ui.SocialButtons exposing (buttons)

import Browser.Navigation as Navigation
import Css exposing (..)
import Css.Media as Media exposing (only, screen, withMedia)
import FeatherIcons
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src, target)
import Html.Styled.Events exposing (onClick)
import Ui.Theme exposing (..)


socialButton url label iconPath =
    a
        [ css
            [ width (px 64)
            , height (px 64)
            , displayFlex
            , flexDirection column
            , textAlign center
            , alignItems center
            , textDecoration none
            ]
        , href url
        , target "_blank"
        ]
        [ div
            [ css
                [ width (px 48)
                , height (px 48)
                , displayFlex
                , verticalAlign middle
                , justifyContent center
                , alignItems center
                ]
            ]
            [ img
                [ src iconPath
                , css
                    [ maxWidth (pct 95)
                    , maxHeight (pct 95)
                    , width (px 36)
                    , height (px 36)
                    ]
                ]
                []
            ]
        , span
            [ css
                [ color (hex "#FFF")
                , fontSize (rem 0.6)
                ]
            ]
            [ text label ]
        ]


buttons =
    div
        [ css
            [ position fixed
            , displayFlex
            , bottom (px 10)
            , left (px 10)
            , zIndex (int 99999)
            ]
        ]
        [ socialButton "https://www.himalayanacademy.com/blog/taka" "Blog" "https://dev.himalayanacademy.com/virtualtour/points-of-interest/khm_logo.png"
        , socialButton "https://www.facebook.com/KauaiHinduMonastery/" "Facebook"  "https://dev.himalayanacademy.com/virtualtour/points-of-interest/facebook.png"
        , socialButton "https://www.instagram.com/kauaishindumonastery/" "Instagram" "https://dev.himalayanacademy.com/virtualtour/points-of-interest/instagram.png"
        , div [ css [ flex2 (num 1) (num 1) ] ] []
        ]
