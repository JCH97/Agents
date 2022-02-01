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
    mockDirtyBFS,
    mockGetPlaceOnCorralAux,
    mockManhantanDistance,
    mockMoveAgentToCorral,
    mockGetPosToMoveChild, 
    mockAgentMoveCase1,
    mockAgentMoveCase4,
    mockMoveOneAgent
) where


import Items.Child (Child (Child), existChild, removeChild, updateChild, existChildOutCorral)
import Items.Dirt (Dirt (Dirt), existDirty, removeDirty)
import Items.Obstacle (Obstacle (Obstacle), existObstacle)
import Items.Agent (Agent (Agent), existAgent, agentLeaveChild, updateAgent, agentGetChild)
import Items.Corral (Corral (Corral), existCorral)
import Items.Utils (randomList, isValidPos, buildCorralAux, contains, makeAdjMax, makePairs, lenght)
import System.Random (StdGen)

data Env = Env {
    children :: Child,
    agents :: Agent,
    corral :: Corral,
    dirty :: Dirt,
    obstacles :: Obstacle,
    dim :: (Int, Int),
    ignorePositions :: [(Int, Int)] -- son posiciones que por razon X tienen que ser ignoradas durantes los BFSs
} deriving (Show)


isEmpty :: Env -> (Int, Int) -> Bool
isEmpty 
    env@Env { children = ch, agents = ag, corral = co, dirty = di, obstacles = ob } pos 
        = not (existChild ch pos || existAgent ag pos || existCorral co pos || existDirty di pos || existObstacle ob pos)


mockIsEmpty :: Bool
mockIsEmpty = 
    isEmpty 
        Env { children = Child [(1, 1)], 
              agents = Agent [(1, 1), (1, 1)] [], 
              corral = Corral [(1, 1)] (1, 1), 
              dirty = Dirt [(1, 1)], 
              obstacles =  Obstacle [(1, 1)],
              dim = (2, 3),
              ignorePositions = []
            }
        (1, 2)


-- StartPos, BoardDim, Amount
buildCorral :: (Int, Int) -> (Int, Int) -> Int -> Env
buildCorral init dim count = 
    let co =  buildCorralAux [init] [] dim count
    in Env { 
                children = Child [],
                agents = Agent [] [],
                corral = Corral co init,
                dirty =  Dirt [],
                obstacles = Obstacle [],
                dim = dim,
                ignorePositions = []
           }

mockBuildCorral :: Env
mockBuildCorral = buildCorral (1, 1) (10, 10) 5

buildObstacles :: Env -> [Int] -> Int -> Env
buildObstacles env [] _ = env
buildObstacles env _ 0 = env
buildObstacles env@Env { children = ch, agents = ag, corral = co,
                        dirty = di, obstacles = Obstacle ob, dim = d, ignorePositions = ig } (x : y : xs) count =
    if isEmpty env (x, y) && isValidPos d (x, y)
        then buildObstacles Env { 
                                    children = ch, 
                                    agents = ag,
                                    corral = co, 
                                    dirty = di, 
                                    obstacles =  Obstacle ([(x, y)] ++ ob), 
                                    dim = d,
                                    ignorePositions = ig
                                }
                            xs (count - 1)
        else buildObstacles env xs count


buildAgents :: Env -> [Int] -> Int -> Env
buildAgents env [] _ = env
buildAgents env _ 0 = env
buildAgents env@Env { children = ch, agents = Agent ag _, corral = co,
                        dirty = di, obstacles = ob, dim = d, ignorePositions = ig } (x : y : xs) count =
    if isEmpty env (x, y) && isValidPos d (x, y)
        then buildAgents Env { 
                                    children = ch, 
                                    agents = Agent ([(x, y)] ++ ag) [],
                                    corral = co, 
                                    dirty = di, 
                                    obstacles =  ob,
                                    dim = d,
                                    ignorePositions = ig
                                }
                            xs (count - 1)
        else buildAgents env xs count



buildChildren :: Env -> [Int] -> Int -> Env
buildChildren env [] _ = env
buildChildren env _ 0  = env
buildChildren env@Env { children = Child ch, agents = ag, corral = co,
                        dirty = di, obstacles = ob, dim = d, ignorePositions = ig } (x : y : xs) count =
    if isEmpty env (x, y) && isValidPos d (x, y)
        then buildChildren Env { 
                                    children = Child ([(x, y)] ++ ch), 
                                    agents = ag,
                                    corral = co, 
                                    dirty = di, 
                                    obstacles = ob, 
                                    dim = d,
                                    ignorePositions = ig
                                }
                            xs (count - 1)
        else buildChildren env xs count


mockBuildChildren :: Env
mockBuildChildren = buildChildren Env { 
                                        children = Child [(1, 1), (1, 2)],
                                        agents = Agent [(2, 3)] [],
                                        corral = Corral [(4, 4), (4, 5)] (1, 2), 
                                        dirty = Dirt [], 
                                        obstacles = Obstacle [(3, 7), (2, 7), (1, 8)], 
                                        dim = (10, 10),
                                        ignorePositions = []
                                      }
                                   [1, 2, 3, 4, 10, 6, 7, 8, 1, 2, 5, 3, 6, 7, 8, 1, 9, 1, 4, 6, 7, 2, 3, 4, 5, 1, 2, 3]  3


-- dim, childrenAmount, ObstacleAmount, AgentsAmount, Generator
buildEnv :: (Int, Int) -> Int -> Int -> Int -> StdGen -> Env
buildEnv dim@(dx, dy) childrenQty obstaclesQty agentsQty gen = 
    let ddx = dx - 1
        ddy = dy - 1
        menor = min ddx ddy -- TODO: aqui hay posiciones del tablero en las que nunca se va a generar nada
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
                                agents = Agent [(3, 1)] [],
                                corral = Corral [(8, 8), (8, 9)] (8, 8), 
                                dirty = Dirt [], 
                                obstacles = Obstacle [(1, 1), (2, 2), (0, 4)], 
                                dim = (10, 10),
                                ignorePositions = []
                            }
                        (0, 0)
                        []
                        [(0, 0)]
                        []


-- env, checked, source, dim
validsAdjForChildBFS :: Env -> [(Int, Int)] -> (Int, Int) -> (Int, Int) -> [(Int, Int)]
validsAdjForChildBFS env@Env { children = ch, agents = ag, corral = co,
                                dirty = di, obstacles = ob, dim = d, ignorePositions = ig } 
                      checked 
                      source 
                      dim = [t | t <- makeAdjMax source, isValidPos dim t, 
                                                        -- not (existChild ch t),
                                                        not (existObstacle ob t),
                                                        not (existAgent ag t),
                                                        -- not (existCorral co t),
                                                        not (contains ig t),
                                                        -- isEmpty env t, 
                                                        not (contains checked t)]

mockValidsAdjForChildBFS :: [(Int, Int)]
mockValidsAdjForChildBFS = validsAdjForChildBFS Env { 
                                                        children = Child [(2, 4)],
                                                        agents = Agent [(3, 1)] [],
                                                        corral = Corral [(4, 4), (4, 5)] (4, 4), 
                                                        dirty = Dirt [], 
                                                        obstacles = Obstacle [(1, 1), (2, 2), (0, 4)], 
                                                        dim = (10, 10),
                                                        ignorePositions = []
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
                                dirty = di, obstacles = ob, dim = d, ignorePositions = ig } 
                      checked 
                      source 
                      dim = [t | t <- makeAdjMax source, isValidPos dim t, 
                                                        not (existChild ch t),
                                                        not (existObstacle ob t),
                                                        not (existAgent ag t),
                                                        not (existCorral co t),
                                                        not (contains ig t),
                                                        -- isEmpty env t, 
                                                        not (contains checked t)]


mockDirtyBFS :: (Int, Int)
mockDirtyBFS = dirtyBFS Env { 
                                children = Child [(2, 4)],
                                agents = Agent [(3, 1), (2, 1)] [],
                                corral = Corral [(8, 8), (8, 9)] (8, 8), 
                                dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                obstacles = Obstacle [(1, 1), (2, 2), (0, 4)], 
                                dim = (10, 10),
                                ignorePositions = [(0, 2)]
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

getPlaceOnCorral :: Env -> (Int, Int)
getPlaceOnCorral env@Env { children = ch, agents = ag, corral = Corral val center,
                           dirty = di, obstacles = ob, dim = d, ignorePositions = ig } = 
                               getPlaceOnCorralAux val center 1000000 center ig

-- posicionesDelCorral, centroDelCorral, mejorDistHastaAhora, respuestaTemporal, PosicionesAIgnorar
getPlaceOnCorralAux :: [(Int, Int)] -> (Int, Int) -> Int -> (Int, Int) -> [(Int, Int)] -> (Int, Int)
getPlaceOnCorralAux [] _ _ temporalAns _ = temporalAns
getPlaceOnCorralAux (x : xs) center best temporalAns ignorePos
                                --  | 
                                 | contains ignorePos x = getPlaceOnCorralAux xs center best temporalAns ignorePos
                                 | manhatanDistance x center < best = 
                                                            getPlaceOnCorralAux xs center (manhatanDistance x center) x ignorePos
                                 | otherwise = getPlaceOnCorralAux xs center best temporalAns ignorePos

mockGetPlaceOnCorralAux :: (Int, Int) 
mockGetPlaceOnCorralAux = getPlaceOnCorralAux [(0, 1), (0, 2), (0, 3), (1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3)]
                                              (1, 2)
                                              1000000
                                              (1, 2)
                                              [(1, 2)]

manhatanDistance :: (Int, Int) -> (Int, Int) -> Int
manhatanDistance (x1, y1) (x2, y2) = abs (x2 - x1) + abs (y2 - y1)

mockManhantanDistance :: Int
mockManhantanDistance = manhatanDistance (2, 3) (1, 2)

-- env, startAgentPos, posToLeaveChild, stack, checked, way
moveAgentToCorral :: Env -> (Int, Int) -> (Int, Int) -> [(Int, Int)] -> [(Int, Int)] -> [((Int, Int), (Int, Int))] -> (Int, Int)
moveAgentToCorral env@Env{ children = ch, agents = ag, corral = co,
                          dirty = di, obstacles = ob, dim = d, ignorePositions = ig } 
                   source 
                   end 
                   stack@(x : xs) 
                   checked 
                   way  
                      | x == end = nextPosToMove source x way
                      | otherwise = moveAgentToCorral env
                                                      source
                                                      end
                                                      (xs ++ validsAdjForMoveAgentToCorral env checked x d)
                                                      (x : checked)
                                                      (way ++ makePairs (validsAdjForMoveAgentToCorral env checked x d) x)

mockMoveAgentToCorral :: (Int, Int)
mockMoveAgentToCorral = moveAgentToCorral  Env { 
                                                children = Child [(2, 4)],
                                                agents = Agent [(3, 1), (2, 1)] [],
                                                corral = Corral [(3, 5)] (3, 5), 
                                                dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                                obstacles = Obstacle [(0, 1), (2, 2), (0, 4)], 
                                                dim = (10, 10),
                                                ignorePositions = [(0, 2)]
                                            }
                                            (0, 0)
                                            (3, 5)
                                            [(0, 0)]
                                            []
                                            []
                                            

validsAdjForMoveAgentToCorral :: Env -> [(Int, Int)] -> (Int, Int) -> (Int, Int) -> [(Int, Int)]
validsAdjForMoveAgentToCorral env@Env { children = ch, agents = ag, corral = co,
                                dirty = di, obstacles = ob, dim = d, ignorePositions = ig } 
                                checked 
                                source 
                                dim = [t | t <- makeAdjMax source, isValidPos dim t, 
                                                                    not (existChild ch t),
                                                                    not (existObstacle ob t),
                                                                    not (existAgent ag t),
                                                                    -- not (existCorral co t),
                                                                    not (contains ig t),
                                                                    -- isEmpty env t, 
                                                                    not (contains checked t)]

-- env, boardDim, generador
getPosToMoveChild :: Env ->  (Int, Int) -> StdGen -> (Int, Int)
getPosToMoveChild env@Env { children = ch, agents = ag, corral = co,
                            dirty = di, obstacles = ob, dim = d, ignorePositions = ig } 
                           childPos 
                           g 
                                = let freePos = [t | t <- makeAdjMax childPos, isValidPos d t,
                                                                               isEmpty env t,
                                                                               not (contains ig t)]
                                      -- como en la lista de posibles se incluye la posicion actual del ninno 
                                      -- entonces eso significa que se queda en la posicion y no se mueve, luego no hay que
                                      -- validarlo
                                      l = lenght freePos
                                      idx = head (randomList l g)
                                  in (childPos : freePos) !! idx

mockGetPosToMoveChild :: StdGen -> (Int, Int)
mockGetPosToMoveChild g = getPosToMoveChild Env { 
                                                    children = Child [(2, 4)],
                                                    agents = Agent [(3, 1), (2, 1)] [],
                                                    corral = Corral [(3, 5)] (3, 5), 
                                                    dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                                    obstacles = Obstacle [(0, 1), (2, 2), (0, 4)], 
                                                    dim = (10, 10),
                                                    ignorePositions = [(0, 2)]
                                                }
                                                (2, 4)
                                                g
moveAgents :: Env -> Env
moveAgents env@Env { children = ch, agents = Agent value _, corral = co,
                     dirty = di, obstacles = ob, dim = d, ignorePositions = ig }
                         = moveAgentsAux env value

-- env, posicionesDeLosRobots
moveAgentsAux :: Env -> [(Int, Int)] -> Env
moveAgentsAux env [] = env
moveAgentsAux env (p: ps) = let newEnv = moveOneAgent env p
                            in moveAgentsAux newEnv ps

moveOneAgent :: Env -> (Int, Int) -> Env
moveOneAgent env@Env { children = ch, agents = Agent unused1 carrying, corral = co,
                       dirty = di, obstacles = ob, dim = d, ignorePositions = ig } 
             agentPos
                        | contains carrying agentPos
                            = agentMoveCase1 env agentPos (getPlaceOnCorral env)
                        | existDirty di agentPos
                            =  agentMoveCase2 env agentPos
                        | existChild ch agentPos 
                            = agentMoveCase3 env agentPos
                        | otherwise = agentMoveCase4 env agentPos

-- env, startAgentPos, posToLeaveChild
-- Case 1: El robot tiene un ninno cargado => hay que moverlo pal corral
agentMoveCase1 :: Env -> (Int, Int) -> (Int, Int) -> Env
agentMoveCase1 env@Env { children = ch, agents = ag, corral = co,
                     dirty = di, obstacles = ob, dim = d, ignorePositions = ig }
               startPos 
               endPos 
                   = 
                    if startPos == endPos then 
                        let newAgent = agentLeaveChild ag startPos
                            -- newIgnorePos
                        in Env {
                                children = ch,
                                agents = newAgent,
                                corral = co,
                                dirty = di,
                                obstacles = ob,
                                dim = d,
                                ignorePositions = (startPos : ig)
                               }
                        -- deja al nino en la posicion => 
                        --  2. decir que el agente no carga ya al ninno
                        --  3. poner esa posicion en el corral como ignorada   

                    else
                        -- moverse 
                        let newAgentPos = moveAgentToCorral env startPos endPos [startPos] [] []
                            newAgent1 = updateAgent ag startPos newAgentPos
                        in Env {
                                children = ch,
                                agents = newAgent1,
                                corral = co,
                                dirty = di,
                                obstacles = ob,
                                dim = d,
                                ignorePositions = ig
                               }

mockAgentMoveCase1 :: Env 
mockAgentMoveCase1 = agentMoveCase1 Env { 
                                            children = Child [(2, 4)],
                                            agents = Agent [(0, 0), (2, 1)] [],
                                            corral = Corral [(3, 5)] (3, 5), 
                                            dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                            obstacles = Obstacle [(0, 1), (2, 2), (0, 4)], 
                                            dim = (10, 10),
                                            ignorePositions = [(0, 2)]
                                        }
                                    (0, 0)
                                    (3, 5)

-- El robot esta parado sobre una suciedad => limpiala
agentMoveCase2 :: Env -> (Int, Int) -> Env
agentMoveCase2 env@Env { children = ch, agents = ag, corral = co,
                    dirty = di, obstacles = ob, dim = d, ignorePositions = ig }
               pos 
                    =  let newDirty = removeDirty di pos
                        in Env {
                                children = ch,
                                agents = ag,
                                corral = co,
                                dirty = newDirty,
                                obstacles = ob,
                                dim = d,
                                ignorePositions = ig
                               }

-- si el robot esta parado sobre un ninno => lo quito del tablero y  lo cargo
agentMoveCase3 :: Env -> (Int, Int) -> Env
agentMoveCase3 env@Env { children = ch, agents = ag, corral = co,
                    dirty = di, obstacles = ob, dim = d, ignorePositions = ig }
                pos 
                    = let newChildren = removeChild ch pos
                          agentUpdt = agentGetChild ag pos
                      in Env {
                                children = newChildren,
                                agents = agentUpdt,
                                corral = co,
                                dirty = di,
                                obstacles = ob,
                                dim = d,
                                ignorePositions = ig
                              }
mockAgentMoveCase3 :: Env
mockAgentMoveCase3 = agentMoveCase3 Env { 
                                        children = Child [(2, 4), (2, 0)],
                                        agents = Agent [(0, 0), (2, 1)] [],
                                        corral = Corral [(3, 5)] (3, 5), 
                                        dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                        obstacles = Obstacle [(1, 1), (2, 2), (0, 4)], 
                                        dim = (10, 10),
                                        ignorePositions = [(0, 2)]
                                    }
                                    (0, 0)

-- buscar el nino mas cercano en el corral y moverse hacia el
agentMoveCase4 :: Env -> (Int, Int) -> Env
agentMoveCase4 env@Env { children = ch, agents = ag, corral = co,
                    dirty = di, obstacles = ob, dim = d, ignorePositions = ig }
                pos
                    | existChildOutCorral ch = 
                                let newPosAgent = childBFS env pos [] [pos] []
                                    newAgents = updateAgent ag pos newPosAgent
                                in Env {
                                            children = ch,
                                            agents = newAgents,
                                            corral = co,
                                            dirty = di,
                                            obstacles = ob,
                                            dim = d,
                                            ignorePositions = ig
                                        }

                    | otherwise = env

mockAgentMoveCase4 :: Env
mockAgentMoveCase4 = agentMoveCase4 Env { 
                                        children = Child [(2, 4), (2, 0)],
                                        agents = Agent [(0, 0), (2, 1)] [],
                                        corral = Corral [(3, 5)] (3, 5), 
                                        dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                        obstacles = Obstacle [(1, 1), (2, 2), (0, 4)], 
                                        dim = (10, 10),
                                        ignorePositions = [(0, 2)]
                                    }
                                    (0, 0)

mockMoveOneAgent :: Env
mockMoveOneAgent = moveOneAgent Env { 
                                        children = Child [(2, 4)],
                                        agents = Agent [(0, 0), (2, 1)] [(2, 1)],
                                        corral = Corral [(3, 5)] (3, 5), 
                                        dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                        obstacles = Obstacle [(1, 2), (2, 2), (0, 4)], 
                                        dim = (10, 10),
                                        ignorePositions = [(0, 2)]
                                    }
                                (2, 1)