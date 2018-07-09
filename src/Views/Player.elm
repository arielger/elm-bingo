module Views.Player exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (src, css)
import Data.Player exposing (Player)
import Views.PlayerBoard

view : List Int -> Player -> Html msg
view activeBalls player =
  div
    [
      css [
        displayFlex,
        flexDirection column,
        alignItems center,
        flexBasis (pct 50)
      ]
    ]
    [
      div
        [ css [ displayFlex, alignItems center ] ]
        [
          img
            [
              src player.data.image,
              css [
                width (px 60),
                height (px 60),
                borderRadius (pct 50),
                marginRight (px 20)
              ]
            ]
            [],
          h2
            [ css [ color (hex "#fff") ] ]
            [ text player.data.name ]
        ],
      Views.PlayerBoard.view activeBalls player.board
    ]