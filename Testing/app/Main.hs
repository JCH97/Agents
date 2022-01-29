module Main where

import Lib

main :: IO ()
main = do
    -- let g = len [1, 2, 3]
    -- let g = five 3
    -- let g = apply doble 4
    -- let g = first (1, 2)
    -- let g = derive doble 2
    -- let g = max3 1 2 3
    -- let g = swap (1, 2)
    -- let g = sumsqrt 3
    -- let g = some [False, False, False, True]
    -- let g = all1 [True, True, False]
    -- let g = factor [2, 3, 4]
    -- let g = restos 2 [1, 2, 3, 4
    -- let g = cuadrados [1, 2, 3, 4]
    -- let g = orden [(1, 3), (10, 3), (3, 9)]
    -- let g = pares [1, 2, 3, 4]
    -- let g = letras ['a', 'b', '1', 'S']
    -- let g = masDe 3 [[1, 2, 3, 4], [1, 2], [1, 2, 3]]
    -- let g = isPrime 18
    let g = buildPrimes 10
    print g