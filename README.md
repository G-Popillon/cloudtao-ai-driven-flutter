# ASEAN Weather AI Assistant / 东盟气象智能助手

大赛 Demo 前端：面向东盟气象生成式 AI 应用的 Flutter 客户端。  
**仅前端**，对接已有 FastAPI 后端（chat / STT / TTS / i18n），不包含 RAG/LLM 逻辑。

## 功能概览

- 文字气象问答（气泡对话）
- AI 回答下方可折叠展示【引用气象数据源】
- 云端 STT：`record` 录音上传 `/api/stt`
- 云端 TTS：回答后自动请求 `/api/tts` 并用 `audioplayers` 播报
- 5 语国际化：中文 / English / ไทย / Tiếng Việt / Bahasa Indonesia
- 对话历史本地缓存（`shared_preferences`）
- 支持 Windows 开发；GitHub Actions 编译 unsigned IPA 供 Apple ID 自签演示

## 环境要求

- Flutter SDK **3.24+**（Dart 3.2+）
- 后端已在 `http://127.0.0.1:8000` 启动（或自定义地址）
- Windows / Android / iOS 真机或模拟器

## 后端接口约定

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/chat` | `{query, lang}` → `{answer, source[], success}` |
| POST | `/api/stt` | form-data 音频字段 `file` → `{text, success}` |
| POST | `/api/tts` | `{text, lang}` → 二进制音频流 |
| GET | `/api/i18n/langs` | 支持语言列表 |

`lang` 取值：`zh` / `en` / `th` / `vi` / `id`。

## 启动步骤

```bash
# 1. 安装依赖
flutter pub get

# 2. 确认后端已启动（默认本机 8000 端口）

# 3. Windows 桌面运行
flutter run -d windows

# 4. Android 模拟器（模拟器访问宿主机请改 baseURL）
flutter run -d android --dart-define=API_BASE_URL=http://10.0.2.2:8000

# 5. 真机（把 IP 换成电脑局域网地址）
flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8000
```

默认 baseURL：`http://127.0.0.1:8000`（见 `lib/config/api_config.dart`）。

## 麦克风权限配置

### Android

已在 `android/app/src/main/AndroidManifest.xml` 声明：

- `RECORD_AUDIO`
- `INTERNET`
- `usesCleartextTraffic=true`（允许访问本地 HTTP 后端）
- `minSdk = 23`

首次点击录音会弹出系统权限请求。

### iOS

已在 `ios/Runner/Info.plist` 配置：

- `NSMicrophoneUsageDescription`
- `NSAppTransportSecurity` 允许本地 HTTP（演示用）

### Windows

- `windows/runner/runner.exe.manifest` 已声明麦克风能力
- 若系统拦截：打开 **设置 → 隐私和安全性 → 麦克风**，允许桌面应用访问

## 演示路径建议

1. 顶部切换语言（验证 UI 文案国际化）
2. 输入「曼谷今天天气如何？」发送，查看 AI 气泡与【引用气象数据源】
3. 点击麦克风录音 → 再点结束 → 自动 STT → 自动发 Chat → 自动 TTS 播报
4. 杀掉 App 再打开，确认历史仍在

## GitHub Actions 编译 IPA（自签演示）

工作流：`.github/workflows/build-ipa.yml`

- 在 macOS runner 上执行 `flutter build ios --release --no-codesign`
- 打包为 `asean-weather-ai.ipa` Artifact（**未签名**）

本地/CI 触发后，下载 IPA，使用 **Sideloadly** 或 **AltStore** + Apple ID 自签安装到 iPhone，即可扫码/安装演示。

> Windows 本机无法直接产出 iOS 包，必须依赖 macOS CI 或 Mac 实机。

## 目录结构

```
lib/
  main.dart / app.dart
  config/api_config.dart
  theme/app_theme.dart
  l10n/                 # 5 语 ARB + AppLocalizations
  models/               # ChatMessage / WeatherSource / ChatResponse
  services/             # HTTP、录音、播放、本地缓存
  providers/            # LocaleProvider / ChatProvider
  screens/chat_screen.dart
  widgets/              # 气泡、来源面板、输入栏、语言选择
```

## 编码规范

- 文件/变量：`snake_case`；类：`PascalCase`
- 关键业务流程保留中文注释
- 禁止接入系统本地 TTS/STT（不用 `flutter_tts` / `speech_to_text`）
- 禁止在前端实现 RAG/LLM，只请求接口并渲染

## 常见问题

**Q: 网络错误 / 连接被拒绝**  
A: 确认 FastAPI 已监听 `0.0.0.0:8000`；真机务必用电脑局域网 IP 的 `--dart-define`。

**Q: STT 字段名不匹配**  
A: 修改 `lib/config/api_config.dart` 中的 `sttFileField`（默认 `file`）。

**Q: TTS 无声音**  
A: 检查后端是否返回音频字节；查看控制台 `TTS failed` 日志；确认设备未静音。
