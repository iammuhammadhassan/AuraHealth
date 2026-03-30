# AuraHealth

A professional AI-powered health application built with **Flutter** and **AI integration** using GitHub Models.

## 🌟 Features

- **AI-Powered Chat** - Intelligent conversational health assistant powered by GitHub Models
- **Cross-Platform** - Native support for iOS, Android, and other platforms
- **Secure API Integration** - Token-based authentication with GitHub Models API
- **Real-time Updates** - Get instant responses from AI models
- **Flexible Model Configuration** - Support for multiple AI models and custom endpoints

## 🛠️ Tech Stack

- **Frontend**: Dart, Flutter
- **Native Code**: C++, C, Swift
- **Build System**: CMake
- **API**: GitHub Models API

## 📋 Prerequisites

Before getting started, ensure you have:

- Flutter SDK installed (latest stable version)
- GitHub account with API access
- A code editor (VS Code recommended)
- Basic knowledge of Flutter development

## 🚀 Quick Start

### Step 1: Create GitHub Personal Access Token

1. Go to [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
2. Click **Generate new token**
3. Grant the `models:read` permission
4. Copy the token and save it securely (never commit it to your repository)

### Step 2: Configure Secrets

Copy the example secrets file and add your token:

```powershell
Copy-Item secrets.github.example.json secrets.github.json
```

Edit `secrets.github.json` and set your GitHub Models API key:

```json
{
  "GITHUB_MODELS_API_KEY": "your_token_here"
}
```

### Step 3: Run the Application

```powershell
flutter run --dart-define-from-file=secrets.github.json
```

> **Note**: VS Code launch configuration automatically includes this argument.

## ⚙️ Configuration

### Supported Environment Variables

| Variable | Description | Status |
|----------|-------------|--------|
| `GITHUB_MODELS_API_KEY` | Your GitHub Models API token | ✅ Preferred |
| `GITHUB_TOKEN` | Alternative authentication token | ⚠️ Fallback |
| `GITHUB_MODELS_MODEL` | Specific model to use | Optional |
| `GITHUB_MODELS_ENDPOINT` | Custom API endpoint | Optional |

### Default Endpoint

```
https://models.github.ai/inference
```

**Legacy Endpoint Migration**: If you're using the old endpoint (`https://models.inference.ai.azure.com`), the app automatically maps it to the new endpoint.

## 🔧 Advanced Usage

### Using External Models

To use external or custom models, follow this naming format:

```
custom/key_id/model_id
```

Example:
```
custom/my-key/gpt-4
```

## 🆘 Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `401` or `403 Unauthorized` | Invalid or missing token | Ensure your token has `models:read` permission and is correctly set in `secrets.github.json` |
| Empty response from API | Model unavailable or endpoint issue | Verify the model is available and the endpoint is correct |
| Configuration not loading | Secrets file not found | Run with `--dart-define-from-file=secrets.github.json` or check file path |

### Debug Mode

For detailed runtime configuration information, send `/diagnose` in the chat screen to view hints and debugging information.

## 📁 Project Structure

```
AuraHealth/
├── lib/              # Flutter app source code
├── ios/              # iOS native code and assets
├── android/          # Android native code
├── windows/          # Windows platform code
├── macos/            # macOS platform code
├── pubspec.yaml      # Flutter dependencies
└── README.md         # This file
```

## 🔐 Security Best Practices

⚠️ **Important**:
- Never commit `secrets.github.json` to version control
- Always use environment-specific tokens
- Rotate tokens regularly
- Keep your GitHub token confidential
- Use `.gitignore` to exclude secret files

## 📝 Environment File Setup

Add this to your `.gitignore`:

```
secrets.github.json
```

Keep `secrets.github.example.json` in your repository as a template for other developers.

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues, questions, or suggestions, please open a GitHub Issue. For detailed troubleshooting, refer to the Troubleshooting section above.

---

**Happy Coding!** 🚀