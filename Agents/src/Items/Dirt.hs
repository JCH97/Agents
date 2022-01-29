module Items.Dirt (
    Dirt (..),
    existDirty
) where


import Items.Utils (contains)

data Dirt = Dirt {
    value :: [(Int, Int)]
}  deriving (Show)

existDirty :: Dirt -> (Int, Int) -> Bool
existDirty Dirt { value = val } pos = contains val pos