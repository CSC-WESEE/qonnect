import 'package:get_it/get_it.dart';
import 'package:qonnect/models/OwnUserDetialsModel.dart';
import 'package:qonnect/models/chat/chat_model.dart';
import 'package:qonnect/models/chat/chat_model_repository.dart';
import 'package:qonnect/services/auth/authentication_repository.dart';
import 'package:qonnect/services/socket_connection/socket_service.dart';
import 'package:qonnect/utils/handlers/dio_handler.dart';
import 'package:qonnect/routes/router.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final dioHandler = DioHandler();
  await dioHandler.initialize();
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.checkIfAuthenticated();
  final socketService = SocketService();
  socketService.connect();
  final ownUserDetailModel = OwnUserDetailModel();
  ownUserDetailModel.updateOwnUserModel();

  getIt.registerSingleton<DioHandler>(dioHandler);
  getIt.registerSingleton<AuthenticationRepository>(authenticationRepository);
  getIt.registerSingleton<RouterHandler>(RouterHandler());
  getIt.registerSingleton<SocketService>(socketService);
  getIt.registerSingleton<ChatModelRepository>(ChatModelRepository());
  getIt.registerSingleton<OwnUserDetailModel>(ownUserDetailModel);
}
