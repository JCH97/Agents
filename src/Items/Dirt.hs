module Items.Dirt (
    Dirt (..),
    existDirty,
    removeDirty,
    mockRemoveDirty
) where


import Items.Utils (contains)

data Dirt = Dirt {
    value :: [(Int, Int)]
}  deriving (Show)

existDirty :: Dirt -> (Int, Int) -> Bool
existDirty Dirt { value = val } pos = contains val pos

removeDirty :: Dirt -> (Int, Int) -> Dirt
removeDirty Dirt { value = val } dirtyPos = Dirt { value = [t | t <- val, t /= dirtyPos] }

mockRemoveDirty :: Dirt
mockRemoveDirty = removeDirty Dirt { value = [(1, 2)] } (1, 2)