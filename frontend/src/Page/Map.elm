module Page.Map exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, id)
import Html.Styled.Events exposing (onClick)
import Types exposing (..)
import Ui.Theme exposing (..)
import Ui.SocialButtons as SocialButtons




locationToItem : (String -> msg) -> ItemLocationMetadata -> Html msg
locationToItem popper location = 
    li
        [ css
            [ cursor pointer
            ]
        ]
        [ span
            [ onClick (popper location.id)
            , css [ textDecoration none 
            , color (rgb 250 250 250)]
            ]
            [ text location.title ]
        ]


view : (String -> msg) -> List ItemLocationMetadata -> Document msg
view popper locations =
    { title = "Map"
    , body =
        [ div
            [ css
                [ displayFlex ]
            ]
            [ div
                [ id "mapid"
                , css
                    [ flex2 (num 1) (num 1)
                    , height (calc (vh 100) minus (px 60))
                    , backgroundColor (hex "#746e24")
                    , backgroundImage (url "http://dev.himalayanacademy.com/virtualtour/points-of-interest/bg2.jpg")
                    , backgroundRepeat repeat
                    ]
                ]
                []
            , div
                [ css
                    [ width (pct 15)
                    , ifMobile [
                        display none
                    ]
                    , borderLeft3 (px 3) solid (hex "#8c3945")
                    , backgroundColor (hex "#746e24")
                    , backgroundImage (url "http://dev.himalayanacademy.com/virtualtour/points-of-interest/bg2.jpg")
            
                    ]
                ]
                [ ul
                    [ css
                        [ listStyle none
                        , color (rgb 250 250 250)
                        , paddingLeft (px 10)
                        , fontSize (rem 1.2)
                        , height (calc (vh 100) minus (px 60))
                        , overflowY scroll
                        , overflowX hidden
                        , margin (px 0)
                        , backgroundColor (rgba 0 0 0 0.4)
                        ]
                    ]
                    (List.map (locationToItem popper) locations)
                ]
            ]
        , SocialButtons.buttons
        ]
    }
