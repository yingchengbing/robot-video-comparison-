# 机器人视频生成 · 多模型定性对比

纯静态展示页，无后端、无外部依赖。`index.html` 已把视频清单内联进页面，**双击即可打开**，也可以直接部署到任意静态托管。

## 内容

- 主展示 **9 组**案例（RoboTwin / RoboDojo / DROID 各 3 组），每组按 **3 排 × 3 列** 对照
- 三排分别是：我方方法（交互白膜 + LTX / MiniMax）、其他视频生成方法（DW05 / MVA / FlowWAM）、三维代理与物理仿真（RealWonder / PhysOmni / 对应输入白膜）
- 视频 **69 个，约 330 MB**，最大单文件 60.5 MB
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
| 站点总体积 | 329.7 MB | Pages 发布上限 1 GB |
| 最大单文件 | 60.5 MB | git 单文件硬上限 100 MB |
| 文件数 | 71 | 无实际限制 |

## 未包含的内容：备用案例

原始包里的 **18 组备用案例（1222 MB）没有随本仓发布**，原因：

1. 其中 3 个 `01_LTX.mp4` 分别为 **147.4 MB / 127.1 MB / 116.0 MB**，超过 GitHub 100 MB 单文件硬上限，`git push` 会被直接拒绝；
2. 加上主展示后总计 1552 MB，超过 Pages 1 GB 上限。

若之后要把备用案例也公开，可行的三种做法：

- **转码压小**：把 `01_LTX.mp4` 降到 720p / 更低码率，使单文件 <100 MB、总量 <1 GB，然后按同样的目录结构补进仓库；
- **Release 附件**：把备用视频作为 GitHub Release 资产上传（单文件 ≤2 GB、总量无硬限），页面里把对应 `src` 换成 Release 的下载地址（跨域 `<video>` 播放不需要 CORS）；
- **对象存储**：视频放 OSS / R2 / S3，页面只留静态 HTML。

## 说明

- 对比口径为**定性精选**，不是全库排名，也不构成成功率统计；各视频保留原始比例、时长与帧率。
- MiniMax 白膜结果不作为与左侧同版输入的严格后端实验；RealWonder 为机器人适配版；PhysOmni 槽位按来源标注 LTX 适配或补充结果，不代表全部原生实现。
- 原始诊断标签不作成功认证。
