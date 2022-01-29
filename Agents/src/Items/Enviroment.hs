module Items.Enviroment (
    Child (..),
    Dirt (..),
    Obstacle (..),
    Agent (..),
    Corral (..),
    Env (..)
) where


import Items.EnvObjects (Child (Child))
import Items.EnvObjects (Dirt (Dirt))
import Items.Obstacle (Obstacle (Obstacle))
import Items.Agent (Agent (Agent))
import Items.Corral (Corral (Corral))

data Env = Env {
    children :: Child,
    agents :: Agent,
    corral :: Corral,
    dirty :: Dirt,
    obstacles :: Obstacle,
    dim :: (Int, Int)
} deriving (Show)



