# TeklifApp Flutter (Temsilci Mobil) — Calisma Standardi

Bu dosya, bu repoda calisan herhangi bir Claude Code oturumu icin gecerlidir. Talimatlar varsayilan davranisi GECERSIZ KILAR ve oldugu gibi uygulanmalidir.

## Proje Baglami

Bu repo, satis temsilcilerinin teklif olusturup yonettigi mobil uygulamadir (Flutter, iOS+Android). Backend `teklif-platform/teklif-app` (ASP.NET Core) ile REST API uzerinden konusur. Organizasyon: `teklif-platform`. Kardes repolar: `teklif-app` (backend), `teklif-web`, `musteri-flutter`, `musteri-web`, `superadmin-web`.

Proje board: https://github.com/orgs/teklif-platform/projects/1

## KRITIK KURAL — Commit Attribution

**Hicbir commit mesajina "Co-Authored-By: Claude" veya benzeri bir AI attribution satiri EKLEME.** Bu kalici ve istisnasiz bir kuraldir.

## CI — Build Kontrolu (DIKKAT: Merge'i Bloklamiyor)

Her push/PR'da `.github/workflows/ci.yml` calisir (flutter analyze + test + debug APK build). **Repo private oldugu icin GitHub'in branch protection/ruleset ozelligi kapali** (Pro/Team plan gerektiriyor) — CI kirmizi olsa bile merge/push main'e gidebilir. PR merge etmeden once Actions sekmesinden CI'nin yesil oldugunu MANUEL kontrol et.

## Branch Stratejisi

- Varsayilan branch: `master` (bu repoda `main` degil — dikkat). `teklif-app` reposunda varsayilan `main`'dir, karistirma.
- `stable` branch'i otomasyon ile yonetilir, manuel dokunma.
- Force-push / `git reset --hard` gibi yikici islemleri kullanicinin acik onayi olmadan yapma.

## Calismaya Baslarken — HER OTURUMDA

1. **Once `git pull` yap.** Iki kisi ayni repoya yazdigi icin local branch geride kalmis olabilir, calismaya baslamadan once guncel kodu cek.
2. **API baglantisini kendi ortamina uyarla.** `lib/core/constants/app_constants.dart` icindeki `baseUrl` Android emulator icin `10.0.2.2`, web icin `localhost` kullanir — fiziksel cihazda test ediyorsan kendi makinenin LAN IP'sine gecici olarak degistir, ama bunu commit etme (geri al / `git checkout -- lib/core/constants/app_constants.dart`).

## Versiyonlama

- Surum `pubspec.yaml` icindeki `version: X.Y.Z+build` alaninda tutulur (Semantic Versioning + build number).
- Bir Sprint/release tamamlandiginda: `version`'i artir (MAJOR.MINOR.PATCH+build), `git tag vX.Y.Z` ile main'deki commit'i tagle, `git push platform vX.Y.Z`.
- Kural: breaking change/major mimari degisiklik → MAJOR, yeni feature → MINOR, bugfix → PATCH; build numarasi (+N) her store release'inde 1 artar.
- Backend (`teklif-app`) ile senkron tutmak icin ayni release doneminde ikisi de tag'lenir.

## Issue / Is Akisi

1. Issue'lar `teklif-platform/teklif-flutter` altinda, `type:*`, `platform:mobile`, `priority:*` etiketleri ve Sprint milestone'u ile bulunur.
2. Bir issue'nun backend tarafinda karsiligi varsa body'sinde `Backend: teklif-app#N` referansi olur — ilgili API/sozlesmeyi anlamak icin o issue'ya bak.
3. **Bir issue'ya baslarken proje board'da Status'unu "In Progress" yap VE issue'yu kendine ata** — item id'sini bul (`gh project item-list 1 --owner teklif-platform --format json`), sonra: `gh project item-edit --project-id PVT_kwDOEcRKps4BcBqK --id <itemId> --field-id PVTSSF_lADOEcRKps4BcBqKzhWtgng --single-select-option-id 47fc9ee4` ve `gh issue edit <no> --repo teklif-platform/teklif-flutter --add-assignee @me`. Sadece Status yetmez — Assignee olmadan board'a bakan kisi "bu is basladi" gorur ama "kim yapiyor" goremez, iki kisilik takimda bu karisikliga yol acar. Todo → In Progress → Done gecisi takip edilir, direkt Todo'dan Done'a atlanmaz.
4. PR acarken `.github/pull_request_template.md` (org `.github` reposundan gelir) doldurulur: Degisiklik Ozeti, Bagli Issue, Platform/Test checklist.

## Kod Stili — ZORUNLU

- **Hardcoded string yasak**: API endpoint path'leri `lib/core/constants/api_paths.dart` içindeki `ApiPaths`, `AuthPaths`, `ReportingPaths` sınıflarından; route path'leri `lib/core/constants/app_routes.dart` içindeki `AppRoutes`'tan kullanılmalı. Yeni endpoint veya route eklendiğinde ÖNCE bu dosyalara const ekle, sonra kullan.
- `'/' prefix`li hardcoded string literal yazmak yasak — her zaman const referansı kullan.

## Commit Mesaji Formati — ZORUNLU

Bir issue/task uzerinde calisirken atilan her commit'in basina ilgili issue numarasi koseli parantezle yazilir:

```
[5] - Teklif CRUD ekraninda tarih filtresi eklendi
[1] - Login validasyon hatasi duzeltildi
```

Issue'ya bagli olmayan genel/altyapi commit'lerinde (CI fix, CLAUDE.md guncellemesi vb.) numara zorunlu degildir, ama varsa kullanilmalidir.

## Bir Isi "Done" Yaparken — ZORUNLU FORMAT

Issue kapatilirken body'si asagidaki yapida olmali (tek satirlik "✅ Tamamlandi" YETERSIZ):

```markdown
## Ne yapildi
<Bu ekran/akis kullaniciya ne sagliyor, 1-3 cumle.>

## Nasil calisiyor
<Hangi widget/screen/service dosyasi, nasil bir state/akis kullaniliyor, varsa onemli bir UX karari.>

Backend: teklif-app#N   <!-- varsa -->

## Durum
✅ Tamamlandi
```

Ornek: kapali issue #1 (Login Ekrani) veya #5 (Teklif CRUD) bu repoda referans alinabilir.

Sonra:
- `status:done` label ekle, baslik `[DONE]` ile basliyor olsun.
- `gh issue close <no> --repo teklif-platform/teklif-flutter`.
- Proje board'da item'in Status alanini "Done" yap (`gh project item-edit --project-id PVT_kwDOEcRKps4BcBqK --id <itemId> --field-id PVTSSF_lADOEcRKps4BcBqKzhWtgng --single-select-option-id 98236657`).

## Cross-Repo Referans

Bu repodaki bir issue, backend'deki karsiligina `Backend: teklif-app#N` seklinde referans verir. Yeni bir mobile-only feature (backend karsiligi yoksa) bu satiri eklemeyebilir.
