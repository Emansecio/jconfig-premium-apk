.class public final Ltp0;
.super Ljava/lang/Object;
.source "r8-map-id-bc1e7422ceb07ae3b46b0e518de81d5cbccad36ad395d4518cecde7eac7cb7ee"


# static fields
.field public static final c:Ljava/util/Base64$Decoder;


# instance fields
.field public final a:Lwj1;

.field public final b:Ljava/util/Map;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 1
    invoke-static {}, Ljava/util/Base64;->getUrlDecoder()Ljava/util/Base64$Decoder;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    sput-object v0, Ltp0;->c:Ljava/util/Base64$Decoder;

    .line 6
    .line 7
    return-void
.end method

.method public constructor <init>(Ljava/util/Map;)V
    .locals 2

    .line 1
    new-instance v0, Lm60;

    .line 2
    .line 3
    const/16 v1, 0x17

    .line 4
    .line 5
    invoke-direct {v0, v1}, Lm60;-><init>(I)V

    .line 6
    .line 7
    .line 8
    invoke-static {v0}, Lfy;->j(Lc21;)Lqk1;

    .line 9
    .line 10
    .line 11
    move-result-object v0

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 13
    .line 14
    .line 15
    iput-object v0, p0, Ltp0;->a:Lwj1;

    .line 16
    .line 17
    invoke-static {p1}, Lqy1;->Y(Ljava/util/Map;)Ljava/util/Map;

    .line 18
    .line 19
    .line 20
    move-result-object p1

    .line 21
    iput-object p1, p0, Ltp0;->b:Ljava/util/Map;

    .line 22
    .line 23
    return-void
.end method


# virtual methods
.method public final a(Ljava/lang/String;)Lyx3;
    .locals 10

    const-string v1, "PREMIUM"
    invoke-static {v1}, Lso3;->valueOf(Ljava/lang/String;)Lso3;
    move-result-object v1

    const-string v2, "jconfig-premium-bypass"

    new-instance v3, Ljava/util/HashSet;
    invoke-direct {v3}, Ljava/util/HashSet;-><init>()V

    const-string v7, "EXTRA_PROFILES"
    invoke-virtual {v3, v7}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    const-string v7, "ADAS"
    invoke-virtual {v3, v7}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    const-string v7, "AUTO_PROFILE_APPLICATION"
    invoke-virtual {v3, v7}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    const-string v7, "PHEV"
    invoke-virtual {v3, v7}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    const-string v7, "CLUSTER_PROJECTION"
    invoke-virtual {v3, v7}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    const-string v7, "MULTITASKING"
    invoke-virtual {v3, v7}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    const-string v7, "CONFIGURABLE_GESTURES"
    invoke-virtual {v3, v7}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    const-string v7, "STEERING_WHEEL"
    invoke-virtual {v3, v7}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z
    const-string v7, "CLIMATE_COMFORT"
    invoke-virtual {v3, v7}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    const-wide v8, 0x178c0000000L
    new-instance v6, Ljava/lang/Long;
    invoke-direct {v6, v8, v9}, Ljava/lang/Long;-><init>(J)V

    const-wide v4, 0x17850000000L

    new-instance v0, Lyx3;
    invoke-direct/range {v0 .. v6}, Lyx3;-><init>(Lso3;Ljava/lang/String;Ljava/util/Set;JLjava/lang/Long;)V

    return-object v0
.end method
