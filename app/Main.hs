module Main where

import Lib ()
import Items.Enviroment (wrapIsEmpty, wrapBuildCorral, wrapBuildChildren, buildEnv, wrapBuildEnv, wrapTest, wrapValidsAdjForChildBFS, wrapChildBFS, wrapNextPosToMove, wrapDirtyBFS, wrapGetPlaceOnCorralAux, wrapManhantanDistance, wrapMoveAgentToCorral, wrapGetPosToMoveChild, wrapAgentMoveCase1, wrapAgentMoveCase4, wrapMoveOneAgent, wrapMoveAgents, wrapRefactorObstacles, wrapMoveOneChild, moveChilds, moveAgents, getPercentDirty, wrapAddRandomDirty, addRandmoDirty, moveAgentsType2, Env (..))
import Items.Utils (wrapBuildCorralAux, wrapMakeAdjMax, randomList, wrapLenght, wrapMakePairs)
import Items.Child (wrapUpdateChild)
import Items.Agent (wrapAgentGetChild, wrapAgentLeaveChild)
import Items.Dirt (wrapRemoveDirty)

import System.Random (StdGen, newStdGen, getStdGen)
import Control.Monad (when)

main :: IO()
main = do
    g <- newStdGen

    -- let wrap1 = wrapIsEmpty
    -- print wrap1

    -- let wrap2 = wrapBuildCorralAux 
    -- print wrap2

    -- let wrap3 = wrapMakeAdjMax
    -- print wrap3

    -- let wrap4 = wrapBuildCorral
    -- print wrap4

    -- let wrap5 = wrapBuildChildren
    -- print wrap5

    -- let wrap6 = wrapLenght
    -- print wrap6

    -- let c = min 45 1
    -- print c

    -- let wrap7 = wrapBuildEnv g
    -- print wrap7

    -- let wrap8 = wrapMakePairs
    -- print wrap8

    -- let wrap9 = wrapTest
    -- print wrap9

    -- let wrap10 = wrapValidsAdjForChildBFS
    -- print wrap10

    -- let wrap11 = wrapChildBFS
    -- print wrap11

    -- let wrap12 = wrapNextPosToMove
    -- print wrap12

    -- let wrap13 = wrapDirtyBFS
    -- print wrap13

    -- let wrap14 = wrapGetPlaceOnCorralAux
    -- print wrap14

    -- let wrap15 = wrapMoveAgentToCorral
    -- print wrap15

    -- let wrap16 = wrapManhantanDistance
    -- print wrap16

    -- let wrap17 = wrapGetPosToMoveChild g
    -- print wrap17

    -- let wrap18 = wrapUpdateChild
    -- print wrap18

    -- let wrap19 = wrapAgentGetChild
    -- print wrap19

    -- let wrap20 = wrapAgentLeaveChild
    -- print wrap20
    
    -- let wrap21 = wrapRemoveDirty
    -- print wrap21

    -- let wrap22 = wrapAgentMoveCase1
    -- print wrap22

    -- let wrap23 = wrapAgentMoveCase4
    -- print wrap23

    -- let wrap24 = wrapMoveOneAgent
    -- print wrap24

    -- let wrap25 = wrapMoveAgents
    -- print wrap25

    -- let wrap26 = wrapRefactorObstacles
    -- print wrap26

    -- let wrap27 = wrapMoveOneChild g
    -- print wrap27

    -- let rnd = randomList 6 g
    -- print (take 4 rnd)
    -- let g1 = sum1 getCar 3 in print g1[(Int, Int)]

    -- let wrap28 = wrapAddRandomDirty (randomList 9 g)
    -- print wrap28

    print "Simulation type 1"
    runSimulations1 10

    print "Simulation type 2"
    runSimulations2 10

runSimulations1 :: Int -> IO()
runSimulations1 0 = print "SIMULATIONS TYPE 1 COMPLETED"
runSimulations1 count = do
    simulationType1
    runSimulations1 (count - 1)

runSimulations2 :: Int -> IO()
runSimulations2 0 = print "SIMULATIONS TYPE 2 COMPLETED"
runSimulations2 count = do
    simulationType2
    runSimulations2 (count - 1) 

-- dim, childrenAmount, ObstacleAmount, AgentsAmount, DirtyAmount, Generator
simulationType1 :: IO()
simulationType1 = do
    g <- newStdGen
    let env = buildEnv (7, 7) 5 2 3 5 g

    -- print env

    let finalEnv = simulationType1Aux env 2000 g
    let percent = getPercentDirty finalEnv

    -- print finalEnv
    print percent
    
simulationType1Aux :: Env -> Int -> StdGen -> Env
simulationType1Aux env 0 _ = env
simulationType1Aux env count gen = do 

    let newEnv1 = moveChilds env gen
    let newEnv2 = moveAgents newEnv1
    
    let finalEnv = changeEnv newEnv2 count (randomList 7 gen)

    simulationType1Aux finalEnv (count - 1) gen


simulationType2 :: IO()
simulationType2 = do
    g <- newStdGen
    let env = buildEnv (7, 7) 5 2 3 5 g

    -- print env

    let finalEnv = simulationType2Aux env 2000 g
    let percent = getPercentDirty finalEnv

    -- print finalEnv
    print percent
    
simulationType2Aux :: Env -> Int -> StdGen -> Env
simulationType2Aux env 0 _ = env
simulationType2Aux env count gen = do 

    let newEnv1 = moveChilds env gen
    let newEnv2 = moveAgentsType2 newEnv1

    let finalEnv = changeEnv newEnv2 count (randomList 7 gen)

    simulationType2Aux finalEnv (count - 1) gen

changeEnv :: Env -> Int -> [Int] -> Env
changeEnv env iter rand | mod iter 100 == 0 = addRandmoDirty env 5 10 rand
                        | otherwise = env