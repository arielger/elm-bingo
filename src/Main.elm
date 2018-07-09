module Main exposing (..)

import Html
import Css exposing (..)
import Random
import Task exposing (Task)
import Random
import Html.Styled exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (css, style)
import Data.Board exposing ( MainBoard, Ball, activateCurrentBall, getActiveBalls, getInactiveBalls, initialMainBoard, randomBallGenerator )
import Data.Player exposing (Player, PlayerBoard, getPlayerBoard)
import Request.Player exposing (fetchPlayerData)
import Views.Button
import Views.MainBoard
import Views.Player

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , subscriptions = subscriptions
    , view = view >> toUnstyled
    , update = update
    }

-- MODEL

type alias Model = {
  mainBoard: MainBoard,
  players: List Player
}

initialModel : Model
initialModel = {
    mainBoard = initialMainBoard,
    players = []
  }

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

-- UPDATE
type Msg
  = CreatePlayerClick
  | GetRandomCharacterId Int
  | CreatePlayer Player
  | ResetAll
  | GetRandomBall
  | HighlightNewBall Int

createNewPlayer : Int -> Cmd Msg
createNewPlayer characterId =
  let
    createPlayerTask : Task Never Player
    createPlayerTask = Task.map2
      (\playerData board -> {
        board = board,
        data = playerData
      })
      (fetchPlayerData characterId)
      getPlayerBoard
  in
    Task.perform
      (\player -> CreatePlayer player)
      createPlayerTask

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    CreatePlayerClick ->
      (model, Random.generate GetRandomCharacterId (Random.int 0 493))
    GetRandomCharacterId id ->
      (model, createNewPlayer id)
    CreatePlayer player ->
      ({ model | players = model.players ++ [player] }, Cmd.none)
    ResetAll ->
      (initialModel, Cmd.none)
    GetRandomBall ->
      (model, Random.generate HighlightNewBall (randomBallGenerator model.mainBoard))
    HighlightNewBall number ->
      (
        { model | mainBoard = activateCurrentBall model.mainBoard number },
        Cmd.none
      )

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  let
    activeBalls = model.mainBoard
      |> getActiveBalls
      |> List.map (\ball -> ball.number)
  in
    div
      [
        css [
          displayFlex,
          height (vh 100),
          fontFamilies ["Helvetica", "sans-serif"],
          flexDirection column,
          alignItems center,
          justifyContent center
        ]
      ]
      [ 
        Views.MainBoard.view model.mainBoard,
        div
          [ css [ marginTop (px 40) ] ]
          [
            Views.Button.view [ onClick CreatePlayerClick ] [text "Add player 🕹"],
            Views.Button.view [ onClick ResetAll ] [text "Reset game ♻️"],
            Views.Button.view [ onClick GetRandomBall ] [text "Next ball 🎲"]
          ],
        div
          [
            css [
              width (pct 100),
              displayFlex,
              flexWrap wrap
            ]
          ]
          (List.map (Views.Player.view activeBalls) model.players )
      ]