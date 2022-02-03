module Items.Agent (
    Agent (..),
    existAgent,
    updateAgent,
    agentGetChild,
    wrapAgentGetChild,
    wrapAgentLeaveChild,
    agentLeaveChild
) where

import Items.Utils (contains)

data Agent = Agent {
    value :: [(Int, Int)],
    carrying :: [(Int, Int)]
} deriving (Show)


existAgent :: Agent -> (Int, Int) -> Bool
existAgent Agent { value = val } pos = contains val pos

-- agent, oldPos, newPos
updateAgent :: Agent ->  (Int, Int) -> (Int, Int) -> Agent
updateAgent Agent { value = val, carrying = c } oldPos newPos = 
                                                let temp = [t | t <- val, t /= oldPos]
                                                in Agent { value = (newPos : temp), carrying = updateAgentAux c oldPos newPos }

-- update carrying 
-- carrying oldPos newPos (if exist)
updateAgentAux :: [(Int, Int)] -> (Int, Int) -> (Int, Int) -> [(Int, Int)]
updateAgentAux carrying oldPos newPos = if contains carrying oldPos then
                                            let temp = [t | t <- carrying, t /= oldPos]
                                            in (newPos: temp)
                                        else carrying

agentGetChild :: Agent -> (Int, Int) -> Agent
agentGetChild Agent { value = val , carrying = c} agentPos = let temp = [t | t <- c, t /= agentPos]
                                                             in Agent { value = val, carrying = (agentPos: temp) }

wrapAgentGetChild :: Agent
wrapAgentGetChild = agentGetChild Agent { value = [(1, 2), (2, 3)], carrying = [(2, 3), (1, 2)] } 
                                  (1, 2)

agentLeaveChild :: Agent -> (Int, Int) -> Agent
agentLeaveChild Agent { value = val, carrying = c } agentPos = Agent { value = val, carrying = [t | t <- c, t /= agentPos] }

wrapAgentLeaveChild :: Agent
wrapAgentLeaveChild = agentLeaveChild Agent { value = [(1, 2)], carrying = [(1, 2)] } (1, 2)
