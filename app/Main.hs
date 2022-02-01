module Main where

import Lib ()
import Items.Enviroment (mockIsEmpty, mockBuildCorral, mockBuildChildren, buildEnv, mockBuildEnv, mockTest, mockValidsAdjForChildBFS, mockChildBFS, mockNextPosToMove, mockDirtyBFS, mockGetPlaceOnCorralAux, mockManhantanDistance, mockMoveAgentToCorral, mockGetPosToMoveChild, mockAgentMoveCase1, mockAgentMoveCase4, mockMoveOneAgent)
import Items.Utils (mockBuildCorralAux, mockMakeAdjMax, randomList, mockLenght, mockMakePairs)
import Items.Child (mockUpdateChild)
import Items.Agent (mockAgentGetChild, mockAgentLeaveChild)
import Items.Dirt (mockRemoveDirty)

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

    -- let mock7 = mockBuildEnv g
    -- print mock7

    -- let mock8 = mockMakePairs
    -- print mock8

    -- let mock9 = mockTest
    -- print mock9

    -- let mock10 = mockValidsAdjForChildBFS
    -- print mock10

    -- let mock11 = mockChildBFS
    -- print mock11

    -- let mock12 = mockNextPosToMove
    -- print mock12

    -- let mock13 = mockDirtyBFS
    -- print mock13

    -- let mock14 = mockGetPlaceOnCorralAux
    -- print mock14

    -- let mock15 = mockMoveAgentToCorral
    -- print mock15

    -- let mock16 = mockManhantanDistance
    -- print mock16

    -- let mock17 = mockGetPosToMoveChild g
    -- print mock17

    -- let mock18 = mockUpdateChild
    -- print mock18

    -- let mock19 = mockAgentGetChild
    -- print mock19

    -- let mock20 = mockAgentLeaveChild
    -- print mock20
    
    -- let mock21 = mockRemoveDirty
    -- print mock21

    -- let mock22 = mockAgentMoveCase1
    -- print mock22

    -- let mock23 = mockAgentMoveCase4
    -- print mock23

    let mock24 = mockMoveOneAgent
    print mock24

    -- let rnd = randomList 6 g
    -- print (take 4 rnd)
    -- let g1 = sum1 getCar 3 in print g1[(Int, Int)]