module Main where

import Lib (randomNumb, sum1, getCar)

import System.Random (newStdGen, getStdGen)

main :: IO()
main = do
    g <- newStdGen
    let rnd = randomNumb 6 g
    -- print (take 4 rnd)
    let g1 = sum1 getCar 3 in print g1