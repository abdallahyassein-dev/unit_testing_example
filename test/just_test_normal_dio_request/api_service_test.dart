import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:unit_testing_example/normal_dio_request/api_service/api_service.dart';

import 'api_service_test.mocks.dart';

// Run the following command to generate the mocks:
// flutter pub run build_runner build

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late ApiService apiService;

  setUp(() {
    mockDio = MockDio();
    apiService = ApiService(mockDio);
  });

  group('fetchPosts', () {
    test('returns a list of posts if the http call completes successfully',
        () async {
      when(mockDio.get('https://jsonplaceholder.typicode.com/posts'))
          .thenAnswer(
        (_) async => Response(
          data: [
            {'id': 1, 'title': 'Test Post 1', 'body': 'This is a test post'},
            {
              'id': 2,
              'title': 'Test Post 2',
              'body': 'This is another test post'
            },
          ],
          statusCode: 200,
          requestOptions: RequestOptions(
              path: 'https://jsonplaceholder.typicode.com/posts'),
        ),
      );

      final posts = await apiService.fetchPosts();

      expect(posts.length, 2);
      expect(posts[0].title, 'Test Post 1');
      expect(posts[1].title, 'Test Post 2');
    });

    test('throws an exception if the http call completes with an error',
        () async {
      when(mockDio.get('https://jsonplaceholder.typicode.com/posts')).thenThrow(
        DioException(
          requestOptions: RequestOptions(
              path: 'https://jsonplaceholder.typicode.com/posts'),
          error: 'Something went wrong',
        ),
      );

      expect(apiService.fetchPosts(), throwsA(isInstanceOf<Exception>()));
    });

    test('throws an exception if the http call returns a non-200 status code',
        () async {
      when(mockDio.get('https://jsonplaceholder.typicode.com/posts'))
          .thenAnswer(
        (_) async => Response(
          data: 'Not Found',
          statusCode: 404,
          requestOptions: RequestOptions(
              path: 'https://jsonplaceholder.typicode.com/posts'),
        ),
      );

      expect(apiService.fetchPosts(), throwsA(isInstanceOf<Exception>()));
    });
  });
}
