import 'package:floor/floor.dart';
import 'package:learning_english_app/login/models/dataset/token_dataset.dart';

@dao
abstract class TokenDao {
  @Query('SELECT * FROM TOKEN WHERE type = :type')
  Stream<TokenDataset?> getRefreshToken(String type);

  @insert
  Future<int> insertToken(TokenDataset token);

  @Query('DELETE FROM TOKEN where type = :type')
  Future<void> deleteRToken(String type);
}
