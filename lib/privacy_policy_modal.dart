import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8, // Limit the modal height to 80% of the screen
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kebijakan Privasi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); // Close the modal
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContent(
                      'Yayasan Pesantren Islam (YPI) Al Azhar merupakan lembaga yang bergerak di bidang pendidikan, dakwah dan sosial membangun aplikasi Sistem Informasi Kepegawaian melalui Bagian Teknologi Informasi & Transformasi Digital sebagai aplikasi yang digunakan di lingkungan internal Pegawai YPI Al Azhar seluruh Indonesia. Layanan aplikasi ini disediakan oleh YPI Al Azhar tanpa biaya dan dimaksudkan untuk digunakan sebagaimana mestinya.',
                    ),
                    SizedBox(height: 10),
                    _buildContent('Halaman Privacy Policy ini digunakan untuk memberi informasi kepada pengunjung aplikasi mengenai kebijakan kami terkait pengumpulan, pengolahan, penggunaan, pengelolaan dan pengungkapan informasi pribadi bagi pengguna layanan kami.'),
                    SizedBox(height: 10),
                    _buildContent('Jika anda memutuskan untuk menggunakan aplikasi ini, maka pada prinsipnya anda telah menyetujui otoritas kami dalam pengumpulan, pengolahan, penggunaan, pengelolaan dan pengungkapan informasi pribadi sesuai dengan kebijakan tersebut. Informasi pribadi yang kami kumpulkan digunakan untuk menyediakan dan meningkatkan layanan. Kami tidak akan menggunakan atau membagikan informasi anda kepada siapapun kecuali sebagaimana dijelaskan dalam Kebijakan Privasi ini.'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Pengelolaan dan Penggunaan Informasi'),
                    _buildContent(
                      'Saat menggunakan layanan kami, kami mungkin meminta anda untuk memberikan informasi pribadi atau tanda pengenal tertentu. Informasi yang kami kumpulkan akan kami simpan dan digunakan seperti yang dijelaskan dalam kebijakan Privasi ini.',
                    ),
                    SizedBox(height: 10),
                    _buildContent('Aplikasi ini juga menggunakan layanan pihak ketiga yang dapat mengumpulkan dan mengelola informasi pribadi yang digunakan untuk mengidentifikasi informasi tersebut selama anda menggunakan layanan Sistem Informasi Kepegawaian. Tautan ke kebijakan privasi penyedia layanan pihak ketiga yang digunakan oleh aplikasi Sistem Informasi Kepegawaian adalah Google Play Services.'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Izin Akses Lokasi'),
                    _buildContent(
                      'Saat menggunakan Aplikasi Sistem Informasi Kepegawaian, untuk menyediakan fitur-fitur dari Aplikasi mungkin akan memerlukan informasi mengenai lokasi anda dengan izin anda terlebih dahulu.',
                    ),
                    SizedBox(height: 10),
                    _buildContent('Kami menggunakan informasi ini untuk menyediakan fitur-fitur dari Layanan aplikasi serta untuk meningkatkan dan menyesuaikan layanan. Informasi ini dapat diunggah ke server Perusahaan dan/atau server Penyedia Layanan atau hanya disimpan di perangkat Anda.'),
                    SizedBox(height: 10),
                    _buildContent('Anda dapat mengaktifkan atau menonaktifkan akses ke informasi ini kapan saja melalui pengaturan perangkat Anda.'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Catatan Aktivitas Data'),
                    _buildContent(
                      'Perlu kami informasikan bahwa setiap anda menggunakan layanan kami, meskipun saat aplikasi sedang bermasalah, kami tetap mengumpulkan data dan informasi (melalui produk pihak ketiga) di ponsel anda yang disebut Log Data.',
                    ),
                    SizedBox(height: 10),
                    _buildContent('Log Data ini dapat mencakup informasi seperti alamat Protokol Internet (“IP”) perangkat anda, nama perangkat, versi OS, konfigurasi aplikasi saat menggunakan layanan kami, waktu dan tanggal penggunaan layanan oleh anda, dan statistik lainnya.'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Cookies'),
                    _buildContent(
                      'Pengertian cookies dalam konteks kebijakan privasi ini adalah file dengan sejumlah kecil data yang biasanya digunakan untuk mengidentifikasi aktivitas pengguna layanan digital. Cookies ini dikirim ke browser anda dari situs web yang anda kunjungi dan disimpan di memori internal perangkat anda.',
                    ),
                    SizedBox(height: 10),
                    _buildContent('Layanan aplikasi Sistem Informasi Kepegawaian tidak menggunakan “cookies” secara eksplisit, tetapi aplikasi ini dapat menggunakan kode dan modul library pihak ketiga yang menggunakan "cookies" untuk mengumpulkan informasi dan meningkatkan layanan mereka. '),
                    SizedBox(height: 10),
                    _buildContent('Anda memiliki pilihan untuk menerima atau menolak cookies ini dan mengetahui kapan cookies dikirim ke perangkat anda. Jika anda memilih untuk menolak cookies kami, anda mungkin tidak dapat menggunakan beberapa bagian dari layanan ini.'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Penyedia Layanan'),
                    _buildContent(
                      'Dalam mengelola aplikasi Sistem Informasi Kepegawaian, kami dapat bekerjasama dengan perusahaan dan individu pihak ketiga untuk beberapa alasan berikut:',
                    ),
                    SizedBox(height: 10),
                    // Add numbered list here
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNumberedItem(1, 'Memfasilitasi layanan kami;'),
                        SizedBox(height: 5),
                        _buildNumberedItem(2, 'Menyediakan layanan atas nama kami;'),
                        SizedBox(height: 5),
                        _buildNumberedItem(3, 'Melakukan layanan yang berhubungan dengan aplikasi; atau'),
                        SizedBox(height: 5),
                        _buildNumberedItem(4, 'Membantu kami dalam menganalisis bagaimana layanan kami digunakan.'),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildContent('Kami ingin memberi tahu pengguna layanan ini bahwa pihak ketiga memiliki akses ke informasi pribadi anda untuk melakukan tugas yang diberikan kepada mereka atas nama Sistem Informasi Kepegawaian. Namun, mereka berkewajiban untuk tidak mengungkapkan atau menggunakan informasi tersebut untuk tujuan lain.'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Keamanan Sistem dan Data'),
                    _buildContent(
                      'Kami menghargai kepercayaan anda dalam memberikan informasi pribadi anda kepada kami, oleh karena itu kami berusaha untuk menggunakan cara yang dapat diterima secara komersial untuk melindunginya. Perlu diingat bahwa tidak ada metode transmisi melalui internet atau metode penyimpanan elektronik yang 100% aman dan andal. Kami tidak dapat menjamin secara mutlak keamanannya.',
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Tautan ke Situs Lain'),
                    _buildContent(
                      'Layanan ini mungkin berisi tautan ke situs lain. Jika anda mengklik tautan pihak ketiga, anda akan diarahkan ke situs tersebut. Perlu diketahui bahwa situs eksternal ini tidak dioperasikan oleh kami. ',
                    ),
                    SizedBox(height: 10),
                    _buildContent('Oleh karena itu, kami sangat menyarankan anda untuk meninjau kebijakan privasi situs web ini. Kami tidak memiliki kendali dan tanggung jawab terhadap konten, kebijakan privasi, atau praktik situs atau layanan pihak ketiga manapun.'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Privasi Anak'),
                    _buildContent(
                      'Layanan ini tidak ditujukan kepada pengguna yang berusia di bawah 13 tahun. Aplikasi ini tidak di desain untuk dengan sengaja mengumpulkan informasi pribadi dari anak-anak di bawah 13 tahun. Jika kami menemukan bahwa seorang anak di bawah 13 tahun telah memberi kami informasi pribadi, kami segera menghapusnya dari server kami.',
                    ),
                    SizedBox(height: 10),
                    _buildContent('Jika anda adalah orang tua atau wali dan anda mengetahui bahwa anak anda telah memberikan informasi pribadi kepada kami, silakan hubungi kami agar kami dapat melakukan tindakan yang diperlukan.'),
                    SizedBox(height: 20),
                    _buildSectionTitle('Perubahan pada Kebijakan Privasi ini'),
                    _buildContent(
                      'Kami dapat memperbarui kebijakan privasi kami dari waktu ke waktu. Oleh karena itu, anda disarankan untuk meninjau halaman ini secara berkala untuk setiap perubahan. Kami akan memberi tahu anda tentang perubahan apa pun dengan memposting Kebijakan Privasi baru di halaman ini. Perubahan ini efektif segera setelah diposting di halaman ini.',
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Hubungi Kami'),
                    _buildContent(
                      'Jika anda memiliki pertanyaan atau saran tentang Kebijakan Privasi kami, jangan ragu untuk menghubungi kami di bag.itd@al-azhar.or.id ',
                    ),
                  ],
                ),
              ),
            ),

            // Add the button below the scrollable content
            Align(
              alignment: Alignment.center, // Center the button
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // Reduce the width to 80% of the modal's width
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the modal when pressed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0053C5), // Set button color
                    padding: EdgeInsets.symmetric(vertical: 10.0), // Adjust padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded rectangle shape
                    ),
                  ),
                  child: Text(
                    'Setuju',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildContent(String content) {
    return Text(
      content,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildNumberedItem(int number, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The number part
        Text(
          '$number. ',
          style: TextStyle(fontSize: 16),
        ),
        // The content part
        Expanded(
          child: Text(
            content,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}

// To show the modal
void showPrivacyPolicyModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,  // Allows closing by tapping outside the modal
    enableDrag: true,     // Allows dragging to close the modal
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return PrivacyPolicyModal();
    },
  );
}
