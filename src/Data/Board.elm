module Data.Board
  exposing (
    MainBoard,
    Ball,
    ballsCount,
    initialMainBoard,
    activateCurrentBall,
    getActiveBalls,
    getInactiveBalls,
    randomBallGenerator
  )

import Random
import Random.List

ballsCount : Int
ballsCount = 90

type alias Ball = { number: Int, isActive: Bool }
type alias MainBoard = List Ball

initialMainBoard : MainBoard
initialMainBoard =
  List.range 1 ballsCount
    |> List.map (\ number -> { number = number, isActive = False })

activateCurrentBall : MainBoard -> Int -> MainBoard
activateCurrentBall board index =
  List.map
    (\ball ->
      { ball | isActive = (index == ball.number) || ball.isActive }
    )
    board

partitionActiveBoard : MainBoard -> (MainBoard, MainBoard)
partitionActiveBoard = List.partition (\ball -> ball.isActive)

getActiveBalls : MainBoard -> MainBoard
getActiveBalls = partitionActiveBoard >> Tuple.first

getInactiveBalls : MainBoard -> MainBoard
getInactiveBalls = partitionActiveBoard >> Tuple.second

randomBallGenerator : MainBoard -> Random.Generator Int
randomBallGenerator board = 
  let
    inactiveBalls = getInactiveBalls board
    randomBall = (Random.List.choose inactiveBalls)
      |> Random.map Tuple.first
      |> Random.map
        (\ball ->
          case ball of
            Nothing -> -1
            Just ball -> ball.number
        )
  in
    randomBall