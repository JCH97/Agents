module Items.Agent (
    Agent (..),
    existAgent,
    updateAgent,
    agentGetChild,
    mockAgentGetChild,
    mockAgentLeaveChild
) where

import Items.Utils (contains)

data Agent = Agent {
    value :: [(Int, Int)],
    carrying :: [(Int, Int)]
} deriving (Show)


existAgent :: Agent -> (Int, Int) -> Bool
existAgent Agent { value = val } pos = contains val pos

updateAgent :: Agent ->  (Int, Int) -> (Int, Int) -> Agent
updateAgent Agent { value = val, carrying = c } oldPos newPos = 
                                                let temp = [t | t <- val, t /= oldPos]
                                                in Agent { value = (newPos : temp), carrying = c }

agentGetChild :: Agent -> (Int, Int) -> Agent
agentGetChild Agent { value = val , carrying = c} agentPos = let temp = [t | t <- c, t /= agentPos]
                                                             in Agent { value = val, carrying = (agentPos: temp) }

mockAgentGetChild :: Agent
mockAgentGetChild = agentGetChild Agent { value = [(1, 2), (2, 3)], carrying = [(2, 3), (1, 2)] } 
                                  (1, 2)

agentLeaveChild :: Agent -> (Int, Int) -> Agent
agentLeaveChild Agent { value = val, carrying = c } agentPos = Agent { value = val, carrying = [t | t <- c, t /= agentPos] }

mockAgentLeaveChild :: Agent
mockAgentLeaveChild = agentLeaveChild Agent { value = [(1, 2)], carrying = [(1, 2)] } (1, 2)
