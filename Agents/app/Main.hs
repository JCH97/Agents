module Main where

import Lib ()
import Items.Enviroment (mockIsEmpty)
import Items.Utils (mockBuildCorralAux, mockMakeAdjMax)

-- import System.Random (newStdGen, getStdGen)

main :: IO()
main = do
    -- let mock1 = mockIsEmpty
    -- print mock1

    let mock2 = mockBuildCorralAux 
    print mock2

    -- let mock3 = mockMakeAdjMax
    -- print mock3

    -- g <- newStdGen
    -- let rnd = randomNumb 6 g
    -- -- print (take 4 rnd)
    -- let g1 = sum1 getCar 3 in print g1[(Int, Int)]