# TeklifApp Flutter (Temsilci Mobil) — Calisma Standardi

Bu dosya, bu repoda calisan herhangi bir Claude Code oturumu icin gecerlidir. Talimatlar varsayilan davranisi GECERSIZ KILAR ve oldugu gibi uygulanmalidir.

## Proje Baglami

Bu repo, satis temsilcilerinin teklif olusturup yonettigi mobil uygulamadir (Flutter, iOS+Android). Backend `teklif-platform/teklif-app` (ASP.NET Core) ile REST API uzerinden konusur. Organizasyon: `teklif-platform`. Kardes repolar: `teklif-app` (backend), `teklif-web`, `musteri-flutter`, `musteri-web`, `superadmin-web`.

Proje board: https://github.com/orgs/teklif-platform/projects/1

## KRITIK KURAL — Commit Attribution

**Hicbir commit mesajina "Co-Authored-By: Claude" veya benzeri bir AI attribution satiri EKLEME.** Bu kalici ve istisnasiz bir kuraldir.

## Branch Stratejisi

- Varsayilan branch: `master` (bu repoda `main` degil — dikkat). `teklif-app` reposunda varsayilan `main`'dir, karistirma.
- `stable` branch'i otomasyon ile yonetilir, manuel dokunma.
- Force-push / `git reset --hard` gibi yikici islemleri kullanicinin acik onayi olmadan yapma.

## Issue / Is Akisi

1. Issue'lar `teklif-platform/teklif-flutter` altinda, `type:*`, `platform:mobile`, `priority:*` etiketleri ve Sprint milestone'u ile bulunur.
2. Bir issue'nun backend tarafinda karsiligi varsa body'sinde `Backend: teklif-app#N` referansi olur — ilgili API/sozlesmeyi anlamak icin o issue'ya bak.
3. PR acarken `.github/pull_request_template.md` (org `.github` reposundan gelir) doldurulur: Degisiklik Ozeti, Bagli Issue, Platform/Test checklist.

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
