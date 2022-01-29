module Lib
    ( 
        len,
        five,
        doble,
        apply, 
        first,
        max3,
        swap,
        sumsqrt,
        some,
        all1,
        factor,
        restos,
        cuadrados,
        orden, 
        pares,
        letras,
        masDe,
        isPrime,
        buildPrimes
        -- derive
    ) where

len :: [a] -> Integer
len [] = 0
len (x : xs) = 1 + len xs

five :: a -> Integer
five _ = 5

apply :: (a -> b) -> a -> b
apply f n = f n

doble :: Integer -> Integer
doble x = x + x

first :: (Integer, Integer) -> Integer
first (a, b) = a


max3 :: Integer -> Integer -> Integer -> Integer
max3 a b c | a > b && a > c = a
           | b > c = b
           | otherwise = c

swap :: (a, b) -> (b, a)
swap (a, b) = (b, a)

sumsqrt :: Int -> Int
sumsqrt 1 = 1
sumsqrt x = x * x + sumsqrt x - 1

some :: [Bool] -> Bool
some [] = False
some (x : xs) = if x == True then True else some xs 

all1 :: [Bool] -> Bool
all1 [] = True
all1 (x : xs) = if x == True then (all1 xs) else False

factor :: [Integer] -> Integer
factor [] = 1
factor (x : xs) = x * factor xs

restos :: Integer -> [Integer] -> [Integer]
restos _ [] = []
restos n (x : xs) = [mod x n] ++ restos n xs

cuadrados :: [Integer] -> [Integer]
cuadrados [] = []
cuadrados (x : xs) = [x * x] ++ cuadrados xs

orden :: [(Integer, Integer)] -> [(Integer, Integer)]
orden [] = []
orden (pair@(x, y) : xs) = if x < 3 * y then [pair] ++ orden xs else orden xs  

pares :: [Integer] -> [Integer]
pares [] = []
pares (x : xs) = [x * 2] ++ pares xs

letras :: [Char] -> [Char]
letras [] = []
letras (x : xs) = if x >= 'a' && x <= 'z' || x >= 'A' && x <= 'Z' then [x] ++ letras xs else letras xs

masDe :: Integer -> [[a]] -> [[a]]
masDe _ [] = []
masDe n (x : xs) = if len x > n then [x] ++ masDe n xs else masDe n xs

isPrime :: Integer -> Bool
isPrime n = isPrimeAux (n - 1) n 

isPrimeAux :: Integer -> Integer -> Bool -- count, number, ans
isPrimeAux 1 _ = True
isPrimeAux a n = if mod n a == 0 then False else isPrimeAux (a - 1) n

buildPrimes :: Integer -> [Integer]
buildPrimes 1 = []
buildPrimes n = if isPrime n == True then [n] ++ buildPrimes (n - 1) else buildPrimes (n - 1)