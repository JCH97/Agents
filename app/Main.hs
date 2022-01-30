module Main where

import Lib ()
import Items.Enviroment (mockIsEmpty, mockBuildCorral, mockBuildChildren, buildEnv, mockBuildEnv)
import Items.Utils (mockBuildCorralAux, mockMakeAdjMax, randomList, mockLenght)

import System.Random (newStdGen, getStdGen)

main :: IO()
main = do
    g <- newStdGen

    -- let mock1 = mockIsEmpty
    -- print mock1

    -- let mock2 = mockBuildCorralAux 
    -- print mock2

    -- let mock3 = mockMakeAdjMax
    -- print mock3

    -- let mock4 = mockBuildCorral
    -- print mock4

    -- let mock5 = mockBuildChildren
    -- print mock5

    -- let mock6 = mockLenght
    -- print mock6

    -- let c = min 45 1
    -- print c

    let mock7 = mockBuildEnv g
    print mock7

    -- let rnd = randomList 6 g
    -- print (take 4 rnd)
    -- let g1 = sum1 getCar 3 in print g1[(Int, Int)]