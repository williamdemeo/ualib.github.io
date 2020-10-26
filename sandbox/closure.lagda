\begin{code}
--FILE: closure.agda
--AUTHOR: William DeMeo and Siva Somayyajula
--DATE: 4 Aug 2020
--UPDATE: 19 Sep 2020

{-# OPTIONS --without-K --exact-split --safe #-}

open import basic
open import congruences
open import prelude using (global-dfunext; dfunext; im; _∪_; inj₁; inj₂)

module closure
 {𝑆 : Signature 𝓞 𝓥}
 {𝓦 : Universe}
 -- {X : 𝓤 ̇}
 {𝕏 : {𝓤 𝓧 : Universe}{X : 𝓧 ̇ }(𝑨 : Algebra 𝓤 𝑆) → X ↠ 𝑨}
 {gfe : global-dfunext}
 {dfe : dfunext 𝓤 𝓤}
 {fevu : dfunext 𝓥 𝓤} where

open import homomorphisms {𝑆 = 𝑆} public
open import subuniverses {𝑆 = 𝑆}{𝓤 = 𝓤}{𝕏 = 𝕏}{fe = gfe} public
open import terms {𝑆 = 𝑆}{𝓤 = 𝓤}{𝕏 = 𝕏}{gfe = gfe} renaming (generator to ℊ) public

_⊧_≈_ : {𝓤 𝓧 : Universe}{X : 𝓧 ̇} → Algebra 𝓤 𝑆 → Term{𝓧}{X} → Term → 𝓤 ⊔ 𝓧 ̇
𝑨 ⊧ p ≈ q = (p ̇ 𝑨) ≡ (q ̇ 𝑨)

_⊧_≋_ : {𝓤 𝓧 : Universe}{X : 𝓧 ̇} → Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)
 →      Term{𝓧}{X} → Term → 𝓞 ⊔ 𝓥 ⊔ 𝓧 ⊔ 𝓤 ⁺ ̇
_⊧_≋_ 𝒦 p q = {𝑨 : Algebra _ 𝑆} → 𝒦 𝑨 → 𝑨 ⊧ p ≈ q

-- OVU+ OVU++ W W+ : Universe
-- OVU+ = 𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺
-- OVU++ = 𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺ ⁺
-- W = OVU+ ⊔ 𝓦
-- W+ = OVU++ ⊔ 𝓦 ⁺

------------------------------------------------------------------------
-- Equational theories and classes
Th : {𝓤 𝓧 : Universe}{X : 𝓧 ̇} → Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)
 →   Pred (Term{𝓧}{X} × Term) (𝓞 ⊔ 𝓥 ⊔ 𝓧 ⊔ 𝓤 ⁺)
Th 𝒦 = λ (p , q) → 𝒦 ⊧ p ≋ q

Mod : {𝓤 𝓧 : Universe}{X : 𝓧 ̇} → Pred (Term{𝓧}{X} × Term) (𝓞 ⊔ 𝓥 ⊔ 𝓧 ⊔ 𝓤 ⁺)
 →    Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓧 ⁺ ⊔ 𝓤 ⁺)
Mod ℰ = λ A → ∀ p q → (p , q) ∈ ℰ → A ⊧ p ≈ q


----------------------------------------------------------------------------------
--Closure under products
data PClo {𝓤 : Universe} (𝒦 : Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)) : Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) where
 pbase : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ 𝒦 → 𝑨 ∈ PClo 𝒦
 prod : {I : 𝓤 ̇ }{𝒜 : I → Algebra _ 𝑆} → (∀ i → 𝒜 i ∈ PClo 𝒦) → ⨅ 𝒜 ∈ PClo 𝒦

--------------------------------------------------------------------------------------
--Closure under hom images
data HClo {𝓤 : Universe}(𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)) : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) where
 hbase : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ 𝒦 → 𝑨 ∈ HClo 𝒦
 hhom : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ HClo 𝒦 → ((𝑩 , _ ) : HomImagesOf 𝑨) → 𝑩 ∈ HClo 𝒦

----------------------------------------------------------------------
-- Subalgebra Closure
data SClo {𝓤 : Universe}(𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)) : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) where
  sbase : {𝑨 :  Algebra _ 𝑆} → 𝑨 ∈ 𝒦 → 𝑨 ∈ SClo 𝒦
  sub : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ SClo 𝒦 → (sa : SUBALGEBRA 𝑨) → ∣ sa ∣ ∈ SClo 𝒦


----------------------------------------------------------------------
-- Variety Closure
-- Classes of algebras closed under the taking of hom images, subalgebras, and products of algebras in the class.
data VClo {𝓤 : Universe}(𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)) : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺ ) where
 vbase : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ 𝒦 → 𝑨 ∈ VClo 𝒦
 vprod : {I : 𝓤 ̇}{𝒜 : I → Algebra _ 𝑆} → (∀ i → 𝒜 i ∈ VClo 𝒦) → ⨅ 𝒜 ∈ VClo 𝒦
 vsub  : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ VClo 𝒦 → (sa : Subalgebra 𝑨) → ∣ sa ∣ ∈ VClo 𝒦
 vhom  : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ VClo 𝒦 → ((𝑩 , _ , _) : HomImagesOf 𝑨) → 𝑩 ∈ VClo 𝒦


-----------------------------------------------------------------------------
-- Closure operator (definition)

_IsExpansive : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → (Pred X 𝓦 → Pred X 𝓦) → 𝓤 ⊔ 𝓦 ⁺ ̇
C IsExpansive = ∀ 𝒦 → 𝒦 ⊆ C 𝒦

_IsMonotone : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → (Pred X 𝓦 → Pred X 𝓦) → 𝓤 ⊔ 𝓦 ⁺ ̇
C IsMonotone = ∀ 𝒦 𝒦' → 𝒦 ⊆ 𝒦' → C 𝒦 ⊆ C 𝒦'

_IsIdempotent : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → (Pred X 𝓦 → Pred X 𝓦) → 𝓤 ⊔ 𝓦 ⁺ ̇
C IsIdempotent = ∀ 𝒦 → C (C 𝒦) ⊆ C 𝒦

_IsClosure : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → (Pred X 𝓦 → Pred X 𝓦) → 𝓤 ⊔ 𝓦 ⁺ ̇
C IsClosure  = (C IsExpansive) × (C IsMonotone) × (C IsIdempotent)


----------------------------------------------------------------------
-- Example. SClo is a closure operator
SCloIsClosure : {𝓤 : Universe} → SClo{𝓤} IsClosure
SCloIsClosure {𝓤} = expa , mono , idem
 where
  expa : SClo IsExpansive
  expa 𝒦 = sbase {𝒦 = 𝒦}

  mono : SClo IsMonotone
  mono 𝒦 𝒦' h₀ {𝑨} (sbase x) = sbase (h₀ x)
  mono 𝒦 𝒦' h₀ {.(fst sa)} (sub x sa) = sub (mono 𝒦 𝒦' h₀ x) sa

  idem : SClo IsIdempotent
  idem 𝒦 {𝑨} (sbase x) = x
  idem 𝒦 {.(fst sa)} (sub x sa) = sub (idem 𝒦 x) sa

SClo-mono : {𝓤 : Universe}{𝒦₁ 𝒦₂ : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
 →          𝒦₁ ⊆ 𝒦₂ → SClo 𝒦₁ ⊆ SClo 𝒦₂
SClo-mono {𝓤} {𝒦₁}{𝒦₂} = ∣ snd SCloIsClosure ∣ 𝒦₁ 𝒦₂

PClo-idem : {𝓤 : Universe}{𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
 →          PClo (PClo 𝒦) ⊆ PClo 𝒦
PClo-idem {𝓤} {𝒦} (pbase x) = x
PClo-idem {𝓤} {𝒦} (prod x) = prod (λ i → PClo-idem (x i))


----------------------------------------------------------------------------------------------
-- For a given algebra 𝑨, and class 𝒦 of algebras, we will find the following fact useful
-- (e.g., in proof of Birkhoff's HSP theorem):  𝑨 ∈ SClo 𝒦  ⇔  𝑨 IsSubalgebraOfClass 𝒦

SClo→Subalgebra : {𝓠 : Universe}{𝒦 : Pred (Algebra 𝓠 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓠 ⁺)}{𝑨 : Algebra 𝓠 𝑆}
 →                𝑨 ∈ SClo 𝒦 →  𝑨 IsSubalgebraOfClass 𝒦
SClo→Subalgebra{𝓠}{𝒦}{𝑨}(sbase x) = 𝑨 , (𝑨 , refl-≤ 𝑨) , x , (((λ x → x) , id-is-hom) ,
                                                                (((λ x → x) , id-is-hom) ,
                                                                  ((λ x₁ → refl _) , λ x₁ → refl _)))
SClo→Subalgebra {𝓠} {𝒦} {.(fst sa)} (sub{𝑨 = 𝑨} x sa) = γ
 where
  IH : 𝑨 IsSubalgebraOfClass 𝒦
  IH = SClo→Subalgebra x

  𝑮 : Algebra 𝓠 𝑆
  𝑮 = ∣ IH ∣

  KG = fst ∥ snd IH ∥            -- KG : 𝑮 ∈ 𝒦
  SG' = fst ∥ IH ∥               -- SG' : SUBALGEBRA 𝑮
  𝑨' = ∣ SG' ∣                    -- 𝑨' : Algebra 𝓠 𝑆
  𝑨'≤𝑮 = ∥ SG' ∥                 -- 𝑨'≤𝑮 : 𝑨' ≤ 𝑮
  𝑨≅𝑨' = snd ∥ (snd IH) ∥        -- 𝑨≅𝑨' : 𝑨 ≅ 𝑨'
  𝑨≤𝑮 = iso-≤ 𝑨 𝑨' 𝑮 𝑨≅𝑨' 𝑨'≤𝑮 -- 𝑨≤𝑮 : 𝑨 ≤ 𝑮

  sa≤𝑮 : ∣ sa ∣ ≤ 𝑮
  sa≤𝑮 = trans-≤ ∣ sa ∣ 𝑨 𝑮 ∥ sa ∥ 𝑨≤𝑮

  γ : ∣ sa ∣ IsSubalgebraOfClass 𝒦
  γ = 𝑮 , ((∣ sa ∣ , sa≤𝑮) , (KG , id≅ ∣ sa ∣))

Subalgebra→SClo : {𝓠 : Universe}{𝒦 : Pred (Algebra 𝓠 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓠 ⁺)}{𝑩 : Algebra 𝓠 𝑆}
 →                𝑩 IsSubalgebraOfClass 𝒦 → 𝑩 ∈ SClo 𝒦
Subalgebra→SClo{𝓠}{𝒦}{𝑩}(𝑨 , sa , (KA , B≅sa)) = sub{𝑨 = 𝑨}(sbase KA)(𝑩 , (iso-≤ 𝑩 ∣ sa ∣ 𝑨 B≅sa ∥ sa ∥))

----------------------------------------------------------------------------------------
-- The (near) lattice of closures
LemPS⊆SP : {𝓠 : Universe} → hfunext 𝓠 𝓠
 →         {𝒦 : Pred (Algebra 𝓠 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓠 ⁺)}{I : 𝓠 ̇}{ℬ : I → Algebra 𝓠 𝑆}
 →         ((i : I) → (ℬ i) IsSubalgebraOfClass 𝒦)
          ----------------------------------------------------
 →         ⨅ ℬ IsSubalgebraOfClass (PClo 𝒦)

LemPS⊆SP{𝓠}hfe{𝒦}{I}{ℬ}ℬ≤𝒦 = ⨅ 𝒜 , (⨅ SA , ⨅SA≤⨅𝒜 ) , (prod PClo𝒜) , (⨅≅ gfe ℬ≅SA)
 where
  𝒜 = λ i → ∣ ℬ≤𝒦 i ∣                -- 𝒜 : I → Algebra 𝓠 𝑆
  SA = λ i → ∣ fst ∥ ℬ≤𝒦 i ∥ ∣        -- SA : I → Algebra 𝓠 𝑆
  𝒦𝒜 = λ i → ∣ snd ∥ ℬ≤𝒦 i ∥ ∣       -- 𝒦𝒜 : ∀ i → 𝒜 i ∈ 𝒦
  PClo𝒜 = λ i → pbase (𝒦𝒜 i)        -- PClo𝒜 : ∀ i → 𝒜 i ∈ PClo 𝒦
  SA≤𝒜 = λ i → snd ∣ ∥ ℬ≤𝒦 i ∥ ∣      -- SA≤𝒜 : ∀ i → (SA i) IsSubalgebraOf (𝒜 i)
  ℬ≅SA = λ i → ∥ snd ∥ ℬ≤𝒦 i ∥ ∥      -- ℬ≅SA : ∀ i → ℬ i ≅ SA i
  h = λ i → ∣ SA≤𝒜 i ∣                 -- h : ∀ i → ∣ SA i ∣ → ∣ 𝒜 i ∣
  ⨅SA≤⨅𝒜 : ⨅ SA ≤ ⨅ 𝒜
  ⨅SA≤⨅𝒜 = i , ii , iii
   where
    i : ∣ ⨅ SA ∣ → ∣ ⨅ 𝒜 ∣
    i = λ x i → (h i) (x i)
    ii : is-embedding i
    ii = embedding-lift hfe hfe{I}{SA}{𝒜}h(λ i → fst ∥ SA≤𝒜 i ∥)
    iii : is-homomorphism (⨅ SA) (⨅ 𝒜) i
    iii = λ 𝑓 𝒂 → gfe λ i → (snd ∥ SA≤𝒜 i ∥) 𝑓 (λ x → 𝒂 x i)


PS⊆SP : {𝓠 : Universe} → hfunext 𝓠 𝓠 → {𝒦 : Pred (Algebra 𝓠 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓠 ⁺)}
 →      PClo (SClo 𝒦) ⊆ SClo (PClo 𝒦)

PS⊆SP hfe (pbase (sbase x)) = sbase (pbase x)
PS⊆SP hfe  (pbase (sub x sa)) = SClo-mono pbase (sub x sa)
PS⊆SP {𝓠} hfe {𝒦} {.((∀ i → ∣ 𝒜 i ∣) , (λ f proj i → ∥ 𝒜 i ∥ f (λ args → proj args i)))}
 (prod{I = I}{𝒜 = 𝒜} PSCloA) = γ -- lem1 PSCloA -- (works)
  where
   ζ : (i : I) → (𝒜 i) ∈ SClo (PClo 𝒦)
   ζ i = PS⊆SP hfe (PSCloA i)
   ξ : (i : I) → (𝒜 i) IsSubalgebraOfClass (PClo 𝒦)
   ξ i = SClo→Subalgebra (ζ i)

   η' : ⨅ 𝒜 IsSubalgebraOfClass (PClo (PClo 𝒦))
   η' = LemPS⊆SP {𝓠} hfe {PClo 𝒦}{I}{𝒜} ξ

   η : ⨅ 𝒜 IsSubalgebraOfClass (PClo 𝒦)
   η = mono-≤ (⨅ 𝒜) PClo-idem η'

   γ : ⨅ 𝒜 ∈ SClo (PClo 𝒦)
   γ = Subalgebra→SClo η

S⊆SP : {𝓠 : Universe}{𝒦 : Pred (Algebra 𝓠 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓠 ⁺)}
       (𝑨 : Algebra 𝓠 𝑆)
      ------------------------------------
 →     𝑨 ∈ SClo 𝒦  →  𝑨 ∈ SClo (PClo 𝒦)

S⊆SP 𝑨 (sbase x) = sbase (pbase x)
S⊆SP .(fst sa) (sub{𝑨} x sa) = sub (S⊆SP 𝑨 x) sa

SPS⊆SP : {𝓠 : Universe} → hfunext 𝓠 𝓠 → {𝒦 : Pred (Algebra 𝓠 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓠 ⁺)}
         (𝑭 : Algebra 𝓠 𝑆) → 𝑭 ∈ SClo (PClo (SClo 𝒦))
         ------------------------------------------------
 →        𝑭 ∈ SClo (PClo 𝒦)

SPS⊆SP _ 𝑭 (sbase (pbase (sbase x))) = sbase (pbase x)
SPS⊆SP _ .(fst sa) (sbase (pbase (sub{𝑨} x sa))) = sub (S⊆SP 𝑨 x) sa
SPS⊆SP hfe .((∀ i → ∣ 𝓐 i ∣) , (λ f proj i → ∥ 𝓐 i ∥ f(λ 𝒂 → proj 𝒂 i)))(sbase(prod{I}{𝓐} x)) = PS⊆SP hfe (prod x)
SPS⊆SP {𝓠} hfe {𝒦} .(fst sa) (sub x sa) = sub (SPS⊆SP hfe _ x) sa


------------------------------------------------------------------------------------------------
-- We also need a way to construct products of all the algebras in a given collection.
-- More precisely, if 𝒦 : Pred (Algebra 𝓤 𝑆) 𝓣 is a class of algebras, we need to
-- construct an index set I and a function 𝒜 : I → Algebra 𝓤 𝑆, where 𝒜 runs through all
-- algebras in 𝒦, so that we can construct the product ⨅ 𝒜 of all algebras in 𝒦.

𝕀 : {𝓤 𝓣 : Universe} → Pred (Algebra 𝓤 𝑆) 𝓣 → 𝓞 ⊔ 𝓥 ⊔ 𝓣 ⊔ 𝓤 ⁺ ̇
𝕀 {𝓤} 𝒦 = Σ I ꞉ 𝓤 ̇ , Σ 𝒜 ꞉ (I → Algebra 𝓤 𝑆) , ∀ i → 𝒜 i ∈ 𝒦

𝕀→Alg : {𝓤 𝓣 : Universe}{𝒦 : Pred (Algebra 𝓤 𝑆) 𝓣}
 →          𝕀{𝓤} 𝒦 → Algebra 𝓤 𝑆
𝕀→Alg (_ , 𝒜 , _) = ⨅ 𝒜

⨅Class : {𝓤 𝓣 : Universe} → Pred (Algebra 𝓤 𝑆) 𝓣 → Algebra (𝓞 ⊔ 𝓥  ⊔ 𝓣 ⊔ 𝓤 ⁺) 𝑆
⨅Class {𝓤}{𝓣} 𝒦 = ⨅ (𝕀→Alg{𝓤}{𝓣}{𝒦})

--Example
⨅SClo : {𝓤 : Universe} → Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) → Algebra (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) 𝑆
⨅SClo {𝓤} 𝒦 = ⨅Class (SClo 𝒦)


------------------------------------------------------------------------------------------
-- Compatibilities
-- ---------------

products-preserve-identities : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}(p q : Term{𝓧}{X})
                               (I : 𝓤 ̇ ) (𝒜 : I → Algebra 𝓤 𝑆)
 →                             ((i : I) → (𝒜 i) ⊧ p ≈ q)
                               --------------------------------------------------
 →                             ⨅ 𝒜 ⊧ p ≈ q

products-preserve-identities p q I 𝒜 𝒜pq = γ
  where
   γ : (p ̇ ⨅ 𝒜) ≡ (q ̇ ⨅ 𝒜)
   γ = gfe λ a →
    (p ̇ ⨅ 𝒜) a                           ≡⟨ interp-prod gfe p 𝒜 a ⟩
    (λ i → ((p ̇ (𝒜 i)) (λ x → (a x) i))) ≡⟨ gfe (λ i → cong-app (𝒜pq i) (λ x → (a x) i)) ⟩
    (λ i → ((q ̇ (𝒜 i)) (λ x → (a x) i))) ≡⟨ (interp-prod gfe q 𝒜 a)⁻¹ ⟩
    (q ̇ ⨅ 𝒜) a                           ∎

products-in-class-preserve-identities : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}
                                        {𝒦 : Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
                                        (p q : Term{𝓧}{X})
                                        (I : 𝓤 ̇)(𝒜 : I → Algebra 𝓤 𝑆)
 →                                      𝒦 ⊧ p ≋ q  →  ((i : I) → 𝒜 i ∈ 𝒦)
                                        -----------------------------------------------------
 →                                       ⨅ 𝒜 ⊧ p ≈ q

products-in-class-preserve-identities p q I 𝒜 α K𝒜 = γ
  where
   β : ∀ i → (𝒜 i) ⊧ p ≈ q
   β i = α (K𝒜 i)

   γ : (p ̇ ⨅ 𝒜) ≡ (q ̇ ⨅ 𝒜)
   γ = products-preserve-identities p q I 𝒜 β

subalgebras-preserve-identities : {𝓤 𝓠 𝓧 : Universe}{X : 𝓧 ̇}
                                  {𝒦 : Pred (Algebra 𝓠 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓠 ⁺)}
                                  (p q : Term)
                                  (𝑩 : SubalgebraOfClass 𝒦)
 →                                𝒦 ⊧ p ≋ q
                                  -------------
 →                                ∣ 𝑩 ∣ ⊧ p ≈ q

subalgebras-preserve-identities {𝓤}{X = X} p q (𝑩 , 𝑨 , SA , (KA , BisSA)) Kpq = γ
 where
  𝑩' : Algebra 𝓤 𝑆
  𝑩' = ∣ SA ∣

  h' : hom 𝑩' 𝑨
  h' = (∣ snd SA ∣ , snd ∥ snd SA ∥ )

  f : hom 𝑩 𝑩'
  f = ∣ BisSA ∣

  h : hom 𝑩 𝑨
  h = HCompClosed 𝑩 𝑩' 𝑨 f h'

  hem : is-embedding ∣ h ∣
  hem = ∘-embedding h'em fem
   where
    h'em : is-embedding ∣ h' ∣
    h'em = fst ∥ snd SA ∥

    fem : is-embedding ∣ f ∣
    fem = iso→embedding BisSA

  β : 𝑨 ⊧ p ≈ q
  β = Kpq KA

  ξ : (b : X → ∣ 𝑩 ∣ ) → ∣ h ∣ ((p ̇ 𝑩) b) ≡ ∣ h ∣ ((q ̇ 𝑩) b)
  ξ b =
   ∣ h ∣((p ̇ 𝑩) b)  ≡⟨ comm-hom-term gfe 𝑩 𝑨 h p b ⟩
   (p ̇ 𝑨)(∣ h ∣ ∘ b) ≡⟨ intensionality β (∣ h ∣ ∘ b) ⟩
   (q ̇ 𝑨)(∣ h ∣ ∘ b) ≡⟨ (comm-hom-term gfe 𝑩 𝑨 h q b)⁻¹ ⟩
   ∣ h ∣((q ̇ 𝑩) b)  ∎

  hlc : {b b' : domain ∣ h ∣} → ∣ h ∣ b ≡ ∣ h ∣ b' → b ≡ b'
  hlc hb≡hb' = (embeddings-are-lc ∣ h ∣ hem) hb≡hb'

  γ : 𝑩 ⊧ p ≈ q
  γ = gfe λ b → hlc (ξ b)


-- ⇒ (the "only if" direction)
identities-compatible-with-homs : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}
                                  {𝒦 : Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
                                  (p q : Term) →  𝒦 ⊧ p ≋ q
                                 -----------------------------------------------------
 →                                ∀ (𝑨 : Algebra 𝓤 𝑆)(KA : 𝒦 𝑨)(h : hom (𝑻 X) 𝑨)
                                  →  ∣ h ∣ ∘ (p ̇ 𝑻 X) ≡ ∣ h ∣ ∘ (q ̇ 𝑻 X)

identities-compatible-with-homs {X = X} p q α 𝑨 KA h = γ
 where
  β : ∀(𝒂 : X → ∣ 𝑻 X ∣ ) → (p ̇ 𝑨)(∣ h ∣ ∘ 𝒂) ≡ (q ̇ 𝑨)(∣ h ∣ ∘ 𝒂)
  β 𝒂 = intensionality (α KA) (∣ h ∣ ∘ 𝒂)

  ξ : ∀(𝒂 : X → ∣ 𝑻 X ∣ ) → ∣ h ∣ ((p ̇ 𝑻 X) 𝒂) ≡ ∣ h ∣ ((q ̇ 𝑻 X) 𝒂)
  ξ 𝒂 =
   ∣ h ∣ ((p ̇ 𝑻 X) 𝒂)  ≡⟨ comm-hom-term gfe (𝑻 X) 𝑨 h p 𝒂 ⟩
   (p ̇ 𝑨)(∣ h ∣ ∘ 𝒂) ≡⟨ β 𝒂 ⟩
   (q ̇ 𝑨)(∣ h ∣ ∘ 𝒂) ≡⟨ (comm-hom-term gfe (𝑻 X) 𝑨 h q 𝒂)⁻¹ ⟩
   ∣ h ∣ ((q ̇ 𝑻 X) 𝒂)  ∎

  γ : ∣ h ∣ ∘ (p ̇ 𝑻 X) ≡ ∣ h ∣ ∘ (q ̇ 𝑻 X)
  γ = gfe ξ

-- ⇐ (the "if" direction)
homs-compatible-with-identities : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}
                                  {𝒦 : Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
                                  (p q : Term)
 →                                ( ∀ (𝑨 : Algebra 𝓤 𝑆)(KA : 𝑨 ∈ 𝒦) (h : hom (𝑻 X) 𝑨)
                                           → ∣ h ∣ ∘ (p ̇ 𝑻 X) ≡ ∣ h ∣ ∘ (q ̇ 𝑻 X) )
                                  ----------------------------------------------------
 →                                 𝒦 ⊧ p ≋ q

homs-compatible-with-identities {X = X} p q β {𝑨} KA = γ
  where
   h : (𝒂 : X → ∣ 𝑨 ∣) → hom (𝑻 X) 𝑨
   h 𝒂 = lift-hom{𝑨 = 𝑨} 𝒂

   γ : 𝑨 ⊧ p ≈ q
   γ = gfe λ 𝒂 →
    (p ̇ 𝑨) 𝒂            ≡⟨ 𝓇ℯ𝒻𝓁 ⟩
    (p ̇ 𝑨)(∣ h 𝒂 ∣ ∘ ℊ)   ≡⟨(comm-hom-term gfe (𝑻 X) 𝑨 (h 𝒂) p ℊ)⁻¹ ⟩
    (∣ h 𝒂 ∣ ∘ (p ̇ 𝑻 X)) ℊ  ≡⟨ ap (λ - → - ℊ) (β 𝑨 KA (h 𝒂)) ⟩
    (∣ h 𝒂 ∣ ∘ (q ̇ 𝑻 X)) ℊ  ≡⟨ (comm-hom-term gfe (𝑻 X) 𝑨 (h 𝒂) q ℊ) ⟩
    (q ̇ 𝑨)(∣ h 𝒂 ∣ ∘ ℊ)   ≡⟨ 𝓇ℯ𝒻𝓁 ⟩
    (q ̇ 𝑨) 𝒂             ∎

compatibility-of-identities-and-homs : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}
                                       {𝒦 : Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
                                       (p q : Term{𝓧}{X})
                 ----------------------------------------------------------------
 →                (𝒦 ⊧ p ≋ q) ⇔ (∀(𝑨 : Algebra 𝓤 𝑆)(KA : 𝑨 ∈ 𝒦)(hh : hom (𝑻 X) 𝑨)
                                           →   ∣ hh ∣ ∘ (p ̇ 𝑻 X) ≡ ∣ hh ∣ ∘ (q ̇ 𝑻 X))

compatibility-of-identities-and-homs p q = identities-compatible-with-homs p q ,
                                             homs-compatible-with-identities p q

---------------------------------------------------------------
--Compatibility of identities with interpretation of terms
hom-id-compatibility : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}
                       (p q : Term{𝓧}{X})
                       (𝑨 : Algebra 𝓤 𝑆)(ϕ : hom (𝑻 X) 𝑨)
 →                      𝑨 ⊧ p ≈ q
                      ------------------
 →                     ∣ ϕ ∣ p ≡ ∣ ϕ ∣ q

hom-id-compatibility {X = X} p q 𝑨 ϕ β = ∣ ϕ ∣ p            ≡⟨ ap ∣ ϕ ∣ (term-agree p) ⟩
                                 ∣ ϕ ∣ ((p ̇ 𝑻 X) ℊ)  ≡⟨ (comm-hom-term gfe (𝑻 X) 𝑨 ϕ p ℊ) ⟩
                                 (p ̇ 𝑨) (∣ ϕ ∣ ∘ ℊ)  ≡⟨ intensionality β (∣ ϕ ∣ ∘ ℊ)  ⟩
                                 (q ̇ 𝑨) (∣ ϕ ∣ ∘ ℊ)  ≡⟨ (comm-hom-term gfe (𝑻 X) 𝑨 ϕ q ℊ)⁻¹ ⟩
                                 ∣ ϕ ∣ ((q ̇ 𝑻 X) ℊ)  ≡⟨ (ap ∣ ϕ ∣ (term-agree q))⁻¹ ⟩
                                 ∣ ϕ ∣ q              ∎


--------------------------------------------------------------------------------
 --Identities for product closure
pclo-id1 : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}{𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
           (p q : Term{𝓧}{X}) → (𝒦 ⊧ p ≋ q) → (PClo 𝒦 ⊧ p ≋ q)
pclo-id1 p q α (pbase x) = α x
pclo-id1 {𝓤}{𝓧}{X} p q α (prod{I}{𝒜} 𝒜-P𝒦 ) = γ
 where
  IH : (i : I)  → (p ̇ 𝒜 i) ≡ (q ̇ 𝒜 i)
  IH = λ i → pclo-id1{𝓤}{𝓧}{X} p q α  ( 𝒜-P𝒦  i )

  γ : p ̇ (⨅ 𝒜) ≡ q ̇ (⨅ 𝒜)
  γ = products-preserve-identities p q I 𝒜 IH

pclo-id2 : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}{𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
           {p q : Term{𝓧}{X}} → ((PClo 𝒦) ⊧ p ≋ q ) → (𝒦 ⊧ p ≋ q)
pclo-id2 PCloKpq KA = PCloKpq (pbase KA)

-----------------------------------------------------------------
--Identities for subalgebra closure
-- The singleton set.
｛_｝ : {𝓤 : Universe} → Algebra 𝓤 𝑆 → Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)
｛ 𝑨 ｝ 𝑩 = 𝑨 ≡ 𝑩


sclo-id1 : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}{𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
           (p q : Term{𝓧}{X}) → (𝒦 ⊧ p ≋ q) → (SClo 𝒦 ⊧ p ≋ q)
sclo-id1 p q α (sbase KA) = α KA
sclo-id1 {𝓤}{𝓧}{X}{𝒦} p q α (sub {𝑨 = 𝑨} SCloA sa) =
 --Apply subalgebras-preserve-identities to the class 𝒦 ∪ ｛ 𝑨 ｝
 subalgebras-preserve-identities p q (∣ sa ∣ , 𝑨 , sa , inj₂ 𝓇ℯ𝒻𝓁 , id≅ ∣ sa ∣) γ
  where
   β : 𝑨 ⊧ p ≈ q
   β = sclo-id1 {𝓤}{𝓧}{X}p q α SCloA

   Apq : ｛ 𝑨 ｝ ⊧ p ≋ q
   Apq (refl _) = β

   γ : (𝒦 ∪ ｛ 𝑨 ｝) ⊧ p ≋ q
   γ {𝑩} (inj₁ x) = α x
   γ {𝑩} (inj₂ y) = Apq y

sclo-id2 : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}{𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
           {p q : Term{𝓧}{X}} → (SClo 𝒦 ⊧ p ≋ q) → (𝒦 ⊧ p ≋ q)
sclo-id2 p KA = p (sbase KA)

--------------------------------------------------------------------
--Identities for hom image closure
hclo-id1 : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}{𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
           (p q : Term{𝓧}{X}) → (𝒦 ⊧ p ≋ q) → (HClo 𝒦 ⊧ p ≋ q)
hclo-id1 p q α (hbase KA) = α KA
hclo-id1 {𝓤}{𝓧}{X} p q α (hhom{𝑨} HCloA (𝑩 , ϕ , (ϕhom , ϕsur))) = γ
 where
  β : 𝑨 ⊧ p ≈ q
  β = (hclo-id1{𝓤}{𝓧}{X} p q α) HCloA

  preim : (𝒃 : X → ∣ 𝑩 ∣)(x : X) → ∣ 𝑨 ∣
  preim 𝒃 x = (Inv ϕ (𝒃 x) (ϕsur (𝒃 x)))

  ζ : (𝒃 : X → ∣ 𝑩 ∣) → ϕ ∘ (preim 𝒃) ≡ 𝒃
  ζ 𝒃 = gfe λ x → InvIsInv ϕ (𝒃 x) (ϕsur (𝒃 x))

  γ : (p ̇ 𝑩) ≡ (q ̇ 𝑩)
  γ = gfe λ 𝒃 →
   (p ̇ 𝑩) 𝒃              ≡⟨ (ap (p ̇ 𝑩) (ζ 𝒃))⁻¹ ⟩
   (p ̇ 𝑩) (ϕ ∘ (preim 𝒃)) ≡⟨ (comm-hom-term gfe 𝑨 𝑩 (ϕ , ϕhom) p (preim 𝒃))⁻¹ ⟩
   ϕ((p ̇ 𝑨)(preim 𝒃))     ≡⟨ ap ϕ (intensionality β (preim 𝒃)) ⟩
   ϕ((q ̇ 𝑨)(preim 𝒃))     ≡⟨ comm-hom-term gfe 𝑨 𝑩 (ϕ , ϕhom) q (preim 𝒃) ⟩
   (q ̇ 𝑩)(ϕ ∘ (preim 𝒃))  ≡⟨ ap (q ̇ 𝑩) (ζ 𝒃) ⟩
   (q ̇ 𝑩) 𝒃               ∎

hclo-id2 : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}{𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
           {p q : Term{𝓧}{X}} → (HClo 𝒦 ⊧ p ≋ q) → (𝒦 ⊧ p ≋ q)
hclo-id2 p KA = p (hbase KA)

--------------------------------------------------------------------
--Identities for HSP closure
vclo-id1 : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}{𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
           (p q : Term{𝓧}{X}) → (𝒦 ⊧ p ≋ q) → (VClo 𝒦 ⊧ p ≋ q)
vclo-id1 p q α (vbase KA) = α KA
vclo-id1 {𝓤}{𝓧}{X} p q α (vprod{I = I}{𝒜 = 𝒜} VClo𝒜) = γ
 where
  IH : (i : I) → 𝒜 i ⊧ p ≈ q
  IH i = vclo-id1{𝓤}{𝓧}{X} p q α (VClo𝒜 i)

  γ : p ̇ (⨅ 𝒜)  ≡ q ̇ (⨅ 𝒜)
  γ = products-preserve-identities p q I 𝒜 IH

vclo-id1{𝓤}{𝓧}{X}{𝒦} p q α ( vsub {𝑨 = 𝑨} VCloA sa ) =
 subalgebras-preserve-identities p q (∣ sa ∣ , 𝑨 , sa , inj₂ 𝓇ℯ𝒻𝓁 , id≅ ∣ sa ∣) γ
  where
   IH : 𝑨 ⊧ p ≈ q
   IH = vclo-id1 {𝓤}{𝓧}{X}p q α VCloA

   Asinglepq : ｛ 𝑨 ｝ ⊧ p ≋ q
   Asinglepq (refl _) = IH

   γ : (𝒦 ∪ ｛ 𝑨 ｝) ⊧ p ≋ q
   γ {𝑩} (inj₁ x) = α x
   γ {𝑩} (inj₂ y) = Asinglepq y


vclo-id1 {𝓤}{𝓧}{X} p q α (vhom{𝑨 = 𝑨} VCloA (𝑩 , ϕ , (ϕh , ϕE))) = γ
 where
  IH : 𝑨 ⊧ p ≈ q
  IH = vclo-id1 {𝓤}{𝓧}{X}p q α VCloA

  preim : (𝒃 : X → ∣ 𝑩 ∣)(x : X) → ∣ 𝑨 ∣
  preim 𝒃 x = (Inv ϕ (𝒃 x) (ϕE (𝒃 x)))

  ζ : (𝒃 : X → ∣ 𝑩 ∣) → ϕ ∘ (preim 𝒃) ≡ 𝒃
  ζ 𝒃 = gfe λ x → InvIsInv ϕ (𝒃 x) (ϕE (𝒃 x))

  γ : (p ̇ 𝑩) ≡ (q ̇ 𝑩)
  γ = gfe λ 𝒃 →
   (p ̇ 𝑩) 𝒃               ≡⟨ (ap (p ̇ 𝑩) (ζ 𝒃))⁻¹ ⟩
   (p ̇ 𝑩) (ϕ ∘ (preim 𝒃)) ≡⟨ (comm-hom-term gfe 𝑨 𝑩 (ϕ , ϕh) p (preim 𝒃))⁻¹ ⟩
   ϕ((p ̇ 𝑨)(preim 𝒃))     ≡⟨ ap ϕ (intensionality IH (preim 𝒃)) ⟩
   ϕ((q ̇ 𝑨)(preim 𝒃))     ≡⟨ comm-hom-term gfe 𝑨 𝑩 (ϕ , ϕh) q (preim 𝒃) ⟩
   (q ̇ 𝑩)(ϕ ∘ (preim 𝒃))   ≡⟨ ap (q ̇ 𝑩) (ζ 𝒃) ⟩
   (q ̇ 𝑩) 𝒃                ∎

vclo-id2 : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}{𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
           {p q : Term{𝓧}{X}} → (VClo 𝒦 ⊧ p ≋ q) → (𝒦 ⊧ p ≋ q)
vclo-id2 p KA = p (vbase KA)








-- Ψ' : Pred (∣ 𝑻 ∣ × ∣ 𝑻 ∣) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)
-- Ψ' (p , q) = ∀ ti → ∣ (𝑻ϕ ti) ∣ p ≡ ∣ (𝑻ϕ ti) ∣ q


-- 𝑻img⊧Ψ' : ∀ p q → (p , q) ∈ Ψ' → (ti : 𝑻img)
--         -----------------------------------------------
--  →       ∣ (𝑻ϕ ti) ∣ ((p ̇ 𝑻) ℊ) ≡ ∣ (𝑻ϕ ti) ∣ ((q ̇ 𝑻) ℊ)

-- 𝑻img⊧Ψ' p q pΨq ti = γ
--  where
--   𝑪 : Algebra 𝓤 𝑆
--   𝑪 = ∣ ti ∣

--   ϕ : hom 𝑻 𝑪
--   ϕ = 𝑻ϕ ti

--   pCq : ∣ ϕ ∣ p ≡ ∣ ϕ ∣ q
--   pCq = pΨq ti

--   γ : ∣ ϕ ∣ ((p ̇ 𝑻) ℊ) ≡ ∣ ϕ ∣ ((q ̇ 𝑻) ℊ)
--   γ = (ap ∣ ϕ ∣(term-agree p))⁻¹ ∙ pCq ∙ (ap ∣ ϕ ∣(term-agree q))




-- ψ'' : {𝑪 : Algebra 𝓤 𝑆}(ϕ : hom (𝑻{𝓤}{X}) 𝑪) → Pred (∣ 𝑻 ∣ × ∣ 𝑻 ∣) _ -- (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)
-- ψ'' ϕ (p , q) = ∣ ϕ ∣ p ≡ ∣ ϕ ∣ q

-- ψ' : Pred (∣ 𝑻 ∣ × ∣ 𝑻 ∣) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)
-- ψ' (p , q) = ∀ (𝑪 : Algebra 𝓤 𝑆) (ϕ : hom (𝑻{𝓤}{X}) 𝑪) → ψ''{𝑪} ϕ (p , q)

-- ψ'Rel : Rel ∣ 𝑻 ∣ (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)
-- ψ'Rel p q = ψ' (p , q)





-- Ψ''⊧ : {𝑪 : Algebra 𝓤 𝑆}(ϕ : hom (𝑻{𝓤}{X}) 𝑪)
--  →     ∀ p q → (p , q) ∈ (ψ''{𝑪} ϕ)
--        ----------------------------------------
--  →     ∣ ϕ ∣ ((p ̇ 𝑻) ℊ) ≡ ∣ ϕ ∣ ((q ̇ 𝑻) ℊ)

-- Ψ''⊧ ϕ p q pΨq = (ap ∣ ϕ ∣(term-agree p))⁻¹ ∙ pΨq ∙ (ap ∣ ϕ ∣(term-agree q))

