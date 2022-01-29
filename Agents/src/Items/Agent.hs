module Items.Agent (
    Agent (..),
    existAgent
) where

import Items.Utils (contains)

data Agent = Agent {
    value :: [(Int, Int)]
} deriving (Show)


existAgent :: Agent -> (Int, Int) -> Bool
existAgent Agent { value = val } pos = contains val pos