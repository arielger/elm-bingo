module Views.Button exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)

view : List (Attribute msg) -> List (Html msg) -> Html msg
view =
  styled button
    [
      display inlineFlex,
      height (px 60),
      alignItems center,
      backgroundColor (hex "#FF2E63"),
      border (px 0),
      padding2 (px 16) (px 32),
      borderRadius (px 3),
      cursor pointer,
      color (hex "#302C42"),
      margin2 (px 0) (px 8),
      fontSize (px 16)
      , hover
        [
          backgroundColor (hex "#E62958")
        ]
    ]