module Utils
  exposing (
    randomToTask
  )

import Time
import Task exposing (Task)
import Random

randomToTask : Random.Generator a -> Task Never a
randomToTask generator =
  Time.now
    |> Task.map (Tuple.first << Random.step generator << Random.initialSeed << round)