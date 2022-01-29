module Items.Utils (
    randomNumb,
    contains
) where 


import System.Random (Random (randomRs), StdGen)

randomNumb :: Int -> StdGen -> [Int]
randomNumb n = randomRs (0, n)

contains ::  (Eq a) => [a] -> a -> Bool
contains [] _ = False
contains (x : xs) val = (x == val) || contains xs val