# Relatório técnico completo  
## JAECOO 7 Elite — iluminação ambiente das portas, arquitetura elétrica, software e hipótese de ativação

**Data da consolidação:** 18 de agosto de 2026  
**Objeto:** investigar por que o JAECOO 7 Elite possui elementos físicos correspondentes à iluminação ambiente nas portas, mas eles permanecem apagados e a central multimídia não oferece o menu de configuração existente em versões superiores; avaliar se a função pode estar apenas desabilitada por software/codificação e qual papel o Android/ADB pode desempenhar.

---

# 1. Resumo executivo

A investigação chegou a uma conclusão significativamente mais específica do que a hipótese inicial.

O JAECOO 7 Elite **não é um veículo simplesmente “sem iluminação ambiente”**.

No veículo analisado:

- existe fisicamente nas portas a faixa/acabamento correspondente ao guia óptico da iluminação;
- essas faixas das portas não acendem;
- o menu de configuração completa de iluminação ambiente não aparece na multimídia;
- porém **a iluminação ambiente situada na lateral do console/túnel central funciona normalmente**.

Esse último dado é decisivo.

Ele demonstra empiricamente que o Elite possui ao menos uma parte funcional do sistema OEM de iluminação ambiente: emissor, alimentação, controle eletrônico e integração com o veículo.

A documentação encontrada reforça justamente uma arquitetura **segmentada por zonas**.

No diagrama elétrico público da arquitetura T1EJ, usada pelo J7, aparecem separadamente:

```text
Instrument Panel Ambient Light
Console Ambient Light
```

em um circuito, enquanto:

```text
Door Ambient Lighting
```

aparece em outro.

Isso corresponde de maneira extraordinariamente próxima ao comportamento observado:

```text
J7 ELITE

Ambient light
│
├── painel / console
│      └── FUNCIONA
│
└── portas
       └── NÃO FUNCIONA
```

Além disso:

1. A própria OMODA & JAECOO Brasil declara oficialmente que o **J7 Elite possui “iluminação ambiente”**.
2. Documentação brasileira anterior da marca diferencia explicitamente versões **com e sem “iluminação ambiente customizável”**, demonstrando que a função é tratada como equipamento dependente de variante.
3. Na Austrália, duas versões do J7 usam a mesma central de **13,2"**, mas apenas a superior possui `Colour Selectable Ambient Light (Dashboard + Doors)`. Portanto, o tamanho/modelo básico da tela não determina sozinho a presença da função.
4. O BCM do J7 T1EJ possui, segundo a implementação diagnóstica do ScanDoc, um **código de configuração de software de 188 bits** e operação de gravação de configuração.
5. O mesmo BCM expõe testes de atuadores relacionados a iluminação interna e canais vermelho/azul.
6. Documentação de engenharia patenteada pela própria Chery mostra arquiteturas nas quais a multimídia/IHU envia parâmetros de cor, brilho, ON/OFF, modo de condução e música ao BCM ou a um controlador dedicado de ambient light.
7. Há proprietários de J7 Urban, Lifestyle e Active relatando praticamente **o mesmo fenômeno**: faixa física visível, ausência do menu e suspeita de que a iluminação tenha sido retirada ou desabilitada conforme a versão.
8. ADB não é mera especulação decorrente de a central ser Android: proprietários de J7 documentaram acesso ao menu de engenharia, ativação do `ADB SWITCH` e conexão efetiva de notebooks à head unit.

**O que ainda não está demonstrado:** se atrás das faixas das portas do Elite estão efetivamente instalados os módulos LED e seus fios/conectores.

Portanto, a conclusão mais rigorosa neste momento é:

> **Há forte evidência de que o Elite recebeu uma configuração parcial do sistema OEM de iluminação ambiente. É plausível que a função das portas seja bloqueada por configuração de variante, mas ainda falta comprovar se o hardware específico das quatro portas também foi instalado.**

A hipótese “é apenas ativar” é tecnicamente viável e merece investigação séria. Ela ainda não está provada.

---

# 2. Pergunta técnica central

A investigação começou com três observações:

1. o acabamento/faixa das portas existe fisicamente;
2. nas versões superiores essa região é iluminada;
3. no Elite a faixa não acende e não existe opção correspondente na multimídia.

A primeira hipótese natural foi:

```text
hardware presente
+
função escondida por software
=
possível desbloqueio
```

Porém havia inicialmente um problema lógico.

Uma faixa translúcida ou um guia de luz visível **não prova a existência do LED**.

A fabricante pode utilizar a mesma peça de acabamento em todas as versões e variar apenas:

```text
acabamento / light guide
        ↓
módulo LED
        ↓
chicote
        ↓
controlador
        ↓
configuração eletrônica
```

Assim, inicialmente existiam duas possibilidades igualmente sérias:

### Hipótese inicial A

```text
Faixa física       SIM
LED                SIM
Chicote            SIM
Controle           SIM
Software/coding    DESABILITADO
```

### Hipótese inicial B

```text
Faixa física       SIM
LED                NÃO
Chicote            NÃO/PARCIAL
Controle           NÃO NECESSARIAMENTE
```

O achado posterior de que **a iluminação ambiente do console central funciona no Elite** alterou substancialmente essa análise.

---

# 3. Evidência física do veículo analisado

As fotografias mostram uma faixa estreita longitudinal nas portas exatamente na região utilizada para iluminação ambiente nas versões equipadas.

Visualmente, ela apresenta geometria compatível com:

- acabamento translúcido;
- guia óptico;
- difusor de uma fonte LED colocada atrás ou em uma das extremidades.

Mas fotografia externa não permite distinguir entre:

```text
light guide + LED
```

e:

```text
light guide sem LED
```

Esse é um limite objetivo das evidências atuais.

## 3.1. O dado mais importante: a iluminação do console funciona

Posteriormente foi confirmado que o Elite analisado possui uma iluminação na lateral do túnel/console central, próximo aos controles centrais, e **essa iluminação efetivamente acende**.

Isso estabelece quatro fatos:

```text
Existe pelo menos um emissor ambient OEM
Existe alimentação elétrica dedicada
Existe lógica eletrônica para comandá-lo
O Elite não foi produzido completamente sem ambient light
```

Portanto, não faz mais sentido modelar o veículo como:

```text
ELITE = sem sistema de ambient light
```

A formulação correta passa a ser:

```text
ELITE = ambient light parcial
```

ou, mais precisamente:

```text
ambient console/painel = presente
ambient portas         = ausente ou inativo
```

---

# 4. O que a própria OMODA & JAECOO Brasil diz sobre o Elite

A fabricante brasileira publicou oficialmente que o JAECOO 7 Elite possui:

- central multimídia de 13,2";
- carregador por indução refrigerado;
- **iluminação ambiente**;
- pacote de assistências à condução.

Esse é um dado primário importante.

Logo, seria factualmente incorreto afirmar simplesmente:

> “O Elite não tem iluminação ambiente.”

A própria fabricante afirma que tem.

Entretanto, a expressão utilizada é apenas:

> iluminação ambiente

e não:

> iluminação ambiente customizável nas portas

A página não especifica zonas nem número de cores.

Isso permite uma interpretação perfeitamente compatível com o veículo observado:

```text
J7 ELITE
│
├── ambient light do console        SIM
│
└── ambient light RGB das portas    NÃO
```

Nesse caso, a iluminação funcional do console poderia ser precisamente aquilo que a fabricante está chamando de “iluminação ambiente” no Elite.

---

# 5. O documento brasileiro mais revelador: “customizável” era equipamento de versão

A ficha técnica do J7 que continua vinculada à área oficial brasileira de documentação descreve uma configuração anterior, com versões **Luxury e Prestige**.

Ela não deve ser usada como ficha específica do Elite atual.

Isso é importante porque esse documento especifica central de 14,8" nas duas versões e, portanto, corresponde a outro arranjo de equipamentos.

Entretanto, ela revela algo arquitetural muito útil.

Na tabela de equipamentos:

```text
                         Luxury      Prestige

Iluminação ambiente
customizável                -            ●
```



Portanto, a própria OMODA & JAECOO Brasil já diferenciava explicitamente:

```text
iluminação ambiente customizável
```

como uma função condicionada à versão do veículo.

Isso fortalece uma distinção que pode explicar o Elite atual:

```text
“iluminação ambiente”
        ≠ necessariamente
“iluminação ambiente customizável completa”
```

O primeiro termo aparece na divulgação atual do Elite.

O segundo já foi utilizado pela marca para diferenciar variantes.

---

# 6. Manual do proprietário: a interface completa existe no software do J7

A página oficial de manuais da OMODA & JAECOO continua oferecendo o manual e a ficha técnica do JAECOO 7.

Na página que extraímos do manual durante a investigação aparece a tela específica:

## “Luz ambiente”

com controles para:

- ON/OFF;
- seleção de cor;
- brilho;
- associação com modos de condução;
- associação com ritmo da música.

[Página do manual analisada](sandbox:/mnt/data/jaecoo_manual_render/page123.png)

A existência dessa interface demonstra que **a plataforma de software do J7 contém uma implementação rica de ambient lighting**.

Porém há uma ressalva essencial:

**o manual é compartilhado entre configurações.**

Logo, a presença dessa tela no manual **não implica que toda versão do J7 deva necessariamente exibi-la**.

O que nos interessa é outra coisa:

> o software/ecossistema do J7 já possui a interface completa. No Elite, ela simplesmente não aparece.

Isso é compatível com uma condição de variante, por exemplo:

```text
if ambientLightConfigurable:
    mostrar menu
else:
    esconder menu
```

Os nomes acima são apenas representação conceitual; não conhecemos ainda a implementação real.

---

# 7. Evidência internacional oficial: mesma central, ambient light diferente

A ficha técnica oficial australiana do J7 fornece uma evidência particularmente forte.

Ela compara:

- Core;
- Track;
- Ridge.

No documento:

```text
Colour Selectable Ambient Light
(Dashboard + Doors)

Core     NÃO
Track    SIM
Ridge    SIM
```



Agora o detalhe decisivo:

```text
Tela multimídia 13,2"

Core     SIM
Track    SIM
```

enquanto o Ridge usa 14,8".

Ou seja:

```text
CORE
13,2"      ✓
ambient    ✕

TRACK
13,2"      ✓
ambient    ✓
```

Isso demonstra diretamente que, dentro da própria família J7, **a mesma classe de head unit de 13,2" pode estar associada a veículos com ou sem iluminação ambiente de painel + portas**.

Portanto:

> a ausência do menu no Elite não decorre simplesmente de ele utilizar a central de 13,2".

A função é claramente dependente da configuração do veículo.

O documento não permite determinar se a diferença entre Core e Track é:

- apenas software;
- software + chicote;
- software + módulos LED;
- ou uma combinação.

Mas prova a existência de **feature differentiation por trim**.

---

# 8. Casos reais extremamente semelhantes

A investigação comunitária encontrou vários casos próximos ao do Elite brasileiro.

Esses relatos são evidência anedótica, não documentação de engenharia. Ainda assim, são relevantes porque descrevem exatamente o mesmo fenômeno observado.

## 8.1. J7 Urban 2024

Um proprietário de J7 Urban perguntou se seria possível ligar a iluminação ambiente original.

Ele relatou que:

- os insertos/faixas estavam presentes nas portas e no interior;
- não acendiam;
- gostaria de saber se bastaria conectar fios.

Posteriormente explicou que a sua head unit **não possuía a página de configuração da iluminação** e levantou expressamente a hipótese de que pudesse estar desabilitada por software.

Outro proprietário de Urban respondeu relatando a mesma combinação:

```text
faixa física presente
+
menu ausente
+
luz apagada
```

e também suspeitou de desativação programática.

É praticamente o mesmo caso do Elite analisado.

## 8.2. J7 Lifestyle 2025

Outro usuário relatou conseguir ver claramente a faixa no interior, mas ela não acendia; informou que lhe haviam dito que sua configuração 2025 não oferecia o equipamento e perguntou se seria possível conectá-la.

## 8.3. J7 Active AWD 2025

Em fevereiro de 2026, outro proprietário perguntou especificamente se a iluminação removida de sua versão poderia ser habilitada **programaticamente**.

## 8.4. Resultado negativo importante

Continuamos a discussão até a terceira página do tópico.

Os participantes chegam exatamente ao ponto correto:

> primeiro é necessário verificar se LED e alimentação estão realmente fisicamente presentes; caso estejam, software pode ser uma possibilidade.

Porém **não aparece uma demonstração posterior de um Urban/Active sendo convertido com sucesso para ambient lighting OEM apenas via software**.

Essa ausência é importante.

Até o momento não encontramos o equivalente a:

```text
J7 versão inferior
      ↓
ADB/coding
      ↓
Door Ambient habilitado
      ↓
4 portas funcionando
```

Portanto, afirmar que “já fizeram e funciona” seria falso com as evidências encontradas.

---

# 9. A estrutura elétrica T1EJ

Foi localizada publicamente documentação derivada do diagrama elétrico da arquitetura **T1EJ**, utilizada pelo J7.

A tabela de fusíveis apresenta algo extremamente significativo.

### RF06 — 10 A

Entre seus consumidores estão:

```text
Instrument Panel Ambient Light
Console Ambient Light
```

### RF08 — 10 A

Entre seus consumidores está:

```text
Door Ambient Lighting
```



Essa separação é provavelmente o achado técnico que melhor explica o comportamento do Elite.

## 9.1. Correspondência com o veículo real

Temos:

```text
DOCUMENTAÇÃO T1EJ             ELITE ANALISADO

Console Ambient Light   →     funciona
Door Ambient Lighting   →     não funciona
```

Ou seja, exatamente os componentes que observamos se comportando de maneira diferente já aparecem separados na arquitetura elétrica.

Isso elimina a suposição de que “ambient light” necessariamente constitui um único circuito indivisível.

O projeto foi concebido de forma que:

```text
console/painel
```

e:

```text
portas
```

possam ser tratados como ramificações distintas.

---

# 10. Limitação importante sobre RF06 e RF08

Não devemos cometer um erro metodológico.

O esquema público encontrado é de documentação T1EJ anterior e não é o **Electrical Wiring Diagram PHEV brasileiro exato** do seu veículo.

Portanto, seria incorreto afirmar neste momento:

> “No seu Elite brasileiro, o fusível RF08 é definitivamente o das portas.”

O que podemos afirmar é:

> **Na arquitetura T1EJ documentada publicamente, a engenharia diferencia explicitamente o circuito de ambient light do console/painel do circuito de ambient light das portas.**

Para descobrir numeração de fusível, pinos e topologia exata do J7 SHS/PHEV precisamos do documento específico do híbrido.

E esse documento existe.

---

# 11. Encontramos a documentação técnica exata do J7 SHS/PHEV

O portal técnico oficial OMODA/JAECOO lista para o **JAECOO 7 SHS LHD**:

```text
T1EJ PHEV LHD Electrical Wiring Diagram-20250207
```

além do manual de serviço do conjunto T1EJ PHEV e materiais de treinamento de sistemas elétricos e diagnóstico.

Esse é precisamente o documento necessário para responder definitivamente:

```text
Quem alimenta o LED da porta?
Quem fornece terra?
Qual conector?
Qual pino?
Existe módulo LED separado?
A porta recebe sinal do BCM?
Do Door Control Module?
De um Ambient Light Controller?
CAN?
LIN?
PWM?
fio dedicado?
```

O portal exige acesso/autenticação para o conteúdo integral.

Também existe oficialmente um:

```text
JAECOO 7 PHEV Disassembly Manual
```

além dos manuais de desmontagem das versões FWD/AWD.

Portanto, se chegarmos à necessidade de abrir a forração, há documentação OEM para fazer isso corretamente, em vez de desmontar por tentativa.

---

# 12. O BCM do J7 possui codificação de variante

A implementação diagnóstica do ScanDoc para:

```text
CHERY
→ JAECOO J7 (T1EJ)
→ Body Control Module (BCM)
```

expõe um parâmetro denominado:

```text
Vehicle software configuration code (188 bits)
```



E oferece uma função:

```text
Write software configuration
```



Isso é uma descoberta relevante.

O J7 efetivamente possui uma estrutura de **configuração de software/variante do BCM** acessível por diagnóstico.

### Importante

Na página estática do ScanDoc os 188 bits aparecem zerados.

Isso **não significa** que um J7 real possua 188 zeros.

A página não está conectada a um veículo, portanto os valores mostrados são apenas estado demonstrativo/default da ferramenta.

O dado relevante é a existência do campo e da rotina de gravação.

---

# 13. Testes de atuadores de iluminação no BCM

O mesmo módulo disponibiliza, segundo o ScanDoc:

```text
Backlight illumination
Red interior lighting brightness adjustment
Blue interior lighting brightness adjustment
```



Isso demonstra que o BCM possui rotinas diagnósticas relacionadas à iluminação interna e ao controle de componentes cromáticos.

Porém é necessário evitar um salto lógico:

**não sabemos se esses dois canais vermelho/azul são especificamente os LEDs das portas.**

Eles podem corresponder a:

- ambient lighting;
- iluminação de instrumentos;
- backlight de comandos;
- outro circuito RGB.

Assim, isso é evidência de capacidade de controle, não prova da porta especificamente.

Mesmo assim, esses testes fornecem uma possibilidade experimental excelente.

Se um scanner conectado ao Elite executar uma dessas rotinas e a faixa de uma porta responder:

```text
LED presente           ✓
alimentação presente   ✓
controle presente      ✓
comunicação presente   ✓
```

Nesse instante, praticamente todo o problema se deslocaria para **configuração/HMI**.

---

# 14. O experimento mais promissor: diff de BCM

Há uma maneira muito mais elegante de abordar isso do que simplesmente escrever valores aleatórios.

Usar:

```text
J7 Elite
+
J7 versão superior com iluminação funcional
```

e ler de ambos:

```text
Vehicle software configuration code
188 bits
```

Sem escrever nada.

Depois:

```text
ELITE:
101010...

SUPERIOR:
101110...
```

e fazer um diff.

Isso não revelará automaticamente qual bit corresponde à iluminação, pois as duas versões possuem outras diferenças de equipamento.

Mas permite reduzir drasticamente o espaço de busca.

O processo correto seria:

```text
1 Elite
+
vários carros superiores
+
se possível vários Elites
      ↓
comparar configurações
      ↓
localizar diferenças consistentes
      ↓
correlacionar com equipamentos
```

Quanto mais veículos, mais fácil isolar bits de variante.

**Nunca seria recomendável copiar os 188 bits inteiros de uma versão superior para o Elite**, porque o mesmo código pode definir dezenas de módulos e recursos não instalados.

---

# 15. Engenharia da própria Chery: IHU → BCM

Encontramos uma patente da **Chery Automobile Co. Ltd.**, CN109334561B, dedicada ao controle de iluminação ambiente interna.

A arquitetura descrita é essencialmente:

```text
IHU / multimídia
       │
       │ comandos
       ▼
      BCM
       │
       ▼
ambient lights
```

O documento descreve comandos de:

- ligar/desligar;
- brilho;
- seleção de cor.

E, posteriormente:

- associação com o modo de condução;
- associação com áudio/música.

Isso chama atenção porque corresponde quase exatamente às funções vistas na tela de ambient light do manual do J7:

```text
ON/OFF
cor
brilho
modo de direção
ritmo da música
```

Essa correspondência sugere forte continuidade na filosofia de engenharia da Chery.

Entretanto:

> uma patente da Chery não prova que o J7 T1EJ utilize exatamente esse circuito.

Ela demonstra uma arquitetura que a fabricante efetivamente desenvolveu e documentou.

---

# 16. Segunda arquitetura Chery: controlador dedicado

Outra patente ligada à Chery descreve uma arquitetura diferente:

```text
           Head Unit
               │
               │ CAN
               ▼
   Ambient Light Controller
               │
               │ alimentação/controle
               ▼
          RGB Ambient
               ▲
               │
              BCM
        wake / sleep
```

O documento prevê parâmetros fornecidos pela head unit através da rede CAN, controlador dedicado para as luzes e PWM para ajuste RGB.

Consequentemente, encontramos duas possibilidades documentadas pela própria engenharia Chery:

### Arquitetura A

```text
IHU → BCM → LEDs
```

### Arquitetura B

```text
IHU → CAN → Ambient Controller → LEDs
               ↑
              BCM
```

Isso é justamente o motivo pelo qual **não devemos adivinhar a topologia do J7**.

O EWD T1EJ PHEV deverá determinar qual arquitetura foi efetivamente implementada.

---

# 17. Onde o Android entra

A central multimídia ser Android é relevante porque o menu de configuração do veículo é apresentado por software executado nessa head unit.

Uma implementação plausível é:

```text
Android
   │
   └── Vehicle Settings APK
           │
           ├── lê configuração do veículo
           │
           └── recebe:
                 ambient configurable = false
                         │
                         ▼
                  esconde o menu
```

ou:

```text
Vehicle Settings
      ↓
serviço OEM Chery/JAECOO
      ↓
gateway / vehicle network
      ↓
BCM / ambient controller
```

O ponto central é:

> o Android pode decidir **se a interface aparece**, mas isso não significa necessariamente que o Android controle diretamente a alimentação das portas.

É perfeitamente possível:

```text
ADB consegue revelar menu
```

mas:

```text
BCM continua configurado como “door ambient absent”
```

e nada acender.

---

# 18. ADB no J7 não é uma hipótese puramente teórica

Há relatos concretos de proprietários de J7 acessando o menu de engenharia da head unit.

Em um caso documentado:

1. o usuário acessou o menu de engenharia;
2. entrou na área de customização;
3. alterou `ADB SWITCH` para `Open`;
4. conectou notebook;
5. estabeleceu conexão ADB com a central;
6. instalou aplicativos Android.

Outro participante descreve novamente o procedimento e confirma a existência do `ADB SWITCH` em um J7 Supreme 2024.

Isso deve ser classificado corretamente:

**evidência comunitária, não documentação oficial.**

E não garante que o firmware brasileiro do Elite utilize:

- o mesmo menu;
- a mesma senha;
- o mesmo nível de permissão;
- a mesma configuração USB.

Mas demonstra que **ADB realmente existe e foi utilizado em determinadas head units J7**.

---

# 19. O objetivo correto do ADB

Eu não começaria tentando escrever:

```text
ambient=true
```

Nem procurando uma propriedade aleatória para alterar.

O primeiro objetivo seria **reverse engineering somente leitura**.

### Coleta inicial

```bash
adb devices
adb shell getprop
adb shell pm list packages -f
adb shell service list
adb shell settings list global
adb shell settings list system
adb shell settings list secure
adb shell dumpsys activity services
```

A partir daí procuraríamos:

```text
Chery
Jaecoo
Vehicle
Car
Settings
Ambient
Light
Atmosphere
Door
Variant
Trim
```

e também termos chineses relevantes, em especial:

```text
氛围灯
```

que significa iluminação ambiente/atmosférica.

---

# 20. O APK de configurações do veículo é um alvo extremamente valioso

Uma vez identificado o aplicativo OEM responsável pelas configurações do carro, o objetivo seria analisar:

- strings;
- resources;
- XML;
- classes;
- serviços vinculados;
- Binder interfaces;
- chamadas JNI;
- bibliotecas `.so`;
- propriedades consultadas.

Queremos encontrar a condição equivalente a:

```text
isAmbientLightSupported()
```

ou:

```text
isDoorAmbientInstalled()
```

ou:

```text
vehicleVariant
```

Os nomes reais podem ser completamente diferentes.

O importante é descobrir:

```text
POR QUE
a tela aparece em uma variante
e não aparece no Elite?
```

Se encontrarmos algo como:

```text
capability = false
```

o próximo passo é seguir de onde esse valor vem.

---

# 21. Possíveis níveis da trava

Hoje conseguimos modelar o problema em quatro camadas.

## Camada 1 — HMI

```text
Menu escondido
```

Pode ser:

- resource overlay;
- feature flag;
- identificação de trim;
- resposta de algum serviço.

**ADB é extremamente útil aqui.**

---

## Camada 2 — Serviço Android/OEM

```text
VehicleSettings APK
       ↓
Chery/JAECOO service
```

A aplicação pode perguntar a um serviço proprietário se o veículo possui determinada função.

**ADB ainda é útil para mapear essa camada.**

---

## Camada 3 — configuração do veículo/BCM

```text
BCM
door ambient = absent
```

Aqui provavelmente entramos em:

- diagnóstico OEM;
- UDS;
- variant coding;
- código de configuração.

**ADB sozinho pode não resolver.**

---

## Camada 4 — hardware

```text
LED não instalado
ou
chicote não populado
```

Nesse cenário:

**nenhuma alteração de software fará a faixa emitir luz.**

---

# 22. O que o fato de o console funcionar muda

Esse dado altera substancialmente a distribuição das hipóteses.

Antes:

```text
Será que existe ambient lighting no Elite?
```

Agora:

```text
Ambient lighting existe.
Qual parte foi removida das portas?
```

Além disso, o diagrama T1EJ mostra justamente:

```text
Console Ambient Light
```

separado de:

```text
Door Ambient Lighting
```



Portanto, o comportamento observado não parece um defeito aleatório.

Ele é muito compatível com uma configuração planejada de fábrica:

```text
Elite:
console/painel   ENABLED
portas           DISABLED/NOT INSTALLED
```

---

# 23. Três cenários técnicos possíveis

## CENÁRIO A — software/coding apenas

```text
Light guide              ✓
LED door module          ✓
Door harness             ✓
Controller               ✓
Power                    ✓

HMI capability           ✕
BCM variant coding       ✕
```

### Resultado

Ativação potencialmente possível sem trocar hardware.

Esse seria o cenário ideal para nossa investigação ADB + BCM.

---

# 24. CENÁRIO B — hardware parcialmente preparado

```text
Light guide              ✓
LED module               ✓ ou parcial
Controller               ✓
Chicote/pinos            ✕
Coding                   ✕
```

### Resultado

Seria necessário:

- completar um ou alguns pinos/chicotes;
- eventualmente adicionar pequeno módulo;
- habilitar coding;
- habilitar interface.

Ainda poderia ser um retrofit OEM relativamente simples.

---

# 25. CENÁRIO C — apenas acabamento compartilhado

```text
Light guide              ✓
LED emitter              ✕
Door wiring              ✕
```

O fabricante utiliza o mesmo painel de porta para reduzir:

- número de moldes;
- complexidade logística;
- número de peças de acabamento.

A iluminação das versões superiores é obtida adicionando componentes atrás da mesma peça.

### Resultado

ADB não resolveria.

Seria necessário retrofit físico.

---

# 26. Qual cenário parece mais provável?

Não considero metodologicamente correto atribuir porcentagens sem um conjunto estatístico.

Podemos, contudo, classificar as evidências.

### Muito bem estabelecido

**O Elite possui ambient light funcional em pelo menos uma zona.**

### Muito bem estabelecido

**A arquitetura T1EJ trata console/painel e portas como circuitos distintos.**

### Muito bem estabelecido

**A função ambient completa é condicionada à versão do J7 em documentação oficial.**

### Bem sustentado

**O menu provavelmente é ocultado de acordo com a configuração da variante.**

É uma inferência consistente com:

- documentação por versões;
- ausência sistemática em trims inferiores;
- comportamento relatado por proprietários.

### Plausível, mas não demonstrado

**Os LEDs das portas do Elite podem estar fisicamente instalados.**

### Não demonstrado

**ADB sozinho consegue ativar as quatro portas.**

### Não encontrado

**Um caso documentado de J7 inferior convertido com sucesso para OEM door ambient exclusivamente por software.**

---

# 27. Evidência e nível de confiança

| Afirmação | Nível |
|---|---|
| O Elite brasileiro é anunciado oficialmente com ambient light | **Confirmado** |
| O Elite analisado possui ambient light funcional no console | **Confirmado no veículo** |
| A faixa física das portas existe | **Confirmado nas fotos** |
| O menu completo não aparece no Elite analisado | **Confirmado no veículo** |
| O J7 possui software com menu completo de ambient light | **Confirmado no manual** |
| Ambient configurável é diferenciado por versão | **Confirmado oficialmente** |
| J7 com mesma tela de 13,2" pode ter ou não door ambient | **Confirmado oficialmente** |
| T1EJ separa console ambient de door ambient | **Confirmado na documentação elétrica pública** |
| BCM do J7 possui configuração de software de 188 bits | **Confirmado no ScanDoc** |
| BCM oferece rotinas ligadas a iluminação interna | **Confirmado no ScanDoc** |
| ADB foi acessado em head units J7 | **Confirmado por relatos comunitários** |
| O menu do Elite é escondido por flag | **Provável, não provado** |
| Door ambient é controlado diretamente pelo BCM no J7 PHEV | **Desconhecido** |
| LEDs das portas estão instalados no Elite | **Desconhecido** |
| Chicote está completamente populado | **Desconhecido** |
| Função pode ser liberada somente via ADB | **Desconhecido** |

---

# 28. Uma interpretação importante da nomenclatura comercial

Existe uma possibilidade bastante plausível de que a diferenciação comercial seja intencional.

### Elite

```text
“Iluminação ambiente”
```

### Versão superior

```text
“Iluminação ambiente customizável”
```

A documentação brasileira anterior utiliza justamente o segundo termo para diferenciar versões.

Isso explicaria:

```text
Elite
└── iluminação fixa/parcial do console

Superior
└── sistema RGB configurável de painel + portas
```

Nesse cenário, o veículo não estaria necessariamente com defeito.

Ele teria sido **deliberadamente configurado com uma versão reduzida do recurso**.

---

# 29. O teste visual mais simples

Antes de qualquer scanner, vale caracterizar completamente a luz funcional do console.

Testar:

```text
ECO
NORMAL
SPORT
```

e observar se a cor muda.

Também verificar:

```text
faróis desligados
posição
farol baixo
AUTO em ambiente claro
AUTO em ambiente escuro
```

Se a luz do console mudar de cor em função do modo de condução, isso demonstrará que o Elite possui:

```text
LED multicolor
+
controle dinâmico
+
informação de drive mode
+
stack eletrônico de ambient light
```

E não apenas um LED decorativo fixo.

Proprietários de versões equipadas relatam associação das cores aos modos de condução, o que também corresponde ao comportamento previsto na engenharia Chery e ao menu do manual.

---

# 30. Plano de investigação definitivo — end to end

A sequência tecnicamente mais eficiente é a seguinte.

---

## FASE 0 — registrar baseline

Antes de modificar qualquer coisa:

1. fotografar as quatro portas;
2. filmar a iluminação do console;
3. testar Eco/Normal/Sport;
4. testar faróis/AUTO;
5. registrar versão completa do firmware da multimídia;
6. registrar VIN, ano/modelo e versão.

Objetivo:

```text
criar estado inicial reproduzível
```

---

# 31. FASE 1 — diagnóstico eletrônico somente leitura

Utilizar preferencialmente:

```text
ferramenta oficial OMODA/JAECOO
```

ou, secundariamente:

```text
ScanDoc com suporte T1EJ
```

Ler:

- identificação do BCM;
- hardware number;
- software number;
- DTCs;
- configuração de software;
- código de configuração de 188 bits.

Salvar tudo antes de qualquer escrita.

A existência dessa configuração no J7 é documentada pela própria interface ScanDoc.

---

# 32. FASE 2 — actuator tests

Executar controladamente os testes disponíveis relacionados à iluminação e observar simultaneamente:

```text
console
porta dianteira esquerda
porta dianteira direita
porta traseira esquerda
porta traseira direita
```

O ScanDoc lista testes de backlight e ajuste de iluminação interna vermelha/azul.

### Resultado possível A

Portas respondem.

**Conclusão:**

```text
LED ✓
chicote ✓
alimentação ✓
controle ✓
```

Nesse caso a hipótese de software/coding passa a ser dominante.

### Resultado possível B

Console responde, portas não.

Ainda precisamos verificar hardware.

### Resultado possível C

Nenhum ambient responde à rotina.

A rotina pode simplesmente não corresponder ao sistema ambient.

Não seria prova de ausência de hardware.

---

# 33. FASE 3 — comparação Elite x versão superior

Conectar dois veículos compatíveis:

```text
Elite
versão superior com door ambient
```

Idealmente:

- mesmo ano/modelo;
- mesmo powertrain PHEV;
- mesma região;
- firmware próximo.

Extrair os códigos de configuração.

Depois fazer:

```text
diff binário dos 188 bits
```

Não gravar.

Objetivo:

```text
identificar bits candidatos
```

O teste melhora exponencialmente com mais exemplares.

---

# 34. FASE 4 — obter o EWD exato

Documento-alvo:

```text
T1EJ PHEV LHD Electrical Wiring Diagram-20250207
```

confirmadamente listado pelo portal técnico oficial.

Pesquisar nele:

```text
Door Ambient Lighting
Ambient Lamp
Atmosphere Lamp
Front Door Ambient Lamp
Rear Door Ambient Lamp
Door Control Module
BCM
Ambient Light Controller
```

E seguir cada linha do circuito.

Queremos chegar a algo deste tipo:

```text
Fuse
  ↓
connector XX
  ↓
pin YY
  ↓
Door Ambient Lamp
  ↓
ground

controle:
BCM/DCM/controller
  ↓
CAN/LIN/PWM/hardwire
```

Nesse momento a arquitetura deixa de ser inferência.

---

# 35. FASE 5 — verificar BOM/chicote

Depois de conhecido o pinout, verificar a porta do Elite.

A pergunta deixa de ser:

> “Tem alguma fita aí?”

e passa a ser:

> “O pino específico do circuito `Door Ambient Lighting` está populado?”

### Se estiver populado:

verificar alimentação/comando.

### Se não estiver:

o hardware foi efetivamente reduzido.

Essa é uma prova muito mais robusta do que simplesmente olhar atrás da forração.

---

# 36. FASE 6 — desmontagem somente se necessária

Se for necessário acesso físico, utilizar como referência o:

```text
JAECOO 7 PHEV Disassembly Manual
```

que a própria fabricante disponibiliza em seu portal de homologação.

Objetivo:

- preservar presilhas;
- evitar dano a airbag lateral/cabeamento;
- desmontar na ordem correta;
- localizar conector e módulo exatos.

---

# 37. FASE 7 — ADB somente leitura

Paralelamente à investigação elétrica:

1. verificar se o firmware brasileiro permite menu de engenharia;
2. verificar se existe `ADB SWITCH`;
3. estabelecer conexão;
4. coletar inventário do sistema;
5. identificar APK responsável pelas configurações do veículo.

Há precedente concreto de acesso ADB em head units J7, embora em outras configurações/mercados.

---

# 38. FASE 8 — reverse engineering do Vehicle Settings

Extrair e analisar:

```text
resources.arsc
AndroidManifest.xml
classes.dex
assets
lib/*.so
```

Pesquisar por:

```text
ambient
atmosphere
light
door
rgb
variant
trim
feature
capability
vehicle config
氛围灯
```

Objetivo:

```text
descobrir a expressão real usada para
decidir se o menu aparece
```

---

# 39. FASE 9 — seguir o comando até o veículo

Uma vez localizada a implementação:

```text
UI
 ↓
método Java/Kotlin
 ↓
service/Binder/JNI
 ↓
propriedade/comando OEM
 ↓
rede veicular
 ↓
ECU
```

Essa abordagem é muito superior a tentar adivinhar frames CAN.

Estamos seguindo **o próprio software original da JAECOO** até descobrir como ele conversa com a iluminação.

---

# 40. FASE 10 — somente então avaliar ativação

Se for demonstrado que:

```text
hardware presente
+
coding diferente
```

a intervenção correta provavelmente será alterar **somente a configuração relevante**.

Nunca:

```text
copiar BCM inteiro de outro carro
```

Nunca:

```text
escrever bits aleatórios
```

Nunca:

```text
forçar frames CAN sem compreender a topologia
```

O BCM gerencia muitas funções de carroceria, portanto um coding incorreto pode afetar:

- travas;
- vidros;
- iluminação;
- limpadores;
- PEPS;
- alarmes;
- outras funções de segurança/conveniência.

---

# 41. Os quatro resultados que encerrariam a investigação

## Smoking gun nº 1

**Door ambient acende durante actuator test.**

Conclusão:

> hardware completo existe; problema é configuração/interface.

---

## Smoking gun nº 2

No EWD existe determinado pino e, no Elite, ele está fisicamente populado e apresenta sinal.

Conclusão:

> circuito da porta está presente; investigar coding/módulo.

---

## Smoking gun nº 3

Elite e versão superior diferem por bit de configuração consistentemente correlacionado à ambient light, e alterar apenas esse bit habilita o circuito.

Conclusão:

> feature gating comprovado.

---

## Smoking gun nº 4

APK contém lógica equivalente a:

```text
doorAmbientSupported == false
```

e essa informação vem da configuração do veículo.

Conclusão:

> gate da HMI comprovado e origem localizada.

---

# 42. O que refutaria a hipótese de “só ativar”

Bastaria encontrar no Elite:

```text
conector sem terminal
+
sem fio
+
sem módulo LED
```

onde o EWD prevê a lâmpada.

Nesse caso:

```text
software-only = impossível
```

Ainda seria possível um retrofit OEM, mas já seria outro problema.

---

# 43. Avaliação específica do ADB

### ADB é uma boa ideia?

**Sim.**

### ADB é a conclusão?

**Não.**

O ADB é especialmente poderoso para descobrir:

```text
por que o menu não aparece
```

Ele pode eventualmente também permitir alterar a condição.

Mas as evidências atuais apontam para uma arquitetura distribuída:

```text
Android HMI
    ↓
serviço OEM
    ↓
rede do veículo
    ↓
BCM / controlador
    ↓
door ambient
```

A própria documentação de engenharia Chery mostra exatamente esse tipo de separação entre HMI e controle efetivo da iluminação.

Portanto, **forçar a interface Android pode ser necessário, mas pode não ser suficiente**.

---

# 44. Modelo arquitetural mais consistente com tudo o que sabemos

Neste momento, eu trabalharia com o seguinte modelo:

```text
                    JAECOO 7 ELITE
                          │
                          ▼
              Head Unit Android / HMI
                          │
                  configuração de variante
                          │
           ┌──────────────┴──────────────┐
           │                             │
    interface reduzida              menu completo
      do Elite                      não exibido
           │
           ▼
      serviço OEM
           │
           ▼
     rede do veículo
           │
           ▼
 BCM / Ambient Controller / Gateway
           │
      ┌────┴─────────────┐
      │                  │
      ▼                  ▼
Console Ambient      Door Ambient
      │                  │
      ✓                  ?
 funcionando          disabled /
                     hardware absent
```

Esse modelo explica simultaneamente:

- a iluminação funcional no console;
- as faixas físicas das portas;
- a ausência do menu;
- a diferenciação por versão;
- a separação elétrica documentada;
- a existência de variant coding;
- a arquitetura de controle utilizada pela Chery.

---

# 45. Hierarquia das fontes utilizadas

## Nível 1 — fontes primárias do fabricante

**OMODA & JAECOO Brasil**

- divulgação oficial do Elite;
- ficha de equipamentos;
- manual do proprietário.



**OMODA JAECOO Australia**

- especificação oficial Core/Track/Ridge.



**OMODA/JAECOO Essential Technical Information**

- EWD T1EJ PHEV;
- Service Manual;
- material técnico.



## Nível 2 — engenharia primária Chery

Patentes da própria Chery relativas a sistemas de ambient lighting.



## Nível 3 — documentação diagnóstica independente

ScanDoc/Quantex para o BCM do J7 T1EJ.



## Nível 4 — evidência comunitária

Relatos de proprietários e procedimentos ADB.



Essa hierarquia é importante: um relato de fórum não recebe o mesmo peso de um Electrical Wiring Diagram ou documento da fabricante.

---

# 46. Conclusão final da investigação até este ponto

A hipótese inicial era:

> “Existe a faixa nas portas; talvez seja apenas desbloquear pelo Android.”

Depois de cruzar documentação e o comportamento real do veículo, podemos formular algo muito mais preciso.

### 1. O Elite realmente possui iluminação ambiente

Isso é confirmado tanto pelo carro quanto pela própria fabricante.

### 2. O sistema do Elite é aparentemente parcial

A luz do console funciona, enquanto as portas não.

### 3. A arquitetura elétrica do J7 prevê justamente essa separação

Console/painel ambient e door ambient aparecem como ramificações distintas na documentação T1EJ disponível.

### 4. A ambient light completa é claramente diferenciada por versão

Isso aparece tanto na documentação brasileira quanto na australiana.

### 5. O J7 possui mecanismo de software configuration no BCM

Há um código de 188 bits e uma rotina de gravação de configuração na implementação diagnóstica do módulo.

### 6. ADB é uma rota tecnicamente legítima

ADB foi efetivamente utilizado em head units de J7 e é uma ferramenta excelente para compreender a HMI e localizar o feature gate.

### 7. Mas ainda falta uma única prova física

Não sabemos se o Elite brasileiro possui:

```text
Door LED modules      ?
Door wiring           ?
Door connector pins   ?
```

Esse é o divisor entre:

```text
“desbloqueio”
```

e:

```text
“retrofit”
```

---

# 47. Diagnóstico atual em uma frase

> **O conjunto das evidências indica que o JAECOO 7 Elite possui uma implementação parcial do sistema OEM de iluminação ambiente e que a função completa das portas é deliberadamente diferenciada por configuração de versão; há uma possibilidade tecnicamente real de os canais das portas estarem desabilitados por HMI/variant coding, mas ainda é necessário confirmar no EWD PHEV e no chicote/BOM se os módulos LED das portas foram efetivamente instalados.**

---

# 48. Próximo passo de maior valor técnico

Se fosse necessário escolher **um único experimento antes de qualquer modificação**, seria:

```text
ELITE
     +
versão superior PHEV com door ambient funcionando
     ↓
scanner
     ↓
ler BCM dos dois
     ↓
salvar configuração de 188 bits
     ↓
executar testes de iluminação
     ↓
fazer diff
```

Em paralelo, o documento prioritário é:

```text
T1EJ PHEV LHD Electrical Wiring Diagram-20250207
```



Somente depois disso eu partiria para alteração via ADB ou coding.

---

# 49. Atualização — recon ADB no head unit (20/08/2026)

Foi feita uma investigação adicional diretamente no head unit conectado via ADB, em modo somente leitura. Nenhum valor foi escrito no veículo e nenhum teste de atuador foi executado.

## 49.1. Serviços automotivos encontrados

O Android expõe os seguintes serviços relacionados à arquitetura veicular:

```text
com.desaysv.ivi.vds.cabinlan.service.CabinLanService
com.desaysv.ivi.vds.vehicle.service.VehicleService
com.desaysv.ivi.vds.vdev.service.VehicleDevice
lights (android.hardware.lights.ILightsManager)
car_service (android.car.ICar)
```

Isso confirma que a HMI possui uma camada própria para comunicação com a cabin LAN/rede veicular, além do serviço genérico de iluminação do Android.

## 49.2. Propriedades VHAL relacionadas a iluminação

O `car_service` registra uma propriedade específica para ambient light:

```text
SV_UART_AMBIENT_LIGHT       0x2141d011
```

Ela aparece com `access:0x3` (leitura e escrita declaradas) e `changeMode:0x1` (notificação por alteração). Também foram encontrados:

```text
SV_SET_BACKLIGHT
SV_CONTROL_BACKLIGHT_SWITCH
SV_DISPATCH_BACKLIGHT_DATA
SV_UART_TSC_BACKLIGHT
HEADLIGHTS_STATE / HEADLIGHTS_SWITCH
FOG_LIGHTS_STATE / FOG_LIGHTS_SWITCH
HAZARD_LIGHTS_STATE / HAZARD_LIGHTS_SWITCH
```

`SV_UART_AMBIENT_LIGHT` é diferente dos canais de backlight da tela e dos comandos dos faróis; portanto, representa um caminho dedicado à iluminação ambiente interna.

## 49.3. Tela OEM de iluminação confirmada

O pacote privilegiado nativo `com.desaysv.setting` registra as duas ações abaixo:

```text
com.desaysv.vehiclesetting.ACTION_ATMOSPHERE_LIGHT_SETTING
com.desaysv.vehiclesetting.ACTION_LIGHT_SETTING
```

As duas ações resolvem para:

```text
com.desaysv.setting/.ui.activity.SettingActivity
```

O APK contém referências a funções de brilho, cor, zonas e modos, incluindo:

```text
CABIN_LIGHTS_STATE / CABIN_LIGHTS_SWITCH
VEHICLE_AMBIENT_LIGHT_BRIGHTNESS
VEHICLE_AMBIENT_LIGHT_COLOR
VEHICLE_AMBIENT_LIGHT_ZONE_CONTROL
VEHICLE_AMBIENT_LIGHT_RELATE_DRIVE_MODE
VEHICLE_ATMOSPHERE_LIGHT_WITH_BREATH_MODE
VEHICLE_ATMOSPHERE_LIGHT_WITH_MUSIC_RHYTHM
VEHICLE_DYNAMIC_ATMOSPHERE_LIGHT
```

Também existem rotinas nomeadas para consultar a configuração (`configInteriorAtmosphereLight`, `inquireAtmosphereLightConfigData`) e ajustar a iluminação por níveis.

## 49.4. Feature gates por configuração do veículo

O mesmo APK contém identificadores separados para a presença/configuração de áreas diferentes:

```text
ID_CAR_CONFIG_INTERIOR_ATMOSPHERE_LIGHT_SYSTEM
ID_CAR_CONFIG_INTERIOR_ATMOSPHERE_LIGHT_TYPE
ID_CAR_CONFIG_REAR_ATMOSPHERE_LIGHT
ID_CAR_CONFIG_SUNROOF_ATMOSPHERE_LAMP
ID_CAR_CONFIG_INTERIOR_LIGHT
ID_CAR_AMBIENT_LIGHT
ID_CAR_AMBIENT_LIGHT_FEEDBACK
```

Isso reforça a hipótese de diferenciação por variante: a tela e o software suportam mais recursos do que necessariamente estão liberados no acabamento atual. As strings do APK, isoladamente, não provam que cada zona esteja instalada no Elite, mas agora existe evidência simultânea no HMI, no VHAL e na camada de configuração.

## 49.5. Limitação do ADB em build de produção

Tentou-se somente ler a propriedade ambiente com:

```text
cmd car_service get-property 0x2141d011
```

O comando foi recusado pelo próprio Android com `SecurityException`, pois os comandos de inspeção do `car_service` exigem build `userdebug/eng`. Portanto, o shell ADB comum não consegue obter o valor atual diretamente por essa interface; não foi feito nenhum contorno de permissões.

## 49.6. Conclusão atualizada

Há uma rota acionável e oficial de software: a tela OEM de `Atmosphere Light`. Há também um canal VHAL dedicado (`SV_UART_AMBIENT_LIGHT`) e controles internos para brilho, cor, zonas e modos. O que ainda não está provado é se o Elite possui os módulos LED/chicote das portas e se os respectivos feature gates estão ativos.

O próximo experimento seguro é abrir apenas a tela oficial de iluminação e ler sua árvore de interface, sem alterar controles. A ativação direta via shell não deve ser tentada: além de o build bloquear a leitura, os valores do VHAL não estão documentados e poderiam comandar módulos indevidos.

## 49.7. Síntese

A investigação já ultrapassou o estágio de “parece que tem um LED escondido”. Hoje existe uma cadeia coerente de evidências apontando para **feature differentiation real dentro da arquitetura elétrica e eletrônica do J7**. O ponto ainda aberto é saber exatamente **em qual camada a JAECOO cortou as portas do Elite: interface Android, codificação do BCM/controlador, chicote ou emissor LED**.
---

# 50. Atualização — investigação externa após o recon ADB (20/08/2026)

Após a identificação, no próprio head unit do JAECOO 7 Elite, dos serviços DesaySV, da Activity OEM de iluminação ambiente, dos feature gates e da propriedade VHAL `SV_UART_AMBIENT_LIGHT`, foi realizada uma nova investigação externa usando os identificadores técnicos exatos encontrados no veículo.

Essa pesquisa trouxe evidências adicionais relevantes e permitiu reconstruir parte importante da camada de middleware entre a interface Android e a eletrônica do carro.

## 50.1. Módulo lógico próprio de Ambient Light no DesaySV/VDBus

Foi localizado o projeto open source **MapControl**, voltado a head units Chery/OMODA baseadas em DesaySV.

No código, a classe:

```text
com.desaysv.ivi.vdb.event.id.carinfo.VDEventCarInfo
```

define explicitamente:

```java
MODULE_CAR_SETTING   = 327681
MODULE_AMBIENT_LIGHT = 327699
```

Isso demonstra que, no middleware DesaySV, **Ambient Light é tratado como um módulo lógico próprio dentro do CarInfo/VDBus**, separado do módulo genérico de configurações do veículo.

Também existe:

```java
public class AmbientLightID {
    public static final int ID_AMBIENT_LIGHT = 0;
}
```

### Fonte

- https://github.com/berkpekatik/MapControl/blob/main/app/src/main/java/com/desaysv/ivi/vdb/event/id/carinfo/VDEventCarInfo.java
- https://github.com/berkpekatik/MapControl/blob/main/app/src/main/java/com/desaysv/ivi/extra/project/carinfo/AmbientLightID.java

---

## 50.2. IDs numéricos dos controles de iluminação ambiente

No mesmo stack DesaySV, a classe `CarSettingID` define:

```text
ID_CAR_AMBIENT_LIGHT                    = 7
ID_CAR_MUSIC_RHYTHM                     = 8
ID_CAR_AMBIENT_LIGHT_COLOR              = 11
ID_CAR_AMBIENT_LIGHT_BRIGHTNESS         = 12
ID_CAR_AMBIENT_LIGHT_RELATE_DRIVE_MODE  = 55
ID_CAR_AMBIENT_LIGHT_FEEDBACK           = 134
ID_CAR_RGB_COLOR                        = 192
```

Esses identificadores correspondem conceitualmente às funções já encontradas no APK OEM do Elite:

```text
VEHICLE_AMBIENT_LIGHT_BRIGHTNESS
VEHICLE_AMBIENT_LIGHT_COLOR
VEHICLE_AMBIENT_LIGHT_RELATE_DRIVE_MODE
VEHICLE_ATMOSPHERE_LIGHT_WITH_MUSIC_RHYTHM
VEHICLE_DYNAMIC_ATMOSPHERE_LIGHT
```

Essa correspondência reforça que o software do Elite e o middleware DesaySV encontrado publicamente pertencem à mesma família arquitetural.

### Fonte

- https://github.com/berkpekatik/MapControl/blob/main/app/src/main/java/com/desaysv/ivi/extra/project/carinfo/CarSettingID.java

---

## 50.3. Como a API OEM consulta o veículo

O código público de `CarInfoProxy` mostra que a leitura de parâmetros do veículo é realizada por meio do VDBus.

Estrutura conceitual:

```java
Bundle bundle = new Bundle();
bundle.putInt(Constants.CMD_ID, itemId);

VDEvent result =
    VDBus.getDefault().getOnce(
        new VDEvent(moduleId, bundle)
    );

int[] values =
    result.getPayload().getIntArray(Constants.VALUE);
```

A mesma classe possui também rotas de escrita por `VDBus.getDefault().set(...)`, porém **não há necessidade de utilizá-las nesta fase**.

Isso é especialmente importante porque o shell ADB comum do J7 não conseguiu ler diretamente a propriedade pelo:

```text
cmd car_service get-property
```

devido à restrição da build `user`.

A API VDBus oferece, portanto, um caminho alternativo para consulta usando a mesma infraestrutura OEM utilizada pelos aplicativos DesaySV.

### Fonte

- https://github.com/berkpekatik/MapControl/blob/main/app/src/main/java/com/desaysv/ivi/extra/project/carinfo/proxy/CarInfoProxy.java

---

## 50.4. Correspondência dos serviços DesaySV

O código público do `VDServiceDef` lista, entre outros:

```text
com.desaysv.ivi.vds.cabinlan.service.CabinLanService
com.desaysv.ivi.vds.vehicle.service.VehicleService
com.desaysv.ivi.vds.vdev.service.VehicleDevice
com.desaysv.ivi.vds.carinfo.service.CarInfoService
```

Os três primeiros já foram encontrados diretamente no head unit do Elite via ADB.

Essa correspondência reduz significativamente a incerteza sobre compatibilidade arquitetural e torna o `CarInfoService` um alvo prioritário de inspeção no veículo.

### Fonte

- https://github.com/berkpekatik/MapControl/blob/main/app/src/main/java/com/desaysv/ivi/vdb/client/bind/VDServiceDef.java

---

## 50.5. Descoberta do mecanismo EOL de configuração de variante

O mesmo projeto contém um leitor específico de configuração OEM/EOL:

```text
OemEolConfigReader
```

Ele consulta blocos de configuração como:

```text
vehicle.persist.project.ext.configs3
vehicle.persist.project.ext.configs5
vehicle.persist.combo.config
```

e os utiliza para identificar:

```text
modelCode
powerType
country/region
TBox network type
face/style
brand
PHEV / EV / ICE
```

Isso é uma descoberta de grande relevância.

Demonstra concretamente que o head unit recebe **blocos binários de configuração de fábrica/variante** e que os aplicativos DesaySV usam esses blocos para alterar seu comportamento.

Essa arquitetura é compatível com os feature gates encontrados no APK do Elite:

```text
ID_CAR_CONFIG_INTERIOR_ATMOSPHERE_LIGHT_SYSTEM
ID_CAR_CONFIG_INTERIOR_ATMOSPHERE_LIGHT_TYPE
ID_CAR_CONFIG_REAR_ATMOSPHERE_LIGHT
ID_CAR_CONFIG_SUNROOF_ATMOSPHERE_LAMP
ID_CAR_CONFIG_INTERIOR_LIGHT
ID_CAR_AMBIENT_LIGHT
ID_CAR_AMBIENT_LIGHT_FEEDBACK
```

### Fonte

- https://github.com/berkpekatik/MapControl/blob/main/app/src/main/java/com/mapcontrol/vehicle/material/OemEolConfigReader.java

---

## 50.6. Eventos de configuração do VehicleDevice

A classe `VDEventVehicleDevice` contém eventos como:

```text
PROJECT_CONFIGS                        = 917507
PROJECT_EXT_CONFIGS                    = 917508
PROJECT_RESERVE_CONFIGS                = 917510
PROJECT_VEHICLE_PROPERTY_CONFIG_UPDATE = 918905
```

O `OemEolConfigReader` usa `PROJECT_RESERVE_CONFIGS` para buscar valores de configuração.

Isso reforça que a configuração do veículo não é apenas uma propriedade estática do Android: existe uma camada própria do VehicleDevice para disponibilizar e atualizar dados de projeto/configuração.

### Fonte

- https://github.com/berkpekatik/MapControl/blob/main/app/src/main/java/com/desaysv/ivi/vdb/event/id/device/VDEventVehicleDevice.java

---

## 50.7. Interpretação técnica de `SV_UART_AMBIENT_LIGHT`

No Elite foi encontrado:

```text
SV_UART_AMBIENT_LIGHT = 0x2141d011
```

Pela estrutura padrão de IDs do Android Automotive VHAL:

```text
0x20000000 → VENDOR
0x01000000 → GLOBAL
0x00410000 → INT32_VEC
0x0000d011 → ID OEM
```

Portanto, a propriedade é compatível com:

```text
VENDOR
GLOBAL
INT32_VEC
```

Ou seja, não parece ser um simples:

```text
ambient = true/false
```

e sim uma propriedade capaz de transportar **um vetor de inteiros**.

Isso é compatível com uma estrutura que possa transportar vários parâmetros, por exemplo:

```text
estado
brilho
cor
zona
modo
...
```

A ordem e a semântica real dos campos **não são conhecidas**.

Nenhuma escrita direta deve ser feita enquanto esse payload não estiver documentado ou decodificado experimentalmente.

### Referência técnica VHAL

- https://source.android.com/docs/automotive/vhal/property-configuration

---

## 50.8. O que a pesquisa externa não encontrou

Foram realizadas buscas pelos identificadores exatos:

```text
SV_UART_AMBIENT_LIGHT
0x2141d011
ID_CAR_CONFIG_INTERIOR_ATMOSPHERE_LIGHT_SYSTEM
ID_CAR_CONFIG_INTERIOR_ATMOSPHERE_LIGHT_TYPE
VEHICLE_AMBIENT_LIGHT_ZONE_CONTROL
```

Não foi localizada documentação pública indexada explicando:

- o payload de `SV_UART_AMBIENT_LIGHT`;
- os valores possíveis dos feature gates;
- o bit exato de ambient light dentro dos blocos EOL;
- um caso documentado de J7 Elite/Urban/Active com door ambient OEM ativado apenas via software.

Neste ponto, a investigação parece estar próxima da fronteira do material público disponível.

---

# 51. Atualização — evidência do menu ocultado por variante

Foi observado diretamente que, na versão topo de linha do J7, existe no menu de configurações uma entrada para acessar a iluminação ambiente e configurar:

```text
cor
brilho
modos
efeitos
```

No Elite analisado, **essa entrada do menu simplesmente não aparece**.

Ao mesmo tempo, o recon ADB demonstrou que o Elite continua possuindo:

```text
com.desaysv.vehiclesetting.ACTION_ATMOSPHERE_LIGHT_SETTING
com.desaysv.vehiclesetting.ACTION_LIGHT_SETTING
```

ambas resolvendo para:

```text
com.desaysv.setting/.ui.activity.SettingActivity
```

e o APK contém toda a infraestrutura de ambient light.

Isso é fortemente compatível com:

```text
mesmo APK / mesma Activity
          │
          ▼
consulta configuração do veículo
          │
     ┌────┴────┐
     │         │
 topo        Elite
     │         │
full        basic/off
     │         │
mostra       esconde
botão        botão
```

A hipótese de **feature gating por configuração de variante** tornou-se significativamente mais forte.

---

# 52. Próximos testes — somente software e somente leitura inicialmente

O escopo da investigação foi deliberadamente limitado.

**Não será desmontada nenhuma porta.**
**Não será feito retrofit físico.**
**Não serão adicionados LEDs, chicotes ou módulos.**

O projeto só prossegue se houver um caminho de ativação OEM/software-only.

## 52.1. Dump EOL do Elite

Primeiro teste recomendado:

```bash
adb shell getprop vehicle.persist.project.ext.configs3
adb shell getprop vehicle.persist.project.ext.configs5
adb shell getprop vehicle.persist.combo.config
```

Também:

```bash
adb shell getprop | grep -Ei "vehicle.persist|project.*config|combo.config|eol"
```

Objetivo:

```text
obter a configuração EOL bruta do Elite
```

sem escrever nada.

---

## 52.2. Abrir a Activity OEM escondida

Executar:

```bash
adb shell am start -W \
  -a com.desaysv.vehiclesetting.ACTION_ATMOSPHERE_LIGHT_SETTING \
  -n com.desaysv.setting/.ui.activity.SettingActivity
```

Em seguida:

```bash
adb shell dumpsys window | grep -E "mCurrentFocus|mFocusedApp"
```

e:

```bash
adb shell uiautomator dump /sdcard/atmosphere.xml
adb pull /sdcard/atmosphere.xml
```

Objetivo:

- verificar se a página completa abre;
- verificar se abre parcialmente;
- verificar se algum recurso aparece desabilitado;
- verificar se a Activity fecha por feature gate.

---

## 52.3. Logcat durante a abertura da Activity

Antes:

```bash
adb logcat -c
```

Abrir a Activity.

Depois:

```bash
adb logcat -d | grep -Ei \
"atmosphere|ambient|desaysv|car.config|vehicle|eol"
```

Objetivo:

buscar mensagens como:

```text
AtmosphereLightConfig
type=
rear=
unsupported
feature=
EolConfig
```

que possam revelar o gate utilizado pelo software.

---

## 52.4. Probe passivo CarInfo/VDBus

Caso necessário, desenvolver um APK mínimo somente leitura utilizando a implementação pública do VDBus.

Consultar:

```text
MODULE_CAR_SETTING = 327681

7    ID_CAR_AMBIENT_LIGHT
8    ID_CAR_MUSIC_RHYTHM
11   ID_CAR_AMBIENT_LIGHT_COLOR
12   ID_CAR_AMBIENT_LIGHT_BRIGHTNESS
55   ID_CAR_AMBIENT_LIGHT_RELATE_DRIVE_MODE
134  ID_CAR_AMBIENT_LIGHT_FEEDBACK
192  ID_CAR_RGB_COLOR
```

e:

```text
MODULE_AMBIENT_LIGHT = 327699
ID_AMBIENT_LIGHT     = 0
```

Sem utilizar:

```text
VDBus.set(...)
sendItemValue(...)
```

Apenas:

```text
getOnce()
getItemValues()
subscribe()
```

Objetivo:

- observar o payload real;
- correlacionar mudanças com ECO/NORMAL/SPORT;
- correlacionar mudanças com faróis;
- correlacionar mudanças com o console ambient já funcional.

---

# 53. Experimento de maior valor — Elite × topo de linha

Se houver acesso ADB temporário a uma versão topo de linha PHEV compatível, comparar:

```text
Elite                         Topo de linha

configs3                ↔     configs3
configs5                ↔     configs5
combo.config            ↔     combo.config

CarSetting/7            ↔     CarSetting/7
CarSetting/11           ↔     CarSetting/11
CarSetting/12           ↔     CarSetting/12
CarSetting/55           ↔     CarSetting/55
CarSetting/134          ↔     CarSetting/134
CarSetting/192          ↔     CarSetting/192

Ambient module/0        ↔     Ambient module/0
```

Esse diff poderá mostrar se:

```text
mesmo software
+
configuração diferente
=
menu/door ambient diferente
```

Se isso ocorrer, a hipótese de ativação por configuração/software será muito fortalecida.

---

# 54. Critério final de decisão

A investigação só prossegue se os dados indicarem um caminho software-only.

## Prosseguir

Se for encontrado algo equivalente a:

```text
Elite:
ambient type = basic
door zone    = disabled

Topo:
ambient type = full
door zone    = enabled
```

e houver uma forma segura, reversível e específica de alterar apenas esse gate.

## Encerrar

Se os dados indicarem que:

```text
software envia corretamente os comandos
+
door ambient permanece ausente
```

e a explicação provável passar a ser hardware/chicote/LED ausente.

Nesse caso:

```text
sem desmontagem
sem retrofit
sem adaptação
```

e a investigação é encerrada.

---

# 55. Estado consolidado da investigação em 20/08/2026

```text
JAECOO 7 ELITE

Head Unit OEM                    ✓
ADB funcional                    ✓
Activity Atmosphere Light        ✓
software RGB completo            ✓
controle por zonas               ✓
integração drive mode            ✓
integração music rhythm          ✓

MODULE_CAR_SETTING               ✓
MODULE_AMBIENT_LIGHT             ✓
IDs numéricos CarInfo            ✓
VDBus API                        ✓
CarInfoService                   compatível com o stack
VehicleService                   ✓
CabinLanService                  ✓
VehicleDevice                    ✓

VHAL ambient dedicado            ✓
SV_UART_AMBIENT_LIGHT            ✓
tipo INT32_VEC                   forte evidência

mecanismo EOL                    ✓
feature gates por tipo/zona      ✓

console ambient físico           ✓
light guide das portas           ✓

EOL real do Elite                ?
payload CarInfo real do Elite    ?
payload Ambient module/0         ?
EOL de versão topo               ?
payload da versão topo           ?
hardware das portas              ?  ← não será investigado fisicamente
```

## Síntese final

A investigação evoluiu de:

```text
“Talvez exista um LED escondido”
```

para:

```text
“O Elite possui o stack completo de software para ambient light,
incluindo UI, feature gates, VDBus, CarInfo, EOL e VHAL.
Agora é necessário descobrir se a configuração de variante está
simplesmente limitando a função e se o hardware já responde aos
comandos OEM existentes.”
```

A regra final do projeto é:

> **desbloqueio OEM/software-only ou nada.**

Nenhuma desmontagem física será realizada.
