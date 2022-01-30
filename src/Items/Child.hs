module Items.Child (
    Child (..),
    existChild
 ) where


import Items.Utils (contains)

data Child = Child {   
    value :: [(Int, Int)]
} deriving (Show)

existChild :: Child -> (Int, Int) -> Bool
existChild Child { value = val } pos  = contains val pos