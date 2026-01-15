import 'package:ai_powered_app/core/network/api.state.dart';
import 'package:ai_powered_app/core/utils/preety.dio.dart';
import 'package:ai_powered_app/data/models/favouriteListBodyModel.dart';
import 'package:ai_powered_app/data/models/favouriteListResModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final favouriteListProvider =
//     FutureProvider.family<FavouriteListResModel, FavouriteListBodyModel>((
//       ref,
//       body,
//     ) async {
//       final service = APIStateNetwork(createDio());
//       return await service.favouriteList(body);
//     });

final favouriteListProvider = FutureProvider.family
    .autoDispose<FavouriteListResModel, int>((ref, userId) async {
      final service = APIStateNetwork(createDio());
      // create model here before sending to service
      final body = FavouriteListBodyModel(userId: userId);
      return await service.favouriteList(body);
    });
