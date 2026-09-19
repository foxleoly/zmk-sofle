# Omarchy 键位定制记录

> 日期：2026-09-20 · 提交：`6e64c2d` → `5b768e0` → `db0f0ff` → `ead08f8`
> 目标：为 Omarchy OS（Hyprland）定制的 Eyelash Sofle 键位；拇指布局保持原样，新增独立 Omarchy 层。

---

## 1. 设计思路

Omarchy 的核心交互全是 `Super + 某键`（终端、菜单、工作区、窗口操作）。键盘侧改动的原则：

- **拇指布局零改动**：`MUTE CTRL GUI ALT mo1 SPACE | ENTER SPACE ENTER mo2 SFT DEL` 一行未动。
  - 早期方案（右拇指 ENTER→Super、mo1 层加 PRINT/REC）被用户否决，全部还原（见 commit `5b768e0`）。
- **新增 LAYER3 = Omarchy 层**：按住 **CAPS**（hold-tap，tap=CAPS）呼出。
  - CAPS 作为触发键：日常没人按住 CAPS 重复输出，损失最小；左手小指 hold + 右手操作符合分体键盘习惯。
- **一键宏**：层内每个键 = 一个完整 `Super+...` 组合宏，无需拼组合键。

## 2. 键位图

### LAYER0（默认层，与原版一致）

```
 ESC 1 2 3 4 5  ↑  6 7 8 9 0 BSP       数字行/方向键在 base 层
 TAB Q W E R T  ↓  Y U I O P \          与 Omarchy 默认 Super+数字/方向 直接兼容
 CAPS A S D F G  ←  H J K L ; '
 SFT  Z X C V B  →  N M , . / ENT
 MUTE CTRL GUI ALT mo1 SPC | ENT SPC ENT mo2 SFT DEL   ← 原样
```

- `CAPS` 改为 hold-tap：**tap = Caps Lock**，**hold = LAYER3 (Omarchy 层)**（行为 `om_lt3`，tap-preferred，200ms）。

### LAYER3（OMARCHY 层，按住 CAPS）

```
 W1  W2  W3  W4  W5  BRW | NEXT | TML  MENU APPS LOCK PRT  -
 REC  -   -   -   -   -  | PREV | FLE  FULL TMUX CLIP -    -
 W6  W7  W8  W9  W0  -  | THME | EMOJ NITE CALC -    -    -
  -   -   -   -   -   -  | BAR  | -    -    -    -    -    -
 拇指行：trans（不动）
```

| 键 | 宏动作 | 键 | 宏动作 |
|----|--------|----|--------|
| W1–W5 | 切工作区 1–5 | TML | 终端 `Super+RET` |
| W6–W0 | 切工作区 6–10 | MENU | 主菜单 `Super+SPC` |
| BRW | 浏览器 `Super+Shift+RET` | APPS | 应用菜单 `Super+Alt+SPC` |
| NEXT/PREV | 切下/上一个工作区 | LOCK | 锁屏 `Super+Ctrl+L` |
| FLE | 文件管理器 `Super+Shift+F` | PRT/REC | 截图 / 录屏（`PRINTSCREEN` / `Alt+PRINTSCREEN`）|
| FULL | 全屏 `Super+F` | TMUX | Tmux `Super+Alt+RET` |
| CLIP | 剪贴板 `Super+Ctrl+V` | THME | 主题菜单（4 键组合一键化）|
| EMOJ/NITE/CALC | 表情/夜灯/计算器 | BAR | 隐藏/显示顶栏 `Super+Shift+SPC` |

### LAYER1 / LAYER2

与原版完全一致（mo1 = 功能层/鼠标层，mo2 = 蓝牙配置层），未改动。

## 3. ZMK 编译踩坑记录（重要）

这几次构建失败都是**键位语法**问题，GitHub Actions 日志里的关键错误行：

| 错误 | 根因 | 修复 |
|------|------|------|
| `devicetree error: /keymap/layer_3: undefined node label 'om_ws1'` | **宏节点标签大小写不匹配**：定义 `OM_WS1: OM_WS1 {`，引用写 `&om_ws1`。ZMK 标签大小写敏感 | 节点标签统一小写（`om_ws1: OM_WS1 {`），`label = "..."` 显示名保持大写 |
| `undefined node label`（同上，第二处） | 引用笔误 `&om_wspr`（应为 `&om_wspv`） | 改名对齐 |
| `gen_defines.py failed with return code: 1` | 这只是 DT 生成失败的结果，**真实错误在上一行**（`devicetree error: ...`） | 看日志要看完整区域 |
| （早期）键码 `PRINT` 报错 | ZMK 截图键码是 **`PRINTSCREEN`**（`PRSC` 为弃用别名），没有 `PRINT` | 改 `&kp PRINTSCREEN` |

**经验总结**

1. ZMK 宏定义：节点标签 `名称` 必须与 keymap 引用 `&名称` **完全一致（含大小写）**。
2. 截图/录屏键码：`PRINTSCREEN`（不是 `PRINT`）。
3. 宏里「一步按多个键」用同步组合：`bindings = <&macro_tap>, <&kp LEFT_GUI &kp N1>;`（可多行为一 step）。
4. hold-tap 建议自定义行为（`compatible = "zmk,behavior-hold-tap"` + `bindings = <&mo>, <&kp>;`），语义最明确：
   ```dts
   om_lt3: om_lt3 {
       compatible = "zmk,behavior-hold-tap";
       #binding-cells = <2>;
       flavor = "tap-preferred";
       tapping-term-ms = <200>;
       quick-tap-ms = <180>;
       bindings = <&mo>, <&kp>;
   };
   ```
   键位写法：`&om_lt3 3 CAPS`（hold→layer3，tap→CAPS）。
5. 构建失败日志下载需要管理员权限；匿名看状态用网页/`gh`，**错误文本让用户从 Actions 页面复制最省事**。

## 4. 本机环境备忘（~/.config/hypr 之外的坑）

这台 Omarchy 机器上影响开发的使用要点：

- **DNS 反复丢失**：`dhcpcd` 每次续租会把 `/etc/resolv.conf` 清空，Go 程序（`op`、`gh`、`git-lfs` 等）解析域名失败（报 `lookup xxx on [::1]:53: connection refused`）。
  → 已写入 **`/etc/resolv.conf.head`** 固化：
    ```
    nameserver 192.168.145.249
    nameserver 192.168.145.96
    ```
    （dhcpcd 重写时会保留 `.head` 内容；若再失效，`sudo cat /etc/resolv.conf.head > /etc/resolv.conf` 临时恢复。）
- **GitHub CLI（gh）**：
  - 已登录：`gh auth login --hostname github.com --web`（账号 foxleoly；登录流程里终端会给一次性代码）。
  - **网络设备会掐掉 HTTP/2 的 POST**（报 `Post ...EOF` / `error connecting`）。gh 命令需加：`GODEBUG=http2client=0 gh ...`。
  - 查询构建：`GODEBUG=http2client=0 gh run list --repo foxleoly/zmk-sofle`
- **Git Push**：走 1Password SSH agent：
  ```bash
  export SSH_AUTH_SOCK=~/.1password/agent.sock
  git push
  ```
  （不需要 1Password 的 SSH agent 时也可 `op signin`。）
- **构建状态**：push 后 GitHub Actions 自动编译（`Build ZMK firmware`）+ 重画 SVG（`Draw Keymap`）。draw 工作流会向 main 提交，本地 push 前记得 `git pull --rebase`。

## 5. 刷写流程

1. `~/Downloads/zmk-firmware/firmware/` 或 Actions → 最新成功 run → Artifacts → `firmware`。
2. 按键盘复位键进入 bootloader。
3. 拖入 `eyelash_sofle_left ...uf2`（左手，含 ZMK Studio）→ 再刷右手。
4. `settings_reset-...uf2` 备用（重置键盘设置）。

## 6. 后续想改怎么改

1. 改 `config/eyelash_sofle.keymap`（键位）/ 宏。
2. 同步 `keymap-drawer/eyelash_sofle.yaml`（画图工作流依赖它渲染 SVG）。
3. `git add` + commit + push → 云上编译 → 下载刷写。
4. 本地备份文件（`*.bak`）不入库，.gitignore 可选加 `*.bak`。

### 常用 ZMK 键码速查

- 截图：`PRINTSCREEN`
- 修饰键：`LSHFT` `LCTRL` `LEFT_GUI` `LEFT_ALT`
- 层行为：`&mo 1`（hold 层）、hold-tap 见上
- 组合键（宏一步多键）：`<&kp LEFT_GUI &kp N1>`