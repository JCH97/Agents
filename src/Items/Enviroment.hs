module Items.Enviroment (
    Child (..),
    Dirt (..),
    Obstacle (..),
    Agent (..),
    Corral (..),
    Env (..),
    buildEnv,
    moveChilds,
    moveAgents,
    wrapIsEmpty,
    wrapBuildCorral,
    wrapBuildChildren, 
    wrapBuildEnv,
    wrapTest,
    wrapValidsAdjForChildBFS,
    wrapChildBFS,
    wrapNextPosToMove, 
    wrapDirtyBFS,
    wrapGetPlaceOnCorralAux,
    wrapManhantanDistance,
    wrapMoveAgentToCorral,
    wrapGetPosToMoveChild, 
    wrapAgentMoveCase1,
    wrapAgentMoveCase4,
    wrapMoveOneAgent, 
    wrapMoveAgents, 
    wrapRefactorObstacles,
    wrapMoveOneChild,
    getPercentDirty,
    wrapAddRandomDirty
) where


import Items.Child (Child (Child), existChild, removeChild, updateChild, existChildOutCorral)
import Items.Dirt (Dirt (Dirt), existDirty, removeDirty, existDirtyInBoard, addDirtyInPos)
import Items.Obstacle (Obstacle (Obstacle), existObstacle, updateObstacle)
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


wrapIsEmpty :: Bool
wrapIsEmpty = 
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

wrapBuildCorral :: Env
wrapBuildCorral = buildCorral (1, 1) (10, 10) 5

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



-- env generador cantidadDeNinnosAGenerar
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

-- TODO: all llamar a esto asegurar que se cree mas suciedad que la que habia para que esto tenga sentido
buildDirty :: Env -> [Int] -> Int -> Env
buildDirty env [] _ = env
buildDirty env _ 0 = env
buildDirty env@Env { children = ch, agents = ag, corral = co,
                     dirty = Dirt di, obstacles = ob, dim = d, ignorePositions = ig } 
           (x : y : xs) 
           count 
                =   if isEmpty env (x, y) && isValidPos d (x, y)
                            then buildDirty Env { 
                                                        children = ch, 
                                                        agents = ag,
                                                        corral = co, 
                                                        dirty = Dirt ([(x, y)] ++ di), 
                                                        obstacles = ob, 
                                                        dim = d,
                                                        ignorePositions = ig
                                                    }
                                                xs (count - 1)
                            else buildDirty env xs count


wrapBuildChildren :: Env
wrapBuildChildren = buildChildren Env { 
                                        children = Child [(1, 1), (1, 2)],
                                        agents = Agent [(2, 3)] [],
                                        corral = Corral [(4, 4), (4, 5)] (1, 2), 
                                        dirty = Dirt [], 
                                        obstacles = Obstacle [(3, 7), (2, 7), (1, 8)], 
                                        dim = (10, 10),
                                        ignorePositions = []
                                      }
                                   [1, 2, 3, 4, 10, 6, 7, 8, 1, 2, 5, 3, 6, 7, 8, 1, 9, 1, 4, 6, 7, 2, 3, 4, 5, 1, 2, 3]  3


-- dim, childrenAmount, ObstacleAmount, AgentsAmount, DirtyAmount, Generator
buildEnv :: (Int, Int) -> Int -> Int -> Int -> Int -> StdGen -> Env
buildEnv dim@(dx, dy) childrenQty obstaclesQty agentsQty dirtyQty gen = 
    let ddx = dx - 1
        ddy = dy - 1
        menor = min ddx ddy -- TODO: aqui hay posiciones del tablero en las que nunca se va a generar nada
        rnd = randomList menor gen
        corralEnv = buildCorral (head rnd, head rnd) dim childrenQty
        obstaclesEnv = buildObstacles corralEnv rnd obstaclesQty
        childrenEnv = buildChildren obstaclesEnv rnd childrenQty
        agentsEnv = buildAgents childrenEnv rnd agentsQty
    in  buildDirty agentsEnv rnd dirtyQty


wrapBuildEnv :: StdGen -> Env 
wrapBuildEnv gen = buildEnv (10, 10) 6 4 3 2 gen


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

wrapChildBFS :: (Int, Int)
wrapChildBFS = childBFS Env { 
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

wrapValidsAdjForChildBFS :: [(Int, Int)]
wrapValidsAdjForChildBFS = validsAdjForChildBFS Env { 
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


wrapDirtyBFS :: (Int, Int)
wrapDirtyBFS = dirtyBFS Env { 
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

wrapNextPosToMove :: (Int, Int)
wrapNextPosToMove = nextPosToMove (0, 0) (2, 4) [((1, 0), (0, 0)),
                                                 ((0, 1), (0, 0)),
                                                 ((0, 2), (0, 1)),
                                                 ((1, 2), (0, 2)),
                                                 ((1, 3), (1, 2)),
                                                 ((2, 3), (1, 3)),
                                                 ((2, 4), (2, 3))]

wrapTest :: [(Int, Int)]
wrapTest = [t | t <- makeAdjMax (1, 1), isValidPos (10, 10) t, not (contains [(1, 1), (2, 2)] t)]

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

wrapGetPlaceOnCorralAux :: (Int, Int) 
wrapGetPlaceOnCorralAux = getPlaceOnCorralAux [(0, 1), (0, 2), (0, 3), (1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3)]
                                              (1, 2)
                                              1000000
                                              (1, 2)
                                              [(1, 2)]

manhatanDistance :: (Int, Int) -> (Int, Int) -> Int
manhatanDistance (x1, y1) (x2, y2) = abs (x2 - x1) + abs (y2 - y1)

wrapManhantanDistance :: Int
wrapManhantanDistance = manhatanDistance (2, 3) (1, 2)

-- env, startAgentPos, posToLeaveChild, stack, checked, way
moveAgentToCorral :: Env -> (Int, Int) -> (Int, Int) -> [(Int, Int)] -> [(Int, Int)] -> [((Int, Int), (Int, Int))] -> (Int, Int)
moveAgentToCorral _ source _ [] _ _  = source
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

wrapMoveAgentToCorral :: (Int, Int)
wrapMoveAgentToCorral = moveAgentToCorral  Env { 
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

moveChilds :: Env -> StdGen -> Env
moveChilds env@Env { children = Child ch, agents = ag, corral = co,
                     dirty = di, obstacles = ob, dim = d, ignorePositions = ig } gen = 
                                        moveAllChilds env ch gen
 
moveAllChilds :: Env -> [(Int, Int)] -> StdGen -> Env
moveAllChilds env [] _ = env
moveAllChilds env (x : xs) gen  
                        = let newEnv = moveOneChild  env x gen
                          in moveAllChilds newEnv xs gen

moveOneChild :: Env -> (Int, Int) -> StdGen -> Env
moveOneChild env@Env { children = ch, agents = ag, corral = co,
                     dirty = di, obstacles = ob, dim = d, ignorePositions = ig }
              childPos
              gen
                    = let newChildPos =  getPosToMoveChild env childPos gen                    
                       in refactorObstacles env childPos newChildPos

wrapMoveOneChild :: StdGen -> Env
wrapMoveOneChild g = moveOneChild Env { 
                                        children = Child [(2, 4), (3, 2)],
                                        agents = Agent [(3, 1), (2, 1)] [],
                                        corral = Corral [(3, 5)] (3, 5), 
                                        dirty = Dirt [], 
                                        obstacles = Obstacle [(2, 2), (1, 2)], 
                                        dim = (10, 10),
                                        ignorePositions = []
                                      }
                                (3, 2)
                                g

-- obstacleStruct, oldChildPos, newChildPos 
-- este metodo se usa para cuando un nino se mueve hacia un obstaculo y tiene que empujarlo
refactorObstacles :: Env -> (Int, Int) -> (Int, Int) -> Env
refactorObstacles env@Env { children = ch, agents = ag, corral = co,
                            dirty = di, obstacles = ob, dim = d, ignorePositions = ig }
                  t1@(x1, y1)  -- oldChildPos
                  t2@(x2, y2)  -- newChildPos --- aqui tambien esta el obstaculo que hay que quitar
                            | not (existObstacle ob t2) = -- aqui se mueve el ninno si no hay obstaculos
                                let updatedChildren = updateChild ch t1 t2
                                    updatedDirty = addDirtyInPos di t1
                                in Env {
                                            children = updatedChildren,
                                            agents = ag,
                                            corral = co,
                                            dirty = updatedDirty,
                                            obstacles = ob,
                                            dim = d,
                                            ignorePositions = ig
                                        }
                            | otherwise = let x = x2 - x1
                                              y = y2 - y1
                                           in refactorObstaclesAux env (x, y) t2 t2 t1

-- env, direccionDeDesplzamiento, antiguaPosicionDelObstaculo posicionTemporal oldChildPos
refactorObstaclesAux :: Env -> (Int, Int) -> (Int, Int) -> (Int, Int) -> (Int, Int) -> Env
refactorObstaclesAux env@Env { children = ch, agents = ag, corral = co,
                             dirty = di, obstacles = ob, dim = d, ignorePositions = ig }
                     direction@(x, y)
                     oldPos -- posicion del obstaculo a mover ---- tambien contiene la posicion donde colocar el nuevo ninno
                     temporalPos@(ox, oy)
                     oldChildPos
                           | not (isValidPos d temporalPos) = env
                           | isEmpty env temporalPos -- aqui se mueve el ninno si tiene que empujar obstaculos
                                        = let newObstacles = updateObstacle ob oldPos temporalPos
                                              newChilds = updateChild ch oldChildPos oldPos
                                              updatedDirty = addDirtyInPos di oldChildPos
                                          in Env {
                                                    children = newChilds,
                                                    agents = ag,
                                                    corral = co,
                                                    dirty = updatedDirty,
                                                    obstacles = newObstacles,
                                                    dim = d,
                                                    ignorePositions = ig
                                                }
                           | otherwise = let newTemporalPosX = x + ox
                                             newTemporalPosY = y + oy
                                          in refactorObstaclesAux env direction oldPos (newTemporalPosX, newTemporalPosY) oldChildPos

wrapRefactorObstacles :: Env
wrapRefactorObstacles = refactorObstacles Env { 
                                                    children = Child [(2, 4), (3, 2)],
                                                    agents = Agent [(3, 1), (2, 1)] [],
                                                    corral = Corral [(3, 5)] (3, 5), 
                                                    dirty = Dirt [], 
                                                    obstacles = Obstacle [(2, 2), (1, 2), (0, 2)], 
                                                    dim = (10, 10),
                                                    ignorePositions = []
                                                }
                                           (3, 2)
                                           (2, 2)


-- env, childPos, generador
getPosToMoveChild :: Env ->  (Int, Int) -> StdGen -> (Int, Int)
getPosToMoveChild env@Env { children = ch, agents = ag, corral = co,
                            dirty = di, obstacles = ob, dim = d, ignorePositions = ig } 
                           childPos 
                           g 
                                = let freePos = [t | t <- makeAdjMax childPos, isValidPos d t,
                                                                            --    isEmpty env t,
                                                                               not (existChild ch t),
                                                                            --    not (existObstacle ob t),
                                                                               not (existAgent ag t),   
                                                                               not (contains ig t)]
                                      -- como en la lista de posibles se incluye la posicion actual del ninno 
                                      -- entonces eso significa que se queda en la posicion y no se mueve, luego no hay que
                                      -- validarlo
                                      l = lenght freePos
                                      idx = head (randomList l g)
                                  in (childPos : freePos) !! idx

wrapGetPosToMoveChild :: StdGen -> (Int, Int)
wrapGetPosToMoveChild g = getPosToMoveChild Env { 
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
                        | existChild ch agentPos && not (contains ig agentPos)
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

wrapAgentMoveCase1 :: Env 
wrapAgentMoveCase1 = agentMoveCase1 Env { 
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
wrapAgentMoveCase3 :: Env
wrapAgentMoveCase3 = agentMoveCase3 Env { 
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
                    | existDirtyInBoard di = 
                                let newPosAgent = dirtyBFS env pos [] [pos] []
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

wrapAgentMoveCase4 :: Env
wrapAgentMoveCase4 = agentMoveCase4 Env { 
                                        children = Child [],
                                        agents = Agent [(0, 0), (2, 1)] [],
                                        corral = Corral [(3, 5)] (3, 5), 
                                        dirty = Dirt [], 
                                        obstacles = Obstacle [(1, 1), (2, 2), (0, 4)], 
                                        dim = (10, 10),
                                        ignorePositions = [(0, 2)]
                                    }
                                    (0, 0)

wrapMoveOneAgent :: Env
wrapMoveOneAgent = moveOneAgent Env { 
                                        children = Child [(2, 4)],
                                        agents = Agent [(0, 0), (2, 1)] [(2, 1)],
                                        corral = Corral [(3, 5)] (3, 5), 
                                        dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                        obstacles = Obstacle [(1, 2), (2, 2), (0, 4)], 
                                        dim = (10, 10),
                                        ignorePositions = [(0, 2)]
                                    }
                                (2, 1)

wrapMoveAgents :: Env 
wrapMoveAgents = moveAgents Env { 
                                    children = Child [(2, 4)],
                                    agents = Agent [(0, 1), (2, 1)] [(2, 1)],
                                    corral = Corral [(5, 5)] (5, 5), 
                                    dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                    obstacles = Obstacle [(1, 2), (2, 2), (0, 4)], 
                                    dim = (10, 10),
                                    ignorePositions = []
                                }

getPercentDirty :: Env -> Double
getPercentDirty env@Env { children = Child ch, agents = Agent ag _, corral = co,
                        dirty = Dirt di, obstacles = Obstacle ob, dim = (m, n), ignorePositions = ig } = 
                            let lenChildren = lenght ch
                                lenAgents = lenght ag
                                lenDirty = lenght di
                                lenObstacles = lenght ob
                                totalCelds = m * n
                                lenIgnored = lenght ig
                                freeCelds = totalCelds - (lenChildren + lenAgents + lenObstacles + lenIgnored)
                            in realToFrac(100 * lenDirty) /  realToFrac freeCelds

-- env, amountDirtyToAdd, numeroDeIntentosParaAgregarLaBasura, valoresRendoms
addRandmoDirty :: Env -> Int -> Int -> [Int] -> Env
addRandmoDirty env 0 _ _  = env
addRandmoDirty env _ 0 _ = env
addRandmoDirty env _ _ [] = env
addRandmoDirty env@Env { children = ch, agents = ag, corral = co,
                        dirty = Dirt di, obstacles = ob, dim = d, ignorePositions = ig }
                amount
                tries
                rnd@(x: y : xs)
                    | isEmpty env (x, y) = let updatedDirty = ((x, y) : di)
                                            in addRandmoDirty Env {
                                                                    children = ch,
                                                                    agents = ag,
                                                                    corral = co,
                                                                    dirty = Dirt updatedDirty,
                                                                    obstacles = ob,
                                                                    dim = d,
                                                                    ignorePositions = ig
                                                                }
                                                                (amount - 1)
                                                                (tries - 1)
                                                                xs
                    | otherwise = addRandmoDirty env amount (tries - 1) xs

wrapAddRandomDirty :: [Int] -> Env 
wrapAddRandomDirty rnd = addRandmoDirty Env { 
                                        children = Child [(2, 4)],
                                        agents = Agent [(0, 0), (2, 1)] [(2, 1)],
                                        corral = Corral [(3, 5)] (3, 5), 
                                        dirty = Dirt [(3, 0), (2, 5), (0, 2)], 
                                        obstacles = Obstacle [(1, 2), (2, 2), (0, 4)], 
                                        dim = (10, 10),
                                        ignorePositions = [(0, 2)]
                                    }
                                    10
                                    1000
                                    rnd

