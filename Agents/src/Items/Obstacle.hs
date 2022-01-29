module Items.Obstacle (
    Obstacle (..),
    existObstacle
) where

import Items.Utils (contains)

data Obstacle = Obstacle {
    value :: [(Int, Int)]
}  deriving (Show)

existObstacle :: Obstacle -> (Int, Int) -> Bool
existObstacle Obstacle { value = val } pos = contains val pos