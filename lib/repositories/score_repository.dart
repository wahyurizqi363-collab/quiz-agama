import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../models/score_entry.dart';

class ScoreRepository {
  final FirebaseFirestore _db;

  ScoreRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('scores');

  String _docId(String uid, String category) =>
      '${uid}_${category.replaceAll(RegExp(r'[^A-Za-z0-9]'), '_')}';

  /// Seluruh skor, ter-update otomatis (real-time).
  Stream<List<ScoreEntry>> watchAll() => _col
      .snapshots()
      .map((snap) => snap.docs.map(_fromDoc).toList());

  /// Simpan hanya jika lebih baik dari skor terbaik sebelumnya.
  Future<void> submitBest(
    AppUser user,
    String category,
    int score,
    int total,
  ) async {
    final ref = _col.doc(_docId(user.uid, category));
    final snap = await ref.get();
    final best = snap.exists
        ? ((snap.data()!['score'] as num?)?.toInt() ?? -1)
        : -1;
    if (score <= best) return;

    await ref.set({
      'uid': user.uid,
      'userName': user.name,
      'category': category,
      'score': score,
      'total': total,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteEntry(String id) => _col.doc(id).delete();

  Future<void> deleteAllOfUser(String uid) async {
    final snap = await _col.where('uid', isEqualTo: uid).get();
    final batch = _db.batch();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();
  }

  ScoreEntry _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return ScoreEntry(
      id: doc.id,
      uid: (d['uid'] as String?) ?? '',
      userName: (d['userName'] as String?) ?? 'Tanpa Nama',
      category: (d['category'] as String?) ?? '',
      score: (d['score'] as num?)?.toInt() ?? 0,
      total: (d['total'] as num?)?.toInt() ?? 0,
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
