module Items.Child (
    Child (..),
    existChild
 ) where


import Items.Utils (contains, lenght)

data Child = Child {   
    value :: [(Int, Int)]
} deriving (Show)

existChild :: Child -> (Int, Int) -> Bool
existChild Child { value = val } pos  = contains val pos

existChildOutCorral :: Child -> Bool
existChildOutCorral Child { value = val } = lenght val >= 0