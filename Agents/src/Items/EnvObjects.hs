module Items.EnvObjects(
    Child (..),
    Agent (..),
    Obstacle (..),
    Dirt (..),
    Corral (..)
) where

data Child = Child {   
    value :: [(Int, Int)]
} deriving (Show)


data Agent = Agent {
    value :: [(Int, Int)]
} deriving (Show)


data Obstacle = Obstacle {
    value :: [(Int, Int)]
}  deriving (Show)

data Dirt = Dirt {
    value :: [(Int, Int)]
}  deriving (Show)

data Corral = Corral {
    value :: [(Int, Int)]
} deriving (Show)