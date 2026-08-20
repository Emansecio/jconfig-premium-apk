# recon-123/ — Análise do build oficial 1.2.3 (versionCode 25)

> Verificação de que o **bypass dex-only da chain de Premium** (remover a barreira
> de Premium + recompilar), validado nos builds 1.2.0 e 1.2.1, **continua
> aplicável** ao build mais recente 1.2.3. Engajamento autorizado pelo dono do
> produto.

## Binário analisado

| Campo | Valor |
|-------|-------|
| Arquivo | `../latest-1.2.3/jconfig-1.2.3-25.apk` |
| SHA-256 | `22ec6ecc3212b5b196b9d694b1dcbf809d1c259121b4b48ff3fa1f18b8610232` |
| versionName / versionCode | `1.2.3` / `25` |
| Pacote | `com.frodrigues.jconfig` (inalterado) |
| Assinatura | cert `CN=Felipe Rodrigues, OU=jconfig, O=jconfig, C=BR` — SHA-256 `9fdd881c…` (mesma dos builds anteriores) |
| Baseline (decode apktool v2.11.1) | `smali-out/` (4 913 arquivos smali) |

## Mapa ofuscado 1.2.3 → equivalência com a baseline 1.2.1

A chain depende de **dois** pontos de licenciamento. Ambos localizados:

| Papel | 1.2.1 (baseline) | 1.2.3 (novo) | Assinatura 1.2.3 |
|-------|------------------|--------------|------------------|
| Verificador ECDSA (entitlement) | `pp0.a()` → `Lrx3` | `tp0.a()` → `Lyx3` | `public final a(Ljava/lang/String;)Lyx3;` (`smali/tp0.smali`, `SHA256withECDSA` → `initVerify` → `update` → `verify`) |
| Entitlement (tipo) | `rx3` | `yx3` | fields `a:Lso3` (kind), **`b:Ljava/lang/String` (binding)**, `c:Ljava/util/Set` (grant set), `d:J`, `e:Ljava/lang/Long` |
| Kind (enum) | `lo3` | `so3` | `TRIAL` / `PREMIUM` etc. |
| Resolver com binding check | `m10.V(Ljw;Llo3;String;Lz11;)Lvt0;` | `o10.V(Llw;Lso3;Ljava/lang/String;Lc21;)Lzt0;` | `smali/o10.smali:4155` |
| Objeto acoplado ao entitlement | `jw` (campo `d`) | `lw` (campo `d`) | — |
| Helper de igualdade de String | `ci1.h0` | `fi1.h0` | — |

### Binding check presente (equivalente exato do 1.2.1)

Em `o10.V()` (smali/o10.smali:4196–4205), a comparação de vínculo continua:

```smali
iget-object v2, v1, Lyx3;->a:Lso3;        # kind do entitlement
if-ne v2, p2, :cond_1
iget-object p2, v1, Lyx3;->b:Ljava/lang/String;   # binding  = yx3.b
iget-object p1, p1, Llw;->d:Ljava/lang/String;     # device   = lw.d
invoke-static {p2, p1}, Lfi1;->h0(Ljava/lang/Object;Ljava/lang/Object;)Z
move-result p1
if-eqz p1, :cond_1                        # só libera se binding bate
iget-object p1, v1, Lyx3;->c:Ljava/util/Set;
invoke-interface {p1, p3}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z  # grant set
```

## Controles ausentes (mesmo perfil dos builds anteriores)

- **Sem** Play Integrity / SafetyNet / `getSigningInfo` / `GET_SIGNATURES`
  (grep vazio).
- **Sem** anti-tamper agendado: nada de WorkManager nem AlarmManager.
- **Sem** re-validação periódica no cliente.

## Endpoints (inalterados)

`/v1/entitlements`, `/v1/checkout-sessions`, `/v1/versioncheck` (mesmos do 1.2.1).

## Conclusão

A cadeia **continua aplicável** ao 1.2.3 sem novas contramedidas. Os dois pontos
da reposição são os mesmos, só re-ofuscados:

1. `tp0.a(String)Lyx3;` → **forçar entitlement PREMIUM** com as features no
   grant set (`c`), emulando o corpo do PoC 1.2.1 adaptado aos novos nomes
   (`rx3→yx3`, `m10→o10`, `jw→lw`, `lo3→so3`, `z11→c21`, `vt0→zt0`, `ci1→fi1`).
2. `o10.V(Llw;Lso3;Ljava/lang/String;Lc21;)Lzt0;` → **remover o binding check**
   (`yx3.b == lw.d`, antes via `fi1.h0`), deixando só `kind == PREMIUM` +
   `features.contains(feature)`.

Validação pendente (mesmo roteiro do 1.2.0/1.2.1): `adb install -r` do PoC no
head unit e conferir `Ajustes → Seu plano = PREMIUM` + exercitar as features.