module Items.Enviroment (
    Child (..),
    Dirt (..),
    Obstacle (..),
    Agent (..),
    Corral (..),
    Env (..),
    mockIsEmpty,
    mockBuildCorral,
    mockBuildChildren, 
    buildEnv,
    mockBuildEnv,
    mockTest,
    mockValidsAdjForChildBFS,
    mockChildBFS,
    mockNextPosToMove, 
    mockDirtyBFS
) where


import Items.Child (Child (Child), existChild)
import Items.Dirt (Dirt (Dirt), existDirty)
import Items.Obstacle (Obstacle (Obstacle), existObstacle)
import Items.Agent (Agent (Agent), existAgent)
import Items.Corral (Corral (Corral), existCorral)
import Items.Utils (randomList, isValidPos, buildCorralAux, contains, makeAdjMax, makePairs)
import System.Random (StdGen)

data Env = Env {
    children :: Child,
    agents :: Agent,
    corral :: Corral,
    dirty :: Dirt,
    obstacles :: Obstacle,
    dim :: (Int, Int)
} deriving (Show)


isEmpty :: Env -> (Int, Int) -> Bool
isEmpty 
    env@Env { children = ch, agents = ag, corral = co, dirty = di, obstacles = ob } pos 
        = not (existChild ch pos || existAgent ag pos || existCorral co pos || existDirty di pos || existObstacle ob pos)


mockIsEmpty :: Bool
mockIsEmpty = 
    isEmpty 
        Env { children = Child [(1, 1)], 
              agents = Agent [(1, 1), (1, 1)], 
              corral = Corral [(1, 1)] (1, 1), 
              dirty = Dirt [(1, 1)], 
              obstacles =  Obstacle [(1, 1)],
              dim = (2, 3) }
        (1, 2)


-- StartPos, BoardDim, Amount
buildCorral :: (Int, Int) -> (Int, Int) -> Int -> Env
buildCorral init dim count = 
    let co =  buildCorralAux [init] [] dim count
    in Env { 
                children = Child [],
                agents = Agent [],
                corral = Corral co init,
                dirty =  Dirt [],
                obstacles = Obstacle [],
                dim = dim
           }

mockBuildCorral :: Env
mockBuildCorral = buildCorral (1, 1) (10, 10) 5

buildObstacles :: Env -> [Int] -> Int -> Env
buildObstacles env [] _ = env
buildObstacles env _ 0 = env
buildObstacles env@Env { children = ch, agents = ag, corral = co,
                        dirty = di, obstacles = Obstacle ob, dim = d } (x : y : xs) count =
    if isEmpty env (x, y) && isValidPos d (x, y)
        then buildObstacles Env { 
                                    children = ch, 
                                    agents = ag,
                                    corral = co, 
                                    dirty = di, 
                                    obstacles =  Obstacle ([(x, y)] ++ ob), 
                                    dim = d 
                                }
                            xs (count - 1)
        else buildObstacles env xs count


buildAgents :: Env -> [Int] -> Int -> Env
buildAgents env [] _ = env
buildAgents env _ 0 = env
buildAgents env@Env { children = ch, agents = Agent ag, corral = co,
                        dirty = di, obstacles = ob, dim = d } (x : y : xs) count =
    if isEmpty env (x, y) && isValidPos d (x, y)
        then buildAgents Env { 
                                    children = ch, 
                                    agents = Agent ([(x, y)] ++ ag),
                                    corral = co, 
                                    dirty = di, 
                                    obstacles =  ob,
                                    dim = d 
                                }
                            xs (count - 1)
        else buildAgents env xs count



buildChildren :: Env -> [Int] -> Int -> Env
buildChildren env [] _ = env
buildChildren env _ 0  = env
buildChildren env@Env { children = Child ch, agents = ag, corral = co,
                        dirty = di, obstacles = ob, dim = d } (x : y : xs) count =
    if isEmpty env (x, y) && isValidPos d (x, y)
        then buildChildren Env { 
                                    children = Child ([(x, y)] ++ ch), 
                                    agents = ag,
                                    corral = co, 
                                    dirty = di, 
                                    obstacles = ob, 
                                    dim = d 
                                }
                            xs (count - 1)
        else buildChildren env xs count


mockBuildChildren :: Env
mockBuildChildren = buildChildren Env { 
                                        children = Child [(1, 1), (1, 2)],
                                        agents = Agent [(2, 3)],
                                        corral = Corral [(4, 4), (4, 5)] (1, 2), 
                                        dirty = Dirt [], 
                                        obstacles = Obstacle [(3, 7), (2, 7), (1, 8)], 
                                        dim = (10, 10)
                                      }
                                   [1, 2, 3, 4, 10, 6, 7, 8, 1, 2, 5, 3, 6, 7, 8, 1, 9, 1, 4, 6, 7, 2, 3, 4, 5, 1, 2, 3]  3


-- dim, childrenAmount, ObstacleAmount, AgentsAmount, Generator
buildEnv :: (Int, Int) -> Int -> Int -> Int -> StdGen -> Env
buildEnv dim@(dx, dy) childrenQty obstaclesQty agentsQty gen = 
    let ddx = dx - 1
        ddy = dy - 1
        menor = min ddx ddy
        rnd = randomList menor gen
        corralEnv = buildCorral (head rnd, head rnd) dim childrenQty
        obstaclesEnv = buildObstacles corralEnv rnd obstaclesQty
        childrenEnv = buildChildren obstaclesEnv rnd childrenQty
    in  buildAgents childrenEnv rnd agentsQty


mockBuildEnv :: StdGen -> Env 
mockBuildEnv gen = buildEnv (10, 10) 6 4 3 gen


-- TODO: garantizar antes de llamar a childBFS que hayan ninnos en fuera del corral, hace falta para la correctitud del algoritmo
-- env, startPos, checked, stack, way => retorna la posicion a la que tengo que moverme para estar mas cerca del ninno
childBFS :: Env -> (Int, Int) -> [(Int, Int)] -> [(Int, Int)] -> [((Int, Int), (Int, Int))] -> (Int, Int)
childBFS _ startPos _ [] _ = startPos
childBFS env@Env { children = ch, agents = ag, corral = co, dirty = di, obstacles = ob, dim = d } 
         startPos
         checked
         stack@(x : xs)
         way
            | existChild ch x = nextPosToMove startPos x way
            -- | x == (1, 3) = (-1, -1)
            | otherwise =  childBFS env 
                                    startPos 
                                    (x : checked)
                                    (xs ++ validsAdjForChildBFS env checked x d)
                                    (way ++ makePairs (validsAdjForChildBFS env checked x d) x)

mockChildBFS :: (Int, Int)
mockChildBFS = childBFS Env { 
                                children = Child [(2, 4)],
                                agents = Agent [(3, 1)],
                                corral = Corral [(8, 8), (8, 9)] (8, 8), 
                                dirty = Dirt [], 
                                obstacles = Obstacle [(1, 1), (2, 2), (0, 4)], 
                                dim = (10, 10)
                            }
                        (0, 0)
                        []
                        [(0, 0)]
                        []


-- env, checked, source, dim
validsAdjForChildBFS :: Env -> [(Int, Int)] -> (Int, Int) -> (Int, Int) -> [(Int, Int)]
validsAdjForChildBFS env@Env { children = ch, agents = ag, corral = co,
                                dirty = di, obstacles = ob, dim = d } 
                      checked 
                      source 
                      dim = [t | t <- makeAdjMax source, isValidPos dim t, 
                                                        -- not (existChild ch t),
                                                        not (existObstacle ob t),
                                                        not (existAgent ag t),
                                                        not (existCorral co t),
                                                        -- isEmpty env t, 
                                                        not (contains checked t)]

mockValidsAdjForChildBFS :: [(Int, Int)]
mockValidsAdjForChildBFS = validsAdjForChildBFS Env { 
                                                        children = Child [(2, 4)],
                                                        agents = Agent [(3, 1)],
                                                        corral = Corral [(4, 4), (4, 5)] (4, 4), 
                                                        dirty = Dirt [], 
                                                        obstacles = Obstacle [(1, 1), (2, 2), (0, 4)], 
                                                        dim = (10, 10)
                                                       }
                                                    []
                                                    (2, 1)
                                                    (10, 10)


-- TODO: garantizar antes de llamar a dirtyBFS que haya suciedad para garantizar la correctitud del algoritmo
-- env, startPos, checked, stack, way => retorna la posicion a la que tengo que moverme para estar mas cerca de la suciedad
dirtyBFS :: Env -> (Int, Int) -> [(Int, Int)] -> [(Int, Int)] -> [((Int, Int), (Int, Int))] -> (Int, Int)
dirtyBFS _ startPos _ [] _ = startPos
dirtyBFS env@Env { children = ch, agents = ag, corral = co, dirty = di, obstacles = ob, dim = d } 
         startPos
         checked
         stack@(x : xs)
         way
            | existDirty di x = nextPosToMove startPos x way
            -- | x == (1, 3) = (-1, -1)
            | otherwise =  dirtyBFS env 
                                    startPos 
                                    (x : checked)
                                    (xs ++ validsAdjForDirtyBFS env checked x d)
                                    (way ++ makePairs (validsAdjForDirtyBFS env checked x d) x)


validsAdjForDirtyBFS :: Env -> [(Int, Int)] -> (Int, Int) -> (Int, Int) -> [(Int, Int)]
validsAdjForDirtyBFS env@Env { children = ch, agents = ag, corral = co,
                                dirty = di, obstacles = ob, dim = d } 
                      checked 
                      source 
                      dim = [t | t <- makeAdjMax source, isValidPos dim t, 
                                                        not (existChild ch t),
                                                        not (existObstacle ob t),
                                                        not (existAgent ag t),
                                                        not (existCorral co t),
                                                        -- isEmpty env t, 
                                                        not (contains checked t)]

mockDirtyBFS :: (Int, Int)
mockDirtyBFS = dirtyBFS Env { 
                                children = Child [(2, 4)],
                                agents = Agent [(3, 1), (2, 1)],
                                corral = Corral [(8, 8), (8, 9)] (8, 8), 
                                dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                obstacles = Obstacle [(1, 1), (2, 2), (0, 4)], 
                                dim = (10, 10)
                            }
                        (0, 0)
                        []
                        [(0, 0)]
                        [] 




-- source end way
nextPosToMove :: (Int, Int) -> (Int, Int) -> [((Int, Int), (Int, Int))] -> (Int, Int)
nextPosToMove source end way@((ch, p) : xs) | getParent end way == source = end
                                            | otherwise = nextPosToMove source (getParent end way) way

-- node way // get parent for node
getParent :: (Int, Int) ->  [((Int, Int), (Int, Int))] -> (Int, Int)
getParent child [] = child
getParent child ((c, p) : xs) = if c == child then p else getParent child xs

mockNextPosToMove :: (Int, Int)
mockNextPosToMove = nextPosToMove (0, 0) (2, 4) [((1, 0), (0, 0)),
                                                 ((0, 1), (0, 0)),
                                                 ((0, 2), (0, 1)),
                                                 ((1, 2), (0, 2)),
                                                 ((1, 3), (1, 2)),
                                                 ((2, 3), (1, 3)),
                                                 ((2, 4), (2, 3))]

mockTest :: [(Int, Int)]
mockTest = [t | t <- makeAdjMax (1, 1), isValidPos (10, 10) t, not (contains [(1, 1), (2, 2)] t)]