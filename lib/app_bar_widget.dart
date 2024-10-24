import 'package:flutter/material.dart';
import 'account_settings_page.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

AppBar buildAppBar(GlobalKey<ScaffoldState> scaffoldKey, String title, String idPegawai) {
  return AppBar(
    backgroundColor: Color(0xFF0053C5),
    leading: IconButton(
      icon: Icon(Icons.menu, color: Colors.white),
      onPressed: () {
        scaffoldKey.currentState?.openDrawer();
      },
    ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Roboto',
      ),
    ),
    actions: [
      FutureBuilder<Map<String, dynamic>?> (
        future: DatabaseHelper.instance.getEmployeePromotionInfo(idPegawai),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return IconButton(
              icon: Icon(Icons.notification_important, color: Colors.white),
              onPressed: null,
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            DateTime promotionDate = DateTime.parse(snapshot.data!['tgl_habis']);
            Duration difference = promotionDate.difference(DateTime.now());
            String formattedDate = DateFormat('dd MMM yyyy').format(promotionDate);
            String nip = snapshot.data!['nip'] as String;
            String namaLengkap = snapshot.data!['nama_lengkap'] as String;
            String jabatanPegawai = snapshot.data!['nama_jabatan'] as String;

            bool isDue = difference.inDays <= 90;

            return GestureDetector(
              onTap: () {
                final overlay = Overlay.of(context).context.findRenderObject();
                final renderBox = context.findRenderObject() as RenderBox;
                final size = renderBox.size;
                final position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    position.dx + size.width - 100,
                    position.dy + size.height + 10,
                    position.dx + size.width,
                    position.dy + size.height + 10,
                  ),
                  items: [
                    PopupMenuItem(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kenaikan Golongan',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              difference.isNegative
                                  ? 'Telah lewat ${difference.inDays.abs()} hari'
                                  : '${difference.inDays} hari lagi',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'NIP: $nip',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              namaLengkap,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Jabatan: $jabatanPegawai',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: Tooltip(
                message: difference.isNegative
                    ? 'Overdue Promotion Date: $formattedDate'
                    : 'Upcoming Promotion Date: $formattedDate',
                height: 60.0,
                padding: EdgeInsets.only(top: 12.0, bottom: 8.0, left: 16.0, right: 16.0),
                verticalOffset: 48,
                preferBelow: false,
                child: Icon(
                  Icons.notifications,
                  color: isDue ? Colors.red : Colors.white,
                ),
              ),
            );
          } else {
            return IconButton(
              icon: Icon(Icons.notification_important, color: Colors.white),
              onPressed: null,
            );
          }
        },
      ),
      SizedBox(width: 16),
      IconButton(
        icon: Icon(Icons.account_circle, color: Colors.white),
        onPressed: () {
          // Navigate to AccountSettingsPage with idPegawai
          Navigator.push(
            scaffoldKey.currentContext!,
            MaterialPageRoute(builder: (context) => AccountSettingsPage(idPegawai: idPegawai)),
          );
        },
      ),
    ],
  );
}

extension DatabaseHelperExtension on DatabaseHelper {
  Future<Map<String, dynamic>?> getEmployeePromotionInfo(String idPegawai) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT p.nip, p.nama_lengkap, rj.nama_jabatan, pg.tgl_habis
      FROM t_pegawai AS p
      JOIN t_pegawai_jabatan AS pj ON p.id_pegawai = pj.id_pegawai
      JOIN t_ref_jabatan_pegawai AS rj ON pj.id_ref_jabatan_pegawai = rj.id_ref_jabatan_pegawai
      JOIN t_pegawai_golongan AS pg ON p.id_pegawai = pg.id_pegawai
      WHERE p.id_pegawai = ?
      ORDER BY pg.tgl_habis ASC LIMIT 1
      '''
      , [idPegawai],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}