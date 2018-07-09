module Data.Player
  exposing (
    Player,
    PlayerBoard,
    PlayerBoardRow,
    BoardPosition,
    getPlayerBoard,
    PlayerData,
    defaultPlayerData
  )

import Task exposing (Task)
import RemoteData exposing (WebData)
import Random exposing (map, generate, int, andThen)
import Random.List exposing (choose, shuffle)
import Random.Extra exposing (combine)
import Data.Board exposing (ballsCount)
import Utils exposing (randomToTask)

type alias PlayerData = {
  name: String,
  image: String
}

type alias BoardPosition = Maybe Int
type alias PlayerBoardRow = List BoardPosition
type alias PlayerBoard = List PlayerBoardRow

type alias Player = {
  board: PlayerBoard,
  data: PlayerData
}

defaultPlayerData : PlayerData
defaultPlayerData =
  { name = "Player"
  , image = "http://i.pravatar.cc/200"
  }

split : Int -> List a -> List (List a)
split i list =
  case List.take i list of
    [] -> []
    listHead -> listHead :: split i (List.drop i list)

getPlayerBoard : Task Never PlayerBoard
getPlayerBoard =
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
    randomToTask shuffledPlayerBoard

