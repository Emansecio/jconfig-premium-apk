# PoC JConfig 1.2.3 — bypass Premium completo (corrigido)

> PoC da chain (remover a barreira de Premium + recompilar) aplicado ao build
> oficial **1.2.3-25** (`../original/jconfig-1.2.3-25.apk`). Revisado em
> 2026-08-20 após o usuário reportar que **a versão anterior continuava com
> botões da sidebar trancados**. Engajamento autorizado pelo dono do produto.

## Builds

| Arquivo | Descrição |
|---------|-----------|
| `../original/jconfig-1.2.3-25.apk` | Build oficial 1.2.3, versionCode 25 (72 249 082 bytes) — **não alterado** |
| `../patched/jconfig-1.2.3-25-premium-fixed.apk` | **PoC corrigido/completo** (72 596 716 bytes), SHA-256 `31d4206d…` — assinado v2/v3 |

## Por que a versão anterior deixava botões trancados (causa raiz)

O PoC anterior apenas fazia `dw0.a(mn2,zt0) → true` (além de `tp0.a` e remoção
do binding em `o10.V`). **Isso não bastava**: no 1.2.3 várias telas — ex.
`ei1`, `fi1`, `j3`, `oz` — **não consultam `dw0.a`**; elas leem o **estado
resolvido** (`st0.j`, `Lrr2`) que é produzido pelo resolver `o10.L()`.

Para uma conta **free**, `o10.L()` devolve `Lut0` (Free). Assim, mesmo com o
gate `dw0.a` forçado, os pontos que checam o estado **direto** (`instance-of
Lyt0/Lxt0`) continuavam vendo *Free* → cadeado persistente na sidebar.

## Correção aplicada (nó central — resolve todos os gates de uma vez)

Patch no **resolver de licença** `o10.L(Llw;Lxi0;)Lzt0;`:

```smali
.method public L(Llw;Lxi0;)Lzt0;
    .locals 7
    # PATCH: force Premium entitlement unconditionally
    iput-object p2, p0, Lo10;->h:Ljava/lang/Object;
    new-instance v0, Lyt0;
    const-wide v1, 0x7fffffffffffffffL      # expiresAt = Long.MAX (nunca expira)
    const-wide v3, 0x0L                      # priceMinor = 0
    const-string v5, "BRL"
    const-string v6, "jconfig-premium-bypass"
    invoke-direct/range {v0 .. v6}, Lyt0;-><init>(JJLjava/lang/String;Ljava/lang/String;)V
    return-object v0
.end method
```

Forçando `o10.L()` a sempre retornar `Lyt0` (Premium), **todos** os consumidores
do estado ficam liberados, incluindo os que não passam por `dw0.a`:

| Tela/função | Checagem que agora passa |
|-------------|--------------------------|
| `dw0.a` (gate das 9 `PremiumFeature`) | `instance-of Lyt0` → true |
| `bn0`, `st0` (resolver/estado) | `instance-of Lyt0` → true |
| `oz`, `ei1`, `fi1`, `j3` (draw cadeado) | flag derivada de `st0.j` → true |
| `zs` (mapa feature→premium) | `dw0.a(...)` → true |

## Defesa em profundidade (mantido do PoC anterior)

- `dw0.smali` — `a(Lmn2;Lzt0;)Z` → **sempre `true`** (`const/4 p0, 0x1; return`).
  Cobre as 9 `PremiumFeature` (`EXTRA_PROFILES`, `ADAS`, `AUTO_PROFILE_APPLICATION`,
  `PHEV`, `CLUSTER_PROJECTION`, `MULTITASKING`, `CONFIGURABLE_GESTURES`,
  `STEERING_WHEEL`, `CLIMATE_COMFORT`).
- `tp0.smali` — `a(String)Lyx3;` fabrica um entitlement **PREMIUM** com as 9
  features no grant set (evidência em `tp0-a-premium.smali`).

## Pipeline (dex-only)

1. `apktool d original/jconfig-1.2.3-25.apk` → baseline.
2. Copia → `work/patched-smali/` + patches (`o10.L`, `dw0.a`, `tp0.a`).
3. `docs/tools/Asm.java` recompila `work/patched-classes.dex` via SmaliBuilder.
4. Substitui só `classes.dex` (DEFLATE) no APK oficial, remove `META-INF/`
   (assinaturas antigas), preserva demais entradas binárias.
5. `zipalign -f 4` + `apksigner sign` (v2/v3) com `docs/tools/keystore-poc.jks`
   (senha `jconfig`).

## Evidência (diffs)

| Arquivo | O que prova |
|---------|-------------|
| `docs/patches/o10-L-premium-forced.diff` | resolver de licença → Premium |
| `docs/patches/dw0-gate-open.diff` | gate das 9 features → true |
| `docs/patches/tp0-a-premium.smali` | verificador → entitlement PREMIUM |

## Validação

- `apksigner verify` OK — v2 (`APK Signature Scheme v2`) e v3 assinado, 1 signer.
- `aapt dump badging` OK — `com.frodrigues.jconfig` versionCode=25 v1.2.3.
- Dex do APK == `work/patched-classes.dex` (SHA-256 `e7a357b5…`), contém a
  string `jconfig-premium-bypass`.

> **A validar no head unit**: `adb install -r patched/jconfig-1.2.3-25-premium-fixed.apk`
> e conferir Ajustes → Seu plano = PREMIUM + **sidebar completa SEM cadeado**
> (todas as 9 features) + exercitar cada botão (clicáveis e acionáveis).