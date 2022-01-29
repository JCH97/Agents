module Items.Utils (
    Child (..),
    Dirt (..),
    Obstacle (..),
    Agent (..),
    Corral (..),
    Env (..),
    randomNumb
) where 


import System.Random (Random (randomRs), StdGen)
import Items.EnvObjects (Child (Child))
import Items.EnvObjects (Dirt (Dirt))
import Items.Obstacle (Obstacle (Obstacle))
import Items.Agent (Agent (Agent))
import Items.Corral (Corral (Corral))
import Items.Envairoment (Env (Env))

randomNumb :: Int -> StdGen -> [Int]
randomNumb n = randomRs (0, n)

contains ::  (Eq a) => [a] -> a -> Bool
contains [] _ = False
contains (x : xs) val = (x == val) || contains xs val

existChild :: Child -> (Int, Int) -> Bool
existChild Child { value = val } pos  = contains val pos

existAgent :: Agent -> (Int, Int) -> Bool
existAgent Agent { value = val } pos = contains val pos

existDirty :: Dirt -> (Int, Int) -> Bool
existDirty Dirty { value = val } pos = contains val pos

existObstacle :: Obstacle -> (Int, Int) -> Bool
existObstacle Obstacle { value = val } pos = contains val pos

existCorral :: Corral -> (Int, Int) -> Bool
existCorral Corral { value = val } pos = contains val pos

isEmpty :: Env -> (Int, Int) -> Bool
isEmpty =  