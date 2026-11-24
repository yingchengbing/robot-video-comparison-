# 机器人视频生成 · 多模型定性对比

纯静态展示页，无后端、无外部依赖。`index.html` 已把视频清单内联进页面，**双击即可打开**，也可以直接部署到任意静态托管。

## 内容

- 主展示 **9 组**案例（RoboTwin / RoboDojo / DROID 各 3 组），每组按 **3 排 × 3 列** 对照
- 三排分别是：我方方法（交互白膜 + LTX / MiniMax）、其他视频生成方法（DW05 / MVA / FlowWAM）、三维代理与物理仿真（RealWonder / PhysOmni / 对应输入白膜）
- 视频 **69 个，统一 640×480**（H.264 / yuv420p / faststart），共约 52.6 MB，最大单文件 3.5 MB
- 播放控件：全部播放 / 暂停 / 回到开头 / 按各视频时长归一化的统一进度 / 0.5×·1×·2× 速度

## 目录

```
index.html        # 页面（清单已内联，可直接 file:// 打开）
.nojekyll         # 关掉 Jekyll 处理，避免静态资源被过滤
RoboTwin/         # 数据集 → 案例 → 各模型视频
RoboDojo/
DROID/
```

视频按 `数据集/案例/槽位.mp4` 组织，页面用相对路径引用，因此放在任何子路径下（含 `https://<user>.github.io/<repo>/`）都能正常工作。

## 部署到 GitHub Pages

### 1. 建仓库

在 GitHub 新建一个**空的公开仓库**（不要勾选 README / .gitignore / license），记下地址，例如
`https://github.com/yourname/robot-video-comparison.git`。

### 2. 推代码

在**你自己的终端**里执行（本目录已就绪，不需要再改任何文件）：

```powershell
cd C:\Users\22682\Documents\deepseek-harness\default-workspace\github-pages

git init
git add -A
git commit -m "Add qualitative robot video comparison site"
git branch -M main
git remote add origin https://github.com/yourname/robot-video-comparison.git
git push -u origin main
```

或者直接用附带的脚本，一步做完并打印线上地址：

```powershell
.\deploy.ps1 -Repo "https://github.com/yourname/robot-video-comparison.git"
```

> 首次推送约 330 MB，视网络可能要几分钟到几十分钟。若中途报错 `HTTP 413`／`RPC failed`，先执行
> `git config --global http.postBuffer 524288000` 再重试；仍失败可改用 `git push` 分两次（先推 `index.html`，再推视频目录）。

### 3. 打开 Pages

仓库页 → **Settings** → **Pages** → Source 选 **Deploy from a branch** → Branch 选 **main**、目录选 **/(root)** → **Save**。

等 1~2 分钟，访问：

```
https://yourname.github.io/robot-video-comparison/
```

### 4. 首次访问自检

- 顶部应显示「主展示 · 每数据集 3 组，共 9 组」，而不是「加载清单…」
- 切换 RoboTwin / RoboDojo / DROID 三个标签，每页应出现 3 个区块、每区块最多 3 个视频
- 视频能点开播放、能调进度与倍速
- 若显示「清单加载失败」，通常是 Pages 还没构建完，等 1 分钟刷新

## 体积与限制（已核对）

| 项目 | 数值 | GitHub 限制 |
|---|---|---|
| 站点总体积 | 52.6 MB | Pages 发布上限 1 GB |
| 最大单文件 | 3.5 MB | git 单文件硬上限 100 MB |
| 文件数 | 73 | 无实际限制 |

## 未包含的内容：备用案例

原始包里的备用案例**没有随本仓发布**（当前 17 组、约 1066 MB，且仍是原始分辨率）。原因：

1. 其中 3 个 `01_LTX.mp4` 分别为 **147.4 MB / 127.1 MB / 116.0 MB**，超过 GitHub 100 MB 单文件硬上限，`git push` 会被直接拒绝；
2. 即使只算备用案例也超过 Pages 1 GB 上限（其中 `simulated__episode15` 已升级为主展示，视频已一并压到 640×480）。

若之后要把备用案例也公开，可行的三种做法：

- **转码压小**：用同样的参数（`scale=640:480`、CRF 20）重编码，备用 17 组可从约 1066 MB 压到 100 MB 量级，然后按同样目录结构补进仓库（推荐）；
- **Release 附件**：把备用视频作为 GitHub Release 资产上传（单文件 ≤2 GB、总量无硬限），页面里把对应 `src` 换成 Release 下载地址（跨域 `<video>` 播放不需要 CORS）；
- **对象存储**：视频放 OSS / R2 / S3，页面只留静态 HTML。

## 说明

- 对比口径为**定性精选**，不是全库排名，也不构成成功率统计。
- 站内 69 个视频已统一为 **640×480**：用 `scale=640:480` 直接拉伸填充，因此原本非 4:3 的素材（如 1280×720、1024×576、832×480）会有轻微横向/纵向变形；时长、帧率与内容顺序保持不变。
- MiniMax 白膜结果不作为与左侧同版输入的严格后端实验；RealWonder 为机器人适配版；PhysOmni 槽位按来源标注 LTX 适配或补充结果，不代表全部原生实现。
- 原始诊断标签不作成功认证。
