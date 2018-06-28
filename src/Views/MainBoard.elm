module Views.MainBoard exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, style)
import Data.Board exposing (MainBoard)
import Views.BoardPosition

view : MainBoard -> Html msg
view board =
  ul
    [ css
      [
        margin zero,
        listStyleType none,
        maxWidth (px 936)
      ]
    ]
    (List.map
      (\item -> Views.BoardPosition.view (toString item.number) item.isActive)
      board
    )