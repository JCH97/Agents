module Items.Utils (
    randomNumb,
    contains,
    isValidPos, 
    address,
    addressMax,
    buildCorralAux,
    mockBuildCorralAux,
    mockMakeAdjMax
) where 


import System.Random (Random (randomRs), StdGen)

randomNumb :: Int -> StdGen -> [Int]
randomNumb n = randomRs (0, n)

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