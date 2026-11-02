# 官方语法文档（不随仓库分发）

本目录预期包含三份 MiniMax H3 官方 prompt-writing 原文：

| 文件名 | 官方来源 |
|---|---|
| `official-skill.md` | `skills/h3-prompt-writing/SKILL.md` |
| `base-en.txt` | `skills/h3-prompt-writing/references/base-en.txt` |
| `ref-en.txt` | `skills/h3-prompt-writing/references/ref-en.txt` |

## 为什么不在仓库里

MiniMax H3 的官方文档适用 **MiniMax H3 Community License Agreement**，其授权范围限定在 Applicable Territory（全球排除欧盟、英国、韩国、美国），并对再分发设有条件（附协议、保留 NOTICE、修改标注等）。为避免把受限材料直接放进公开仓库，本仓库不收录这三份文件，改为安装时从官方仓库拉取。

- 官方仓库：https://github.com/MiniMax-AI/MiniMax-H3
- 许可证全文：https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

## 获取方式

在仓库根目录运行：

```bash
bash scripts/fetch-official.sh
```

Windows PowerShell：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/fetch-official.ps1
```

脚本会要求你确认已阅读并接受上述许可证，且处于 Applicable Territory，然后把三份文件下载到本目录。下载后的文件已被 `.gitignore` 忽略，不会被误提交。

也可以先安装官方 skill，再手动复制：

```bash
npx skills add https://github.com/MiniMax-AI/MiniMax-H3 --skill h3-prompt-writing
```

把安装目录中的 `SKILL.md` 复制为 `official-skill.md`，把 `references/base-en.txt`、`references/ref-en.txt` 复制到本目录即可。

## 缺失时的影响

`SKILL.md` 的优先级是 **官方三文档 ＞ 本地 00 ＞ 03–09 创作板块**。本目录为空时，skill 仍可按本地规范运行，但遇到语法细节（标签定义位置、retention 标记、speaker 编号等）会缺少最高优先级的原文依据。建议首次使用先拉取。

## 许可提示

拉取与使用官方文档即表示你接受 MiniMax H3 Community License Agreement。本仓库的 MIT 许可**不覆盖**这三份官方文件；它们的使用、复制与再分发以该协议为准。本项目与 MiniMax 无隶属或背书关系。
