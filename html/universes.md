---
layout: default
title : universes module (from the Type Topology library of Martin Escardo)
date : 2021-01-12
author: Martin Escardo
---

<!--
FILE: universes.lagda
AUTHOR: Martin Escardo
REF: This file was adapted from the HoTT/UF course notes by Martin Hötzel Escardo (MHE).
SEE: https://www.cs.bham.ac.uk/~mhe/HoTT-UF-in-Agda-Lecture-Notes/
-->

<pre class="Agda">

<a id="368" class="Symbol">{-#</a> <a id="372" class="Keyword">OPTIONS</a> <a id="380" class="Pragma">--without-K</a> <a id="392" class="Pragma">--exact-split</a> <a id="406" class="Pragma">--safe</a> <a id="413" class="Symbol">#-}</a>

<a id="418" class="Keyword">module</a> <a id="425" href="universes.html" class="Module">universes</a> <a id="435" class="Keyword">where</a>

<a id="442" class="Keyword">open</a> <a id="447" class="Keyword">import</a> <a id="454" href="Agda.Primitive.html" class="Module">Agda.Primitive</a>
  <a id="471" class="Keyword">using</a> <a id="477" class="Symbol">(</a><a id="478" href="Agda.Primitive.html#636" class="Primitive Operator">_⊔_</a><a id="481" class="Symbol">)</a>
  <a id="485" class="Keyword">renaming</a> <a id="494" class="Symbol">(</a><a id="495" href="Agda.Primitive.html#590" class="Primitive">lzero</a> <a id="501" class="Symbol">to</a> <a id="Primitive.lzero"></a><a id="504" href="universes.html#504" class="Primitive">𝓤₀</a>
          <a id="517" class="Symbol">;</a> <a id="519" href="Agda.Primitive.html#606" class="Primitive">lsuc</a> <a id="524" class="Symbol">to</a> <a id="Primitive.lsuc"></a><a id="527" href="universes.html#527" class="Primitive">_⁺</a>
          <a id="540" class="Symbol">;</a> <a id="542" href="Agda.Primitive.html#423" class="Postulate">Level</a> <a id="548" class="Symbol">to</a> <a id="Primitive.Level"></a><a id="551" href="universes.html#551" class="Postulate">Universe</a>
          <a id="570" class="Symbol">;</a> <a id="572" href="Agda.Primitive.html#787" class="Primitive">Setω</a> <a id="577" class="Symbol">to</a> <a id="Primitive.Setω"></a><a id="580" href="universes.html#580" class="Primitive">𝓤ω</a>
          <a id="593" class="Symbol">)</a> <a id="595" class="Keyword">public</a>

<a id="603" class="Keyword">variable</a>
 <a id="613" href="universes.html#613" class="Generalizable">𝓞</a> <a id="615" href="universes.html#615" class="Generalizable">𝓤</a> <a id="617" href="universes.html#617" class="Generalizable">𝓥</a> <a id="619" href="universes.html#619" class="Generalizable">𝓦</a> <a id="621" href="universes.html#621" class="Generalizable">𝓣</a> <a id="623" href="universes.html#623" class="Generalizable">𝓤&#39;</a> <a id="626" href="universes.html#626" class="Generalizable">𝓥&#39;</a> <a id="629" href="universes.html#629" class="Generalizable">𝓦&#39;</a> <a id="632" href="universes.html#632" class="Generalizable">𝓣&#39;</a> <a id="635" class="Symbol">:</a> <a id="637" href="universes.html#551" class="Postulate">Universe</a>

</pre>

The following should be the only use of the Agda keyword 'Set' in this development:

<pre class="Agda">

<a id="_̇"></a><a id="758" href="universes.html#758" class="Function Operator">_̇</a> <a id="761" class="Symbol">:</a> <a id="763" class="Symbol">(</a><a id="764" href="universes.html#764" class="Bound">𝓤</a> <a id="766" class="Symbol">:</a> <a id="768" href="universes.html#551" class="Postulate">Universe</a><a id="776" class="Symbol">)</a> <a id="778" class="Symbol">→</a> <a id="780" class="Symbol">_</a>
<a id="782" href="universes.html#782" class="Bound">𝓤</a> <a id="784" href="universes.html#758" class="Function Operator">̇</a> <a id="786" class="Symbol">=</a> <a id="788" class="PrimitiveType">Set</a> <a id="792" href="universes.html#782" class="Bound">𝓤</a>

<a id="𝓤₁"></a><a id="795" href="universes.html#795" class="Function">𝓤₁</a> <a id="798" class="Symbol">=</a> <a id="800" href="universes.html#504" class="Primitive">𝓤₀</a> <a id="803" href="universes.html#527" class="Primitive Operator">⁺</a>
<a id="𝓤₂"></a><a id="805" href="universes.html#805" class="Function">𝓤₂</a> <a id="808" class="Symbol">=</a> <a id="810" href="universes.html#795" class="Function">𝓤₁</a> <a id="813" href="universes.html#527" class="Primitive Operator">⁺</a>

<a id="_⁺⁺"></a><a id="816" href="universes.html#816" class="Function Operator">_⁺⁺</a> <a id="820" class="Symbol">:</a> <a id="822" href="universes.html#551" class="Postulate">Universe</a> <a id="831" class="Symbol">→</a> <a id="833" href="universes.html#551" class="Postulate">Universe</a>
<a id="842" href="universes.html#842" class="Bound">𝓤</a> <a id="844" href="universes.html#816" class="Function Operator">⁺⁺</a> <a id="847" class="Symbol">=</a> <a id="849" href="universes.html#842" class="Bound">𝓤</a> <a id="851" href="universes.html#527" class="Primitive Operator">⁺</a> <a id="853" href="universes.html#527" class="Primitive Operator">⁺</a>

</pre>

This is mainly to avoid naming implicit arguments:

<pre class="Agda">

<a id="universe-of"></a><a id="934" href="universes.html#934" class="Function">universe-of</a> <a id="946" class="Symbol">:</a> <a id="948" class="Symbol">(</a><a id="949" href="universes.html#949" class="Bound">X</a> <a id="951" class="Symbol">:</a> <a id="953" href="universes.html#615" class="Generalizable">𝓤</a> <a id="955" href="universes.html#758" class="Function Operator">̇</a> <a id="957" class="Symbol">)</a> <a id="959" class="Symbol">→</a> <a id="961" href="universes.html#551" class="Postulate">Universe</a>
<a id="970" href="universes.html#934" class="Function">universe-of</a> <a id="982" class="Symbol">{</a><a id="983" href="universes.html#983" class="Bound">𝓤</a><a id="984" class="Symbol">}</a> <a id="986" href="universes.html#986" class="Bound">X</a> <a id="988" class="Symbol">=</a> <a id="990" href="universes.html#983" class="Bound">𝓤</a>

<a id="993" class="Keyword">infix</a>  <a id="1000" class="Number">1</a> <a id="1002" href="universes.html#758" class="Function Operator">_̇</a>
</pre>