module Items.Enviroment (
    Child (..),
    Dirt (..),
    Obstacle (..),
    Agent (..),
    Corral (..),
    Env (..),
    mockIsEmpty
) where


import Items.Child (Child (Child), existChild)
import Items.Dirt (Dirt (Dirt), existDirty)
import Items.Obstacle (Obstacle (Obstacle), existObstacle)
import Items.Agent (Agent (Agent), existAgent)
import Items.Corral (Corral (Corral), existCorral)
import Items.Utils (randomNumb, isValidPos)

data Env = Env {
    children :: Child,
    agents :: Agent,
    corral :: Corral,
    dirty :: Dirt,
    obstacles :: Obstacle,
    dim :: (Int, Int)
} deriving (Show)


isEmpty :: Env -> (Int, Int) -> Bool
isEmpty 
    env@Env { children = ch, agents = ag, corral = co, dirty = di, obstacles = ob } pos 
        = not (existChild ch pos || existAgent ag pos || existCorral co pos || existDirty di pos || existObstacle ob pos)




mockIsEmpty :: Bool
mockIsEmpty = 
    isEmpty 
        Env { children = Child [(1, 1)], 
              agents = Agent [(1, 1), (1, 1)], 
              corral = Corral [(1, 1)], 
              dirty = Dirt [(1, 1)], 
              obstacles =  Obstacle [(1, 1)],
              dim = (2, 3) }
        (1, 2)


-- StartPos, BoardDim, Amount, Ans
-- buildCorral :: (Int, Int) -> (Int, Int) -> Int -> [(Int, Int)]
-- buildCorral 