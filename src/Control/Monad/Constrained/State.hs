{-# LANGUAGE RebindableSyntax       #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE UndecidableInstances   #-}
{-# LANGUAGE ConstraintKinds  #-}

module Control.Monad.Constrained.State where

import GHC.Exts

import Control.Monad.Constrained

import qualified Control.Monad.Trans.State.Lazy as State.Lazy
import qualified Control.Monad.Trans.State.Strict as State.Strict

import qualified Control.Monad.Trans.Maybe as Maybe
import qualified Control.Monad.Trans.Cont as Cont

import Control.Monad.Constrained.Trans

class Monad m =>
      MonadState s m  | m -> s where
    {-# MINIMAL state #-}
    type StateSuitable m s a :: Constraint
    get
        :: (StateSuitable m s s)
        => m s
    get =
        state
            (\s ->
                  (s, s))
    put
        :: (StateSuitable m s (), StateSuitable m s s)
        => s -> m ()
    put s = state (const ((), s))
    state
        :: (StateSuitable m s a, StateSuitable m s s)
        => (s -> (a, s)) -> m a

gets :: (StateSuitable m s s, MonadState s m, Suitable m b) => (s -> b) -> m b
gets f = fmap f get

instance Monad m => MonadState s (State.Strict.StateT s m) where
  type StateSuitable (State.Strict.StateT s m) s a = Suitable m (a, s)
  state f = State.Strict.StateT (pure . f)

instance Monad m => MonadState s (State.Lazy.StateT s m) where
  type StateSuitable (State.Lazy.StateT s m) s a = Suitable m (a, s)
  state f = State.Lazy.StateT (pure . f)

instance (MonadState s m, Suitable m r) => MonadState s (Cont.ContT r m) where
    type StateSuitable (Cont.ContT r m) s a = (Suitable m s, Suitable m r, StateSuitable m s a)
    state = lift . state

instance MonadState s m =>
         MonadState s (Maybe.MaybeT m) where
    type StateSuitable (Maybe.MaybeT m) s a = (Suitable m (Maybe a), Suitable m a, StateSuitable m s a)
    state = lift . state
