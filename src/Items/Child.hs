module Items.Child (
    Child (..),
    existChild,
    existChildOutCorral,
    updateChild,
    mockUpdateChild
 ) where


import Items.Utils (contains, lenght)

data Child = Child {   
    value :: [(Int, Int)]
} deriving (Show)

existChild :: Child -> (Int, Int) -> Bool
existChild Child { value = val } pos  = contains val pos

existChildOutCorral :: Child -> Bool
existChildOutCorral Child { value = val } = lenght val >= 0

-- oldChildStruct, oldPos, newPos, newChildStruct
updateChild :: Child ->  (Int, Int) -> (Int, Int) -> Child
updateChild Child { value = val } oldPos newPos = let temp = [t | t <- val, t /= oldPos]
                                                  in Child { value = (newPos : temp) }

mockUpdateChild :: Child
mockUpdateChild = updateChild Child { value = [(1, 2), (2, 3), (1, 4)] }
                              (2, 3)
                              (5, 6)


removeChild :: Child -> (Int, Int) -> Child
removeChild Child { value = val } childPos = Child { value = [t | t <- val, t /= childPos] }