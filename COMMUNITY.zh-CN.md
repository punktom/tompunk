# NekoBox Community 1.4.3-community.2

基于 MatsuriDayo/NekoBoxForAndroid 1.4.2（5768494d8ae3c74a057bb6d46c0f8dc071b0d821），根据 MatsuriDayo/NekoBoxForAndroid PR #1213 迁移到 sing-box 1.14.3（带 NekoBox 兼容补丁）。需要 Android 6.0 及以上。旧版自定义 sing-box JSON 可能需要迁移 DNS、TUN 和 WireGuard 字段。维护版的包名为 `moe.nb4a.community`，测试包则为 `moe.nb4a.community.debug`。两者均可与官方版并存，使用独立的数据。迁移时先在官方版导出备份。

## 在 punktom/tompunk 构建测试 APK

收到 Git bundle 后，在你自己的终端运行以下两条命令。请先切换到 bundle 文件所在目录。需要能够以 GitHub 账号向目标仓库推送工作流文件。

```powershell
git clone --branch nekobox-community ./NekoBox-1.4.3-community.2.bundle NekoBox-community
git -C NekoBox-community push https://github.com/punktom/tompunk.git refs/heads/nekobox-community:refs/heads/nekobox-community
```

这两条命令只新增或更新 `nekobox-community` 分支。若同名分支已有其他提交，Git 会拒绝，不要强推。推送后到仓库的 **Actions → Community APK** 查看构建。成功后下载 **NekoBox-community-apks**，绝大多数现代手机选择文件名含 `arm64-v8a` 的 APK。产物附带 `SHA256SUMS`。

测试包无需配置签名密钥。GitHub 的临时构建环境会生成调试密钥，所以后续测试包可能无法覆盖安装。先验证应用启动、备份导入、桌面快捷方式和 VPN 启停；卸载应用之前请另存备份。

## 构建可持续更新的正式 APK

如果没有自己的 Android 签名密钥，可用 JDK 的 `keytool` 生成。签名文件和密码要安全保存，以后用同一密钥签名才能覆盖更新。

```text
keytool -genkeypair -v -keystore community.p12 -storetype PKCS12 -alias community -keyalg RSA -keysize 3072 -validity 10000
```

在仓库 **Settings → Secrets and variables → Actions** 配置：

- `KEYSTORE_BASE64`：签名文件的单行 Base64。
- `KEYSTORE_PASS`：签名文件的密码。
- `ALIAS_NAME`：密钥别名，例如 `community`。
- `ALIAS_PASS`：密钥密码；上述 PKCS12 命令通常使用与文件相同的密码。

配置后，从分支同一提交创建并推送名为 `nekobox-community-v1.4.3-community.2` 的标签。工作流会构建正式 APK 并上传到同一个 Actions 产物列表。它不会创建 GitHub Release。
