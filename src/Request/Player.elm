module Request.Player exposing (playerDecoder, fetchPlayerData)

import Http
import Random
import Json.Decode exposing (Decoder, at, string)
import Json.Decode.Pipeline exposing (decode, required)
import Data.Player exposing (PlayerData, defaultPlayerData)
import Task exposing (Task)
import Data.Player exposing (Player, getPlayerBoard)

playerDecoder : Decoder (PlayerData)
playerDecoder =
  decode PlayerData
    |> required "name" string
    |> required "image" string

-- Get random value 
fetchPlayerData : Int -> Task Never PlayerData
fetchPlayerData characterId =
  playerDecoder
    |> Http.get ("https://rickandmortyapi.com/api/character/" ++ toString characterId)
    |> Http.toTask
    |> Task.onError (\error -> Task.succeed defaultPlayerData)