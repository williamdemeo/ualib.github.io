--FILE: UF-Free.agda
--AUTHOR: William DeMeo and Siva Somayyajula
--DATE: 20 Feb 2020
--UPDATE: 27 May 2020

{-# OPTIONS --without-K --exact-split --safe #-}

open import UF-Prelude using (Universe; 𝓘; 𝓜; 𝓞; 𝓤; 𝓤₀;𝓥; 𝓦; _⁺; _̇;_⊔_; _,_; Σ; -Σ; ∣_∣; ∥_∥; _≡_; refl; _∼_; _≡⟨_⟩_; _∎; ap; _⁻¹; _∘_; pr₂; Id)
open import UF-Basic using (Signature; Algebra; Π'; SmallAlgebra; Πₛ)
open import UF-Hom using (HOM; Hom; hom)
open import UF-Con using (Con; compatible-fun)
open import UF-Singleton using (is-set)
open import UF-Extensionality using (propext; dfunext; funext; _∈_; global-funext; hfunext; intensionality)
open import Relation.Unary using (Pred)

module UF-Free {S : Signature 𝓞 𝓥}  where

----------------------------
-- TERMS in the signature S
module _ {X : 𝓤 ̇} where
  data Term  : 𝓞 ⊔ 𝓥 ⊔ 𝓤 ̇  where
    generator : X → Term
    node : ( 𝓸 : ∣ S ∣ )  →  ( 𝒕 : ∥ S ∥ 𝓸 → Term )  →  Term

  open Term

  map-Term : (Term → Term) → Term → Term
  map-Term f (generator x) = f (generator x)
  map-Term f (node 𝓸 𝒕) = node 𝓸 (λ i → map-Term f (𝒕 i))

  ----------------------------------
  -- TERM ALGEBRA (for signature S)
  𝔉 : Algebra _ S
  𝔉 = Term , node

-------------------------------------
-- The UNIVERSAL PROPERTY of free
module _ {X : 𝓤 ̇} {𝑨 : Algebra 𝓤 S} where

  -- 1. every h : X → ⟦ A ⟧ᵤ  lifts to a hom from free to A.
  -- 2. the induced hom is unique.

  -- PROOF.
  -- We prove this twice, once for each variation on the definition of homomorphism.

  --1.a. Every map  (X → A)  "lifts".
  free-lift : (h : X → ∣ 𝑨 ∣)  →   ∣ 𝔉 ∣ → ∣ 𝑨 ∣
  free-lift h (generator x) = h x
  free-lift h (node 𝓸 args) = (∥ 𝑨 ∥ 𝓸) λ{i → free-lift  h (args i)}

  --I. Extensional proofs (using hom's) -----------------------------------------------
  --1.b.' The lift is (extensionally) a hom
  lift-hom : (h : X → ∣ 𝑨 ∣) →  hom 𝔉 𝑨
  lift-hom h = free-lift h , λ 𝓸 𝒂 → ap (∥ 𝑨 ∥ _) (refl _)

  -- 2.' The lift to  (free → A)  is (extensionally) unique.
  free-unique : funext 𝓥 𝓤 → ( f g : hom 𝔉 𝑨 )
   →             ( ∀ x  →  ∣ f ∣ (generator x) ≡ ∣ g ∣ (generator x) )
   →             (t : Term {X = X})
                  ---------------------------
   →              ∣ f ∣ t ≡ ∣ g ∣ t

  free-unique fe f g p (generator x) = p x
  free-unique fe f g p (node 𝓸 args) =
      ( ∣ f ∣ )(node 𝓸 args)             ≡⟨ ∥ f ∥ 𝓸 args ⟩
      (∥ 𝑨 ∥ 𝓸) (λ i -> ∣ f ∣ (args i))   ≡⟨ ap (∥ 𝑨 ∥ _) (fe (λ i → free-unique fe f g p (args i)) ) ⟩
      (∥ 𝑨 ∥ 𝓸) (λ i -> ∣ g ∣ (args i))   ≡⟨ (∥ g ∥ 𝓸 args)⁻¹ ⟩
      ∣ g ∣ (node 𝓸 args)                 ∎


  --II. Intensional proofs (using HOM's) ---------------------------------------------
  --1.b. that free-lift is (intensionally) a hom.
  lift-HOM : (h : X → ∣ 𝑨 ∣) →  HOM 𝔉 𝑨
  lift-HOM  h = free-lift h , refl _

  --2. The lift to  (free → A)  is (intensionally) unique.
  --   N.B. using the new "intensional" def of hom, we don't need function extensionality to prove uniqueness!
  free-intensionally-unique : funext 𝓥 𝓤 → ( f g : HOM 𝔉 𝑨 )
   →             ( ∣ f ∣ ∘ generator ) ≡ ( ∣ g ∣ ∘ generator )
   →             (t : Term {X = X})
                  --------------------------------
   →              ∣ f ∣ t ≡ ∣ g ∣ t

  free-intensionally-unique fe f g p (generator x) = intensionality p x
  free-intensionally-unique fe f g p (node 𝓸 args) =
      ( ∣ f ∣ )(node 𝓸 args)       ≡⟨ ap (λ - → - 𝓸 args) ∥ f ∥  ⟩
      (∥ 𝑨 ∥ 𝓸) ( ∣ f ∣ ∘ args )   ≡⟨ ap (∥ 𝑨 ∥ _) (fe (λ i → free-intensionally-unique fe f g p (args i)) ) ⟩
      (∥ 𝑨 ∥ 𝓸) ( ∣ g ∣ ∘ args )   ≡⟨ (ap (λ - → - 𝓸 args) ∥ g ∥ ) ⁻¹ ⟩
      ∣ g ∣ (node 𝓸 args)         ∎

--SUGAR:  𝓸 ̂ 𝑨  ≡  ⟦ 𝑨 ⟧ 𝓸   -------------------------------------
--Before proceding, we define some syntactic sugar that allows us to replace ⟦ 𝑨 ⟧ 𝓸 with (the more standard-looking) 𝓸 ̂ 𝑨.
_̂_ :  (𝓸 : ∣ S ∣ ) → (𝑨 : Algebra 𝓤 S)
 →       ( ∥ S ∥ 𝓸  →  ∣ 𝑨 ∣ ) → ∣ 𝑨 ∣
𝓸 ̂ 𝑨 = λ x → (∥ 𝑨 ∥ 𝓸) x
--We can now write 𝓸 ̂ 𝑨 for the interpretation of the basic operation 𝓸 in the algebra 𝑨.
--N.B. below, we will write 𝒕 ̇ 𝑨 for the interpretation of a TERM 𝒕 in 𝑨.
--(todo: probably we should figure out how to use the same notation for both, if possible)

----------------------------------------------------------------------
--INTERPRETATION OF TERMS (cf Def 4.31 of Bergman)
--Let 𝒕 : Term be a term and 𝑨 an S-algebra. We define the n-ary operation 𝒕 ̇ 𝑨 on 𝑨 by structural recursion on 𝒕.
-- 1. if 𝒕 = x ∈ X (a variable) and 𝒂 : X → ∣ 𝑨 ∣ is a tuple from A, then (t ̇ 𝑨) 𝒂 = 𝒂 x.
-- 2. if 𝒕 = 𝓸 args, where 𝓸 ∈ ∣ S ∣ is an op symbol and args : ⟦ S ⟧ 𝓸 → Term is an (⟦ S ⟧ 𝓸)-tuple of terms and
--    𝒂 : X → ∣ A ∣ is a tuple from A, then (𝒕 ̇ 𝑨) 𝒂 = ((𝓸 args) ̇ 𝑨) 𝒂 = (𝓸 ̂ 𝑨) λ{ i → ((args i) ̇ 𝑨) 𝒂 }
--
--Interpretation of terms in Agda.
_̇_ : {X : 𝓤 ̇ } → Term → (𝑨 : Algebra 𝓤 S) →  ( X → ∣ 𝑨 ∣ ) → ∣ 𝑨 ∣
((generator x)̇ 𝑨) 𝒂 = 𝒂 x
((node 𝓸 args)̇ 𝑨) 𝒂 = (𝓸 ̂ 𝑨) λ{x → (args x ̇ 𝑨) 𝒂 }

interp-prod : funext 𝓥 𝓤 → {X I : 𝓤 ̇} (p : Term)  (𝓐 : I → Algebra 𝓤 S) ( x : X → ∀ i → ∣ (𝓐 i) ∣ )
 →              (p ̇ (Π' 𝓐)) x  ≡   (λ i → (p ̇ 𝓐 i) (λ j -> x j i))
interp-prod fe (generator x₁) 𝓐 x = refl _
interp-prod fe (node 𝓸 𝒕) 𝓐 x =
  let IH = λ x₁ → interp-prod fe (𝒕 x₁) 𝓐 x in
      ∥ Π' 𝓐 ∥ 𝓸 (λ x₁ → (𝒕 x₁ ̇ Π' 𝓐) x)                                ≡⟨ ap (∥ Π' 𝓐 ∥ 𝓸 ) (fe IH) ⟩
      ∥ Π' 𝓐 ∥ 𝓸 (λ x₁ → (λ i₁ → (𝒕 x₁ ̇ 𝓐 i₁) (λ j₁ → x j₁ i₁))) ≡⟨ refl _ ⟩   -- refl ⟩
      (λ i₁ → ∥ 𝓐 i₁ ∥ 𝓸 (λ x₁ → (𝒕 x₁ ̇ 𝓐 i₁) (λ j₁ → x j₁ i₁)))  ∎

interp-prod2 : global-funext → {X I : 𝓤 ̇} (p : Term) ( A : I → Algebra 𝓤 S )
 →              (p ̇ Π' A)  ≡  λ (args : X → ∣ Π' A ∣ ) → ( λ ᵢ → (p ̇ A ᵢ ) ( λ x → args x ᵢ ) )
interp-prod2 fe (generator x₁) A = refl _
interp-prod2 fe {X = X} (node 𝓸 𝒕) A = fe λ ( tup : X → ∣ Π' A ∣ ) →
  let IH = λ x → interp-prod fe (𝒕 x) A  in
  let tᴬ = λ z → 𝒕 z ̇ Π' A in
    ( 𝓸 ̂ Π' A )  ( λ s → tᴬ s tup )                                    ≡⟨ refl _ ⟩
    ∥ Π' A ∥ 𝓸 ( λ s →  tᴬ s tup )                                     ≡⟨ ap ( ∥ Π' A ∥ 𝓸 ) (fe  λ x → IH x tup) ⟩
    ∥ Π' A ∥ 𝓸 (λ s → (λ ⱼ → (𝒕 s ̇ A ⱼ ) ( λ ℓ → tup ℓ ⱼ ) ) )    ≡⟨ refl _ ⟩
    ( λ ᵢ → (𝓸 ̂ A ᵢ ) (λ s → (𝒕 s ̇ A ᵢ ) (λ ℓ → tup ℓ ᵢ ) ) )       ∎

-- Recall (cf. UAFST Thm 4.32)
-- Theorem 1. If A and B are algebras of type S, then the following hold:
--   1. For every n-ary term t and homomorphism g: A → B,  g ( tᴬ ( a₁, ..., aₙ ) ) = tᴮ ( g (a₁), ..., g (aₙ) ).
--  2. For every term t ∈ T(X) and every θ ∈ Con(A),  a θ b → t(a) θ t(b).
--  3. For every subset Y of A,  Sg ( Y ) = { t (a₁, ..., aₙ ) : t ∈ T(Xₙ), n < ω, aᵢ ∈ Y, i ≤ n}.
--
-- Proof of 1. (homomorphisms commute with terms).
comm-hom-term : funext 𝓤 (𝓤 ⊔ 𝓥)  → funext 𝓥 𝓤  → {X : 𝓤 ̇} (𝑨 : Algebra 𝓤 S) (𝑩 : Algebra 𝓤 S) (g : HOM 𝑨 𝑩)  (𝒕 : Term {X = X})
 →                    ∣ g ∣ ∘  (𝒕 ̇ 𝑨)    ≡    (𝒕 ̇ 𝑩) ∘ (λ 𝒂 → ∣ g ∣ ∘ 𝒂 )
 -- Goal: ∣ g ∣ ∘ (λ 𝒂 → (𝓸 ̂ 𝑨) (λ x → (args x ̇ 𝑨) 𝒂)) ≡  (λ 𝒂 → (𝓸 ̂ 𝑩) (λ x → (args x ̇ 𝑩) 𝒂)) ∘ _∘_ ∣ g ∣
comm-hom-term feu fev 𝑨 𝑩 g (generator x) = refl _
comm-hom-term feu fev 𝑨 𝑩 g (node 𝓸 args) = γ
--  (λ (𝓸 : ∣ S ∣ ) ( 𝒂 : ∥ S ∥ 𝓸 → A )  → f (𝐹ᴬ 𝓸 𝒂) ) ≡ (λ (𝓸 : ∣ S ∣ ) ( 𝒂 : ∥ S ∥ 𝓸 → A )  → 𝐹ᴮ 𝓸 (f ∘ 𝒂) )
 where
  γ : ∣ g ∣ ∘ (λ 𝒂 → (𝓸 ̂ 𝑨) (λ i → (args i ̇ 𝑨) 𝒂)) ≡ (λ 𝒂 → (𝓸 ̂ 𝑩) (λ i → (args i ̇ 𝑩) 𝒂)) ∘ _∘_ ∣ g ∣
  γ =  ∣ g ∣ ∘ (λ 𝒂 → (𝓸 ̂ 𝑨) (λ i → (args i ̇ 𝑨) 𝒂) )           ≡⟨ ap (λ - → (λ 𝒂 → - 𝓸 (λ i → (args i ̇ 𝑨) 𝒂 )) ) ∥ g ∥ ⟩
         ( λ 𝒂 → ( 𝓸 ̂ 𝑩 ) ( ∣ g ∣ ∘ (λ i →  (args i ̇ 𝑨) 𝒂 ) ) )  ≡⟨ refl _ ⟩
         ( λ 𝒂 → ( 𝓸 ̂ 𝑩 ) (λ i → ∣ g ∣ ( (args i ̇ 𝑨) 𝒂) ) )      ≡⟨ ap (λ - → (λ 𝒂 → (𝓸 ̂ 𝑩) ( - 𝒂 ) ) ) ih ⟩
         ( (λ 𝒂 → (𝓸 ̂ 𝑩) (λ i → (args i ̇ 𝑩) 𝒂) ) ∘ _∘_ ∣ g ∣ )  ∎
    where
     IH : (𝒂 : _ → ∣ 𝑨 ∣) (i : ∥ S ∥ 𝓸) →   ( ( ∣ g ∣ ∘ (args i ̇ 𝑨) ) 𝒂 ) ≡ ( ( ( args i ̇ 𝑩) ∘ _∘_ ∣ g ∣) 𝒂 )
     IH 𝒂 i = intensionality (comm-hom-term feu fev 𝑨 𝑩 g (args i) ) 𝒂

     IH' : (i : ∥ S ∥ 𝓸) →   ( ( ∣ g ∣ ∘ (args i ̇ 𝑨) ) ) ≡  ( ( args i ̇ 𝑩) ∘ _∘_ ∣ g ∣)
     IH' i = (comm-hom-term feu fev 𝑨 𝑩 g (args i) )

     ih : (λ 𝒂 → (λ i → ∣ g ∣ ((args i ̇ 𝑨) 𝒂 ) ) ) ≡  (λ 𝒂 → ( λ i → ((args i ̇ 𝑩) ∘ _∘_ ∣ g ∣) 𝒂 ) )
     ih = feu λ 𝒂 → fev λ i → IH 𝒂 i

     ih' : (λ i → ∣ g ∣ ∘ (args i ̇ 𝑨) )  ≡  ( λ i → ((args i ̇ 𝑩) ∘ _∘_ ∣ g ∣) )
     ih' = fev λ i → IH' i

-- Proof of 2.  (If t : Term, θ : Con A, then a θ b  →  t(a) θ t(b). )
compatible-term :    {X : 𝓤 ̇} (𝑨 : Algebra 𝓤 S) ( 𝒕 : Term {X = X} ) (θ : Con 𝑨)
                         ------------------------------------------------------
 →                              compatible-fun (𝒕 ̇ 𝑨) ∣ θ ∣

compatible-term 𝑨 (generator x) θ p = p x
compatible-term 𝑨 (node 𝓸 args) θ p = ∥ ∥ θ ∥ ∥ 𝓸 λ{ x → (compatible-term 𝑨 (args x) θ) p }

-- For proof of 3, see `TermImageSub` in Subuniverse.agda.

------------------------------------------------------------------
-- EXTENSIONAL VERSIONS.
-- Proof of 1. (homomorphisms commute with terms).
comm-hom-term' : funext 𝓥 𝓤 → {X : 𝓤 ̇} (𝑨 : Algebra 𝓤 S) (𝑩 : Algebra 𝓤 S)
 →                   (g : hom 𝑨 𝑩)   →  (𝒕 : Term)  →   (𝒂 : X → ∣ 𝑨 ∣)
                      --------------------------------------------
 →                           ∣ g ∣ ((𝒕 ̇ 𝑨) 𝒂) ≡ (𝒕 ̇ 𝑩) (∣ g ∣ ∘ 𝒂)

comm-hom-term' fe 𝑨 𝑩 g (generator x) 𝒂 = refl _
comm-hom-term'  fe 𝑨 𝑩 g (node 𝓸 args) 𝒂 =
    ∣ g ∣ ((𝓸 ̂ 𝑨)  (λ i₁ → (args i₁ ̇ 𝑨) 𝒂))     ≡⟨ ∥ g ∥ 𝓸 ( λ r → (args r ̇ 𝑨) 𝒂 ) ⟩
    (𝓸 ̂ 𝑩) ( λ i₁ →  ∣ g ∣ ((args i₁ ̇ 𝑨) 𝒂) )    ≡⟨ ap (_ ̂ 𝑩) ( fe (λ i₁ → comm-hom-term' fe 𝑨 𝑩 g (args i₁) 𝒂) ) ⟩
    (𝓸 ̂ 𝑩) ( λ r → (args r ̇ 𝑩) (∣ g ∣ ∘ 𝒂) )        ∎

-- Proof of 2.  (If t : Term, θ : Con A, then a θ b  →  t(a) θ t(b). )
compatible-term' :    {X : 𝓤 ̇} (𝑨 : Algebra 𝓤 S) ( 𝒕 : Term {X = X} ) (θ : Con 𝑨)
                         ------------------------------------------------------
 →                              compatible-fun (𝒕 ̇ 𝑨) ∣ θ ∣

compatible-term' 𝑨 (generator x) θ p = p x
compatible-term' 𝑨 (node 𝓸 args) θ p = ∥ ∥ θ ∥ ∥ 𝓸 λ{ x → (compatible-term' 𝑨 (args x) θ) p }

-- For proof of 3, see `TermImageSub` in Subuniverse.agda.











----------------------------------------------------------------------------------------
--Theories and Models.

_⊢_≈_ : {X : 𝓤 ̇} → Algebra 𝓤 S → Term {X = X} → Term → 𝓤 ̇
𝑨 ⊢ p ≈ q = p ̇ 𝑨 ≡ q ̇ 𝑨

_⊢_≋_ : {𝓤 : Universe} {X : 𝓤 ̇} → Pred (Algebra 𝓤 S) 𝓦 → Term {X = X} → Term → 𝓞 ⊔ 𝓥 ⊔ 𝓦 ⊔ 𝓤 ⁺ ̇
_⊢_≋_ 𝓚 p q = {A : Algebra _ S} → 𝓚 A → A ⊢ p ≈ q



------------------------------------------------------------------------------------------
-- Misc unused stuff -----------------------------------------------------------------------

-- ARITY OF A TERM
-- argsum : ℕ -> (ℕ -> ℕ) -> ℕ
-- argsum nzero f = 0
-- argsum (succ n) f = f n + argsum n f
-- ⟨_⟩ₜ : Term -> ℕ
-- ⟨ generator x ⟩ₜ = 1
-- ⟨ node 𝓸 args ⟩ₜ = (S ρ) 𝓸 + argsum ((S ρ) 𝓸) (λ i -> ⟨ args i ⟩ₜ)


