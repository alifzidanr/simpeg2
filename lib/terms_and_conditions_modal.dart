import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button and title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Syarat dan Ketentuan',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the modal
                },
              ),
            ],
          ),
          SizedBox(height: 10),

          // Terms and Conditions content in a limited-height container
          Container(
            height: MediaQuery.of(context).size.height * 0.6, // Limit height to 60% of the screen
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionContent(
                    '''Peraturan mengenai Syarat dan Ketentuan dimana anda menggunakan layanan Aplikasi Sistem Informasi Kepegawaian Al Azhar. Jika Anda tidak setuju atas Syarat dan Ketentuan ini, silahkan tidak menggunakan layanan aplikasi ini.''',
                  ),

                  _buildSectionTitle('1. Umum'),
                   _buildSectionContent(
                    '''Syarat dan Ketentuan ini mengatur penggunaan seluruh layanan dan fitur-fitur yang tersedia di aplikasi Sistem Informasi Kepegawaian Al Azhar. Berikut segala informasi, tulisan, gambar atau material lainnya yang diunggah (upload), diunduh (download) atau ditampilkan dalam Aplikasi Sistem Informasi Kepegawaian Al Azhar yang secara bersama-sama disebut sebagai “Layanan”.''',
                  ),

                  SizedBox(height: 10), // Extra spacing between paragraphs

                  _buildSectionContent(
                    '''Layanan ini dimiliki, dioperasikan dan diselenggarakan oleh Yayasan Pesantren Islam (YPI) Al Azhar, Yayasan yang didirikan berdasarkan hukum Republik Indonesia yang telah memperoleh izin bergerak di bidang Pendidikan, Dakwah dan Sosial. Aplikasi ini digunakan oleh pegawai dibawah manajemen YPI Al Azhar di seluruh Indonesia mencakup perangkat dan platform yang ditampilkan di dalam aplikasi baik yang sudah ada atau di kemudian hari.''',
                  ),
                  _buildListItem('1.1 ', 'Memberikan persetujuan kepada Sistem Informasi Kepegawaian Al Azhar untuk menggunakan informasi yang diberikan untuk tujuan sebagaimana diatur dalam Syarat dan Ketentuan ini.'),
                  _buildListItem('1.2 ', 'Melepaskan hak untuk menggugat maupun menuntut atas segala pernyataan, kekeliruan, ketidaktepatan atau kekurangan dalam setiap konten yang dicantumkan dan disampaikan dalam aplikasi Sistem Informasi Kepegawaian Al Azhar.'),
                   SizedBox(height: 10),
                  _buildSectionContent(
                    '''Apabila Anda memiliki pertanyaan sehubungan dengan Syarat Ketentuan ini, Anda dapat menghubungi kami pada bagian Kontak Kami di bagian bawah Syarat Ketentuan ini.''',),
 _buildSectionContent('''Syarat dan Ketentuan ini dapat diubah, modifikasi, tambah, hapus atau koreksi setiap saat dan setiap perubahan itu berlaku sejak saat Sistem Informasi Kepegawaian Al Azhar nyatakan berlaku atau pada waktu lain yang ditetapkan. Sistem Informasi Kepegawaian Al Azhar tidak memberikan pemberitahuan apabila terjadi perubahan Syarat dan Ketentuan dan karenanya kami menganjurkan untuk mengunjungi Layanan Sistem Informasi Kepegawaian Al Azhar secara berkala agar dapat mengetahui adanya perubahan tersebut.''',
                  ),

                  _buildSectionTitle('2. Pemberian Layanan Oleh Sistem Informasi Kepegawaian Al Azhar'),
                  _buildSectionContent(
                    '''Sistem Informasi Kepegawaian Al Azhar dengan ini menjamin kerahasiaan untuk menjaga informasi yang telah anda berikan, kecuali apa yang akan akan digunakan dalam Layanan Sistem Informasi Kepegawaian Al Azhar.''',),
 _buildSectionContent('''Akses Anda terhadap Layanan Sistem Informasi Kepegawaian Al Azhar tidak selalu tersedia sewaktu-waktu, karena terhadap Layanan dapat dilakukan perbaikan, perawatan, penambahan konten baru, fasilitas atau layanan lainnya. Sistem Informasi Kepegawaian Al Azhar akan memberikan pemberitahuan apabila sewaktu-waktu terjadi pembatasan akses.''',),
 _buildSectionContent('''Sistem Informasi Kepegawaian Al Azhar tidak dapat menjamin bahwa layanan akan bebas dari gangguan, kerusakan atau memiliki masalah server, bebas dari virus dan masalah lainnya. Apabila terjadi gangguan dalam Layanan Sistem Informasi Kepegawaian Al Azhar, Anda harus memberi tahu kepada kami agar dapat dilakukan perbaikan secepat mungkin.''',
                  ),

                  _buildSectionTitle('3. Penyangkalan / Disclaimer'),
                  _buildSectionContent(
                    '''Sistem Informasi Kepegawaian Al Azhar tidak dapat digugat maupun dituntut atas segala pernyataan, kekeliruan, ketidaktepatan atau kekurangan dalam setiap informasi yang dicantumkan dan disampaikan dalam Aplikasi Sistem Informasi Kepegawaian Al Azhar.''',
                  ),

                  _buildSectionTitle('4. Iklan'),
                  _buildSectionContent(
                    '''Dalam Layanan Sistem Informasi Kepegawaian Al Azhar mungkin saja terdapat iklan yang dilakukan oleh pengguna sponsor pihak ketiga (“Pengiklan”)..''',),
 _buildSectionContent('''Sistem Informasi Kepegawaian Al Azhar berhak menghapus atau mengubah atau mengganti atau menolak pemasangan materi iklan oleh Pengiklan dengan memberikan alasan kepada pengiklan..''',),
 _buildSectionContent('''Pengiklan bertanggung jawab atas materi iklan dalam Layanan Sistem Informasi Kepegawaian Al Azhar, dan karenanya Pengiklan melepaskan Sistem Informasi Kepegawaian Al Azhar dari tanggung jawab atas materi iklan yang dilakukan oleh Pengiklan.''',
                  ),

                  _buildSectionTitle('5. Pembayaran Fee'),
                  _buildSectionContent(
                    '''Pemberian Layanan pada dasarnya adalah gratis.
Khusus untuk pemberian Layanan Services, akan didasarkan pada perjanjian terpisah di luar dari Syarat dan Ketentuan ini.''',
                  ),

                  _buildSectionTitle('6. Pelepasan Hak'),
                  _buildSectionContent(
                    '''Anda setuju bahwa pada dasarnya Layanan Sistem Informasi Kepegawaian Al Azhar adalah bertujuan untuk pengelolaan data pegawai dan karenanya Anda dengan ini melepaskan Sistem Informasi Kepegawaian Al Azhar dan pihak manapun yang bekerjasama dengan Sistem Informasi Kepegawaian Al Azhar atas segala tanggung jawab hukum sehubungan dengan pemberian Layanan dalam Sistem Informasi Kepegawaian Al Azhar..''',),
 _buildSectionContent('''Apabila terdapat artikel yang setidak-tidaknya terdapat ketidaktepatan atas fakta dan/atau penggunaan peraturan dan/atau penggunaan sumber tulisan dan kejadian lainnya yang dapat mengakibatkan pemberian Layanan menjadi merugikan pihak lain, maka Anda dapat meminta kepada Sistem Informasi Kepegawaian Al Azhar untuk tidak menampilkan artikel dalam Layanan dengan mengirimkan email keberatan yang ditujukan kepada alamat email sebagaimana dimaksud dalam Kontak Kami di bagian paling bawah Syarat dan Ketentuan ini.''',
                  ),

                  _buildSectionTitle('7. Layanan Tersedia “As Is”'),
                  _buildSectionContent(
                    '''Seluruh informasi, atau konten dalam bentuk apapun yang tersedia pada aplikasi Sistem Informasi Kepegawaian Al Azhar disediakan sebagaimana adanya dan sebagaimana tersedia tanpa adanya jaminan apapun baik tersirat maupun tersurat.''',
                  ),

                  _buildSectionTitle('8. Keamanan'),
                  _buildSectionContent(
                    '''Dalam mengakses informasi Akun Anda dalam Layanan Sistem Informasi Kepegawaian Al Azhar, Anda akan menggunakan akses Secure Server Layer (SSL) yang akan mengenkripsi informasi yang ditampilkan dalam Layanan Sistem Informasi Kepegawaian Al Azhar.''',),
 _buildSectionContent('''Sistem Informasi Kepegawaian Al Azhar tidak bisa menjamin seberapa kuat atau efektifnya enkripsi ini dan Sistem Informasi Kepegawaian Al Azhar tidak akan bertanggung jawab atas masalah yang terjadi akibat pengaksesan tanpa ijin dari informasi yang Anda sediakan.''',
                  ),

                  _buildSectionTitle('9. Hukum Yang Berlaku'),
                  _buildSectionContent(
                    '''Hukum yang berlaku dalam Syarat dan Ketentuan ini adalah Hukum Negara Republik Indonesia.''',
                  ),

                  _buildSectionTitle('10. Lain-lain'),
                  _buildSectionContent(
                    '''Versi asli dari Syarat dan Ketentuan ini adalah dalam Bahasa Indonesia, dan dapat diterjemahkan ke dalam bahasa lain. Versi terjemahan dibuat untuk memberi kemudahan bagi pengguna asing, dan tidak bisa dianggap sebagai terjemahan resmi.''',),
 _buildSectionContent('''Jika ditemukan adanya perbedaan antara versi Bahasa Indonesia dan versi bahasa lainnya dari syarat dan ketentuan ini, maka yang berlaku dan mengikat adalah versi Bahasa Indonesia..''',),
 _buildSectionContent('''Setiap perselisihan dalam Layanan Sistem Informasi Kepegawaian Al Azhar akan diselesaikan secara musyawarah mufakat dan apabila tidak tercapai musyawarah mufakat, maka akan diselesaikan di badan arbitrase.''',
                  ),

                  _buildSectionTitle('11. Kontak Kami'),
                  _buildSectionContent(
                    '''Apabila Anda memiliki pertanyaan terkait dengan Syarat dan Ketentuan ini, hubungi kami di: bag_itd@al-azhar.or.id.''',
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8), // Space between the content and the button

          Align(
  alignment: Alignment.center, // Center the button
  child: SizedBox(
    width: MediaQuery.of(context).size.width * 0.8, // Reduce the width to 90% of the modal's width
    child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop(); // Close the modal when pressed
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0053C5), // Set button color to the requested one
        padding: EdgeInsets.symmetric(vertical: 10.0), // Adjust padding to make the button smaller
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded rectangle shape
        ),
      ),
      child: Text(
        'Setuju',
        style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color
        ),
      ),
    ),
  ),
)

        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Add space after each paragraph
      child: Text(
        content,
        style: GoogleFonts.roboto(
          fontSize: 16,
          height: 1.5, // Increase line height slightly for readability
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildListItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 8.0), // Special indentation
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: GoogleFonts.roboto(fontSize: 16),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 16,
                height: 1.5, // Ensure same height for lists
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

void _showTermsAndConditionsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the modal to be scrollable with content
    isDismissible: true, // Allows tapping outside to close the modal
    enableDrag: true, // Allows dragging the modal down to close
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: TermsAndConditionsModal(),
      );
    },
  );
}
