module Views.Player exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
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
      h2
        [
          css [
            color (hex "#fff")
          ]
        ]
        [text player.name],
        Views.PlayerBoard.view activeBalls player.board
    ]