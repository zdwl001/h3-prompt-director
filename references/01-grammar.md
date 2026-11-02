# 01 语法底线（本地 ComfyUI Ref2VA 执行版）

来源：MiniMax-AI/MiniMax-H3 官方 skill 三文档（SKILL.md / base-en.txt / ref-en.txt，2026-09-18 拉取，库内原文为准）＋ ComfyUI 官方节点文档 ＋ 社区实证。本板块只写硬约束与本地差异，创作偏好见各创作板块。

## 1. 模式与模型对应

| 模式 | 本地模型 | 本流水线是否使用 |
|---|---|---|
| T2VA / I2VA / FL2VA / L2VA | fl2va | 否（仅当某段明确不需要任何参考时可选 T2VA） |
| Ref2VA（R2V） | ref2va | **是，默认**。全部段走 R2V 参考工作流 |

## 2. Ref2VA 六段结构与顺序（不可调换）

1. `subject_definitions` — 定义参考内容与标签
2. `summary` — 方括号任务类型前缀 + 一段英文概述，如 `[reference generation] ...`；组合用 ` + ` 连接不重复
3. `retention_analysis` — 每个标签一行，关系标记限：`fully_preserved` / `partially_preserved` / `attribute_transfer` / `weak_reference`（音频限 `fully_copy` / `partially_copy` / `reference` / `weak_reference`）
4. `detailed_description` — 主体，见第 3、4 节
5. `overall_soundscape` — 见第 5 节
6. `non_diegetic_music` — 见第 5 节

- **模式 B 段的 summary 前缀**：引导通道（上一段末 22 帧）不是 `<Video N>` 参考资产；模式 B 段前缀统一用 `[reference generation]`（有其他参考时组合）；`video continuation` 仅当存在真实 `<Video N>` 参考视频时使用。
**正文语言默认中文**（项目开关，可切回官方英文）：叙述性正文（summary 段落、retention 描述、detailed_description、音景、配乐）用中文；仅 `<d>` 内对白/歌词与画面可见文字保留原语言。**以下固定 token 永远英文**：字段名与六段段名、`[Shot N]`、`At MM:SS.mmm`、`<Subject N>`/`<Picture N>`/`<Video N>`/`<Audio N>`、`<d>[语言]` 标签、`<scenetrans>`、`<cutoff>`、retention 关系标记、summary 任务类型前缀、`N/A`。

## 3. 标签体系与双通道规则（本地硬约束）

- 四类标签：`<Subject N>`（可复用可见内容）／`<Picture N>`（作帧或构图锚点的具体图像）／`<Video N>`（整片级视频关系）／`<Audio N>`（音频信号）。
- **编号 = 参考输入的连接顺序**，跨六段含义不变。
- **双通道**：AddGuide 引导通道的图/片段经 vae 编码进 conditioning，节点输出仅 positive，**不进入参考标签序列**——提示词中不得为其写 `<Picture N>`。引导的连续性用自然语言在开场描述中与像素锚点互证。
- `<Subject N>` 与文件非一一对应：一个角色可合并多来源（面部自图1、服装自图2）。
- 参考上限：9 图 / 3 视频 / 3 音频（每段）。
- **参考图的定义位置（依官方 ref-en §2.2，强制）**：`<Picture N>` **独立条目仅限帧/构图锚点**（首帧/尾帧/关键帧/构图锚点，如"<Picture 1> 是 [Shot 1] 的首帧"）；**仅用于定义角色/场景/道具/风格的图不单独立条**，源图在对应 `<Subject N>` 定义句内引用。
  - 正确写法（场景）：`<Subject 2> 是这座院落的环境，形制取自 <Picture 2>；<Picture 2> 是同一环境多角度视图的 12 格参考网格，各格为同一地点的不同区域与视角，非连续镜头或分镜，12 格合起来构成完整全景，其中不含任何可移动物体。`
  - 正确写法（道具）：`<Subject 3> 是竹匾道具，形制与编纹取自 <Picture 3>；它出现在 [Shot 6]、[Shot 7]，由 <Subject 1> 双手端持。`
  - 反例（禁止）：把场景图/道具图写成独立的 `<Picture N>` 条目。

## 4. detailed_description 写法

- 生成任务通常 **400–700 中文字**（经验默认，可调；对应官方英文 350–500 词）；对白密集段以说满对白时间线优先，不机械凑字。
- 风格开场：`[Shot 1]` 之前用 1–2 句（中文默认）定风格（如：写实电影感、文学化 MV 风格、柔光低饱和……）。
- 镜头格式：`[Shot 1]` 无时间戳；后续 `[Shot N] At MM:SS.mmm, ...`，切点严格递增且在时长内。切镜动词限（中文默认）：镜头切至／画面切到／镜头过渡到／画面转为／镜头换到（用户明确要求才可用溶解/淡入淡出/擦除）。
- 运镜三维度：类型 + 幅度（with small/large amplitude）+ 速度（at slow/fast speed），后两者有意义才写；**写成镜内自然动作句，禁止 token 堆叠**（❌ `Truck Left + Pan Right`）。类型词表：Zoom In/Out、Push In/Pull Out、Pan Left/Right、Truck Left/Right、Tilt Up/Down、Pedestal Up/Down、Arc Shot、Tracking Shot、Static Shot、Shake Slightly/Strongly、POV、Roll Clockwise/Counterclockwise。
- 说话人：稳定 ID `(S1)`、`(S2)`…，合说用 `(S1,S2)`。**编号按段内发声顺序独立分配**，跨段不复用同一编号指代同一角色；交付物每段附 角色→(Sx) 映射表（**给用户看的参考，不属于提示词**）。
  - **声明机制（官方，无独立声明区块）**：官方六段结构中没有单独的说话人映射声明——声明在每个说话人的**首次发声句**内完成：身份描述（类型/年龄/性别/是否出镜/音高/音色/语速/口音）+ (Sx)；旁白等无画面说话人用**稳定声音描述** + (S1)（例："一个清缓温和的中年女声叙述者 (S1) 以画外音说道：……"）；引用参考的主体说话写 `<Subject N> (Sx)`。
  - **之后复用不重声明**：同一说话人后续每次发声复用同一 (Sx)，不重复身份描述。
  - **两条禁令**：`retention_analysis` 中禁止写 (Sx)；`<Audio N>` 绑定说话人时复用同一 (Sx)、不得另编编号。
  - **音色参考音频（音色统一）**：说话人挂音色参考音频时，subject_definitions 定义 `<Audio N> 是 <Subject X> (Sx) 的音色参考。`；summary 前缀加 `audio reference`（如 `[reference generation + audio reference]`）；retention_analysis 写 `<Audio N>: reference - 仅引用音色，不复制原始信号。`；detailed_description 发声处写"以 <Audio N> 参考的音色说道"。**参考音频的原始对白不得带入目标视频**（只引用音色）。同一角色全片用同一条音色参考音频（细则见 02§5）。
- 对白：`<d>[语言] 原文</d>`，逐字保留不翻译不改写；标识语、动作、语气写在 `<d>` 外。
  - **对白完整句式模板（强制，禁止自造）**：`<说话人标签> (<Sx>) + 说话动词 + <d>[语言] 原文</d>`。说话动词限：说/喊道/低声说/笑着说/问。`<d>` 必须紧跟说话动词之后、独占一句，**禁止把 `<d>` 嵌进"口型与…同步""声波…"等描述句**。
  - 示例：`<Subject 2> (S1) 声音爽利、尾音上扬，说道：<d>[zh] 都出来浣衣了，还簪着。</d>`
  - 反例（禁止）：`她的口型与 <d>[zh] …</d> 的声波同步`（把标签嵌进描述句）
- 画外音：中文固定句式"**以画外音说道**"（英文模式用 `says in an off-screen voiceover`），且紧随其后声明嘴唇闭合（中文：此时他的嘴唇完全闭合）。
- 跨切对白：连接点两侧用 `<scenetrans>` 并声明音频跨切延续；被片尾截断用 `<cutoff>`。连续性声明（中文默认）：无缝延续跨过切点／不间断延续进下一镜头／从上一镜头延续／转场中持续可闻。
- 画面可见文字：英文双引号逐字保留（如 a red neon sign reading "营业中"）。
- 参考标签在镜头内的使用：重要 `<Subject N>` 首次清晰出现时描述其参考特征+画面位置+当前动作；帧锚点用自然语句（the shot begins from <Picture 1> / the shot ends on <Picture 3>）。

## 5. 声音两节

- `overall_soundscape`：1–4 句（中文默认）一段话，全片环境声/物理动作声/非语言人声；不与 detailed_description 重复对白；仅用户要求全静音才写 N/A。
- `non_diegetic_music`：1–3 句，写配器/速度/节奏/动态变化，**禁用抽象情绪词**；无则 N/A。角色能听到的音乐属 diegetic，进 detailed_description。**跨段音乐 continuity**：延续上一段配乐时须声明动机/配器延续（如 continues the solo-piano motif from the previous segment），不得每段凭空换一套配器。

## 6. 时长网格（24 FPS，17k+5 帧）

| 秒 | 帧 | 秒 | 帧 | 秒 | 帧 |
|---|---|---|---|---|---|
| 3.75 | 90 | 8.00 | 192 | 11.54 | 277 |
| 4.46 | 107 | 8.71 | 209 | 12.25 | 294 |
| 5.17 | 124 | 9.42 | 226 | 12.96 | 311 |
| 5.88 | 141 | 10.13 | 243 | 13.67 | 328 |
| 6.58 | 158 | 10.83 | 260 | 14.38 | 345 |
| 7.29 | 175 | | | | |

段时长与所有 `[Shot N]` 时间戳必须落在该表值上（中间切点时间戳不必是网格值，但须 < 段时长）。引导片段合法长度同为该帧网格：5 / 22 / 39 / 56 帧，**模式 B 默认 22 帧**。

## 7. 本地节点约束

- **AddGuide**：输入 positive/latent 必填；接 image 需 vae、接 audio 需 audio_vae；frame_idx 负值从片尾倒数；多帧批次裁到 5/22/39/56；输出仅 positive（conditioning）。
- **分辨率**：短边原生 768px，上限 768×1344，取 32 的倍数；最低 384p。
- **采样器**：参考内容多的提示词用 res_multistep + beta 或 normal 调度器；T2V/I2V 基线 res_multistep + simple 20 步（<15 步画质明显降）。
- **ref_image_size**：match=缩到生成分辨率（快）；max=短边保留至 2048px（身份保真强，慢）。角色身份要求高时选 max。

## 8. 禁止清单

- 禁止 token 堆叠式运镜；禁止剧情梗概式描述（每句须对应可见/可听内容）；禁止未定义或跨段改义的标签；禁止时长与时间戳不符；禁止把 diegetic 声音写进 non_diegetic_music；禁止为 guide 片段写参考标签；禁止单段超 9/3/3 参考上限。
