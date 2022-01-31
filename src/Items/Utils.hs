module Items.Utils (
    randomList,
    contains,
    isValidPos, 
    address,
    addressMax,
    buildCorralAux,
    mockBuildCorralAux,
    mockMakeAdjMax,
    mockLenght,
    makeAdjMax,
    makePairs,
    mockMakePairs,
    lenght
) where 


import System.Random (Random (randomRs), StdGen, newStdGen, getStdGen)

randomList :: Int -> StdGen -> [Int]
randomList n = randomRs (0, n)

contains ::  (Eq a) => [a] -> a -> Bool
contains [] _ = False
contains (x : xs) val = (x == val) || contains xs val

-- dimensions, pos
isValidPos :: (Int, Int) -> (Int, Int) -> Bool
isValidPos (dx, dy) (px, py) = px < dx && py < dy && px >= 0 && py >= 0

address :: [(Int, Int)]
address = [(0, 1), (1, 0), (-1, 0), (0, -1)]

addressMax :: [(Int, Int)]
addressMax = [(-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1)]

makeAdjMax :: (Int, Int) -> [(Int, Int)]
makeAdjMax (x, y) = [(x + dx, y + dy) | (dx, dy) <- addressMax]

-- stack, checked, dimension, count
buildCorralAux :: [(Int, Int)] -> [(Int, Int)] -> (Int, Int) -> Int -> [(Int, Int)]
buildCorralAux [] checked _ _ = checked
buildCorralAux _ checked _ 0 = checked
buildCorralAux stack@(x : xs) checked dim@(dx, dy) count = 
    if not (contains checked x) && isValidPos dim x
        -- no hay que validar que esten vacias las casillas xq el corral es lo primero a generar, luego siempre estan vacias
        then buildCorralAux (xs ++ makeAdjMax x) (x : checked) dim (count - 1)
        else buildCorralAux xs checked dim count
        

mockBuildCorralAux :: [(Int, Int)]
mockBuildCorralAux = 
    buildCorralAux [(1, 1)] [] (10, 10) 5

mockMakeAdjMax :: [(Int, Int)]
mockMakeAdjMax = makeAdjMax (1, 1)

lenght :: [a] -> Int
lenght [] = 0
lenght (x : xs) = 1 + lenght xs

mockLenght :: Int
mockLenght = lenght [1, 2, 3, 4, 5]

-- empareja el segundo parametro con cada uno de los que esta en el array
-- ej: [(1, 1), (1, 2), (1, 3)] (5, 5) => [( (1, 1), (5, 5) ), ( (1, 2), (5, 5) ), ( (1, 3), (5, 5) )]
makePairs :: [(Int, Int)] -> (Int, Int) -> [((Int, Int), (Int, Int))]
makePairs pairs tuple = [(k, tuple) | k <- pairs]

mockMakePairs :: [((Int, Int), (Int, Int))]
mockMakePairs = makePairs [(1, 1), (2, 2)] (3, 3)

-- -- mxm, take
-- getListRnd :: Int -> Int -> [Int] 
-- getListRnd mxm t = do
--     g <- newStdGen
--     let rnd = randomNumb mxm g
--     take t rnd