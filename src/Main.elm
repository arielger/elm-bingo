import Html

import Css exposing (..)
import Random exposing (generate, int)
import Random.List exposing (choose)
import Html.Styled exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (css, style)

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , subscriptions = subscriptions
    , view = view >> toUnstyled
    , update = update
    }

-- MODEL
ballsCount : Int
ballsCount = 90

type alias Ball = (Int, Bool)

type alias Model = List Ball
initialList : Model
initialList = List.indexedMap (\index item -> (index, item)) (List.repeat ballsCount False)

init : (Model, Cmd Msg)
init =
  (initialList, Cmd.none)


activateCurrentBall : Model -> Int -> Model
activateCurrentBall ballsList newBallIndex =
  List.map
    (\ball ->
      let
        (index, active) = ball
        shouldBeActive = (newBallIndex == index) || active
      in
        (index, shouldBeActive)
    )
    ballsList

getInactiveBalls : Model -> Model
getInactiveBalls ballsList =
    List.filter
      (\ball ->
        let
          (index, active) = ball
        in
          not active
      )
      ballsList


-- UPDATE
type Msg
  = ResetAll
  | GetRandomBall
  | HighlightNewBall (Maybe Ball, List Ball)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ResetAll ->
      (initialList, Cmd.none)
    GetRandomBall ->
      let
          inactiveBalls = getInactiveBalls model
          randomBall = choose inactiveBalls
      in
          (model, Random.generate HighlightNewBall randomBall)
    HighlightNewBall generatorResult ->
      let
          ballItem = Tuple.first(generatorResult)
      in
        case ballItem of
          Nothing ->
              (model, Cmd.none)
          Just ballItem ->
              (activateCurrentBall model (Tuple.first(ballItem)), Cmd.none)

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div
    [
      css [
        displayFlex,
        backgroundColor (hex "#242133"),
        height (vh 100),
        fontFamilies ["Helvetica", "sans-serif"],
        flexDirection column,
        alignItems center,
        justifyContent center
      ]
    ]
    [ ul
        [ css
          [
            margin zero,
            listStyleType none,
            maxWidth (px 936)
          ]
        ]
        (List.map bingoNumber model),
        div
          [ css [ marginTop (px 40) ] ]
          [
            btn [ onClick ResetAll ] [text "Reset game ♻️"],
            btn [ onClick GetRandomBall ] [text "Next ball 🎲"]
          ]
    ]

btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn =
    styled button
        [
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

bingoNumber : Ball -> Html Msg
bingoNumber ball =
  let
      (index, isActive) = ball
  in
    li
      [ css
        [
          display inlineFlex,
          alignItems center,
          justifyContent center,
          width (px 40),
          height (px 40),
          margin (px 6),
          borderRadius (px 5),
          color (hex "#242133"),
          fontWeight (Css.int 600),
          letterSpacing (px 1)
        ],
        style [
          ("background-color", if isActive then "#FF2F65" else "#302C42")
        ]
      ]
      [ text (toString index) ]
