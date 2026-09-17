
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

//Bu kısım temiz.   
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok, "DIJITAL");

  @override
  double kargoUcretiHesapla() {
    throw Exception("Dijital urunlerde kargo hesaplanamaz!");
  }
}

//Bu kısımda LISKOV Prensibine karşı bir ihlal söz konusudur override edildiğinde kargoUcretiHesapla değeri üst sınıfda double sayı olarak geri ...
//dönüş yaparken burada bir exception fırlatmaktadır bu alt sınıfın üst sınıfdan beklendiği gibi bir davranış sergilememesine yol açar çünkü ...
//beklenen double değerken exception olmuştur.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


abstract class ISiparisIslemleri {
  void siparisKaydet(String orderId, double tutar);
  void odemeYap(String tip, double tutar);
  void kargoGonder(String orderId, String adres);
  void mailGonder(String email, String mesaj);
  void smsGonder(String tel, String mesaj);
  void faturaYazdir(String orderId);
}

//Burada iki kusur bulunmaktadır birincisi SRP yani tek sorumluluk prensibini ihlal ederek sınıfın içine birden fazla sorumluluk eklenmiştir
//İkinci mesele ise burda birden fazla sorumluluk alanı olduğundan kullanılmayacak methodları içeren arayüzlerde ihtiyacı olmasa bile implemente ...
//etmek mecburiyetinde kalınacaktır bu da kodun sadeliğini bozarak gereksiz yere şişirecektir ve kod karmaşasına arttıracaktır.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class SqliteVeritabani {
  void kaydet(String sql) {
    print("DB calistirildi: " + sql);
  }
}

//Bu kısım temiz.  


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class SmtpMailServisi {
  void mailAt(String to, String body) {
    print("SMTP Mail gonderildi: " + to);
  }
}

//Bu kısım temiz.  


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class NetgsmSmsServisi {
  void smsYolla(String gsm, String text) {
    print("SMS iletildi: " + gsm);
  }
}

//Bu kısım temiz.  


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class SiparisYoneticisi implements ISiparisIslemleri {
  SqliteVeritabani db = SqliteVeritabani();
  SmtpMailServisi mailci = SmtpMailServisi();
  NetgsmSmsServisi smsci = NetgsmSmsServisi();

//Yukarıda bahsi geçen ISiparisIslemleri burada implemente edilmiştir biz bunun için SRP ihlali var demiştik burada birden fazla sorumluluğun ...
//olması karışıklığa sebebiyet verir ve okunurluğu düşürür. ISiparisIslemleri classında yapılan bir değişiklik bu sınıfıda etkiler. Ayrı ...
//ayrı parçalar olduğunda değişim ve güncellemeler daha local halledilirken iç içe yapılarda bu değişimin takibi ve düzeltimesi giderek zorlaşır.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void siparisKaydet(String orderId, double tutar) {
    db.kaydet("INSERT INTO siparisler VALUES ('$orderId', $tutar)");
  }

//Burada DIP bağımlılığı ihlal edilmiştir söz gelimi db nesnesinin türü değiştiğinde üst seviye olan SiparisYoneticisi sınıfınında ...
//kodunun değişmesi gerekecektir.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void odemeYap(String tip, double tutar) {
    if (tip == "KREDI_KARTI") {
      print("$tutar TL Kredi kartindan POS ile cekildi.");
    } else if (tip == "HAVALE") {
      print("$tutar TL Havale kontrol edildi.");
    } else if (tip == "KAPIDA_ODEME") {
      print("$tutar TL Kapida odeme tahsil edilecek (Komisyon +15 TL).");
    } else if (tip == "CRYPTO") {
      print("$tutar TL USDT transferi onaylandi.");
    } else {
      print("Gecersiz odeme yontemi");
    }
  }

// Burada OCP problemi vardır yani Open/Close Principle, if ve elselerle kurulmuş bir kod yapısında biz sistemi değiştirmek yerine gelişime ...
// açık tutmak isteriz bu kod yapısında yeni bir ödeme yöntemi eklemek isteseydik şayet else i bozup araya else if koymak durumunda kalacaktık ...
// yani yeni bir özellik getirmek yerine olanı bozmuş olacaktık bu basit örnekte düzeltmesi kolay gibi gözüksede karmaşık problemlerde ekleme ...
// ve çıkarma yapmamız kod karmaşasına sebebiyet vericekti.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres");
  }

//Kargo gönderme aşamasında OCP ihlali gerçekleşir çünkü geliştirici MNG değilde farklı kargo lar eklemek istediğinde...
//"MNG Kargo takip fis basildi" yazan yazıyı kaldırmak yada kaldırmıyorsa ona uygun bir kod düzeniyle değiştirmek zorundadır.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void mailGonder(String email, String mesaj) {
    mailci.mailAt(email, mesaj);
  }

  @override
  void smsGonder(String tel, String mesaj) {
    smsci.smsYolla(tel, mesaj);
  }

//Bu bölümde göze çarpın iki problem vardır SmtpMailServisi mailci = SmtpMailServisi(); kodu ve NetgsmSmsServisi smsci = NetgsmSmsServisi(); ...
//Bu ikisi de yukarıda benzer bir örnekte değindğimiz üzere burada da DIP problemi mevcuttur mailci ve smsci nesneleri değişirse bağlı ...
//olduğu SiparisYoneticisi classınında kodunun değişmesi gerekir.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void siparisTamamla(
      String orderId,
      List<Urun> sepet,
      String odemeTipi,
      String musteriAdi,
      String email,
      String tel,
      String adres,
      String kuponKodu) {
    
      //void içine birden fazla parametre yığılmış ve birbiriyle alakalı gibi gözüksede ilk başta aşağılara doğru indikçe şunu farkediyoruz.


    double toplam = 0;

    for (var i = 0; i < sepet.length; i++) {
      if (sepet[i].stok <= 0) {
        print("Hata: " + sepet[i].ad + " tukenmis!");
        return;
      }  // burada stok kontrolü yapıyor bu kodda güncelleme yapılmak istense yada uygulama daha da geliştirilmek istense her defasında ...
         // siparisTamamla methodu üzerinde oynamalar yapmak gerekicek bu da SRP ihlalinin varlığını gösterir.
      toplam += sepet[i].fiyat;
      toplam += sepet[i].kargoUcretiHesapla();
      sepet[i].stok--;
    }

    if (kuponKodu == "INDIRIM10") {
      toplam = toplam * 0.90;
    } else if (kuponKodu == "YAZ20") {
      toplam = toplam * 0.80;
    } else if (kuponKodu == "SEPETTE50") {
      toplam = toplam - 50;
    }

    double kdv = toplam * 0.20;
    double sonTutar = toplam + kdv;

    //indirim yaparken hazır if, else if, else blokları kullanarak OCP ihlali yapılmaktadır çünkü geliştirilmek istenen uygulama da indrimler ...
    //değişebilir promosyonlar özel günler bayramlara göre indirimler değişebilir yada stokların erimesi mevsim geçişi gibi sebeplerle bu ...
    //kodlarla oynanması gerekebilir.

    odemeYap(odemeTipi, sonTutar);
    siparisKaydet(orderId, sonTutar);
    faturaYazdir(orderId);
    mailGonder(email, "Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL");
    smsGonder(tel, "Siparisiniz onaylandi: $orderId");
    kargoGonder(orderId, adres);
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


void main() {
  var siparisci = SiparisYoneticisi();

  var urun1 = Urun("1", "Kablosuz Mouse", 450.0, 5, "FIZIKSEL"); 
  var urun2 = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100); // burada Urun nesnesi ne girilen parametrelerden urun2 değişkenine ...
  //5.parametre olarak kullanıcı girdisi istenilmez tip değşkenine DIJITAL stringi super ile otomatik gönderilir ve kargoUcretiHesapla() 
  //methodu return olarak double değil Exception fırlatır.

  var sepet = <Urun>[urun1, urun2];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    "KREDI_KARTI",
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadikoy / Istanbul",
    "INDIRIM10",
  );
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////