module Data.Player
  exposing (
    Player,
    PlayerBoard,
    PlayerBoardRow,
    BoardPosition,
    playerBoardGenerator
  )

import Random exposing (map, generate, int, andThen)
import Random.List exposing (choose, shuffle)
import Random.Extra exposing (combine)
import Data.Board exposing (ballsCount)

type alias BoardPosition = Maybe Int
type alias PlayerBoardRow = List BoardPosition
type alias PlayerBoard = List PlayerBoardRow

type alias Player = {
  name: String,
  board: PlayerBoard
}

split : Int -> List a -> List (List a)
split i list =
  case List.take i list of
    [] -> []
    listHead -> listHead :: split i (List.drop i list)

playerBoardGenerator : Random.Generator PlayerBoard
playerBoardGenerator =
  let
    allNumbers = List.map (\a -> Just a) (List.range 1 ballsCount)
    emptyCellsInRow = List.repeat 4 Nothing

    playerBoard = Random.map
      (
        List.take 15 >>
        split 5 >>
        List.map (List.append emptyCellsInRow)
      )
      (shuffle allNumbers)

    shuffledPlayerBoard = Random.andThen
      (\ pb -> combine (List.map shuffle pb))
      playerBoard
  in
    shuffledPlayerBoard