module Items.Dirt (
    Dirt (..),
    existDirty,
    removeDirty,
    wrapRemoveDirty, 
    existDirtyInBoard,
    addDirtyInPos
) where


import Items.Utils (contains, lenght)

data Dirt = Dirt {
    value :: [(Int, Int)]
}  deriving (Show)

existDirty :: Dirt -> (Int, Int) -> Bool
existDirty Dirt { value = val } pos = contains val pos

removeDirty :: Dirt -> (Int, Int) -> Dirt
removeDirty Dirt { value = val } dirtyPos = Dirt { value = [t | t <- val, t /= dirtyPos] }

wrapRemoveDirty :: Dirt
wrapRemoveDirty = removeDirty Dirt { value = [(1, 2)] } (1, 2)

existDirtyInBoard :: Dirt -> Bool 
existDirtyInBoard Dirt { value = val } = lenght val > 0

addDirtyInPos :: Dirt -> (Int, Int) -> Dirt 
addDirtyInPos dirty@Dirt { value = val } pos@(x, y) = if mod (x + y) 2 == 0 then
                                                            let tempDirty = [t | t <- val, t /= pos]
                                                            in Dirt { value = (pos: tempDirty) }
                                                      else dirty