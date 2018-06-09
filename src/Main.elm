import Html

import Css exposing (..)
import Random exposing (map, generate, int, andThen)
import Random.List exposing (choose, shuffle)
import Random.Extra exposing (combine)
import Html.Styled exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (css, style)

-- General utilities

split : Int -> List a -> List (List a)
split i list =
  case List.take i list of
    [] -> []
    listHead -> listHead :: split i (List.drop i list)

-- Main board utilities

activateCurrentBall : MainBoard -> Int -> MainBoard
activateCurrentBall mainBoard index =
  List.map
    (\ball ->
      { ball | isActive = (index == ball.number) || ball.isActive }
    )
    mainBoard

getInactiveBalls : MainBoard -> MainBoard
getInactiveBalls mainBoard =
  List.filter
    (\ball -> not ball.isActive)
    mainBoard

--

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

type alias Ball = { number: Int, isActive: Bool }
type alias MainBoard = List Ball

type alias BoardPosition = Maybe Int
type alias PlayerBoardRow = List BoardPosition
type alias PlayerBoard = List PlayerBoardRow

type alias Player = {
  name: String,
  board: PlayerBoard
}

type alias Model = { mainBoard: MainBoard, players: List Player }

initialMainBoard : MainBoard
initialMainBoard =
  List.range 1 ballsCount
    |> List.map (\ number -> { number = number, isActive = False })

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
  | HighlightNewBall (Maybe Ball, List Ball)

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
      let
          inactiveBalls = getInactiveBalls model.mainBoard
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
              (
                { model | mainBoard = activateCurrentBall model.mainBoard ballItem.number },
                Cmd.none
              )

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
        height (vh 100),
        fontFamilies ["Helvetica", "sans-serif"],
        flexDirection column,
        alignItems center,
        justifyContent center
      ]
    ]
    [ 
      ul
        [ css
          [
            margin zero,
            listStyleType none,
            maxWidth (px 936)
          ]
        ]
        (List.map bingoNumber model.mainBoard),
      div
        [ css [ marginTop (px 40) ] ]
        [
          btn [ onClick AddPlayer ] [text "Add player 🕹"],
          btn [ onClick ResetAll ] [text "Reset game ♻️"],
          btn [ onClick GetRandomBall ] [text "Next ball 🎲"]
        ],
      div
        [
          css [
            width (pct 100),
            displayFlex,
            flexWrap wrap
          ]
        ]
        (List.map player model.players)
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

player : Player -> Html msg
player p =
  div
    [
      css [
        displayFlex,
        flexDirection column,
        alignItems center,
        flexBasis (pct 50)
      ]
    ]
    [
      h2
        [
          css [
            color (hex "#fff")
          ]
        ]
        [text p.name],
        div [] (List.map playerBoardRow p.board)
    ]

playerBoardRow : PlayerBoardRow -> Html msg
playerBoardRow pbr =
  div [ css [ displayFlex ] ] (
    List.map playerBoardPosition pbr
  )

positionItem : List (Attribute msg) -> List (Html msg) -> Html msg
positionItem =
    styled div
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
          letterSpacing (px 1),
          backgroundColor (hex "#302C42")
        ]

playerBoardPosition : BoardPosition -> Html msg
playerBoardPosition pbp =
  case pbp of
    Nothing -> positionItem [] []
    Just x -> positionItem [] [x |> toString |> text] 


bingoNumber : Ball -> Html Msg
bingoNumber ball =
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
        ("background-color", if ball.isActive then "#FF2F65" else "#302C42")
      ]
    ]
    [ text (toString ball.number) ]
