# Görev 1
Akış şeması açıklaması için:
`16 Eylül Teslimli Ödev-Görev1.pdf`

### Görev 1-Pseudocode:

STEP 1. START
STEP 2. Uygulamayı Aç.
STEP 3. IF Kullanıcı giriş yapmış mı? = YES THEN
GO TO STEP 6
ELSE
GO TO STEP 4.
STEP 4. Giriş Ekranını Göster.
STEP 5. IF Giriş başarılı oldu mu? = YES THEN
GO TO STEP 6
ELSE
GO TO STEP 4.
STEP 6. Ürünleri Göster.
STEP 7. Ürün Seç.
STEP 8. Sepete Ekle.
STEP 9. IF Başka ürün eklenecek mi? = YES THEN
GO TO STEP 7
ELSE
GO TO STEP 10.
STEP 10. Sepettekileri Göster.
STEP 11. IF Sipariş onaylandı mı? = YES THEN
GO TO STEP 12
ELSE
GO TO STEP 6.
STEP 12. Sepet tutarını hesapla.
STEP 13. IF Bakiye yeterli mi? = YES THEN
GO TO STEP 17
ELSE
GO TO STEP 14.
STEP 14. Bakiye Yükle Uyarısı.
STEP 15. IF Bakiye yüklendi mi? = YES THEN
GO TO STEP 13
ELSE
GO TO STEP 10.
STEP 16. CHECK Bakiye again.
STEP 17. Sipariş Paketini Sunucuya Gönder.
STEP 18. Bakiyeden Düş.
STEP 19. Sipariş onaylandı mesajını göster.
STEP 20. END

# Görev 2 

```C#
Görev-2
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
public class Program
{
	public static void Main(string[] args)
	{
	var builder = WebApplication.CreateBuilder(args);
	builder.Services.AddControllers();
	var app = builder.Build();
	app.MapControllers();
	app.Run();
	}
}

[ApiController]
[Route("api/v1")]

public class KahveController : ControllerBase
{
	[HttpPost("siparisler")]
	public IActionResult SiparisOlustur([FromBody] Siparis siparis)
	{
		string token = Request.Headers["Authorization"].ToString();

		if (string.IsNullOrEmpty(token) || !token.StartsWith("Bearer "))
		{
			return Unauthorized();
		}

		return StatusCode(201, siparis);
	}

	[HttpGet("kullanici/bakiye")]

	public IActionResult BakiyeGetir()
	{
		Bakiye bakiye = new Bakiye();
		bakiye.Miktar = 185.50;
		bakiye.ParaBirimi = "TRY";
		return Ok(bakiye);
	}

}

public class Siparis
{
	[JsonPropertyName("kahve_adi")]
	public string KahveAdi { get; set; }
	[JsonPropertyName("boyut")]
	public string Boyut { get; set; }
	[JsonPropertyName("adet")]
	public int Adet { get; set; }
	[JsonPropertyName("toplam_tutar")]
	public double ToplamTutar { get; set; }
}

public class Bakiye
{
[JsonPropertyName("bakiye")]
public double Miktar { get; set; }
[JsonPropertyName("para_birimi")]
public string ParaBirimi { get; set; }
}

```
İdempotent kısaca 1 işlemi 1 kerede 1000 kerede yapsan sonucun değişmemesidir. Programda örnek teşkil ettiği
gibi GET işlemi POST a nispeten bir şeyi değiştirmeyi değil veriyi isteme üzerinedir, bu işlem 1000 kerede
yapılsa aynı şekilde olmaya devam eder.

POST ise idempotent değildir çünkü aynı istek tekrar gönderdilirse bu defa yeni bir sipariş oluşturabilir.

# Görev 3

GÖREV 3: Clean Code & SOLID Prensip Teşhisi (25 Puan)

Aşağıda junior bir geliştirici tarafından yazılmış temsili bir sipariş sınıfı yer almaktadır:

class KahveSiparisYoneticisi {
void sepetHesaplaVeIndirimUygula() { ... }
void krediKartindanTahsilatYap() { ... }
void siparisiVeritabaninaKaydet() { ... }
	void musteriyiSmsIleBilgilendir() { ... }

double indirimHesapla(String musteriTipi, double tutar){
if (musteriTipi == "OGRENCI") return tutar * 0.80;
else if (musteriTipi == "OGRETMEN")
return tutar * 0.85;
else return tutar; }
}

Soru:
1. Bu sınıfta Single Responsibility Principle (SRP - Tek Sorumluluk) nasıl ihlal edilmiştir? Sınıfı
hangi küçük parçalara bölmeliyiz? (Kod yazmanıza gerek yoktur, 2 cümleyle açıklayın).
2. indirimHesapla fonksiyonunda yarın yeni bir müşteri tipi (örneğin "DOKTOR" ) geldiğinde ifelse
kodunu değiştirmek zorunda kalmak hangi SOLID prensibine aykırıdır? (Open/Closed
Principle - OCP).

Cevap-1:
SRP ihlalinin olabilmesi için adından mütevellit Single Responsibility Principle yani bir class
yapısına birden fazla birbirinden farklı sorumluluklar ve işler vermeniz gerekir.
KahveSiparisYoneticisi aynı anda indirim, kredi kartı çekimi, veri tabanı işlemi ve sms gönderimini
üstlenmektedir. SRP’nin ihlalinde bir kodu güncellemek için kendisiyle alakalı kod yapısına
dokunduğumuzda aynı zamanda iç içe geçmiş birçok kod yapısının bulunduğu programa da
müdahale etmek zorunda kalırız, oysaki ayrı class lar da her işlem kendi bünyesinde değişikliğe
gittiğinden kodun yapısında yapılan değişiklikler daha kolay gerçekleştirilmiş olacaktır.
Sınıfı küçük parçalara şu şekilde böleriz tek bir class da kullanmak yerine 4 ayrı class’lara böleriz.
Artık KahveSiparisYoneticisi yerine SepetHesabı, KrediKartıTahsilatı, VeriTabaniKayit,
SmsBilgilendirme şeklinde bölebiliriz. Kodun alakada olduğu bölümleri de revize ederiz.

Cevap-2:
Soruda da değinildiği gibi OCP yani Open/Closed Principle’ına aykırı bir durum vardır ortada.
Çünkü yeni müşteri tipi gelmesi demek koda ekleme yapmak demektir oysaki biz OCP ile
programın değişikliğe kapalı genişletilmeye açık olmasını isteriz oysaki DOKTOR’u eklemek
demek if-else yapısını değiştirip araya yeni bir kod ekleyip kodu değiştirmek demektir.
