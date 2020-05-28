import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  // PostStore _postStore;
  // ThemeStore _themeStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    // _themeStore = Provider.of<ThemeStore>(context);
    // _postStore = Provider.of<PostStore>(context);

    // // check to see if already called api
    // if (!_postStore.loading) {
    //   _postStore.getPosts();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------
  Widget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('home_tv_posts')),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildSettingsButton(),
    ];
  }

  Widget _buildSettingsButton() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(Routes.settings);
      },
      icon: Icon(
        Icons.settings,
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return ListTile();
    // return Observer(
    //   builder: (context) {
    //     return _postStore.loading
    //         ? CustomProgressIndicatorWidget()
    //         : Material(child: _buildListView());
    //   },
    // );
  }

  Widget _buildListView() {
    // return _postStore.postList != null
    //     ? ListView.separated(
    //         itemCount: _postStore.postList.posts.length,
    //         separatorBuilder: (context, position) {
    //           return Divider();
    //         },
    //         itemBuilder: (context, position) {
    //           return _buildListItem(position);
    //         },
    //       )
    //     : Center(
    //         child: Text(
    //           AppLocalizations.of(context).translate('home_tv_no_post_found'),
    //         ),
    //       );
  }

  Widget _buildListItem(int position) {
    // return ListTile(
    //   dense: true,
    //   leading: Icon(Icons.cloud_circle),
    //   title: Text(
    //     '${_postStore.postList.posts[position].title}',
    //     maxLines: 1,
    //     overflow: TextOverflow.ellipsis,
    //     softWrap: false,
    //     style: Theme.of(context).textTheme.title,
    //   ),
    //   subtitle: Text(
    //     '${_postStore.postList.posts[position].body}',
    //     maxLines: 1,
    //     overflow: TextOverflow.ellipsis,
    //     softWrap: false,
    //   ),
    // );
  }

  Widget _handleErrorMessage() {
    return ListTile();

    // return Observer(
    //   builder: (context) {
    //     if (_postStore.errorStore.errorMessage.isNotEmpty) {
    //       return _showErrorMessage(_postStore.errorStore.errorMessage);
    //     }

    //     return SizedBox.shrink();
    //   },
    // );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    // Future.delayed(Duration(milliseconds: 0), () {
    //   if (message != null && message.isNotEmpty) {
    //     FlushbarHelper.createError(
    //       message: message,
    //       title: AppLocalizations.of(context).translate('home_tv_error'),
    //       duration: Duration(seconds: 3),
    //     )..show(context);
    //   }
    // });

    // return SizedBox.shrink();
  }
}
