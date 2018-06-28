module Main exposing (..)

import Html
import Css exposing (..)
import Random
import Html.Styled exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (css, style)
import Data.Board exposing ( MainBoard, Ball, activateCurrentBall, getActiveBalls, getInactiveBalls, initialMainBoard, randomBallGenerator )
import Data.Player exposing (Player, PlayerBoard, playerBoardGenerator)
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

type alias Model = { mainBoard: MainBoard, players: List Player }

initialModel : Model
initialModel = {
    mainBoard = initialMainBoard,
    players = []
  }

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)



-- UPDATE
type Msg
  = AddPlayer
  | CreatePlayerBoard PlayerBoard
  | ResetAll
  | GetRandomBall
  | HighlightNewBall Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AddPlayer ->
      (model, Random.generate CreatePlayerBoard playerBoardGenerator)
    CreatePlayerBoard board ->
      let
        newPlayerName = "Player " ++ toString (List.length model.players + 1)
      in
        (
          { model | players =
              model.players ++ [{ name = newPlayerName, board = board}]
          },
          Cmd.none
        )
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
            Views.Button.view [ onClick AddPlayer ] [text "Add player 🕹"],
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