module Basics where

open import Level
open import Relation.Binary.Core public using (_≡_; refl; _≢_)
open import Relation.Nullary.Core public using (¬_)
open import Relation.Binary.PropositionalEquality using (trans)


_o_ : forall {i j k}
        {A : Set i}{B : A -> Set j}{C : (a : A) -> B a -> Set k} ->
        (f : {a : A}(b : B a) -> C a b) ->
        (g : (a : A) -> B a) ->
        (a : A) -> C a (g a)
f o g = \ a -> f (g a)

id : forall {k}{X : Set k} -> X -> X
id x = x

record Sg {l : Level}(S : Set l)(T : S -> Set l) : Set l where
  constructor _,_
  field
    fst : S
    snd : T fst
open Sg public
_*_ : {l : Level} -> Set l -> Set l -> Set l
S * T = Sg S \ _ -> T
infixr 4 _,_ _*_

vv_ :  forall {k l}{S : Set k}{T : S -> Set k}{P : Sg S T -> Set l} ->
      ((s : S)(t : T s) -> P (s , t)) ->
      (p : Sg S T) -> P p
(vv p) (s , t) = p s t
infixr 1 vv_

record One {l : Level} : Set l where
  constructor <>
open One public

{-data _==_ {l}{X : Set l}(x : X) : X -> Set l where
  refl : x == x
infix 1 _==_
{-# BUILTIN EQUALITY _==_ #-}
{-# BUILTIN REFL refl #-}
-}


subst :  forall {k l}{X : Set k}{s t : X} ->
         s ≡ t -> (P : X -> Set l) -> P s -> P t
subst refl P p = p


_=!!_>>_ : forall {l}{X : Set l}(x : X){y z} -> x ≡ y -> y ≡ z -> x ≡ z
_ =!! refl >> q = q

_<<_!!=_ : forall {l}{X : Set l}(x : X){y z} -> y ≡ x -> y ≡ z -> x ≡ z
_ << refl !!= q = q

_<QED> : forall {l}{X : Set l}(x : X) -> x ≡ x
x <QED> = refl

infixr 1 _=!!_>>_ _<<_!!=_ _<QED>


data Two : Set where tt ff : Two
_<?>_ : forall {l}{P : Two -> Set l} -> P tt -> P ff -> (b : Two) -> P b
(t <?> f) tt = t
(t <?> f) ff = f

--_+_ : Set -> Set -> Set
--S + T = Sg Two (S <?> T)

{-
data Zero : Set where

magic : forall {l}{A : Set l} -> Zero -> A
magic ()

Dec : Set -> Set
Dec X = X + (X -> Zero)
-}

data Pair (A B : Set) : Set where
  _,_ : A -> B -> Pair A B 

data Unit : Set where
  unit : Unit

pi1 : forall {A B} -> Pair A B -> A
pi1 (x , y) = x

pi2 : forall {A B} -> Pair A B -> B
pi2 (x , y) = y

data Either (A B : Set) : Set where
   inl : A -> Either A B
   inr : B -> Either A B

Case : {A B : Set} -> {C : Either A B -> Set}
   -> ((a : A) -> C (inl a)) -> ((b : B) -> C (inr b)) -> (c : Either A B) -> C c
Case d e (inl a) = d a
Case d e (inr b) = e b

--trans : forall {A : Set} {x y z : A} -> (x ≡ y) -> (y ≡ z) -> (x ≡ z)
--trans refl refl = refl


infixr 7 _===_
_===_ = trans

symm : forall {A : Set} {x y : A} -> (x ≡ y) -> (y ≡ x)
symm refl = refl

{-
cong : ∀ {A : Set} {B : Set}
       (f : A → B) {x y} → x ≡ y → f x ≡ f y
cong f refl = refl
-}

coerce : ∀ {A B : Set} → A ≡ B → A → B
coerce refl = id

--coerce-gen : forall {A : Set} {X Y : A} -> (X ≡ Y) -> (X -> Y)
--coerce-gen refl = id


cong-gen : forall {t : Set} {A B : t} (f : t -> Set) -> A ≡ B -> (f A ≡ f B)
cong-gen f refl = refl

cong-coerce : forall {t : Set} {A B : t} (f : t -> Set) -> A ≡ B -> (f A -> f B)
cong-coerce f refl = id

{-
data Inspect {a} {A : Set a} (x : A) : Set a where
   _with-≡_ : (y : A) (eq : x ≡ y) → Inspect x

inspect : ∀ {a} {A : Set a} (x : A) → Inspect x
inspect x = x with-≡ refl
-}