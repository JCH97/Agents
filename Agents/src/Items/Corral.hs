module Items.Corral (
    Corral (..),
    existCorral
) where


import Items.Utils (contains)

data Corral = Corral {
    value :: [(Int, Int)]
} deriving (Show)


existCorral :: Corral -> (Int, Int) -> Bool
existCorral Corral { value = val } pos = contains val pos