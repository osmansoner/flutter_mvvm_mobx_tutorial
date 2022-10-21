import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_mvvm/features/post/view-model/post_view_model.dart';

class PostView extends StatelessWidget {
  final _viewModel = PostViewModel();

  PostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _viewModel.getAllPost();
        },
        child: const Icon(Icons.list),
      ),
      body: buildListViewPost(),
    );
  }

  Center buildCenterLikeCubic() {
    return Center(child: Observer(builder: (_) {
      switch (_viewModel.pageState) {
        case PageState.LOADING:
          return const CircularProgressIndicator();
        case PageState.SUCCESS:
          return buildListViewPost();

        case PageState.ERROR:
          return const Center(
            child: Text('Error'),
          );

        default:
          return const FlutterLogo();
      }
    }));
  }

  Widget buildListViewPost() {
    return Observer(builder: (_) {
      return ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _viewModel.posts.length,
        itemBuilder: (context, index) => buildListTileCard(index),
      );
    });
  }

  ListTile buildListTileCard(int index) {
    return ListTile(
      title: Text(_viewModel.posts[index].title!),
      subtitle: Text(_viewModel.posts[index].body!),
      trailing: Text(_viewModel.posts[index].userId.toString()),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('ASE MVVM'),
      leading: Observer(builder: (_) {
        return Visibility(
          visible: _viewModel.isServiceRequestLoading,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      }),
    );
  }
}
