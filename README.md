# 单晓鹏 · 个人主页

纯静态单文件站点（`index.html`），无外部字体、无 CDN、无网络请求，双击即可离线打开。

## 本地预览

```powershell
# 方式一：直接双击 index.html
# 方式二：起一个本地服务（推荐，和线上行为一致）
python -m http.server 8080
# 然后访问 http://127.0.0.1:8080
```

---

## 首次部署（5 步）

### 1. 建仓库

打开 <https://github.com/new>，新建一个**空仓库**：

- Repository name：随意，例如 `homepage`
- 可见性：**Public**（免费账号只有公开仓库能开 Pages）
- 不要勾选 README / .gitignore / license（保持空仓库）

### 2. 绑定远程并推送

在本目录打开 PowerShell，执行（把 URL 换成你的）：

```powershell
.\deploy.ps1 https://github.com/你的用户名/仓库名.git
```

> 如果提示「禁止运行脚本」，改用 `deploy.cmd` 双击运行，或执行：
> `powershell -ExecutionPolicy Bypass -File .\deploy.ps1 https://github.com/你的用户名/仓库名.git`

首次推送会弹出浏览器让你登录 GitHub（Git Credential Manager），登录一次之后就不用了。

### 3. 开启 Pages

仓库页 → **Settings → Pages**：

- Source：`Deploy from a branch`
- Branch：**`gh-pages`** ／ 目录 **`/ (root)`**
- 点 **Save**

### 4. 等 1 分钟

访问 `https://你的用户名.github.io/仓库名/`

（仓库名如果叫 `用户名.github.io`，地址就是 `https://用户名.github.io/`，路径少一层。）

### 5. 以后每次更新

改完 `index.html`，只需要执行：

```powershell
.\deploy.ps1
```

脚本会自动提交、推 `main`、再把 `main` 强推到 `gh-pages`。大约 30 秒后生效，浏览器缓存可能还要几分钟。

---

## 这个仓库的结构

```
index.html        # 整站（HTML + CSS + JS 全在里面）
预览-桌面.png      # 截图，仅用于文档展示
预览-手机.png
deploy.ps1        # 一键部署脚本
deploy.cmd        # 双击即可运行 deploy.ps1（绕过脚本执行策略）
.nojekyll         # 告诉 GitHub Pages 不要跑 Jekyll
README.md
```

## 为什么用 gh-pages 分支

- `main` = 源码，想改就改
- `gh-pages` = 实际发布的文件，由脚本从 `main` 强推覆盖
- 两者分开，发布时不会把开发历史带到线上

## 常见问题

| 现象 | 原因 / 解决 |
|---|---|
| 打开是 404 | Pages 还没构建完，等 1–2 分钟；或分支/目录选错 |
| 打开是 README | Settings 里分支选成了 `main`，改回 `gh-pages` |
| push 报 403 | 账号没权限或密码用错，删掉 Windows 凭据里 github.com 的条目重试 |
| 改了内容线上没变 | 浏览器缓存，`Ctrl+F5` 强刷；或 Pages 仍在构建（看仓库 Actions 页） |
| 想让别人用自己域名 | Pages 设置里填 Custom domain，再到域名商加一条 CNAME 记录指向 `用户名.github.io` |

## 安全提醒

页面里包含手机号和邮箱，公开仓库 = 全网可见。如果只想给朋友看，可以把手机号换成微信二维码，或只保留邮箱。
