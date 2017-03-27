{-# LANGUAGE ApplicativeDo    #-}
{-# LANGUAGE RebindableSyntax #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DataKinds #-}

module MuchAdo where

import           Control.Monad.Constrained.Ap
import           Data.Set
import           Prob
import           EnumVect
import           Numeric.Sized.WordOfSize

sumThriceAdoFinal :: [Integer] -> [Integer] -> [Integer] -> Int
sumThriceAdoFinal xs ys zs = size . phi @ Final $ do
  x <- eta (fromList xs)
  a <- eta (fromList [0..x])
  y <- eta (fromList ys)
  z <- eta (fromList zs)
  t <- eta (fromList xs)
  u <- eta (fromList ys)
  b <- eta (fromList [0..y])
  c <- eta (fromList [0..z])
  g <- eta (fromList xs)
  h <- eta (fromList ys)
  v <- eta (fromList zs)
  pure (x + a + y + b + z + c + t + u + v + g + h)

sumThriceAdoInitial :: [Integer] -> [Integer] -> [Integer] -> Int
sumThriceAdoInitial xs ys zs = size . phi @ Initial $ do
  x <- eta (fromList xs)
  a <- eta (fromList [0..x])
  y <- eta (fromList ys)
  z <- eta (fromList zs)
  t <- eta (fromList xs)
  u <- eta (fromList ys)
  b <- eta (fromList [0..y])
  c <- eta (fromList [0..z])
  g <- eta (fromList xs)
  h <- eta (fromList ys)
  v <- eta (fromList zs)
  pure (x + a + y + b + z + c + t + u + v + g + h)

sumThriceAdoConstrained :: [Integer] -> [Integer] -> [Integer] -> Int
sumThriceAdoConstrained xs ys zs = size . phi @ ConstrainedWrapper $ do
  x <- eta (fromList xs)
  a <- eta (fromList [0..x])
  y <- eta (fromList ys)
  z <- eta (fromList zs)
  t <- eta (fromList xs)
  u <- eta (fromList ys)
  b <- eta (fromList [0..y])
  c <- eta (fromList [0..z])
  g <- eta (fromList xs)
  h <- eta (fromList ys)
  v <- eta (fromList zs)
  pure (x + a + y + b + z + c + t + u + v + g + h)

sumThriceAdoCodensity :: [Integer] -> [Integer] -> [Integer] -> Int
sumThriceAdoCodensity xs ys zs = size . phi @ Codensity $ do
  x <- eta (fromList xs)
  a <- eta (fromList [0..x])
  y <- eta (fromList ys)
  z <- eta (fromList zs)
  t <- eta (fromList xs)
  u <- eta (fromList ys)
  b <- eta (fromList [0..y])
  c <- eta (fromList [0..z])
  g <- eta (fromList xs)
  h <- eta (fromList ys)
  v <- eta (fromList zs)
  pure (x + a + y + b + z + c + t + u + v + g + h)

diceAdoFinal :: Integer -> [Integer] -> Double
diceAdoFinal n die' = probOf n . phi @ Final $ do
  t <- die
  a <- eta (upTo t)
  u <- die
  w <- die
  x <- die
  v <- eta (upTo u)
  y <- eta (upTo w)
  z <- die
  pure (a + t + u + x + y + z + v + w)
  where die = eta (uniform die')

diceAdoInitial :: Integer -> [Integer] -> Double
diceAdoInitial n die' = probOf n . phi @ Initial $ do
  t <- die
  a <- eta (upTo t)
  u <- die
  w <- die
  x <- die
  v <- eta (upTo u)
  y <- eta (upTo w)
  z <- die
  pure (a + t + u + x + y + z + v + w)
  where die = eta (uniform die')

diceAdoConstrained :: Integer -> [Integer] -> Double
diceAdoConstrained n die' = probOf n . phi @ ConstrainedWrapper $ do
  t <- die
  a <- eta (upTo t)
  u <- die
  w <- die
  x <- die
  v <- eta (upTo u)
  y <- eta (upTo w)
  z <- die
  pure (a + t + u + x + y + z + v + w)
  where die = eta (uniform die')

diceAdoCodensity :: Integer -> [Integer] -> Double
diceAdoCodensity n die' = probOf n . phi @ Codensity $ do
  t <- die
  a <- eta (upTo t)
  u <- die
  w <- die
  x <- die
  v <- eta (upTo u)
  y <- eta (upTo w)
  z <- die
  pure (a + t + u + x + y + z + v + w)
  where die = eta (uniform die')

diceVectAdoInitial :: WordOfSize 3 -> [WordOfSize 3] -> Double
diceVectAdoInitial n die' = probOfV n . phi @ Initial $ do
  t <- die
  a <- eta (upToV t)
  u <- die
  w <- die
  v <- eta (upToV u)
  y <- eta (upToV w)
  pure (a + t + u + y + v + w)
  where die = eta (uniformV die')

diceVectAdoCodensity :: WordOfSize 3 -> [WordOfSize 3] -> Double
diceVectAdoCodensity n die' = probOfV n . phi @ Codensity $ do
  t <- die
  a <- eta (upToV t)
  u <- die
  w <- die
  v <- eta (upToV u)
  y <- eta (upToV w)
  pure (a + t + u + y + v + w)
  where die = eta (uniformV die')
  
