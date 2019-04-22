module Ui.Navigation exposing (header)

import Browser.Navigation as Navigation
import Css exposing (..)
import Css.Media as Media exposing (only, screen, withMedia)
import FeatherIcons
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Html.Styled.Events exposing (onClick)
import Ui.Theme exposing (..)

navIcon icon label url active =
    let
        borderIfActive =
            if active then
                borderBottom3 (px 3) solid (hex "#fff")

            else
                border (px 0)
    in
    a
        [ css
            [ paddingLeft (px 15)
            , paddingRight (px 15)
            , paddingBottom (px 5)
            , displayFlex
            , justifyContent spaceBetween
            , verticalAlign middle
            , cursor pointer
            , textDecoration none
            , outline none
            , visited [ color (hex "#FFF") ]
            , color (hex "#FFF")
            , backgroundColor (hex "#8c3945")
            , borderIfActive
            ]
        , href url
        ]
        [ icon
        , span
            [ css
                [ paddingLeft (px 4) ]
            ]
            [ text label ]
        ]


header =
    let
        mapIcon =
            FeatherIcons.map
                |> FeatherIcons.toHtml []
                |> fromUnstyled

        galleriesIcon =
            FeatherIcons.image
                |> FeatherIcons.toHtml []
                |> fromUnstyled

        aboutIcon =
            FeatherIcons.info
                |> FeatherIcons.toHtml []
                |> fromUnstyled
    in
    nav
        [ css
            [ displayFlex
            , backgroundColor colors.headerBackground
            , color colors.headerForeground
            , ifMobile
                [ flexDirection column ]
            , ifDesktop
                [ flexDirection row
                , height (px 60)
                ]
            , alignItems center
            , verticalAlign middle
            , justifyContent center
            ]
        ]
        [ h1
            [ css
                [ flex2 (int 1) (int 1)
                , fontFamilies [ "Lato", .value sansSerif ]
                , ifDesktop
                    [ paddingLeft (px 20) ]
                , ifMobile
                    [ fontSize (px 18) ]
                ]
            ]
            [ 
                a 
                [ href "#/map"
                , css 
                    [textDecoration none
                    , color (hex "#FFF")] ] 
                [ text "Kauai's Hindu Monastery Virtual Tour" ] ]
        , ul
            [ css
                [ listStyle none
                , displayFlex
                , justifyContent spaceAround
                , verticalAlign middle
                , padding (px 0)
                ]
            ]
            [ navIcon mapIcon "Map" "#/map" False
            , navIcon galleriesIcon "Galleries" "#/galleries" False
            , navIcon aboutIcon "About" "#/about" False
            ]
        ]
