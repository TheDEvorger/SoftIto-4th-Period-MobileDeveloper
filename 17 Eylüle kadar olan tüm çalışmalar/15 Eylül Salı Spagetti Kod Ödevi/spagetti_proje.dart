class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;
  String tip;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);

  double kargoUcretiHesapla() {
    return 29.90;
  }
}

class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok, "DIJITAL");

  @override
  double kargoUcretiHesapla() {
    return 0.0;
  }
}



abstract class SiparisKayitIslemi {
  void siparisKaydet(String orderId, double tutar);
}

abstract class OdemeIslemi {
  void odemeYap(OdemeYontemi odemeYontemi, double tutar);
}

abstract class KargoIslemi {
  void kargoGonder(String orderId, String adres);
}

abstract class MailIslemi {
  void mailGonder(String email, String mesaj);
}

abstract class SmsIslemi {
  void smsGonder(String tel, String mesaj);
}

abstract class FaturaIslemi {
  void faturaYazdir(String orderId);
}




abstract class MailServisi {
  void mailAt(String to, String body);
}

class SmtpMailServisi implements MailServisi {
  @override
  void mailAt(String to, String body) {
    print("SMTP Mail gonderildi: " + to);
  }
}

abstract class SmsServisi {
  void smsYolla(String gsm, String text);
}

class NetgsmSmsServisi implements SmsServisi {
  @override
  void smsYolla(String gsm, String text) {
    print("SMS iletildi: " + gsm);
  }
}






abstract class OdemeYontemi {
  void ode(double tutar);
}

class KrediKartiOdeme implements OdemeYontemi {
  @override
  void ode(double tutar) {
    print("$tutar TL Kredi kartindan POS ile cekildi.");
  }
}

abstract class Veritabani {
  void kaydet(String sql);
}

class SqliteVeritabani implements Veritabani {
  @override
  void kaydet(String sql) {
    print("DB calistirildi: " + sql);
  }
}



abstract class Indirim {
  double uygula(double toplam);
}


class Indirim10 implements Indirim {
  @override
  double uygula(double toplam) {
    return toplam * 0.90;
  }
}

class Yaz20 implements Indirim {
  @override
  double uygula(double toplam) {
    return toplam * 0.80;
  }
}

class Sepette50 implements Indirim {
  @override
  double uygula(double toplam) {
    return toplam - 50;
  }
}


class SiparisYoneticisi implements SiparisKayitIslemi,OdemeIslemi,KargoIslemi,MailIslemi,SmsIslemi,FaturaIslemi {
  final Veritabani db;
  final MailServisi mailci;
  final SmsServisi smsci;

  SiparisYoneticisi(this.db, this.mailci, this.smsci);

  @override
  void siparisKaydet(String orderId, double tutar) {
    db.kaydet("INSERT INTO siparisler VALUES ('$orderId', $tutar)");
  }

  @override
  void odemeYap(OdemeYontemi odemeYontemi, double tutar) {
    odemeYontemi.ode(tutar);
  }

  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres");
  }

  @override
  void mailGonder(String email, String mesaj) {
    mailci.mailAt(email, mesaj);
  }

  @override
  void smsGonder(String tel, String mesaj) {
    smsci.smsYolla(tel, mesaj);
  }

  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }

  void siparisTamamla(
      String orderId,
      List<Urun> sepet,
      OdemeYontemi odemeYontemi,
      String musteriAdi,
      String email,
      String tel,
      String adres,
      Indirim indirim) {
    
    double toplam = 0;

    for (var i = 0; i < sepet.length; i++) {
      if (sepet[i].stok <= 0) {
        print("Hata: " + sepet[i].ad + " tukenmis!");
        return;
      }
      toplam += sepet[i].fiyat;
      toplam += sepet[i].kargoUcretiHesapla();
      sepet[i].stok--;
    }

    toplam = indirim.uygula(toplam);

    double kdv = toplam * 0.20;
    double sonTutar = toplam + kdv;

    odemeYap(odemeYontemi, sonTutar);
    siparisKaydet(orderId, sonTutar);
    faturaYazdir(orderId);
    mailGonder(email, "Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL");
    smsGonder(tel, "Siparisiniz onaylandi: $orderId");
    kargoGonder(orderId, adres);
  }
}

void main() {
  var siparisci = SiparisYoneticisi(
    SqliteVeritabani(),
    SmtpMailServisi(),
    NetgsmSmsServisi(),
  );

  var urun1 = Urun("1", "Kablosuz Mouse", 450.0, 5, "FIZIKSEL");
  var urun2 = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100);

  var sepet = <Urun>[urun1, urun2];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    KrediKartiOdeme(),
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadikoy / Istanbul",
    Indirim10(),
  );
}
