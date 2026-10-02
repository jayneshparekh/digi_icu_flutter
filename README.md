# Digi ICU Flutter

**Digi ICU Flutter** is a clinical Tele-ICU and digital health management platform designed for healthcare professionals (Doctors & ICU Specialists) to manage patients, monitor vital sign graphs, perform clinical assessments with touch canvas drawing and voice dictation, formulate diagnoses, and prescribe treatments.

---

## 🛠 Tech Stack
- **Framework**: Flutter SDK 3.47.2 (Stable) / Dart SDK 3.13.2
- **Architecture**: Model-View-Controller (MVC) + GetX (v4.6.6)
- **Networking**: Dio (v5.11.1)
- **Charts**: fl_chart (v1.1.0)
- **Speech-to-Text**: speech_to_text (v7.4.0)
- **Payments**: Razorpay Flutter (v1.4.6)

---

## 📚 Project Documentation & Standards
All architecture, design guidelines, rules, and API maps are centralized under the [`.agents/`](file:///c:/Users/admin/Desktop/digi_icu_flutter/.agents/) directory:

- [**AGENTS.md**](file:///c:/Users/admin/Desktop/digi_icu_flutter/.agents/AGENTS.md): Master coding rules, strict constraints, and quality standards (auto-enforced by AI agents).
- [**PROJECT_OVERVIEW.md**](file:///c:/Users/admin/Desktop/digi_icu_flutter/.agents/PROJECT_OVERVIEW.md): System context, screen catalog, controller map, and user workflows.
- [**ARCHITECTURE.md**](file:///c:/Users/admin/Desktop/digi_icu_flutter/.agents/ARCHITECTURE.md): MVC + GetX architectural design, layer responsibilities, and data flow.
- [**DESIGN_SYSTEM.md**](file:///c:/Users/admin/Desktop/digi_icu_flutter/.agents/DESIGN_SYSTEM.md): 60/30/10 color scheme (`AppColors`), typography, form controls, and reusable widget catalog.
- [**API_INTEGRATIONS.md**](file:///c:/Users/admin/Desktop/digi_icu_flutter/.agents/API_INTEGRATIONS.md): Centralized `ApiEndpoints` map, Dio client configuration, and third-party integrations.
- [**TESTING_AND_QUALITY.md**](file:///c:/Users/admin/Desktop/digi_icu_flutter/.agents/TESTING_AND_QUALITY.md): Static analysis, test strategies, and platform permission checklist.

---

## 🚀 Getting Started

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run static analysis**:
   ```bash
   flutter analyze
   ```

3. **Run tests**:
   ```bash
   flutter test
   ```

4. **Launch development build**:
   ```bash
   flutter run
   ```
