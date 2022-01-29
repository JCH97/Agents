module Lib
    (
        randomNumb,
        sum1, 
        getCar
    ) where

import System.Random (Random (randomRs), StdGen)

randomNumb :: Int -> StdGen -> [Int]
randomNumb n = randomRs (0, n)

data Car = Car 
    {
        color :: String,
        time :: Int
    }
    deriving (Show)


sum1 :: Car -> Int -> Car
sum1 Car {color = c, time = t} n = Car { color = c, time = t + n}

getCar :: Car
getCar = Car { color = "red", time = 1}