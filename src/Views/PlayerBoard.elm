module Views.PlayerBoard exposing (view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, style)
import Data.Player exposing (PlayerBoard, PlayerBoardRow, BoardPosition)
import Views.BoardPosition

view : List Int -> PlayerBoard -> Html msg
view activeBalls board =
  div [] (List.map (playerBoardRow activeBalls) board)

playerBoardRow : List Int -> PlayerBoardRow -> Html msg
playerBoardRow activeBalls row =
  div [ css [ displayFlex ] ] (
    List.map (playerBoardPosition activeBalls) row
  )

playerBoardPosition : List Int -> BoardPosition -> Html msg
playerBoardPosition activeBalls position =
  case position of
    Nothing -> Views.BoardPosition.view "" False
    Just position ->
      let
        isActive = List.member position activeBalls
      in
        Views.BoardPosition.view (toString position) isActive