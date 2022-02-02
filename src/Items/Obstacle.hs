module Items.Obstacle (
    Obstacle (..),
    existObstacle,
    updateObstacle
) where

import Items.Utils (contains)

data Obstacle = Obstacle {
    value :: [(Int, Int)]
}  deriving (Show)

existObstacle :: Obstacle -> (Int, Int) -> Bool
existObstacle Obstacle { value = val } pos = contains val pos

-- obstacle, oldPos, newPos
updateObstacle :: Obstacle -> (Int, Int) -> (Int, Int) -> Obstacle
updateObstacle Obstacle { value = val } oldPos newPos = let temp = [t | t <- val, t /= oldPos]
                                                  in Obstacle { value = (newPos : temp) }