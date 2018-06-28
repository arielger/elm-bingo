module Views.BoardPosition exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, style)

view : String -> Bool -> Html msg
view number isActive =
  div
    [
      css [
        display inlineFlex,
        alignItems center,
        justifyContent center,
        width (px 40),
        height (px 40),
        margin (px 6),
        borderRadius (px 5),
        color (hex "#242133"),
        fontWeight (Css.int 600),
        letterSpacing (px 1),
        backgroundColor (hex "#302C42")
      ],
      style [
        ("background-color", if isActive then "#FF2F65" else "#302C42")
      ]
    ]
    [ text number ]