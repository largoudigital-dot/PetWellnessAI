# AI API Empfehlungen für Tierarzt-App

## 🏆 Beste Optionen (Preis/Leistung)

### 1. **Groq API** ⭐ EMPFOHLEN
- **Preis**: $0.10 pro 1M Input-Tokens, $0.27 pro 1M Output-Tokens
- **Vorteile**:
  - Sehr günstig
  - Extrem schnell (bis zu 300 Tokens/Sekunde)
  - Gute Qualität mit Llama 3.1 70B
  - Einfache Integration
- **Nachteile**:
  - Weniger bekannt als OpenAI/Claude
- **Free Tier**: Nein, aber sehr günstig
- **Website**: https://console.groq.com

### 2. **Google Gemini API** ⭐ EMPFOHLEN
- **Preis**: 
  - Gemini 1.5 Flash: $0.075 pro 1M Input, $0.30 pro 1M Output
  - Gemini 1.5 Pro: $1.25 pro 1M Input, $5.00 pro 1M Output
- **Vorteile**:
  - Sehr günstig (Flash-Version)
  - Großzügiges Free Tier (15 RPM, 1M Tokens/Tag)
  - Gute Qualität
  - Multimodal (Text + Bilder)
- **Nachteile**:
  - Etwas langsamer als Groq
- **Free Tier**: Ja, sehr großzügig
- **Website**: https://aistudio.google.com

### 3. **Anthropic Claude API**
- **Preis**: 
  - Claude 3 Haiku: $0.25 pro 1M Input, $1.25 pro 1M Output
  - Claude 3 Sonnet: $3.00 pro 1M Input, $15.00 pro 1M Output
- **Vorteile**:
  - Sehr gute Qualität
  - Gute für medizinische Anwendungen
  - Sicher und zuverlässig
- **Nachteile**:
  - Teurer als Groq/Gemini
- **Free Tier**: Nein
- **Website**: https://console.anthropic.com

### 4. **OpenAI GPT API**
- **Preis**:
  - GPT-4o: $2.50 pro 1M Input, $10.00 pro 1M Output
  - GPT-4o-mini: $0.15 pro 1M Input, $0.60 pro 1M Output
- **Vorteile**:
  - Beste Qualität
  - Sehr bekannt und etabliert
- **Nachteile**:
  - Teuer (außer mini-Version)
- **Free Tier**: $5 Startguthaben
- **Website**: https://platform.openai.com

## 💰 Kostenvergleich (pro 1000 Nachrichten, ~500 Tokens pro Nachricht)

| API | Kosten pro 1000 Nachrichten | Qualität | Geschwindigkeit |
|-----|----------------------------|----------|-----------------|
| **Groq** | ~$0.14 | ⭐⭐⭐⭐ | ⚡⚡⚡⚡⚡ |
| **Gemini Flash** | ~$0.19 | ⭐⭐⭐⭐ | ⚡⚡⚡ |
| **Claude Haiku** | ~$0.38 | ⭐⭐⭐⭐⭐ | ⚡⚡⚡ |
| **GPT-4o-mini** | ~$0.23 | ⭐⭐⭐⭐ | ⚡⚡⚡ |
| **GPT-4o** | ~$3.75 | ⭐⭐⭐⭐⭐ | ⚡⚡⚡⚡ |

## 🎯 Empfehlung für Tierarzt-App

### **Option 1: Groq API** (Beste Preis/Leistung)
- Sehr günstig
- Extrem schnell
- Gute Qualität für Tierarzt-Beratung
- Einfache Integration

### **Option 2: Google Gemini Flash** (Mit Free Tier)
- Großzügiges Free Tier für Start
- Sehr günstig danach
- Multimodal (kann Fotos analysieren!)
- Gute Qualität

## 📝 Integration Beispiel

### Groq API Integration:
```swift
// Groq API Service
class GroqAPIService {
    private let apiKey = "YOUR_GROQ_API_KEY"
    private let baseURL = "https://api.groq.com/openai/v1/chat/completions"
    
    func sendMessage(_ message: String) async throws -> String {
        // Implementation
    }
}
```

### Gemini API Integration:
```swift
// Gemini API Service
class GeminiAPIService {
    private let apiKey = "YOUR_GEMINI_API_KEY"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
    
    func sendMessage(_ message: String) async throws -> String {
        // Implementation
    }
}
```

## 🔐 API Key Setup

1. **Groq**: https://console.groq.com → API Keys erstellen
2. **Gemini**: https://aistudio.google.com → API Key generieren
3. **Claude**: https://console.anthropic.com → API Keys
4. **OpenAI**: https://platform.openai.com → API Keys

## ⚠️ Wichtige Hinweise

- **API Keys niemals im Code committen!**
- Verwenden Sie Environment Variables oder Secure Storage
- Implementieren Sie Rate Limiting
- Fügen Sie Error Handling hinzu
- Testen Sie mit verschiedenen Tierarzt-Fragen

## 🚀 Nächste Schritte

1. API Key von Groq oder Gemini holen
2. API Service erstellen
3. In ChatView integrieren
4. System Prompt für Tierarzt-Beratung erstellen
5. Testen und optimieren


